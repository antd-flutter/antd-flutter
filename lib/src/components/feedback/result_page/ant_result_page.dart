/// AntResultPage — antd-mobile v5 ResultPage 的 Flutter 实现
///
/// API 与 antd-mobile v5 ResultPage 对齐：
/// - [AntResultPage.status] — 结果状态（success/error/info/warning/waiting），图标自动映射
/// - [AntResultPage.title] — 主标题
/// - [AntResultPage.subTitle] — 副标题
/// - [AntResultPage.description] — 明细描述（多行文字列表）
/// - [AntResultPage.buttons] — 操作按钮区
/// - [AntResultPage.icon] — 自定义图标（覆盖状态默认图标）
/// - [AntResultPage.children] — 自定义内容区
///
/// 与 [AntResult]（antd React Result 对齐版）的差异：支持 description 多行
/// 明细列表 + buttons 操作区，页面级排版垂直居中。
///
/// ```dart
/// AntResultPage(
///   status: AntResultPageStatus.success,
///   title: '操作成功',
///   description: [Text('订单号：20240101'), Text('支付方式：支付宝')],
///   buttons: [AntButton(child: Text('查看订单'), onTap: () {})],
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/feedback/result_page/ant_result_page_types.dart';
export 'package:antd_flutter_plus/src/components/feedback/result_page/ant_result_page_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntResultPage
// ============================================================

/// 页面级结果页 — 用于反馈一整套操作流程的最终处理结果。
///
/// 对齐 antd-mobile v5 ResultPage 组件；整体内容在可用空间内垂直居中。
class AntResultPage extends StatelessWidget {
  const AntResultPage({
    super.key,
    this.status = AntResultPageStatus.info,
    this.title,
    this.subTitle,
    this.description,
    this.buttons,
    this.children,
    this.icon,
  });

  /// 结果状态（决定默认图标与颜色）。
  final AntResultPageStatus status;

  /// 主标题。
  final String? title;

  /// 副标题。
  final String? subTitle;

  /// 明细描述（多行文字列表，展示在副标题下方）。
  final List<Widget>? description;

  /// 操作按钮区（按钮列表，水平居中排列）。
  final List<Widget>? buttons;

  /// 自定义内容区（展示在按钮区下方）。
  final Widget? children;

  /// 自定义图标（覆盖状态默认图标）。
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final color = _statusColor(theme);

    final items = <Widget>[
      IconTheme.merge(
        data: IconThemeData(size: 64, color: color),
        child: icon ?? Icon(status.icon, size: 64, color: color),
      ),
      if (title != null) ...[
        const SizedBox(height: 12),
        Text(
          title!,
          textAlign: TextAlign.center,
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
      if (description != null && description!.isNotEmpty) ...[
        const SizedBox(height: 16),
        ..._buildDescription(theme),
      ],
      if (buttons != null && buttons!.isNotEmpty) ...[
        const SizedBox(height: 24),
        _buildButtons(theme),
      ],
      if (children != null) ...[
        const SizedBox(height: 24),
        children!,
      ],
    ];

    // 页面级排版：内容在可用空间内垂直居中。
    return SizedBox(
      width: double.infinity,
      child: Column(
        key: const Key('ant_result_page_layout'),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }

  /// 构建多行明细列表。
  List<Widget> _buildDescription(AntThemeData theme) {
    return [
      for (var i = 0; i < description!.length; i++) ...[
        description![i],
        if (i != description!.length - 1) const SizedBox(height: 6),
      ],
    ];
  }

  /// 构建按钮操作区。
  Widget _buildButtons(AntThemeData theme) {
    final list = buttons!;
    return Wrap(
      key: const Key('ant_result_page_buttons'),
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: list,
    );
  }

  /// 语义状态映射主题色。
  Color _statusColor(AntThemeData theme) {
    switch (status) {
      case AntResultPageStatus.success:
        return theme.colorSuccess;
      case AntResultPageStatus.error:
        return theme.colorError;
      case AntResultPageStatus.info:
        return theme.colorInfo;
      case AntResultPageStatus.warning:
        return theme.colorWarning;
      case AntResultPageStatus.waiting:
        return theme.colorPrimary;
    }
  }
}
