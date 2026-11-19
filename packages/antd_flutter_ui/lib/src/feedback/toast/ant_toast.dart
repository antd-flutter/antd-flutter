/// AntToast — antd-mobile v5 Toast（轻提示）的 Flutter 实现
///
/// API 与 antd-mobile Toast 对齐：
/// - [AntToast.show] — 屏幕中央弹出深色半透明圆角卡片提示，返回
///   [AntToastHandle] 可手动关闭
/// - [AntToast.show.content] — 支持 String / Widget
/// - [AntToast.show.icon] — 内置图标类型（success / fail / loading）或自定义 Widget
/// - [AntToast.show.duration] — 自动消失时长（默认 2000ms；loading 不自动消失）
/// - [AntToast.show.maskClickable] — true 时点击穿透遮罩（默认），false 时遮罩拦截点击
/// - [AntToast.show.position] — top / center / bottom 展示位置
/// - [AntToast.show.onClose] — 关闭回调
///
/// 多条提示简化为替换当前展示。
///
/// ```dart
/// AntToast.show(context, '这是一条提示');
/// AntToast.show(context, '上传成功', icon: AntToastIconType.success);
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_toast_types.dart';
import '../../engines/overlay_shell.dart';
export 'ant_toast_types.dart';

// ============================================================
// 测试定位 Key 与默认常量
// ============================================================

/// 提示卡片标记 key，便于测试定位。
const Key kAntToastKey = ValueKey<String>('AntToast');

/// 默认自动消失时长（antd-mobile 对齐：2000ms）。
const Duration kAntToastDefaultDuration = Duration(milliseconds: 2000);

/// 入场/出场动画时长。
const Duration kAntToastAnimationDuration = Duration(milliseconds: 200);

/// 默认遮罩颜色（深色半透明）。
const Color kAntToastMaskColor = Color(0x99000000);

// ============================================================
// AntToastHandle
// ============================================================

/// 轻提示句柄 — 可手动关闭当前提示。
abstract class AntToastHandle {
  /// 关闭该条提示。
  void close();
}

// ============================================================
// AntToast
// ============================================================

/// 轻提示 — 在屏幕中央（或指定位置）展示深色半透明圆角卡片反馈。
///
/// 对齐 antd-mobile Toast：静态方法 [show] 弹出提示，自动消失（默认
/// 2000ms），loading 类型不自动消失，多条展示时替换当前提示。
class AntToast {
  AntToast._();

  static OverlayEntry? _overlayEntry;
  static _ActiveToast? _active;

  /// 弹出一条轻提示，返回句柄可手动关闭。
  ///
  /// - [content] — 提示内容，支持 String 或 Widget
  /// - [icon] — 内置图标类型（[AntToastIconType]）或自定义 Widget
  /// - [duration] — 自动关闭时长；null 时取默认值（非 loading 为 2000ms，
  ///   loading 不自动消失）；[Duration.zero] 表示永不自动消失
  /// - [maskClickable] — true 时遮罩不拦截点击（穿透），false 时遮罩拦截
  /// - [position] — 展示位置，默认 [AntToastPosition.center]
  /// - [onClose] — 提示关闭时回调（含自动消失与手动关闭）
  static AntToastHandle show(
    BuildContext context,
    Object content, {
    Object? icon,
    Duration? duration,
    bool maskClickable = true,
    AntToastPosition position = AntToastPosition.center,
    VoidCallback? onClose,
  }) {
    final themeData = AntTheme.of(context);
    final toast = _ActiveToast(
      themeData: themeData,
      content: content,
      icon: icon,
      duration: _resolveDuration(icon, duration),
      maskClickable: maskClickable,
      position: position,
      onClose: onClose,
    );

    // 多条时简化为替换当前：先移除旧条目再插入新条目。
    _active = toast;
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (_) => _ToastView(toast: toast),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    return toast;
  }

  /// 各图标类型的默认消失策略。
  static Duration? _resolveDuration(Object? icon, Duration? duration) {
    if (duration != null) return duration;
    return icon == AntToastIconType.loading ? null : kAntToastDefaultDuration;
  }

