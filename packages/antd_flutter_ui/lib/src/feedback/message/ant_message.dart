/// AntMessage — antd React Message（全局提示）的 Flutter 实现
///
/// API 与 antd React message 对齐：
/// - [AntMessage.show] — 弹出全局提示，返回 [AntMessageHandle] 可手动关闭
/// - [type] — info / success / warning / error / loading
/// - [duration] — 自动关闭时长（默认 3s；loading 类型默认不自动消失）
/// - [closable] — 是否显示关闭按钮
/// - [onClose] — 关闭回调
///
/// 多条提示叠加显示（队列），顶部居中滑入，适配顶部安全区。
///
/// ```dart
/// AntMessage.show(context, Text('这是一条提示'));
/// AntMessage.show(context, Text('成功了'), type: AntMessageType.success);
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_message_types.dart';
import '../../engines/overlay_shell.dart';
export 'ant_message_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 单条提示卡片标记 key，便于测试定位。
const Key kAntMessageItemKey = ValueKey<String>('AntMessageItem');

/// 关闭按钮标记 key。
const Key kAntMessageCloseKey = ValueKey<String>('AntMessageClose');

/// 默认自动关闭时长。
const Duration kAntMessageDefaultDuration = Duration(seconds: 3);

/// 提示入场/出场动画时长。
const Duration kAntMessageAnimationDuration = Duration(milliseconds: 200);

// ============================================================
// AntMessageHandle
// ============================================================

/// 全局提示句柄 — 可手动关闭对应提示。
abstract class AntMessageHandle {
  /// 关闭该条提示。
  void close();
}

// ============================================================
// AntMessage
// ============================================================

/// 全局提示 — 在页面顶部居中展示全局反馈信息。
///
/// 对齐 antd React Message 组件：静态方法 [show] 弹出提示，
/// 自动消失（默认 3s），可叠加多条，loading 类型默认不自动消失。
class AntMessage {
  AntMessage._();

  static final List<_ActiveMessage> _queue = <_ActiveMessage>[];
  static OverlayEntry? _overlayEntry;

  /// 弹出一条全局提示，返回句柄可手动关闭。
  ///
  /// - [content] — 提示内容（任意 Widget）
  /// - [type] — 提示类型，决定图标与主题色
  /// - [duration] — 自动关闭时长；null 时取默认值（info/success/warning/error
  ///   为 3s，loading 不自动消失）；[Duration.zero] 表示永不自动消失
  /// - [closable] — 是否显示右上角关闭按钮
  /// - [onClose] — 提示关闭时回调（含自动消失与手动关闭）
  static AntMessageHandle show(
    BuildContext context,
    Widget content, {
    AntMessageType type = AntMessageType.info,
    Duration? duration,
    bool closable = false,
    VoidCallback? onClose,
  }) {
    final effectiveDuration = _resolveDuration(type, duration);
    final item = _ActiveMessage(
      themeData: AntTheme.of(context),
      content: content,
      type: type,
      duration: effectiveDuration,
      closable: closable,
      onClose: onClose,
      onDismissed: _remove,
    );

    // 旧浮层已随宿主树销毁时，清空残留队列后重建。
    if (_overlayEntry == null || !_overlayEntry!.mounted) {
      _queue.clear();
      _itemStates.clear();
    }
    _queue.add(item);

    if (_overlayEntry == null || !_overlayEntry!.mounted) {
      _overlayEntry = OverlayEntry(
        builder: (context) => _MessageStack(items: List.of(_queue)),
      );
      Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    }
    _overlayEntry!.markNeedsBuild();
    return item;
  }

  /// 各类型的默认消失策略。
  static Duration? _resolveDuration(AntMessageType type, Duration? duration) {
    if (duration != null) return duration;
    return type == AntMessageType.loading ? null : kAntMessageDefaultDuration;
  }

  static void _remove(_ActiveMessage item) {
    final existed = _queue.remove(item);
    if (_queue.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else if (existed) {
      _overlayEntry?.markNeedsBuild();
    }
  }
}

// ============================================================
// _ActiveMessage — 队列中的一条活跃提示
// ============================================================

class _ActiveMessage implements AntMessageHandle {
  _ActiveMessage({
    required this.themeData,
    required this.content,
    required this.type,
    required this.duration,
    required this.closable,
    required this.onClose,
    required this.onDismissed,
  });

