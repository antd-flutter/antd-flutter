import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_pull_to_refresh.dart';
/// AntPullToRefresh 默认头部指示器。
///
/// 指示器结构参照 [pull_to_refresh_flutter3](https://github.com/xxzj990-game/flutter_pulltorefresh)
/// 的 `ClassicIndicator`（MIT License）整理：
/// 状态文案 + 状态图标（箭头/转圈/完成标记）居中展示，
/// 各状态由 [AntPullToRefreshStatus] 驱动，自定义内容仍通过
/// [AntPullToRefresh.header] 整体替换本指示器。
class AntPullToRefreshHeader extends StatelessWidget {
  const AntPullToRefreshHeader({
    super.key,
    required this.status,
    this.pullingText,
    this.releasingText,
    this.finishingText,
    this.completeText,
    this.indicatorSize = kAntPullToRefreshIndicatorSize,
    this.spacing = kAntPullToRefreshIndicatorSpacing,
  });

  /// 当前刷新状态。
  final AntPullToRefreshStatus status;

  /// 下拉中（未达阈值）文案。
  final String? pullingText;

  /// 达到阈值释放即刷新文案。
  final String? releasingText;

  /// 刷新中文案（伴随转圈显示）。
  final String? finishingText;

  /// 刷新完成文案。
  final String? completeText;

  /// 状态图标尺寸。
  final double indicatorSize;

  /// 图标与文案间距。
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final String text = switch (status) {
      AntPullToRefreshStatus.canRelease =>
        releasingText ?? kAntPullToRefreshReleasingText,
      AntPullToRefreshStatus.refreshing =>
        finishingText ?? kAntPullToRefreshFinishingText,
      AntPullToRefreshStatus.complete =>
        completeText ?? kAntPullToRefreshCompleteText,
      _ => pullingText ?? kAntPullToRefreshPullingText,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIndicator(theme),
        SizedBox(width: spacing),
        Text(
          text,
          style: TextStyle(
            fontSize: kAntPullToRefreshTextFontSize,
            color: theme.colorTextSecondary,
          ),
        ),
      ],
    );
  }

  /// 按状态渲染图标：下拉箭头 / 释放箭头 / 转圈 / 完成标记。
  Widget _buildIndicator(AntThemeData theme) {
    return switch (status) {
      AntPullToRefreshStatus.canRelease => Icon(
          Icons.arrow_upward,
          size: indicatorSize,
          color: theme.colorTextSecondary,
        ),
      AntPullToRefreshStatus.refreshing => SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      AntPullToRefreshStatus.complete => Icon(
          Icons.check,
          size: indicatorSize,
          color: theme.colorSuccess,
        ),
      _ => Icon(
          Icons.arrow_downward,
          size: indicatorSize,
          color: theme.colorTextSecondary,
        ),
    };
  }
}
