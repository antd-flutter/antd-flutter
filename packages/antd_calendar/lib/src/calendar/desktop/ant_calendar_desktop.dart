/// 桌面渲染器 — 对齐 antd v6 Calendar（fullscreen 全屏面板 / card 迷你面板）。
///
/// C2 阶段按 antd v6 重写：
/// - 默认头部：年份下拉（±10 年，validRange 裁剪）+ 月份下拉 +
///   月/年面板切换（headerRender 可整体替换）；
/// - 月面板 6×7 网格：顶部细分隔线、选中 controlItemBgActive + 主色日期、
///   今天主色描边/文字、非本月补位淡化、showWeek 周序号列；
/// - 年面板：3×4 月份格，选中背景与今天主色；
/// - cellRender / fullCellRender 的 info 增加 type（date/month）与
///   originNode（默认渲染节点），并兼容废弃的 dateCellRender /
///   dateFullCellRender 映射；
/// - 删除原桌面路径的周/两周/多选专属分支，格式由共享核心决定。
library;

import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_core_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_locale.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_math.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_state.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 日期单元格最多展示的事件圆点数。
const int _kMaxEventDots = 3;

/// 周序号列宽度（antd v6 week 列）。
const double _kWeekColumnWidth = 44;

/// 桌面 fullscreen 日期格高度（antd v6 全屏面板约 100 高）。
const double _kFullscreenCellHeight = 96;

/// 桌面 card 日期格高度（antd v6 miniContentHeight 256 / 6 行）。
const double _kCardCellHeight = 44;

/// 桌面渲染器（antd v6 对齐）。
class AntCalendarDesktop extends StatelessWidget {
  /// 创建桌面渲染器。
  const AntCalendarDesktop({
    super.key,
    required this.core,
    required this.fullscreen,
    required this.locale,
    this.header,
  });

  /// 共享状态机。
  final AntCalendarCoreState core;

  /// true 为 antd v6 fullscreen 全屏面板，false 为 card 迷你面板。
  final bool fullscreen;

  /// 国际化文案。
  final AntCalendarLocale locale;

  /// 旧版自定义头部（headerRender 优先级更高）。
  final Widget? header;

  AntCalendarCoreConfig get _config => core.config;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final days = core.gridDays;
    final today = calendarDateOnly(DateTime.now());

    final body = core.mode == AntCalendarMode.year
        ? _buildMonthPanel(t, today)
        : _buildDatePanel(t, days, today);

