/// AntEllipsis 类型定义
library;

/// 文本截断方向。
enum AntEllipsisDirection {
  /// 截尾 — 从尾部截断（默认）
  end,

  /// 截头 — 从头部截断
  start,

  /// 截中间 — 头尾保留，中间截断
  middle,
}
