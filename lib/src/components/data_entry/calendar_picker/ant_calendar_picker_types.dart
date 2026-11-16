/// AntCalendarPicker 类型定义。
library;

/// 日历选择模式。
enum AntCalendarSelectionMode {
  /// 单选模式。
  single,

  /// 范围选择模式。
  range,
}

/// 周起始日设置。
enum AntCalendarWeekStartsOn {
  /// 周一为一周起始。
  monday,

  /// 周日为一周起始（默认）。
  sunday,
}