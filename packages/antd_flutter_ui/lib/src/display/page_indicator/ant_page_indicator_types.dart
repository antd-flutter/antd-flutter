/// AntPageIndicator 类型定义。
library;

/// 页码指示器方向。
enum AntPageIndicatorDirection {
  /// 水平排列（默认）。
  horizontal,

  /// 垂直排列。
  vertical,
}

/// 页码指示器预设配色。
enum AntPageIndicatorPresetColor {
  /// 主色激活（默认）：点为浅灰，激活点为主题主色。
  primary,

  /// 白色：点为半透明白，激活点为纯白（适合深色背景轮播）。
  white,
}
