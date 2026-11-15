/// AntDivider 类型定义
library;

/// 分割线类型。
enum AntDividerType {
  /// 水平分割线（默认）。
  horizontal,

  /// 垂直分割线。
  vertical,
}

/// 标题位置（仅水平分割线带标题时生效）。
enum AntDividerOrientation {
  /// 标题居左。
  left,

  /// 标题居中。
  center,

  /// 标题居右。
  right,
}

/// 线条样式变体。
enum AntDividerVariant {
  /// 实线（默认）。
  solid,

  /// 虚线。
  dashed,

  /// 点线。
  dotted,
}