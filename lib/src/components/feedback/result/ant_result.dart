/// AntResult — antd React Result 的 Flutter 实现
///
/// API 与 antd React Result 对齐：
/// - [status] — 结果状态（success/error/info/warning/404/403/500），图标自动映射
/// - [title] — 主标题
/// - [subTitle] — 副标题
/// - [extra] — 操作区
/// - [children] — 自定义内容区
/// - [icon] — 自定义图标（覆盖状态默认图标）
///
/// ```dart
/// AntResult(status: AntResultStatus.success, title: '操作成功')
/// AntResult(status: AntResultStatus.notFound, title: '404', extra: AntButton(child: '返回首页'))
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/feedback/result/ant_result_types.dart';
export 'package:antd_flutter_plus/src/components/feedback/result/ant_result_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntResult
// ============================================================

/// 结果页 — 用于反馈一系列操作任务的处理结果。
///
/// 对齐 antd React Result 组件。
class AntResult extends StatelessWidget {
  const AntResult({
    super.key,
    this.status = AntResultStatus.info,
    this.title,
    this.subTitle,
    this.extra,
    this.children,
    this.icon,
  });

  /// 结果状态（决定默认图标/数字大字与颜色）。
  final AntResultStatus status;

  /// 主标题。
  final String? title;

  /// 副标题。
  final String? subTitle;

  /// 操作区（如按钮组）。
  final Widget? extra;

  /// 自定义内容区（展示在操作区下方）。
  final Widget? children;

  /// 自定义图标（覆盖状态默认图标；数字状态仍展示数字大字）。
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final numeric = status.numericLabel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImage(theme, numeric),
        if (title != null) ...[
          const SizedBox(height: 24),
          Text(
            title!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colorTextHeading,
            ),
          ),
        ],
        if (subTitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subTitle!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: theme.fontSize,
              color: theme.colorTextSecondary,
            ),
          ),
        ],
        if (extra != null) ...[
          const SizedBox(height: 24),
          extra!,
        ],
        if (children != null) ...[
          const SizedBox(height: 24),
          children!,
        ],
      ],
    );
  }

  /// 构建状态图/数字大字区域。
  Widget _buildImage(AntThemeData theme, String? numeric) {
    if (numeric != null) {
      return Text(
        numeric,
        style: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.w600,
          height: 1,
          color: theme.colorTextHeading,
        ),
      );
    }

    final color = _statusColor(theme);
    final iconWidget = icon ?? Icon(status.icon, size: 72, color: color);
    return IconTheme.merge(
      data: IconThemeData(size: 72, color: color),
      child: iconWidget,
    );
  }

  /// 语义状态映射主题色。
  Color _statusColor(AntThemeData theme) {
    switch (status) {
      case AntResultStatus.success:
        return theme.colorSuccess;
      case AntResultStatus.error:
        return theme.colorError;
      case AntResultStatus.info:
        return theme.colorInfo;
      case AntResultStatus.warning:
        return theme.colorWarning;
      case AntResultStatus.notFound:
      case AntResultStatus.forbidden:
      case AntResultStatus.serverError:
        return theme.colorPrimary;
    }
  }
}