  static void _remove(_ActiveToast toast) {
    if (!identical(_active, toast)) return;
    _active = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

// ============================================================
// _ActiveToast — 当前活跃的一条提示
// ============================================================

class _ActiveToast implements AntToastHandle {
  _ActiveToast({
    required this.themeData,
    required this.content,
    required this.icon,
    required this.duration,
    required this.maskClickable,
    required this.position,
    required this.onClose,
  });

  final AntThemeData themeData;
  final Object content;
  final Object? icon;
  final Duration? duration;
  final bool maskClickable;
  final AntToastPosition position;
  final VoidCallback? onClose;

  bool _closing = false;
  _ToastViewState? _state;

  @override
  void close() => dismiss();

  void dismiss() {
    if (_closing) return;
    _closing = true;
    onClose?.call();
    final state = _state;
    if (state != null) {
      state._playExit();
    } else {
      // 尚未挂载（极端情况），直接移除。
      AntToast._remove(this);
    }
  }
}

// ============================================================
// _ToastView — Overlay 根视图
// ============================================================

class _ToastView extends StatefulWidget {
  const _ToastView({required this.toast});

  final _ActiveToast toast;

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView> {
  /// 内部 open 镜像：false 时由基座播放退出动画后移除浮层。
  bool _open = true;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    widget.toast._state = this;
    final duration = widget.toast.duration;
    if (duration != null && duration > Duration.zero) {
      _autoCloseTimer = Timer(duration, widget.toast.dismiss);
    }
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _playExit() {
    _autoCloseTimer?.cancel();
    if (mounted) setState(() => _open = false);
  }

  /// 按 position 解析对齐配置。
  ({Alignment alignment, EdgeInsets padding}) _resolvePosition() {
    // 设备真实安全区（根视图 MediaQuery，不受页面 SafeArea 消费影响）
    final devicePadding = antDeviceSafePadding();
    final vertical = devicePadding.top + devicePadding.bottom;
    return switch (widget.toast.position) {
      AntToastPosition.top => (
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: vertical + 64.w),
        ),
      AntToastPosition.bottom => (
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: vertical + 64.w),
        ),
      AntToastPosition.center => (
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: vertical),
        ),
    };
  }

  Widget _buildIcon(AntThemeData theme) {
    final icon = widget.toast.icon;
    if (icon == null) return const SizedBox.shrink();
    if (icon is Widget) return icon;
    if (icon is AntToastIconType) {
      final size = 36.w;
      return switch (icon) {
        AntToastIconType.success => Icon(
            Icons.check_circle_outline,
            size: size,
            color: theme.colorSuccess,
          ),
        AntToastIconType.fail => Icon(
            Icons.close,
            size: size,
            color: theme.colorError,
          ),
        AntToastIconType.loading => SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorTextLightSolid,
              ),
            ),
          ),
      };
    }
    return const SizedBox.shrink();
  }

  Widget _buildContent() {
    final content = widget.toast.content;
    final theme = widget.toast.themeData;
    if (content is String) {
      return Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: theme.fontSize,
          color: theme.colorTextLightSolid,
        ),
      );
    }
    if (content is Widget) return content;
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final (:alignment, :padding) = _resolvePosition();
    final theme = widget.toast.themeData;
    final hasIcon = widget.toast.icon != null;

    final card = Container(
      key: kAntToastKey,
      margin: EdgeInsets.symmetric(horizontal: 48.w),
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: hasIcon ? 24.w : 12.w,
      ),
      decoration: BoxDecoration(
        color: kAntToastMaskColor,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(theme),
          if (hasIcon) SizedBox(height: 12.w),
          _buildContent(),
        ],
      ),
    );

    // 出现/退出动画由弹层基座（AntOverlayShell）统一播放。
    // Material 仅包裹卡片，避免整层拦截点击。
    Widget body = Align(
      alignment: alignment,
      child: ConstrainedBox(
        // 宽度封顶仅桌面端视口生效，移动端保持原生宽度
        constraints: BoxConstraints(
          maxWidth: antIsDesktopViewport(context)
              ? kAntMobileOverlayDefaultMaxWidth
              : double.infinity,
        ),
        child: Material(color: Colors.transparent, child: card),
      ),
    );
    if (padding != EdgeInsets.zero) {
      body = Padding(padding: padding, child: body);
    }

    // 弹层基座：缩放淡入动画 + 可选拦截层（maskClickable=false 时拦截点击）+
    // 退出动画后移除浮层；轻提示无遮罩层，定位由组件自身按 position 计算
    return AntOverlayShell(
      open: _open,
      showMask: false,
      interceptWithoutMask: !widget.toast.maskClickable,
      interceptBehavior: HitTestBehavior.opaque,
      onMaskTap: widget.toast.dismiss,
      duration: kAntToastAnimationDuration,
      curve: Curves.easeOutCubic,
      scaleFrom: 0.8,
      onExited: () => AntToast._remove(widget.toast),
      child: SafeArea(
        child: Stack(
          children: [
            body,
          ],
        ),
      ),
    );
  }
}
