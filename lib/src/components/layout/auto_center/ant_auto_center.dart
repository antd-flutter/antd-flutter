/// AntAutoCenter — antd React AutoCenter 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [child] — 需要居中的内容
///
/// 扩展能力（Flutter 场景）：
/// - [expanded] — 为 true 时在 Flex 父级中占据剩余空间并居中
///
/// 让内容在剩余空间中自动居中。在 Column / Row 等弹性布局中，
/// 设置 [expanded] 为 true 可占据剩余空间；在非弹性布局中直接居中。
library;

import 'package:flutter/material.dart';

// ============================================================
// AntAutoCenter
// ============================================================

/// 自动居中 — 让内容在剩余空间中自动居中。
///
/// 对齐 antd React AutoCenter 组件，常用于页面内容区在
/// 导航栏与标签栏之间的剩余空间中居中展示。
///
/// ```dart
/// AntAutoCenter(child: Text('居中内容')) // 直接居中
/// Column(children: [navBar, AntAutoCenter(expanded: true, child: content)]) // 弹性布局中占据剩余空间居中
/// ```
class AntAutoCenter extends StatelessWidget {
  const AntAutoCenter({
    super.key,
    this.child,
    this.expanded = false,
  });

  /// 需要居中的内容。
  final Widget? child;

  /// 是否在 Flex 父级中占据剩余空间。
  ///
  /// 为 true 时内部使用 Expanded + Center，在 Column / Row 等
  /// 弹性布局中占据剩余空间并居中内容。
  /// 为 false（默认）时仅使用 Center，不改变自身尺寸约束。
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final centered = Center(child: child);
    if (expanded) {
      return Expanded(child: centered);
    }
    return centered;
  }
}