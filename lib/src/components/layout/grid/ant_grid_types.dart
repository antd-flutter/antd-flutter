/// AntGrid 类型定义 — 24 栅格布局
library;

/// Row 垂直对齐方式。
enum AntRowAlign {
  /// 顶部对齐（默认）。
  top,

  /// 居中对齐。
  middle,

  /// 底部对齐。
  bottom,
}

/// Row 水平分布方式。
enum AntRowJustify {
  /// 起点分布（默认）。
  start,

  /// 终点分布。
  end,

  /// 居中分布。
  center,

  /// 等距分布（两侧间距为项间距的一半）。
  spaceAround,

  /// 两端分布（首尾贴边，中间等距）。
  spaceBetween,
}