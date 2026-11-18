import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_pull_to_refresh.dart';

/// AntPullToRefresh 默认底部（加载更多）指示器。
///
/// 指示器结构参照 [easy_refresh](https://pub.dev/packages/easy_refresh)
/// 的 `ClassicFooter`（MIT License）精简：
/// - loading：转圈 + 文案；
/// - noMore：提示「没有更多了」，不再触发；
/// - failed：失败文案 + 「点击重试」，点击触发 [onRetry]。
///
/// 自定义内容仍通过 [AntPullToRefresh.footer] 整体替换本指示器。
class AntPullToRefreshFooter extends StatelessWidget {
  const AntPullToRefreshFooter({
    super.key,
    required this.status,
    this.loadingText,
    this.noMoreText,
    this.failedText,
    this.retryText,
    this.onRetry,
    this.indicatorSize = kAntPullToRefreshIndicatorSize,
    this.spacing = kAntPullToRefreshIndicatorSpacing,
  });

  /// 当前加载更多状态。
  final AntPullToRefreshFooterStatus status;

  /// 加载中文案（伴随转圈显示）。
  final String? loadingText;

  /// 没有更多文案。
  final String? noMoreText;

  /// 加载失败文案。
  final String? failedText;

  /// 失败后重试按钮文案。
  final String? retryText;

  /// 失败态点击重试回调（默认 footer 由组件内部接线）。
  final VoidCallback? onRetry;

  /// 状态图标尺寸。
  final double indicatorSize;

  /// 图标与文案间距。
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final TextStyle textStyle = TextStyle(
      fontSize: kAntPullToRefreshTextFontSize,
      color: theme.colorTextSecondary,
    );

    return switch (status) {
      AntPullToRefreshFooterStatus.loading => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: indicatorSize,
              height: indicatorSize,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: spacing),
            Text(loadingText ?? kAntPullToRefreshLoadingText, style: textStyle),
          ],
        ),
      AntPullToRefreshFooterStatus.noMore => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.horizontal_rule,
              size: indicatorSize,
              color: theme.colorTextTertiary,
            ),
            SizedBox(width: spacing),
            Text(noMoreText ?? kAntPullToRefreshNoMoreText, style: textStyle),
          ],
        ),
      AntPullToRefreshFooterStatus.failed => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: indicatorSize,
              color: theme.colorError,
            ),
            SizedBox(width: spacing),
            Text(failedText ?? kAntPullToRefreshFailedText, style: textStyle),
            SizedBox(width: spacing),
            GestureDetector(
              key: kAntPullToRefreshFooterRetryKey,
              onTap: onRetry,
              child: Text(
                retryText ?? kAntPullToRefreshRetryText,
                style: TextStyle(
                  fontSize: kAntPullToRefreshTextFontSize,
                  color: theme.colorPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      // idle 状态下 footer 不展示，无需内容。
      AntPullToRefreshFooterStatus.idle => const SizedBox.shrink(),
    };
  }
}
