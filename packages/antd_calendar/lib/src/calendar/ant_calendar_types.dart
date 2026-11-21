/// AntCalendar 类型定义。
library;

import 'package:flutter/widgets.dart';

/// 日历面板模式（antd v6 mode 对齐：月面板 / 年面板）。
enum AntCalendarMode {
  /// 月面板（日期网格，默认）。
  month,

  /// 年面板（12 个月网格，点击月份回到月面板）。
  year,
}

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

/// 日历平台渲染器选择（C1 引入；auto 按 [AntPlatform] 分派）。
enum AntCalendarPlatform {
  /// 自动：移动端 → mobile 渲染器，其余 → desktop 渲染器。
  auto,

  /// 强制桌面渲染器（antd v6 形态，C1 阶段兼容 fullscreen/card 两种布局）。
  desktop,

  /// 强制移动渲染器（antd-mobile v5 形态）。
  mobile,
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

/// 有效日期范围（antd v6 validRange 对齐）。
///
/// 范围外日期不可交互（等同禁用），且面板导航被裁剪在范围内；
/// 传参方式：`AntCalendarValidRange(DateTime(2024, 1, 1), DateTime(2024, 12, 31))`。
class AntCalendarValidRange {
  /// 创建有效范围（[start] ≤ [end]，构造时自动归一化并去除时分秒）。
  AntCalendarValidRange(DateTime start, DateTime end)
      : start = _dateOnly(
          start.isBefore(end) ? start : end,
        ),
        end = _dateOnly(start.isBefore(end) ? end : start);

  /// 范围起点（含当天）。
  final DateTime start;

  /// 范围终点（含当天）。
  final DateTime end;

  /// 判断日期是否在范围内（按天比较，含边界）。
  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  bool operator ==(Object other) =>
      other is AntCalendarValidRange &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// 单元格类型（antd v6 `info.type` 对齐）：日期格 / 月格。
enum AntCalendarCellType {
  /// 日期面板的日期格。
  date,

  /// 年面板的月份格。
  month,
}

/// 选择来源（antd v6 `SelectInfo.source` 对齐）。
enum AntCalendarSelectSource {
  /// 点击日期格（月面板默认来源）。
  date,

  /// 头部年份下拉切换（antd v6 `source: 'year'`）。
  year,

  /// 头部月份下拉切换（antd v6 `source: 'month'`）。
  month,

  /// 自定义头部 `headerRender` 触发（antd v6 `source: 'customize'`）。
  customize,
}

/// 选中事件附加信息（antd v6 `onSelect(date, info)` 的 info 对齐）。
class AntCalendarSelectInfo {
  /// 创建选择信息。
  const AntCalendarSelectInfo({required this.source});

  /// 本次选择的来源。
  final AntCalendarSelectSource source;

  @override
  String toString() => 'AntCalendarSelectInfo(source: $source)';
}

/// 自定义头部渲染配置（antd v6 `headerRender` 的 config 对齐）。
class AntCalendarHeaderRenderConfig {
  /// 创建头部渲染配置。
  const AntCalendarHeaderRenderConfig({
    required this.value,
    required this.type,
    required this.onChange,
    required this.onTypeChange,
  });

  /// 当前值（选中日期，未选中时回退焦点日）。
  final DateTime value;

  /// 当前面板模式（month / year）。
  final AntCalendarMode type;

  /// 头部改动日期时调用（对应 antd v6 `onChange(date)`）。
  final ValueChanged<DateTime> onChange;

  /// 头部切换面板模式时调用（对应 antd v6 `onTypeChange(type)`）。
  final ValueChanged<AntCalendarMode> onTypeChange;
}

/// 自定义头部渲染回调（antd v6 `headerRender` 对齐，仅桌面渲染器生效）。
typedef AntCalendarHeaderRender = Widget Function(
  AntCalendarHeaderRenderConfig config,
);

/// 单元格渲染信息（antd v6 cellRender / fullCellRender 的 info 参数对齐）。
class AntCalendarCellRenderInfo {
  const AntCalendarCellRenderInfo({
    required this.isToday,
    required this.isSelected,
    required this.isCurrentMonth,
    required this.isDisabled,
    required this.isInValidRange,
    this.type = AntCalendarCellType.date,
    this.originNode,
  });

  /// 是否为今天。
  final bool isToday;

  /// 是否为选中日期。
  final bool isSelected;

