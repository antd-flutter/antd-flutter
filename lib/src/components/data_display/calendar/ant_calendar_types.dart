/// AntCalendar 类型定义。
library;

import 'package:flutter/material.dart';

export 'package:antd_flutter_plus/src/components/data_entry/calendar_picker/ant_calendar_picker_types.dart'
    show AntCalendarWeekStartsOn;

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
