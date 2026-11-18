/// AntCalendar 类型定义。
library;

import 'package:flutter/widgets.dart';

/// 日历可见格式（吸收 table_calendar calendarFormat，参考 Apache-2.0 源码改造）。
enum AntCalendarFormat {
  /// 月视图（默认，固定 6 行网格）。
  month,

  /// 两周视图（锚定日期所在的两周）。
  twoWeeks,

  /// 周视图（锚定日期所在的一周）。
  week,
}

/// 日历布局形态（双实现切换）。
enum AntCalendarLayout {
  /// 自动：经 AntResponsive 自适应（desktop/web → fullscreen，phone/tablet → card）。
  auto,

  /// 强制桌面形态（fullscreen 大格子 + dateCell 内容插槽 + 头部年月下拉）。
  fullscreen,

  /// 强制移动形态（紧凑面板 + 滑动手势）。
  card,
}

/// 自定义日期单元格构建回调。
///
/// [date] 为单元格对应日期（已去除时分秒）；
/// [isCurrentMonth] 表示是否属于当前展示月份（非本月补位日期为 false）；
/// [isToday] 表示是否为今天；
/// [isSelected] 表示是否为选中日期。
typedef AntCalendarDateCellBuilder = Widget? Function(
  DateTime date, {
  required bool isCurrentMonth,
  required bool isToday,
  required bool isSelected,
});

/// 周起始日设置。
enum AntCalendarWeekStartsOn {
  /// 周一为一周起始。
  monday,

  /// 周日为一周起始（默认）。
  sunday,
}

/// 日历选择模式。
enum AntCalendarSelectionMode {
  /// 单选模式。
  single,

  /// 范围选择模式。
  range,
}
