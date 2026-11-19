/// AntAlert — antd React Alert 的 Flutter 实现
///
/// API 与 antd React Alert 对齐：
/// - [type] — 语义类型 success/info/warning/error
/// - [message] — 警告提示内容
/// - [description] — 警告描述内容
/// - [closable] — 是否可关闭
/// - [onClose] — 关闭回调
/// - [showIcon] — 是否显示辅助图标
/// - [icon] — 自定义图标
/// - [action] — 操作区
/// - [banner] — 横幅变体
///
/// ```dart
/// AntAlert(message: '信息提示')
/// AntAlert(message: '成功', type: AntAlertType.success, showIcon: true)
/// AntAlert(message: '可关闭', closable: true, onClose: () {})
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_alert_types.dart';
export 'ant_alert_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntAlert
// ============================================================

/// 警告提示 — 展示需要用户关注的信息。
///
/// 对齐 antd React Alert 组件。
class AntAlert extends StatefulWidget {
  const AntAlert({
    super.key,
    this.type = AntAlertType.info,
    required this.message,
    this.description,
    this.closable = false,
    this.onClose,
    this.showIcon = false,
    this.icon,
    this.action,
    this.banner = false,
    this.bordered = true,
  });

  /// 语义类型。
  final AntAlertType type;

  /// 警告提示内容（主体）。
  final String message;

  /// 警告描述内容。
  final String? description;

  /// 是否可关闭。
  final bool closable;

  /// 关闭回调。
  final VoidCallback? onClose;

  /// 是否显示辅助图标。
  final bool showIcon;

  /// 自定义图标（覆盖默认图标，仅在 showIcon 时生效）。
  final Widget? icon;

  /// 操作区（右侧补充操作）。
  final Widget? action;

  /// 是否用作顶部公告（横幅变体：无边框/圆角，默认显示图标）。
  final bool banner;

  /// 是否显示边框。
  final bool bordered;

  @override
  State<AntAlert> createState() => _AntAlertState();
}

class _AntAlertState extends State<AntAlert>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    setState(() => _closed = true);
    _controller.forward().whenComplete(() {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_closed) {
      return SizeTransition(
        sizeFactor: _animation,
        child: const SizedBox.shrink(),
      );
    }

    final theme = AntTheme.of(context);
    final (bg, fg, borderColor) = _resolveColors(theme);
    final showIcon = widget.showIcon || widget.banner;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showIcon) ...[
              IconTheme.merge(
                data: IconThemeData(color: fg, size: 16.w),
                child: widget.icon ?? Icon(_defaultIcon(widget.type)),
              ),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(
                widget.message,
                style: TextStyle(
                  fontSize: theme.fontSize,
                  fontWeight: FontWeight.w600,
                  color: theme.colorTextHeading,
                  height: 1.5,
                ),
              ),
            ),
            if (widget.closable)
              GestureDetector(
                onTap: _handleClose,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Icon(
                    Icons.close,
                    size: 14.w,
                    color: theme.colorTextSecondary,
                  ),
                ),
              ),
          ],
        ),
        if (widget.description != null) ...[
          SizedBox(height: 4.w),
          Text(
            widget.description!,
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: theme.colorText,
              height: 1.5,
            ),
          ),
        ],
      ],
    );

    final borderRadius =
        widget.banner ? BorderRadius.zero : BorderRadius.circular(
      theme.borderRadiusLG,
    );

    Widget alert = Container(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: widget.description != null ? 10.w : 8.w,
        bottom: widget.description != null ? 10.w : 8.w,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius,
        border: widget.bordered && !widget.banner
            ? Border.all(color: borderColor)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.bordered && !widget.banner) ...[
            Container(
              width: 3.w,
              constraints: const BoxConstraints(minHeight: 16),
              decoration: BoxDecoration(
                color: fg,
                borderRadius: BorderRadius.circular(1.5.w),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Expanded(child: content),
          if (widget.action != null) ...[
            SizedBox(width: 8.w),
            widget.action!,
          ],
        ],
      ),
    );

    if (widget.banner) return alert;

    return ClipRRect(
      borderRadius: borderRadius,
      child: alert,
    );
  }

  (Color, Color, Color) _resolveColors(AntThemeData theme) {
    switch (widget.type) {
      case AntAlertType.success:
        return (
          theme.colorSuccessBg,
          theme.colorSuccess,
          theme.colorSuccessBorder,
        );
      case AntAlertType.info:
        return (
          theme.colorInfoBg,
          theme.colorInfo,
          theme.colorInfoBorder,
        );
      case AntAlertType.warning:
        return (
          theme.colorWarningBg,
          theme.colorWarning,
          theme.colorWarningBorder,
        );
      case AntAlertType.error:
        return (
          theme.colorErrorBg,
          theme.colorError,
          theme.colorErrorBorder,
        );
    }
  }

  IconData _defaultIcon(AntAlertType type) {
    switch (type) {
      case AntAlertType.success:
        return Icons.check_circle;
      case AntAlertType.info:
        return Icons.info;
      case AntAlertType.warning:
        return Icons.warning_amber_rounded;
      case AntAlertType.error:
        return Icons.cancel;
    }
  }
}
