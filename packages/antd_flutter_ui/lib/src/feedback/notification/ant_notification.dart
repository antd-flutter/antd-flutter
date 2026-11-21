/// AntNotification — antd React Notification（通知提醒框）的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [AntNotification.show] — 弹出一条通知
/// - [title] / [description] — 标题 + 描述两段结构
/// - [type] — info | success | warning | error 语义类型
/// - [duration] — 自动关闭时长（默认 4.5s，0 表示不自动关闭）
/// - [placement] — 屏幕四角弹出位置
/// - [width] — 通知卡片宽度
/// - [closable] / [onClose] — 关闭按钮与关闭回调
/// - [message] — 关闭提示文案（无标题时显示）
///
/// 与 AntMessage 的区别：通知带 title + description 两段结构、
/// 支持四角 placement 与显式关闭按钮。
///
/// ```dart
/// AntNotification.show(
///   context,
///   title: '通知标题',
///   description: '这是通知内容',
///   type: AntNotificationType.success,
/// );
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_notification_types.dart';
import '../../engines/overlay_shell.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'ant_notification_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 通知卡片标记 key，便于测试定位单条通知。
const Key kAntNotificationCardKey = ValueKey<String>('AntNotificationCard');

/// 通知标题标记 key。
const Key kAntNotificationTitleKey = ValueKey<String>('AntNotificationTitle');

/// 通知描述标记 key。
const Key kAntNotificationDescKey = ValueKey<String>('AntNotificationDesc');

/// 关闭按钮标记 key。
const Key kAntNotificationCloseKey = ValueKey<String>('AntNotificationClose');

/// 通知容器（某个 placement 的堆叠层）标记 key。
const Key kAntNotificationStackKey = ValueKey<String>('AntNotificationStack');

/// 通知卡片默认宽度（antd 默认 384）。
const double kAntNotificationDefaultWidth = 384;

// ============================================================
// AntNotification
// ============================================================

/// 通知提醒框 — 全局展示通知信息。
///
/// 静态方法 [show] 在屏幕四角堆叠展示通知卡片，
/// 多条通知按弹出顺序垂直排列，新通知带滑入动画。
class AntNotification {
  AntNotification._();

  /// 每个 placement 一份堆叠状态。
  static final Map<AntNotificationPlacement, _PlacementState> _states = {};

  static _PlacementState _stateOf(AntNotificationPlacement placement) =>
      _states.putIfAbsent(placement, _PlacementState.new);

  /// 弹出一条通知。
  static void show(
    BuildContext context, {
    String? title,
    String? description,
    String? message,
    AntNotificationType type = AntNotificationType.info,
    Duration duration = const Duration(milliseconds: 4500),
    AntNotificationPlacement placement = AntNotificationPlacement.topRight,
    double? width,
    bool closable = true,
    VoidCallback? onClose,
  }) {
    _stateOf(placement).show(
      context,
      title: title,
      description: description,
      message: message,
      type: type,
      duration: duration,
      width: width,
      closable: closable,
      onClose: onClose,
    );
  }

  /// 关闭指定 placement 下的所有通知。
  static void closeAll([AntNotificationPlacement? placement]) {
    if (placement != null) {
      _stateOf(placement).clear();
    } else {
      for (final state in _states.values) {
        state.clear();
      }
    }
  }
}

// ============================================================
// _PlacementState — 单 placement 的堆叠管理
// ============================================================

/// 单条活动通知的数据。
class _ActiveNotification {
  _ActiveNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.message,
    required this.type,
    required this.duration,
    required this.width,
    required this.closable,
    required this.onClose,
  });

  final int id;
  final String? title;
  final String? description;
  final String? message;
  final AntNotificationType type;
  final Duration duration;
  final double? width;
  final bool closable;
  final VoidCallback? onClose;

  /// 是否正在退出（播放关闭动画中）。
  bool closing = false;

  /// 自动关闭定时器（移除时取消）。
  Timer? autoCloseTimer;
}

class _PlacementState {
  final ValueNotifier<List<_ActiveNotification>> items =
      ValueNotifier<List<_ActiveNotification>>([]);

  OverlayEntry? _entry;

  int _nextId = 0;

  void show(
    BuildContext context, {
    required String? title,
    required String? description,
    required String? message,
    required AntNotificationType type,
    required Duration duration,
    required double? width,
    required bool closable,
    required VoidCallback? onClose,
  }) {
    final item = _ActiveNotification(
      id: _nextId++,
      title: title,
      description: description,
      message: message,
      type: type,
      duration: duration,
      width: width,
      closable: closable,
      onClose: onClose,
    );
    final list = [...items.value, item];
    items.value = list;

    if (_entry == null) {
      _entry = OverlayEntry(
        builder: (context) => _NotificationStack(state: this),
      );
      Overlay.of(context, rootOverlay: true).insert(_entry!);
    } else {
      // 新增通知时刷新堆叠层
      _entry!.markNeedsBuild();
    }

    if (duration > Duration.zero) {
      item.autoCloseTimer = Timer(duration, () => close(item.id));
    }
  }

  /// 关闭一条通知：标记 closing 播放退出动画，动画结束后移除。
  void close(int id) {
    final index = items.value.indexWhere((it) => it.id == id);
    if (index < 0 || items.value[index].closing) return;
    final list = [...items.value];
    list[index].closing = true;
    items.value = list;
    _entry?.markNeedsBuild();
  }

  /// 通知退出动画播放完成，由卡片回调移除。
  void remove(int id) {
    final item = items.value.where((it) => it.id == id).firstOrNull;
    item?.autoCloseTimer?.cancel();
    item?.onClose?.call();
    items.value = items.value.where((it) => it.id != id).toList();
    if (items.value.isEmpty) {
      _entry?.remove();
      _entry = null;
    } else {
      _entry?.markNeedsBuild();
    }
  }

