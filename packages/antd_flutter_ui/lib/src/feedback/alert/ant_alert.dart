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
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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
          // 对齐 antd web Alert：无描述时图标与文字垂直居中；
          // 有描述时图标与 message 顶部对齐（描述行不参与图标对齐）。
          crossAxisAlignment: widget.description != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (showIcon) ...[
              // 对齐 antd web Alert：无描述时图标与文字垂直居中；
              // 有描述时图标放大到 fontSizeHeading3（20）并与 message
              // 首行视觉居中（行高 1.5 的首行盒顶部内偏移半个差值）。
              Builder(
                builder: (context) {
                  final hasDesc = widget.description != null;
                  final iconSize = hasDesc ? theme.s(20) : theme.s(16);
                  final firstLineHeight = theme.fontSize * 1.5;
                  // 首行盒高可能小于放大后的图标（.w 缩放），偏移不允许为负。
                  final gap = firstLineHeight - iconSize;
                  return Padding(
                    padding: EdgeInsets.only(
                      top: gap > 0 ? gap / 2 : 0,
                    ),
                    child: IconTheme.merge(
                      data: IconThemeData(color: fg, size: iconSize),
                      child: widget.icon ?? Icon(_defaultIcon(widget.type)),
                    ),
                  );
                },
              ),
              SizedBox(width: theme.s(8)),
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
                  padding: EdgeInsets.only(left: theme.s(8)),
                  child: Icon(
                    AntIcons.closeOutlined,
                    size: theme.s(14),
                    color: theme.colorTextSecondary,
                  ),
                ),
              ),
          ],
        ),
        if (widget.description != null) ...[
          SizedBox(height: theme.s(4)),
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

    final borderRadius = widget.banner
        ? BorderRadius.zero
        : BorderRadius.circular(
            theme.borderRadiusLG,
          );

    Widget alert = Container(
      padding: EdgeInsets.only(
        left: theme.s(12),
        right: theme.s(12),
        top: widget.description != null ? theme.s(10) : theme.s(8),
        bottom: widget.description != null ? theme.s(10) : theme.s(8),
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
              width: theme.s(3),
              constraints: const BoxConstraints(minHeight: 16),
              decoration: BoxDecoration(
                color: fg,
                borderRadius: BorderRadius.circular(theme.s(1.5)),
              ),
            ),
            SizedBox(width: theme.s(8)),
          ],
          Expanded(child: content),
          if (widget.action != null) ...[
            SizedBox(width: theme.s(8)),
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
        return AntIcons.checkCircleFilled;
      case AntAlertType.info:
        return AntIcons.infoCircleFilled;
      case AntAlertType.warning:
        return AntIcons.warningFilled;
      case AntAlertType.error:
        return AntIcons.closeCircleFilled;
    }
  }
}
