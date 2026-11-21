import 'package:antd_calendar/src/calendar/ant_calendar_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_core_types.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_locale.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_math.dart';
import 'package:antd_calendar/src/calendar/calendar_core/calendar_state.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 年下拉面板的过去/未来年数（antd v6 默认区间）。
const int _kYearDropdownPastYears = 20;
const int _kYearDropdownFutureYears = 10;

/// 日期单元格最多展示的事件圆点数。
const int _kMaxEventDots = 3;

/// 桌面渲染器（C1 原样搬迁）。
///
/// C1 阶段同时承载 antd v6 fullscreen 与 card 两种布局，逻辑与旧
/// `_AntCalendarState` 的 build/渲染辅助方法逐行一致，差异仅在于状态来自
/// [AntCalendarCoreState]，而不是 Widget State 自身。
class AntCalendarDesktop extends StatelessWidget {
  const AntCalendarDesktop({
    super.key,
    required this.core,
    required this.fullscreen,
    required this.locale,
    this.header,
  });

  final AntCalendarCoreState core;
  final bool fullscreen;
  final AntCalendarLocale locale;
  final Widget? header;

  AntCalendarCoreConfig get _config => core.config;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final days = core.gridDays;
    final today = calendarDateOnly(DateTime.now());
    final weekLabels = locale.weekLabelsFor(
      weekStartsOnMonday: core.weekStartsOnMonday,
    );

