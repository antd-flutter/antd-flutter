/// AntFooter — antd-mobile Footer 的 Flutter 实现
///
/// API 与 antd-mobile v5 对齐：
/// - [content] — 底部文案，默认 `Foot 返回顶部`
/// - [onClick] — 点击回调（如回顶部，由使用方实现）
/// - [child] — 自定义内容，传入时覆盖 content
/// - [style] — 容器样式透传
///
/// ```dart
/// AntFooter()
/// AntFooter(content: 'Custom Footer', onClick: () => controller.jumpTo(0))
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_display/footer/ant_footer_types.dart';
import 'package:flutter/material.dart';

/// 默认底部文案。
const String kAntFooterDefaultContent = 'Foot 返回顶部';

/// 页脚 — 页面底部说明与回顶部入口。
///
/// 对齐 antd-mobile Footer 组件。
class AntFooter extends StatelessWidget {
  const AntFooter({
    super.key,
    this.content = kAntFooterDefaultContent,
    this.onClick,
    this.child,
    this.style,
  });

  /// 底部文案，默认 `Foot 返回顶部`。
  final String content;

  /// 点击回调（如返回顶部，由使用方实现）。
  final GestureTapCallback? onClick;

  /// 自定义内容，传入时覆盖 [content]。
  final Widget? child;

  /// 容器样式透传。
  final BoxDecoration? style;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
      decoration: style ??
          BoxDecoration(color: theme.colorBgLayout),
      child: child ??
          GestureDetector(
            onTap: onClick,
            behavior: HitTestBehavior.opaque,
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: theme.fontSizeSM,
                color: theme.colorTextQuaternary,
              ),
            ),
          ),
    );
  }
}