  /// 直接清空（不播放退出动画），用于全局重置。
  void clear() {
    for (final item in items.value) {
      item.autoCloseTimer?.cancel();
      item.onClose?.call();
    }
    items.value = [];
    _entry?.remove();
    _entry = null;
  }
}

// ============================================================
// _NotificationStack — 某个 placement 的堆叠容器
// ============================================================

class _NotificationStack extends StatelessWidget {
  const _NotificationStack({required this.state});

  final _PlacementState state;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_ActiveNotification>>(
      valueListenable: state.items,
      builder: (context, items, _) {
        if (items.isEmpty) return const SizedBox.shrink();
        final placement = _placementOf(state);
        final theme = AntTheme.of(context);
        final margin = 24.w;

        final isTop = placement == AntNotificationPlacement.topRight ||
            placement == AntNotificationPlacement.topLeft;
        final isRight = placement == AntNotificationPlacement.topRight ||
            placement == AntNotificationPlacement.bottomRight;

        // 新通知在最上方（顶部 placement）或最下方（底部 placement）
        final ordered = isTop ? items.reversed.toList() : items;

        final stack = Column(
          key: kAntNotificationStackKey,
          mainAxisSize: MainAxisSize.min,
          // 右侧弹出右对齐、左侧弹出左对齐（卡片宽度小于上限时贴弹出侧）
          crossAxisAlignment:
              isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            for (final item in ordered)
              _NotificationCard(
                key: ValueKey<int>(item.id),
                item: item,
                state: state,
                themeData: theme,
                // 宽度 clamp 到屏宽内（减去两侧 margin），窄屏不顶满/不溢出
                width: (item.width ?? kAntNotificationDefaultWidth).clamp(
                  0.0,
                  MediaQuery.sizeOf(context).width - 2 * margin,
                ),
                slideFromRight: isRight,
              ),
          ],
        );

        final deviceSafe = antDeviceSafePadding();

        return Positioned(
          // 水平方向也避开安全区（横屏刘海侧/圆角屏）
          left: isRight ? null : margin + deviceSafe.left,
          right: isRight ? margin + deviceSafe.right : null,
          top: isTop ? margin + deviceSafe.top : null,
          bottom: isTop ? null : margin + deviceSafe.bottom,
          child: Material(
            color: Colors.transparent,
            child: stack,
          ),
        );
      },
    );
  }

  /// 反查 placement：每个 state 实例对应一个 placement。
  AntNotificationPlacement _placementOf(_PlacementState state) {
    for (final entry in AntNotification._states.entries) {
      if (identical(entry.value, state)) return entry.key;
    }
    return AntNotificationPlacement.topRight;
  }
}

// ============================================================
// _NotificationCard — 单条通知卡片（滑入 + 退出动画）
// ============================================================

class _NotificationCard extends StatefulWidget {
  const _NotificationCard({
    super.key,
    required this.item,
    required this.state,
    required this.themeData,
    required this.width,
    required this.slideFromRight,
  });

  final _ActiveNotification item;
  final _PlacementState state;
  final AntThemeData themeData;
  final double width;
  final bool slideFromRight;

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  bool _exiting = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _NotificationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 关闭标记出现 → 播放退出动画后移除
    if (widget.item.closing && !_exiting) {
      _exiting = true;
      _controller.reverse().whenComplete(() {
        widget.state.remove(widget.item.id);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (_exiting) return;
    _exiting = true;
    _controller.reverse().whenComplete(() {
      widget.state.remove(widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;
    final item = widget.item;
    final (icon, color) = _resolveType(theme);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.w),
      // 出现动画复用弹层基座（AntPopupMotion：fade + 侧向滑入）
      child: AntPopupMotion(
        animation: _curve,
        slideBegin: Offset(widget.slideFromRight ? 1 : -1, 0),
        child: Container(
          key: kAntNotificationCardKey,
          width: widget.width,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorBgContainer,
            borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
            boxShadow: [
              BoxShadow(
                color: theme.colorShadow.withValues(alpha: 0.15),
                blurRadius: 16.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20.w, color: color),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.title ?? item.message ?? '',
                      key: kAntNotificationTitleKey,
                      style: TextStyle(
                        fontSize: 16.sp,
                        // 行高 1.25（=20.w）与图标同高，保证图标与首行文字垂直居中对齐
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: theme.colorTextHeading,
                      ),
                    ),
                  ),
                  if (item.closable)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        key: kAntNotificationCloseKey,
                        onTap: _handleClose,
                        behavior: HitTestBehavior.opaque,
                        // 与标题行高（20.w）同高居中，保证关闭图标与文字垂直对齐
                        child: SizedBox(
                          height: 20.w,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Icon(
                                AntIcons.closeOutlined,
                                size: 14.w,
                                color: theme.colorTextSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (item.description != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.w),
                  child: Text(
                    item.description!,
                    key: kAntNotificationDescKey,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.colorTextSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  (IconData, Color) _resolveType(AntThemeData theme) {
    switch (widget.item.type) {
      case AntNotificationType.success:
        return (AntIcons.checkCircleFilled, theme.colorSuccess);
      case AntNotificationType.warning:
        return (AntIcons.warningFilled, theme.colorWarning);
      case AntNotificationType.error:
        return (AntIcons.closeCircleFilled, theme.colorError);
      case AntNotificationType.info:
        return (AntIcons.infoCircleFilled, theme.colorInfo);
    }
  }
}