  final AntThemeData themeData;
  final Widget content;
  final AntMessageType type;
  final Duration? duration;
  final bool closable;
  final VoidCallback? onClose;
  final void Function(_ActiveMessage) onDismissed;

  final Key itemKey = UniqueKey();
  bool _closing = false;

  @override
  void close() => dismiss();

  void dismiss() {
    if (_closing) return;
    _closing = true;
    onClose?.call();
    // 触发对应 _MessageItemState 播放出场动画后移除。
    _dismissRequests.add(this);
    _itemStates[itemKey]?._playExit();
  }
}

/// item.dismiss 与对应 State 之间的桥接。
final Map<Key, _MessageItemState> _itemStates = <Key, _MessageItemState>{};
final List<_ActiveMessage> _dismissRequests = <_ActiveMessage>[];

// ============================================================
// _MessageStack — 顶部提示堆叠容器
// ============================================================

class _MessageStack extends StatelessWidget {
  const _MessageStack({required this.items});

  final List<_ActiveMessage> items;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    final theme = items.isEmpty ? null : items.first.themeData;
    return Positioned(
      top: safeTop + 16.w,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in items)
            _MessageItem(
              key: item.itemKey,
              item: item,
              themeData: theme ?? AntThemeData.light(),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// _MessageItem — 单条提示（滑入/滑出动画）
// ============================================================

class _MessageItem extends StatefulWidget {
  const _MessageItem({
    super.key,
    required this.item,
    required this.themeData,
  });

  final _ActiveMessage item;
  final AntThemeData themeData;

  @override
  State<_MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<_MessageItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: kAntMessageAnimationDuration,
    reverseDuration: kAntMessageAnimationDuration,
  );
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _itemStates[widget.item.itemKey] = this;
    _controller.forward();
    final duration = widget.item.duration;
    if (duration != null && duration > Duration.zero) {
      _autoCloseTimer = Timer(duration, widget.item.dismiss);
    }
    // 处理 dismiss 早于 State 挂载的极端情况。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_dismissRequests.remove(widget.item)) {
        _playExit();
      }
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _itemStates.remove(widget.item.itemKey);
    _controller.dispose();
    super.dispose();
  }

  void _playExit() {
    _autoCloseTimer?.cancel();
    _controller.reverse().whenComplete(() {
      if (mounted) setState(() {});
      widget.item.onDismissed(widget.item);
    });
  }

  ({IconData icon, Color color}) _resolveIndicator(AntThemeData theme) {
    return switch (widget.item.type) {
      AntMessageType.success => (
          icon: Icons.check_circle,
          color: theme.colorSuccess,
        ),
      AntMessageType.warning => (
          icon: Icons.warning_amber_rounded,
          color: theme.colorWarning,
        ),
      AntMessageType.error => (icon: Icons.cancel, color: theme.colorError),
      AntMessageType.loading => (icon: Icons.sync, color: theme.colorPrimary),
      AntMessageType.info => (icon: Icons.info, color: theme.colorInfo),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeData;
    final (:icon, :color) = _resolveIndicator(theme);

    final indicator = widget.item.type == AntMessageType.loading
        ? SizedBox(
            width: 16.w,
            height: 16.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorPrimary),
            ),
          )
        : Icon(icon, size: 16.w, color: color);

    final card = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorShadow.withValues(alpha: 0.15),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        key: kAntMessageItemKey,
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          SizedBox(width: 8.w),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: theme.fontSize,
              color: theme.colorText,
            ),
            child: widget.item.content,
          ),
          if (widget.item.closable) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              key: kAntMessageCloseKey,
              onTap: widget.item.dismiss,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.close,
                size: 14.w,
                color: theme.colorTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Material(
        color: Colors.transparent,
        // 出现动画复用弹层基座（AntPopupMotion：fade + 顶部滑入）
        child: AntPopupMotion(
          animation: _curve,
          slideBegin: const Offset(0, -1),
          child: card,
        ),
      ),
    );
  }
}
