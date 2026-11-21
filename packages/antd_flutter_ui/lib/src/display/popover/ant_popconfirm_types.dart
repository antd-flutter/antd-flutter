/// AntPopconfirm 类型定义 — antd React Popconfirm 的 Flutter 实现
library;

import 'package:flutter/widgets.dart';

/// 气泡确认框弹出位置（同 antd v6 Popconfirm placement，参考 Popover 九/十二方向）。
///
/// - 上：[topLeft] / [topCenter] / [topRight]
/// - 下：[bottomLeft] / [bottomCenter] / [bottomRight]
/// - 左：[leftTop] / [leftCenter] / [leftBottom]
/// - 右：[rightTop] / [rightCenter] / [rightBottom]
enum AntPopconfirmPlacement {
  /// 上方，左对齐。
  topLeft,

  /// 上方，水平居中。
  topCenter,

  /// 上方，右对齐。
  topRight,

  /// 下方，左对齐（默认）。
  bottomLeft,

  /// 下方，水平居中。
  bottomCenter,

  /// 下方，右对齐。
  bottomRight,

  /// 左侧，顶部对齐。
  leftTop,

  /// 左侧，垂直居中。
  leftCenter,

  /// 左侧，底部对齐。
  leftBottom,

  /// 右侧，顶部对齐。
  rightTop,

  /// 右侧，垂直居中。
  rightCenter,

  /// 右侧，底部对齐。
  rightBottom,
}

/// 气泡确认框浮层自定义样式。
class AntPopconfirmOverlayStyle {
  const AntPopconfirmOverlayStyle({
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.padding,
  });

  /// 浮层背景色。
  final Color? backgroundColor;

  /// 浮层圆角。
  final BorderRadius? borderRadius;

  /// 浮层边框。
  final Border? border;

  /// 浮层阴影。
  final List<BoxShadow>? boxShadow;

  /// 浮层内边距。
  final EdgeInsetsGeometry? padding;
}