    final panel = Container(
      key: const Key('ant-calendar-desktop'),
      width: fullscreen ? null : t.s(300),
      padding: fullscreen
          ? EdgeInsets.symmetric(horizontal: t.s(8))
          : EdgeInsets.all(t.s(4)),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius:
            fullscreen ? null : BorderRadius.circular(t.borderRadiusLG),
        border: fullscreen ? null : Border.all(color: t.colorSplit, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(t),
          body,
        ],
      ),
    );
    // card 形态固定 300 宽（antd v6 card demo），Align 提供宽松约束使宽度生效。
    return fullscreen
        ? panel
        : Align(alignment: Alignment.topLeft, child: panel);
  }

  // ---------------------------------------------------------------------------
  // 头部
  // ---------------------------------------------------------------------------

  Widget _buildHeader(AntThemeData t) {
    final headerRender = _config.headerRender;
    if (headerRender != null) {
      return headerRender(
        AntCalendarHeaderRenderConfig(
          value: core.selectedDate ?? core.focusedDate,
          type: core.mode,
          onChange: (date) =>
              core.selectFromHeader(date, AntCalendarSelectSource.customize),
          onTypeChange: core.setMode,
        ),
      );
    }
    if (header != null) return header!;
    return _buildDefaultHeader(t);
  }

  /// antd v6 默认头部：右侧对齐的年份/月份下拉 + 月年模式切换。
  Widget _buildDefaultHeader(AntThemeData t) {
    final year = core.currentMonth.year;
    final years = _headerYears(year);
    final months = _headerMonths(year);
    final selectSize = fullscreen ? AntSelectSize.middle : AntSelectSize.small;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: t.s(4),
        vertical: t.s(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: t.s(104),
            child: AntSelect<int>(
              key: const Key('ant-calendar-year-select'),
              size: selectSize,
              options: years,
              value: years.contains(year) ? year : null,
              labelOf: locale.yearLabel,
              onChange: (value) {
                if (value != null) _onYearSelected(value);
              },
            ),
          ),
          if (core.mode == AntCalendarMode.month) ...[
            SizedBox(width: t.s(8)),
            SizedBox(
              width: t.s(88),
              child: AntSelect<int>(
                key: const Key('ant-calendar-month-select'),
                size: selectSize,
                options: months,
                value: months.contains(core.currentMonth.month)
                    ? core.currentMonth.month
                    : null,
                labelOf: locale.monthLabel,
                onChange: (value) {
                  if (value != null) _onMonthSelected(value);
                },
              ),
            ),
          ],
          SizedBox(width: t.s(8)),
          _buildModeSwitcher(t, selectSize),
        ],
      ),
    );
  }

  /// 年份下拉区间：默认当前展示年 ±10（共 20 年），validRange 时取完整范围。
  List<int> _headerYears(int currentYear) {
    final range = _config.validRange;
    if (range != null) {
      return [
        for (var year = range.start.year; year <= range.end.year; year++) year,
      ];
    }
    final start = currentYear - 10;
    return [for (var i = 0; i < 20; i++) start + i];
  }

  /// 月份下拉区间：validRange 首/末年的月份按范围裁剪（antd v6 Header 逻辑）。
  List<int> _headerMonths(int year) {
    final range = _config.validRange;
    var start = 1;
    var end = 12;
    if (range != null) {
      if (year == range.start.year && range.start.month > start) {
        start = range.start.month;
      }
      if (year == range.end.year && range.end.month < end) {
        end = range.end.month;
      }
    }
    return [for (var month = start; month <= end; month++) month];
  }

  void _onYearSelected(int year) {
    final month = core.currentMonth.month;
    final day = core.focusedDate.day;
    core.selectFromHeader(
      DateTime(year, month, day),
      AntCalendarSelectSource.year,
    );
  }

  void _onMonthSelected(int month) {
    final year = core.currentMonth.year;
    final day = core.focusedDate.day;
    core.selectFromHeader(
      DateTime(year, month, day),
      AntCalendarSelectSource.month,
    );
  }

  /// 月/年面板切换器（antd v6 Radio.Button 对齐：选中项主色描边 + 主色文字）。
  Widget _buildModeSwitcher(AntThemeData t, AntSelectSize size) {
    if (!_config.showModeSwitcher) return const SizedBox.shrink();
    final height = size == AntSelectSize.small
        ? t.s(24)
        : size == AntSelectSize.large
            ? t.s(40)
            : t.s(32);
    final items = <AntCalendarMode, String>{
      AntCalendarMode.month: locale.effectiveModeMonthText,
      AntCalendarMode.year: locale.effectiveModeYearText,
    };
    final entries = items.entries.toList();
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(t.borderRadius),
        border: Border.all(color: t.colorBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < entries.length; i++)
            GestureDetector(
              key: Key('ant-calendar-mode-${entries[i].key.name}'),
              onTap: () => core.setMode(entries[i].key),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: t.s(8)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      entries[i].key == core.mode ? t.colorBgContainer : null,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(
                      i == 0 ? t.borderRadius : 0,
                    ),
                    right: Radius.circular(
                      i == entries.length - 1 ? t.borderRadius : 0,
                    ),
                  ),
                  border: Border.all(
                    color: entries[i].key == core.mode
                        ? t.colorPrimary
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Text(
                  entries[i].value,
                  style: TextStyle(
                    fontSize: t.fontSizeSM,
                    color: entries[i].key == core.mode
                        ? t.colorPrimary
                        : t.colorTextSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 月面板（日期网格）
  // ---------------------------------------------------------------------------

  Widget _buildDatePanel(
    AntThemeData t,
    List<DateTime> days,
    DateTime today,
  ) {
    final weekLabels = locale.weekLabelsFor(
      weekStartsOnMonday: core.weekStartsOnMonday,
    );
    final weeks = (days.length / kCalendarDaysPerWeek).ceil();

    return Column(
      key: const Key('ant-calendar-desktop-grid'),
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildWeekdayRow(t, weekLabels),
        for (var row = 0; row < weeks; row++)
          _buildWeekRow(t, days, row, today),
      ],
    );
  }

  Widget _buildWeekdayRow(AntThemeData t, List<String> labels) {
    return Row(
      key: const Key('ant-calendar-weekday-row'),
      children: [
        if (_config.showWeek) SizedBox(width: t.s(_kWeekColumnWidth)),
        for (final label in labels)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: fullscreen ? t.s(8) : 0,
                bottom: t.s(4),
              ),
              child: Text(
                label,
                textAlign: fullscreen ? TextAlign.right : TextAlign.center,
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: t.colorTextSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWeekRow(
    AntThemeData t,
    List<DateTime> days,
    int row,
    DateTime today,
  ) {
    final cells = <Widget>[];
    if (_config.showWeek) {
      final weekNumber = calendarWeekNumber(
        days[row * kCalendarDaysPerWeek],
        weekStartsOnMonday: core.weekStartsOnMonday,
      );
      cells.add(
        Container(
          key: Key('ant-calendar-week-cell-$row'),
          width: t.s(_kWeekColumnWidth),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: t.s(4), right: t.s(8)),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: t.colorSplit, width: 1),
            ),
          ),
          child: Text(
            '$weekNumber',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextTertiary,
            ),
          ),
        ),
      );
    }
    for (var col = 0; col < kCalendarDaysPerWeek; col++) {
      final day = calendarDateOnly(days[row * kCalendarDaysPerWeek + col]);
      cells.add(
        Expanded(
          child: _buildDayCell(t, day, today, col: col),
        ),
      );
    }
    // IntrinsicHeight + stretch 保证周序号列与日期列同高（antd cell-week）。
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cells,
      ),
    );
  }

  Widget _buildDayCell(
    AntThemeData t,
    DateTime day,
    DateTime today, {
    required int col,
  }) {
    final isCurrentMonth = calendarIsSameMonth(day, core.currentMonth);
    final isToday = calendarIsSameDay(day, today);
    final isSelected = core.isSelected(day);
    final isInRange = core.isInRange(day);
    final disabled = core.isDisabled(day);
    final inValidRange = _config.validRange?.contains(day) ?? true;

    Color dateColor;
    if (disabled) {
      dateColor = t.colorTextDisabled;
    } else if (isSelected || isToday) {
      dateColor = t.colorPrimary;
    } else if (!isCurrentMonth) {
      dateColor = t.colorTextQuaternary;
    } else {
      dateColor = t.colorText;
    }

    // 默认内容层（cellRender 的 originNode 基准）。
    final defaultContent = _buildDefaultCellContent(
      t,
      day,
      dateColor: dateColor,
      disabled: disabled,
      isCurrentMonth: isCurrentMonth,
    );
    final contentInfo = AntCalendarCellRenderInfo(
      isToday: isToday,
      isSelected: isSelected,
      isCurrentMonth: isCurrentMonth,
      isDisabled: disabled,
      isInValidRange: inValidRange,
      type: AntCalendarCellType.date,
      originNode: defaultContent,
    );
    final content = _config.cellRender?.call(day, contentInfo) ??
        _config.dateCellRender?.call(day) ??
        _config.dateCell?.call(
          day,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          isSelected: isSelected,
        ) ??
        defaultContent;

    // 默认整格（fullCellRender 的 originNode 基准）：antd v6 顶部细分隔线、
    // 选中 controlItemBgActive、今天主色描边。
    final defaultCell = Container(
      height: t.s(fullscreen ? _kFullscreenCellHeight : _kCardCellHeight),
      padding: EdgeInsets.fromLTRB(
        t.s(8),
        t.s(4),
        fullscreen ? t.s(8) : t.s(4),
        t.s(4),
      ),
      decoration: BoxDecoration(
        color: disabled
            ? null
            : isSelected
                ? t.controlItemBgActive
                : isInRange
                    ? t.colorPrimary.withValues(alpha: 0.06)
                    : null,
        border: Border(
          top: BorderSide(
            color: isToday && !isSelected ? t.colorPrimary : t.colorSplit,
            width: 1,
          ),
          left: col == 0
              ? BorderSide(color: t.colorSplit, width: 1)
              : BorderSide.none,
        ),
      ),
      child: isCurrentMonth ? content : Opacity(opacity: 0.45, child: content),
    );

    final fullInfo = AntCalendarCellRenderInfo(
      isToday: isToday,
      isSelected: isSelected,
      isCurrentMonth: isCurrentMonth,
      isDisabled: disabled,
      isInValidRange: inValidRange,
      type: AntCalendarCellType.date,
      originNode: defaultCell,
    );
    final rendered = _config.fullCellRender?.call(day, fullInfo) ??
        _config.dateFullCellRender?.call(day) ??
        defaultCell;

    return GestureDetector(
      key: Key('ant-calendar-cell-${day.year}-${day.month}-${day.day}'),
      onTap: disabled ? null : () => core.handleDayTap(day),
      behavior: HitTestBehavior.opaque,
      child: rendered,
    );
  }

  /// 默认单元格内容：日期数字（renderDate 可覆盖）+ 子标题
  /// （renderLabel / 事件点标记）。
  Widget _buildDefaultCellContent(
    AntThemeData t,
    DateTime day, {
    required Color dateColor,
    required bool disabled,
    required bool isCurrentMonth,
  }) {
    final events = core.eventsOf(day);
    final subtitle = _config.renderLabel?.call(day) ??
        (events.isNotEmpty
            ? _buildEventDots(
                t,
                disabled ? t.colorTextDisabled : t.colorPrimary,
                events,
              )
            : null);
    final dateWidget = _config.renderDate?.call(day) ??
        Text(
          fullscreen ? '${day.day}'.padLeft(2, '0') : '${day.day}',
          style: TextStyle(
            fontSize: fullscreen ? t.fontSize : t.fontSizeSM,
            color: dateColor,
            fontWeight: FontWeight.w400,
          ),
        );

    if (!fullscreen) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dateWidget,
          if (subtitle != null) subtitle,
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(alignment: Alignment.topRight, child: dateWidget),
        if (subtitle != null)
          Padding(
            padding: EdgeInsets.only(top: t.s(4)),
            child: Align(alignment: Alignment.topLeft, child: subtitle),
          ),
      ],
    );
  }

  Widget _buildEventDots(
    AntThemeData t,
    Color color,
    List<DateTime> events,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: fullscreen ? t.s(4) : t.s(1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < events.length && i < _kMaxEventDots; i++)
            Container(
              width: fullscreen ? t.s(6) : t.s(3),
              height: fullscreen ? t.s(6) : t.s(3),
              margin: EdgeInsets.symmetric(horizontal: t.s(1)),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 年面板（月份网格）
  // ---------------------------------------------------------------------------

  Widget _buildMonthPanel(AntThemeData t, DateTime today) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 3; row++)
          Row(
            children: [
              for (var col = 0; col < 4; col++)
                Expanded(
                  child: _buildMonthCell(
                    t,
                    DateTime(core.currentMonth.year, row * 4 + col + 1),
                    today,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildMonthCell(
    AntThemeData t,
    DateTime month,
    DateTime today,
  ) {
    final disabled = core.isMonthBlocked(month) ||
        (_config.min != null &&
            month.isBefore(DateTime(_config.min!.year, _config.min!.month))) ||
        (_config.max != null &&
            month.isAfter(DateTime(_config.max!.year, _config.max!.month)));
    final isToday = calendarIsSameMonth(month, today);
    final selected = core.selectedDate != null &&
        calendarIsSameMonth(month, core.selectedDate!);

    final defaultContent = Text(
      locale.monthLabel(month.month),
      style: TextStyle(
        fontSize: fullscreen ? t.fontSizeLG : t.fontSize,
        fontWeight: FontWeight.w500,
        color: disabled
            ? t.colorTextDisabled
            : selected || isToday
                ? t.colorPrimary
                : t.colorText,
      ),
    );
    final info = AntCalendarCellRenderInfo(
      isToday: isToday,
      isSelected: selected,
      isCurrentMonth: month.year == core.currentMonth.year,
      isDisabled: disabled,
      isInValidRange: !disabled,
      type: AntCalendarCellType.month,
      originNode: defaultContent,
    );
    final content = _config.cellRender?.call(month, info) ??
        _config.monthCellRender?.call(month) ??
        defaultContent;

    final defaultCell = Container(
      height: t.s(fullscreen ? 64 : 36),
      margin: EdgeInsets.all(fullscreen ? t.s(2) : t.s(1)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? t.controlItemBgActive : null,
        borderRadius: BorderRadius.circular(t.borderRadiusSM),
        border: Border.all(
          color: isToday ? t.colorPrimary : t.colorSplit,
          width: 1,
        ),
      ),
      child: content,
    );

    final fullInfo = AntCalendarCellRenderInfo(
      isToday: isToday,
      isSelected: selected,
      isCurrentMonth: month.year == core.currentMonth.year,
      isDisabled: disabled,
      isInValidRange: !disabled,
      type: AntCalendarCellType.month,
      originNode: defaultCell,
    );
    final rendered = _config.fullCellRender?.call(month, fullInfo) ??
        _config.monthFullCellRender?.call(month) ??
        defaultCell;

    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              core.jumpToYearMonth(month.year, month.month);
              core.setMode(AntCalendarMode.month);
            },
      behavior: HitTestBehavior.opaque,
      child: rendered,
    );
  }
}