    final body = core.mode == AntCalendarMode.year
        ? _buildMonthPanel(t, fullscreen)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: fullscreen ? t.s(8) : t.s(4),
                ),
                child: Row(
                  children: weekLabels
                      .map(
                        (label) => Expanded(
                          child: Center(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize:
                                    fullscreen ? t.fontSize : t.fontSizeSM,
                                color: t.colorTextSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              // 移动（card）形态支持左右滑动手势翻页（antd-mobile 惯例）。
              fullscreen
                  ? _buildDayGrid(t, days, today, fullscreen)
                  : GestureDetector(
                      onHorizontalDragEnd: (details) {
                        final v = details.primaryVelocity ?? 0;
                        if (v < 0) {
                          core.goToMonth(1);
                        } else if (v > 0) {
                          core.goToMonth(-1);
                        }
                      },
                      child: _buildDayGrid(t, days, today, fullscreen),
                    ),
            ],
          );

    return Container(
      padding: EdgeInsets.all(fullscreen ? t.s(8) : t.s(4)),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header! else _buildHeader(context, t, fullscreen),
          body,
        ],
      ),
    );
  }

  Widget _buildDayGrid(
    AntThemeData t,
    List<DateTime> days,
    DateTime today,
    bool fullscreen,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        (days.length / kCalendarDaysPerWeek).ceil(),
        (row) => Row(
          children: List.generate(kCalendarDaysPerWeek, (col) {
            final day = days[row * kCalendarDaysPerWeek + col];
            return Expanded(
              child: _buildDayCell(t, calendarDateOnly(day), today, fullscreen),
            );
          }),
        ),
      ),
    );
  }

  /// 默认头部：年导航 + 月导航 + 年月标题（可点跳转）+ 模式切换 +
  /// 格式切换 + 「本月」按钮。
  Widget _buildHeader(
    BuildContext context,
    AntThemeData t,
    bool fullscreen,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.s(8), vertical: t.s(8)),
      child: Row(
        children: [
          if (_config.showYearNavButtons)
            _buildNavIcon(
              t,
              AntIcons.doubleLeftOutlined,
              () => core.goToYear(-1),
            ),
          _buildNavIcon(t, AntIcons.leftOutlined, () => core.goToMonth(-1)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _config.enableYearMonthDropdown
                      ? () => _showYearMonthDropdown(context)
                      : null,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: t.s(4)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          locale.monthTitle(
                            core.currentMonth.year,
                            core.currentMonth.month,
                          ),
                          style: TextStyle(
                            fontSize: t.fontSizeLG,
                            fontWeight: FontWeight.w600,
                            color: t.colorText,
                          ),
                        ),
                        if (_config.enableYearMonthDropdown) ...[
                          SizedBox(width: t.s(2)),
                          Icon(
                            AntIcons.downOutlined,
                            size: t.s(16),
                            color: t.colorTextSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (_config.showModeSwitcher) ...[
                  SizedBox(width: t.s(8)),
                  _buildModeSwitcher(t),
                ],
              ],
            ),
          ),
          if (_config.showFormatSwitcher) _buildFormatSwitcher(t),
          GestureDetector(
            onTap: core.goToToday,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: t.s(8),
                vertical: t.s(4),
              ),
              child: Text(
                locale.effectiveTodayText,
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: t.colorPrimary,
                ),
              ),
            ),
          ),
          _buildNavIcon(t, AntIcons.rightOutlined, () => core.goToMonth(1)),
          if (_config.showYearNavButtons)
            _buildNavIcon(
              t,
              AntIcons.doubleRightOutlined,
              () => core.goToYear(1),
            ),
        ],
      ),
    );
  }

  /// 月/年面板切换器（antd v6 头部 Radio 对齐）。
  Widget _buildModeSwitcher(AntThemeData t) {
    final items = {
      AntCalendarMode.month: locale.effectiveModeMonthText,
      AntCalendarMode.year: locale.effectiveModeYearText,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.entries.map((entry) {
        final active = entry.key == core.mode;
        return GestureDetector(
          onTap: () => core.setMode(entry.key),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: t.s(8), vertical: t.s(2)),
            decoration: BoxDecoration(
              color: active ? t.colorPrimary : Colors.transparent,
              borderRadius: BorderRadius.horizontal(
                left: entry.key == AntCalendarMode.month
                    ? Radius.circular(t.borderRadiusSM)
                    : Radius.zero,
                right: entry.key == AntCalendarMode.year
                    ? Radius.circular(t.borderRadiusSM)
                    : Radius.zero,
              ),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: active ? Colors.white : t.colorTextSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavIcon(AntThemeData t, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(t.s(4)),
        child: Icon(icon, size: t.s(20), color: t.colorText),
      ),
    );
  }

  /// 格式切换按钮组（月 / 两周 / 周，table_calendar onFormatChanged 对齐）。
  Widget _buildFormatSwitcher(AntThemeData t) {
    const labels = {
      AntCalendarFormat.month: '月',
      AntCalendarFormat.twoWeeks: '两周',
      AntCalendarFormat.week: '周',
    };
    return Padding(
      padding: EdgeInsets.only(right: t.s(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: labels.entries.map((entry) {
          final active = entry.key == core.format;
          return GestureDetector(
            onTap: () => core.setFormat(entry.key),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: t.s(8),
                vertical: t.s(3),
              ),
              margin: EdgeInsets.symmetric(horizontal: t.s(1)),
              decoration: BoxDecoration(
                color: active ? t.colorPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(t.borderRadiusSM),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: active ? Colors.white : t.colorTextSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 年面板：12 个月单元格网格（antd v6 year mode 对齐）。
  Widget _buildMonthPanel(AntThemeData t, bool fullscreen) {
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
                    fullscreen,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildMonthCell(AntThemeData t, DateTime month, bool fullscreen) {
    final disabled = core.isMonthBlocked(month) ||
        (_config.min != null &&
            month.isBefore(
              DateTime(_config.min!.year, _config.min!.month),
            )) ||
        (_config.max != null &&
            month.isAfter(
              DateTime(_config.max!.year, _config.max!.month),
            ));
    final isCurrent = calendarIsSameMonth(month, DateTime.now());

    Widget content = _config.monthFullCellRender?.call(month) ??
        Container(
          margin: EdgeInsets.all(t.s(4)),
          constraints: BoxConstraints(
            minHeight: fullscreen ? t.s(64) : t.s(36),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(t.borderRadiusSM),
            border: Border.all(
              color: isCurrent ? t.colorPrimary : t.colorSplit,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: _config.monthCellRender?.call(month) ??
              Text(
                locale.monthLabel(month.month),
                style: TextStyle(
                  fontSize: fullscreen ? t.fontSizeLG : t.fontSize,
                  fontWeight: FontWeight.w500,
                  color: disabled
                      ? t.colorTextDisabled
                      : isCurrent
                          ? t.colorPrimary
                          : t.colorText,
                ),
              ),
        );

    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              core.jumpToYearMonth(month.year, month.month);
              core.setMode(AntCalendarMode.month);
            },
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }

  Widget _buildDayCell(
    AntThemeData t,
    DateTime day,
    DateTime today,
    bool fullscreen,
  ) {
    final isCurrentMonth = calendarIsSameMonth(day, core.currentMonth);
    final isToday = calendarIsSameDay(day, today);
    final events = core.eventsOf(day);

    final isSelected = core.isSelected(day);
    final isInRange = core.isInRange(day);
    final isRangePending = core.isRangePending;

    final disabled = core.isDisabled(day);
    final info = AntCalendarCellRenderInfo(
      isToday: isToday,
      isSelected: isSelected,
      isCurrentMonth: isCurrentMonth,
      isDisabled: disabled,
      isInValidRange: _config.validRange?.contains(day) ?? true,
    );

    Color textColor;
    Color? bgColor;
    if (disabled) {
      textColor = t.colorTextDisabled;
    } else if (isSelected) {
      textColor = Colors.white;
      bgColor = t.colorPrimary;
    } else if (isInRange) {
      textColor = t.colorPrimary;
      bgColor = t.colorPrimary.withValues(alpha: 0.1);
    } else if (isToday) {
      textColor = t.colorPrimary;
    } else if (!isCurrentMonth) {
      textColor = t.colorTextQuaternary;
    } else {
      textColor = t.colorText;
    }

    Widget content = _config.cellRender?.call(day, info) ??
        _config.dateCell?.call(
          day,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          isSelected: isSelected,
        ) ??
        _buildDefaultCellContent(
          t,
          day,
          textColor,
          isCurrentMonth,
          events,
          fullscreen,
        );

    Widget cell = Container(
      margin: EdgeInsets.all(fullscreen ? t.s(2) : t.s(1)),
      constraints: BoxConstraints(
        // card 形态对齐 antd-mobile 单元格比例（约 44 高 / 53 宽），
        // fullscreen 形态对齐 antd v6 大格子。
        minHeight: fullscreen ? t.s(72) : t.s(44),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          fullscreen ? t.borderRadiusSM : t.borderRadius,
        ),
        border: (isToday && !isSelected) ||
                (isRangePending && calendarIsSameDay(day, core.rangeStart))
            ? Border.all(color: t.colorPrimary, width: 1)
            : null,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: t.s(2),
        vertical: fullscreen ? t.s(4) : 0,
      ),
      child: content,
    );

    // fullCellRender 整格接管（antd v6 fullCellRender 对齐），
    // 点击仍由组件统一处理。
    final rendered = _config.fullCellRender?.call(day, info);
    if (rendered != null) cell = rendered;

    return GestureDetector(
      onTap: disabled ? null : () => core.handleDayTap(day),
      behavior: HitTestBehavior.opaque,
      child: cell,
    );
  }

  /// 默认单元格内容：日期数字（renderDate 可覆盖）+ 子标题
  /// （renderLabel / 事件点标记）。
  Widget _buildDefaultCellContent(
    AntThemeData t,
    DateTime day,
    Color textColor,
    bool isCurrentMonth,
    List<DateTime> events,
    bool fullscreen,
  ) {
    final Widget? subtitle = _config.renderLabel?.call(day) ??
        (events.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                  top: fullscreen ? t.s(4) : t.s(1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0;
                        i < events.length && i < _kMaxEventDots;
                        i++)
                      Container(
                        width: fullscreen ? t.s(6) : t.s(3),
                        height: fullscreen ? t.s(6) : t.s(3),
                        margin: EdgeInsets.symmetric(horizontal: t.s(1)),
                        decoration: BoxDecoration(
                          color: textColor == Colors.white
                              ? Colors.white
                              : t.colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              )
            : fullscreen
                ? SizedBox(height: t.s(4))
                : null);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _config.renderDate?.call(day) ??
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: fullscreen ? t.fontSizeXL : t.fontSizeSM,
                color: fullscreen && !isCurrentMonth
                    ? t.colorTextDisabled
                    : textColor,
                fontWeight: fullscreen ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
        if (subtitle != null) subtitle,
      ],
    );
  }

  /// 头部年月快速跳转面板（antd v6 行为，复用 AntPickerView 滚轮，
  /// 列文案走 locale yearLabel/monthLabel）。
  void _showYearMonthDropdown(BuildContext context) {
    final t = AntTheme.of(context);
    final loc = locale;
    final years = <int>[
      for (var y = DateTime.now().year - _kYearDropdownPastYears;
          y <= DateTime.now().year + _kYearDropdownFutureYears;
          y++)
        y,
    ];
    final months = <int>[for (var m = 1; m <= 12; m++) m];
    int? selectedYear = core.currentMonth.year;
    int? selectedMonth = core.currentMonth.month;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: t.colorBgContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(t.borderRadiusLG),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: t.s(16),
                  vertical: t.s(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(sheetContext).pop(),
                      child: Text(
                        loc.effectiveCancelText,
                        style: TextStyle(
                          fontSize: t.fontSize,
                          color: t.colorText,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        core.jumpToYearMonth(
                          selectedYear ?? core.currentMonth.year,
                          selectedMonth ?? core.currentMonth.month,
                        );
                      },
                      child: Text(
                        loc.effectiveConfirmText,
                        style: TextStyle(
                          fontSize: t.fontSize,
                          color: t.colorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AntPickerView<int>(
                defaultValue: [core.currentMonth.year, core.currentMonth.month],
                columns: [
                  AntPickerColumn<int>(
                    dataSource: years,
                    keyOf: (year) => year,
                    labelBuilder: (context, year) => Text(loc.yearLabel(year)),
                  ),
                  AntPickerColumn<int>(
                    dataSource: months,
                    keyOf: (month) => month,
                    labelBuilder: (context, month) =>
                        Text(loc.monthLabel(month)),
                  ),
                ],
                onChange: (vals) {
                  selectedYear = vals[0];
                  selectedMonth = vals.length > 1 ? vals[1] : null;
                },
                height: t.s(200),
              ),
              SizedBox(height: t.s(16)),
            ],
          ),
        );
      },
    );
  }
}