  /// 是否属于当前展示月份。
  final bool isCurrentMonth;

  /// 是否被禁用（disabledDate / min/max / validRange 之外）。
  final bool isDisabled;

  /// 是否在 validRange 内（未配置 validRange 时恒为 true）。
  final bool isInValidRange;

  /// 单元格类型（antd v6 `info.type`）：日期格为 [AntCalendarCellType.date]，
  /// 月面板的月格为 [AntCalendarCellType.month]。
  final AntCalendarCellType type;

  /// 默认渲染节点（antd v6 `info.originNode` 的降级近似）：
  /// `cellRender` / `fullCellRender` 中可直接包裹或作为替换参考。
  ///
  /// 说明：与 antd 一致，`cellRender` 的 originNode 为默认「内容层」节点
  /// （日期数字 + 内容插槽），`fullCellRender` 的 originNode 为默认「整格」
  /// 节点（含分隔线、选中背景、内边距）；两者均为惰性构建的普通 Widget，
  /// 但未挂载 Element，不可通过 GlobalKey 读取其状态。
  final Widget? originNode;

  @override
  String toString() =>
      'AntCalendarCellRenderInfo(isToday: $isToday, isSelected: $isSelected, '
      'isCurrentMonth: $isCurrentMonth, isDisabled: $isDisabled, '
      'isInValidRange: $isInValidRange, type: $type)';
}

/// cellRender 内容层渲染回调（antd v6 cellRender 对齐）：
/// 返回 null 时回退默认内容（dateCell / 默认数字 + 事件点）。
typedef AntCalendarCellRender = Widget? Function(
  DateTime date,
  AntCalendarCellRenderInfo info,
);

/// fullCellRender 整格渲染回调（antd v6 fullCellRender 对齐）：
/// 返回 null 时回退 cellRender / 默认整格（含背景、边框、点击区）。
typedef AntCalendarFullCellRender = Widget? Function(
  DateTime date,
  AntCalendarCellRenderInfo info,
);

/// 移动端整格包裹渲染回调（C3 新增，antd-mobile `cellRender` 包裹语义）。
///
/// 与桌面替换式 [AntCalendarCellRender] 不同：本回调接收已渲染好的默认
/// 单元格 [oriNode]，在其外层包裹装饰/布局后返回（返回的 Widget 仍由组件
/// 统一处理点击）。默认渲染链为 renderDate → renderLabel → 默认内容，
/// 最后再用本回调包裹整格。
typedef AntCalendarMobileCellRender = Widget Function(
  Widget oriNode, {
  required DateTime date,
});

/// 移动端头部内置导航按钮标记（[AntCalendar.prevMonthButton] 等默认值）。
///
/// 渲染器识别该类型后按主题缩放绘制内置图标；传 `null` 表示隐藏该按钮；
/// 也可传入任意自定义 Widget 完全替换按钮外观。
class AntCalendarBuiltInNavButton extends StatelessWidget {
  /// 创建内置导航按钮标记。
  const AntCalendarBuiltInNavButton(this.icon, {super.key});

  /// 内置图标。
  final IconData icon;

  @override
  Widget build(BuildContext context) => Icon(icon);
}

/// 月面板单元格内容渲染回调（antd v6 monthCellRender 对齐）。
typedef AntCalendarMonthCellRender = Widget? Function(DateTime month);

/// 月面板整格渲染回调（antd v6 monthFullCellRender 对齐）。
typedef AntCalendarMonthFullCellRender = Widget? Function(DateTime month);

/// 面板变化回调（antd v6 onPanelChange 对齐）：
/// 面板模式切换或展示月份变化时触发。
typedef AntCalendarPanelChangeCallback = void Function(
  DateTime date,
  AntCalendarMode mode,
);

/// 年月页面（antd-mobile Page 对齐），用于 minPage/maxPage 面板导航范围限制。
class AntCalendarPage {
  /// 创建年月页面（month 取 1~12）。
  const AntCalendarPage({required this.year, required this.month});

  /// 年份。
  final int year;

  /// 月份（1~12）。
  final int month;

  /// 与目标月份比较：负数表示在目标之前，0 相同，正数在目标之后。
  int compareTo(int year, int month) {
    if (this.year != year) return this.year - year;
    return this.month - month;
  }

  @override
  bool operator ==(Object other) =>
      other is AntCalendarPage && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}
