/// AntTooltip 类型定义 — antd React Tooltip 的 Flutter 实现
library;

// ============================================================
// AntTooltipPlacement — 弹出位置
// ============================================================

/// 气泡弹出位置。
///
/// 对齐 antd React Tooltip 的 `placement`：
/// top / bottom / left / right 及 8 个角落变体。
enum AntTooltipPlacement {
  /// 上方弹出（默认）。
  top,

  /// 上方弹出，左对齐。
  topLeft,

  /// 上方弹出，右对齐。
  topRight,

  /// 下方弹出。
  bottom,

  /// 下方弹出，左对齐。
  bottomLeft,

  /// 下方弹出，右对齐。
  bottomRight,

  /// 左侧弹出。
  left,

  /// 左侧弹出，顶部对齐。
  leftTop,

  /// 左侧弹出，底部对齐。
  leftBottom,

  /// 右侧弹出。
  right,

  /// 右侧弹出，顶部对齐。
  rightTop,

  /// 右侧弹出，底部对齐。
  rightBottom,
}

// ============================================================
// AntTooltipTrigger — 触发方式
// ============================================================

/// 气泡触发方式。
///
/// 未显式指定时按平台自动选择：桌面端 hover，移动端 click。
enum AntTooltipTrigger {
  /// 悬停触发（桌面端）。
  hover,

  /// 点击 / 长按触发（移动端）。
  click,

  /// 焦点触发。
  focus,
}
