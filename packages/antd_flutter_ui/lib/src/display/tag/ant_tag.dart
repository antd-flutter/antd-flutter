/// AntTag — antd React Tag 的 Flutter 实现
///
/// API 与 antd React Tag 对齐：
/// - [child] — 标签内容
/// - [color] — 预设颜色或自定义颜色
/// - [customColor] — 自定义颜色值
/// - [bordered] — 是否有边框
/// - [closable] — 是否可关闭
/// - [onClose] — 关闭回调
/// - [icon] — 前置图标
///
/// ```dart
/// AntTag(child: '标签')
/// AntTag(child: '成功', color: AntTagColor.success)
/// AntTag(child: '可关闭', closable: true, onClose: () {})
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_tag_types.dart';
export 'ant_tag_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntTag
// ============================================================

/// 标签 — 进行标记和分类的小标签。
///
/// 对齐 antd React Tag 组件。
class AntTag extends StatefulWidget {
  const AntTag({
    super.key,
    required this.child,
    this.color,
    this.customColor,
    this.bordered = true,
    this.closable = false,
    this.onClose,
    this.icon,
    this.padding,
  });

  /// 标签内容。
  final String child;

  /// 预设颜色。
  final AntTagColor? color;

  /// 自定义颜色值（十六进制或 Color）。
  final Color? customColor;

  /// 是否有边框。
  final bool bordered;

  /// 是否可关闭。
  final bool closable;

  /// 关闭回调。
  final VoidCallback? onClose;

  /// 前置图标。
  final Widget? icon;

  /// 内边距。
  final EdgeInsets? padding;

  @override
  State<AntTag> createState() => _AntTagState();
}

class _AntTagState extends State<AntTag> {
  bool _closed = false;

  void _handleClose() {
    setState(() => _closed = true);
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_closed) return const SizedBox.shrink();

    final theme = AntTheme.of(context);
    final (bg, fg, borderColor) = _resolveColors(theme);

    return Container(
      padding: widget.padding ??
          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(theme.borderRadiusXS),
        border: widget.bordered
            ? Border.all(color: borderColor, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            IconTheme.merge(
              data: IconThemeData(color: fg, size: 14.w),
              child: widget.icon!,
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            widget.child,
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: fg,
              height: 1.5,
            ),
          ),
          if (widget.closable) ...[
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: _handleClose,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.close,
                size: 12.w,
                color: fg,
              ),
            ),
          ],
        ],
      ),
    );
  }

  (Color, Color, Color) _resolveColors(AntThemeData theme) {
    if (widget.customColor != null) {
      final c = widget.customColor!;
      return (c.withValues(alpha: 0.15), c, c.withValues(alpha: 0.4));
    }

    if (widget.color != null) {
      switch (widget.color!) {
        case AntTagColor.success:
          return (
            theme.colorSuccessBg,
            theme.colorSuccess,
            theme.colorSuccessBorder,
          );
        case AntTagColor.processing:
          return (
            theme.colorPrimaryBg,
            theme.colorPrimary,
            theme.colorPrimary.withValues(alpha: 0.3),
          );
        case AntTagColor.error:
          return (
            theme.colorErrorBg,
            theme.colorError,
            theme.colorErrorOutline,
          );
        case AntTagColor.standard:
          return (
            theme.colorBgContainer,
            theme.colorText,
            theme.colorBorder,
          );
        case AntTagColor.warning:
          return (
            theme.colorWarningBg,
            theme.colorWarning,
            theme.colorWarningOutline,
          );
      }
    }

    return (
      theme.colorBgContainer,
      theme.colorText,
      theme.colorBorder,
    );
  }
}