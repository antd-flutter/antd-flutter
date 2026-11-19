/// antd_calendar example — 日历族演示画廊（AntCalendar / AntCalendarPicker 全量功能）。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntResponsive 断点布局
///   （desktop 宽屏双栏 / phone 窄屏单栏），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 全量功能分区：桌面 antd v6（三层渲染 / 月年面板 / validRange / mode /
///   onPanelChange）+ 移动 antd-mobile（renderDate/renderLabel / min-max /
///   minPage-maxPage / 年导航 / allowClear）+ Picker 弹层
library;

import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdCalendarGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

DateTime _date(int y, [int m = 1, int d = 1]) => DateTime(y, m, d);

/// antd 日历画廊根组件。
class AntdCalendarGalleryApp extends StatefulWidget {
  const AntdCalendarGalleryApp({super.key});

  @override
  State<AntdCalendarGalleryApp> createState() => _AntdCalendarGalleryAppState();
}

class _AntdCalendarGalleryAppState extends State<AntdCalendarGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    '基础选择',
    '自定义渲染（桌面三层）',
    '月/年面板（mode）',
    '范围约束',
    '选择模式',
    '格式与跳转',
    '移动分层渲染',
    'Picker 弹层',
  ];

  static final List<List<_DemoCard>> _sectionCards = [
    _basicCards,
    _renderCards,
    _modeCards,
    _constraintCards,
    _selectionCards,
    _formatCards,
    _mobileCards,
    [], // Picker 弹层分区为 StatefulWidget，见 _buildSectionBody
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_picker example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdCalendar Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Calendar 日历族'),
                  actions: [
                    IconButton(
                      onPressed: () => setState(() => _isDark = !_isDark),
                      icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (final t in _sectionTitles) Tab(text: t),
                    ],
                  ),
                ),
                // R35.4：desktop 宽屏双栏、phone 窄屏单栏，缩放窗口不溢出。
                body: TabBarView(
                  children: [
                    for (var i = 0; i < _sectionTitles.length; i++)
                      _buildSectionBody(context, layout, i),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionBody(
    BuildContext pageContext,
    AntLayoutData layout,
    int index,
  ) {
    final isPickerSection = index == _sectionTitles.length - 1;
    final cards = isPickerSection
        ? const _PickerSection().cards
        : _sectionCards[index];
    final isWide = layout.width >= 768 ||
        layout.breakpoint == AntBreakpoint.lg ||
        layout.breakpoint == AntBreakpoint.xl ||
        layout.breakpoint == AntBreakpoint.xxl;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: isWide
          ? Wrap(
              spacing: 16.w,
              runSpacing: 16.w,
              children: [
                for (final card in cards)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 560.w),
                    child: _sectionCard(pageContext, card.$1, card.$2),
                  ),
              ],
            )
          : Column(
              children: [
                for (final card in cards)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.w),
                    child: _sectionCard(pageContext, card.$1, card.$2),
                  ),
              ],
            ),
    );
  }
}

/// 卡片容器。
Widget _sectionCard(BuildContext context, String title, Widget child) {
  final theme = AntTheme.of(context);
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: theme.colorBgContainer,
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      border: Border.all(color: theme.colorSplit),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.w),
          child: Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
        ),
        child,
      ],
    ),
  );
}

Widget _resultText(BuildContext context, String label, String value) {
  final theme = AntTheme.of(context);
  return Text(
    value.isEmpty ? '$label：未选择' : '$label：$value',
    style: TextStyle(fontSize: 14.sp, color: theme.colorText),
  );
}

String _fmt(DateTime? d) =>
    d == null ? '' : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

// ============================================================
// 分区 1：基础选择
// ============================================================
final List<_DemoCard> _basicCards = [
  (
    '单选（fullscreen 桌面形态）',
    _BasicFullscreenCard(),
  ),
  (
    '单选（card 移动形态）',
    StatefulBuilder(builder: (context, setState) {
      DateTime? picked;
      return StatefulBuilder(
        builder: (context, innerSetState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AntCalendar(
              layout: AntCalendarLayout.card,
              onSelect: (d) => innerSetState(() => picked = d),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.w),
              child: _resultText(context, '选中', _fmt(picked)),
            ),
          ],
        ),
      );
    }),
  ),
];

class _BasicFullscreenCard extends StatefulWidget {
  @override
  State<_BasicFullscreenCard> createState() => _BasicFullscreenCardState();
}

class _BasicFullscreenCardState extends State<_BasicFullscreenCard> {
  DateTime? _picked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(DateTime.now().year, DateTime.now().month, 1),
          onSelect: (d) => setState(() => _picked = d),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w),
          child: _resultText(context, '选中', _fmt(_picked)),
        ),
      ],
    );
  }
}

// ============================================================
// 分区 2：自定义渲染（桌面三层 dateCell / cellRender / fullCellRender）
// ============================================================
final List<_DemoCard> _renderCards = [
  (
    'dateCell 内容插槽（事件点 + 备注）',
    AntCalendar(
      fullscreen: true,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 1),
      dateCell: (date, {required isCurrentMonth, required isToday, required isSelected}) {
        if (date.day % 10 == 0) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${date.day}'),
              Text('结', style: TextStyle(fontSize: 10.sp, color: Colors.orange)),
            ],
          );
        }
        return null;
      },
      eventLoader: (day) => day.day % 7 == 0 ? [day] : const [],
    ),
  ),
  (
    'cellRender 状态层（cellRender > dateCell）',
    AntCalendar(
      fullscreen: true,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 1),
      cellRender: (date, info) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${date.day}'),
          if (info.isToday) Text('今', style: TextStyle(fontSize: 10.sp, color: Colors.green)),
        ],
      ),
    ),
  ),
  (
    'fullCellRender 整格接管',
    AntCalendar(
      fullscreen: true,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 1),
      fullCellRender: (date, info) => Container(
        margin: EdgeInsets.all(2.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: info.isSelected ? Colors.indigo : Colors.indigo.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: info.isSelected ? Colors.white : Colors.indigo,
          ),
        ),
      ),
    ),
  ),
  (
    'monthCellRender / monthFullCellRender（月面板自定义）',
    AntCalendar(
      fullscreen: true,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 1),
      monthCellRender: (month) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${month.month}月'),
          if (month.month == 1)
            Text('春节', style: TextStyle(fontSize: 10.sp, color: Colors.red)),
        ],
      ),
    ),
  ),
];

// ============================================================
// 分区 3：月/年面板（mode 受控 + onPanelChange）
// ============================================================
final List<_DemoCard> _modeCards = [
  (
    '月/年面板切换（fullscreen 默认切换器）',
    _ModeControlledCard(),
  ),
  (
    '初始年面板（initialMode=year）',
    AntCalendar(
      fullscreen: true,
      initialMode: AntCalendarMode.year,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 1),
    ),
  ),
];

class _ModeControlledCard extends StatefulWidget {
  @override
  State<_ModeControlledCard> createState() => _ModeControlledCardState();
}

class _ModeControlledCardState extends State<_ModeControlledCard> {
  String _log = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCalendar(
          fullscreen: true,
          defaultValue: _date(DateTime.now().year, DateTime.now().month, 1),
          onModeChanged: (m) => setState(() => _log = '模式：${m.name}'),
          onPanelChange: (date, mode) =>
              setState(() => _log = '${mode.name} @ ${_fmt(date)}'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w),
          child: _resultText(context, '面板变化', _log),
        ),
      ],
    );
  }
}

// ============================================================
// 分区 4：范围约束（validRange / min-max / minPage-maxPage / disabledDate）
// ============================================================
final List<_DemoCard> _constraintCards = [
  (
    'validRange 有效范围',
    AntCalendar(
      layout: AntCalendarLayout.card,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
      validRange: AntCalendarValidRange(
        _date(DateTime.now().year, DateTime.now().month, 5),
        _date(DateTime.now().year, DateTime.now().month, 20),
      ),
    ),
  ),
  (
    'min / max（antd-mobile）',
    AntCalendar(
      layout: AntCalendarLayout.card,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
      min: _date(DateTime.now().year, DateTime.now().month, 5),
      max: _date(DateTime.now().year, DateTime.now().month, 20),
    ),
  ),
  (
    'minPage / maxPage 导航裁剪',
    AntCalendar(
      layout: AntCalendarLayout.card,
      showYearNavButtons: true,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
      minPage: AntCalendarPage(year: DateTime.now().year, month: DateTime.now().month - 1 < 1 ? 1 : DateTime.now().month - 1),
      maxPage: AntCalendarPage(year: DateTime.now().year, month: DateTime.now().month + 1 > 12 ? 12 : DateTime.now().month + 1),
    ),
  ),
  (
    'disabledDate（周末不可选）',
    AntCalendar(
      layout: AntCalendarLayout.card,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
      disabledDate: (d) => d.weekday == DateTime.saturday || d.weekday == DateTime.sunday,
    ),
  ),
];

// ============================================================
// 分区 5：选择模式（range / multi / allowClear）
// ============================================================
final List<_DemoCard> _selectionCards = [
  (
    'range 范围选择',
    _RangeCard(),
  ),
  (
    'multiSelect 多选',
    _MultiCard(),
  ),
  (
    'allowClear 清除选择（再点已选清除）',
    _AllowClearCard(),
  ),
];

class _RangeCard extends StatefulWidget {
  @override
  State<_RangeCard> createState() => _RangeCardState();
}

class _RangeCardState extends State<_RangeCard> {
  String _range = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCalendar(
          layout: AntCalendarLayout.card,
          selectionMode: AntCalendarSelectionMode.range,
          defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
          onRangeSelected: (s, e) =>
              setState(() => _range = '${_fmt(s)} ~ ${_fmt(e)}'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w),
          child: _resultText(context, '范围', _range),
        ),
      ],
    );
  }
}

class _MultiCard extends StatefulWidget {
  @override
  State<_MultiCard> createState() => _MultiCardState();
}

class _MultiCardState extends State<_MultiCard> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCalendar(
          layout: AntCalendarLayout.card,
          multiSelect: true,
          defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
          onSelectMulti: (days) => setState(() => _count = days.length),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w),
          child: _resultText(context, '已选数', '$_count'),
        ),
      ],
    );
  }
}

class _AllowClearCard extends StatefulWidget {
  @override
  State<_AllowClearCard> createState() => _AllowClearCardState();
}

class _AllowClearCardState extends State<_AllowClearCard> {
  String _onChange = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCalendar(
          layout: AntCalendarLayout.card,
          allowClear: true,
          defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
          onChange: (d) => setState(() => _onChange = _fmt(d)),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w),
          child: _resultText(context, 'onChange', _onChange),
        ),
      ],
    );
  }
}

// ============================================================
// 分区 6：格式切换 / 年月跳转 / 程序化控制
// ============================================================
final List<_DemoCard> _formatCards = [
  (
    '格式切换（月 / 两周 / 周）',
    AntCalendar(
      layout: AntCalendarLayout.card,
      showFormatSwitcher: true,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
    ),
  ),
  (
    'Controller 程序化跳转（R35.2）',
    _ControllerCard(),
  ),
];

class _ControllerCard extends StatefulWidget {
  @override
  State<_ControllerCard> createState() => _ControllerCardState();
}

class _ControllerCardState extends State<_ControllerCard> {
  final _controller = AntCalendarController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          children: [
            OutlinedButton(
              onPressed: () => _controller.previousMonth(),
              child: const Text('上一月'),
            ),
            OutlinedButton(
              onPressed: () => _controller.nextMonth(),
              child: const Text('下一月'),
            ),
            OutlinedButton(
              onPressed: () => _controller.goToYearMonth(2020, 1),
              child: const Text('跳 2020-01'),
            ),
            OutlinedButton(
              onPressed: () => _controller.jumpToToday(),
              child: const Text('回到今天'),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.w),
          child: AntCalendar(
            layout: AntCalendarLayout.card,
            defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
            controller: _controller,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 分区 7：移动分层渲染（renderDate / renderLabel / 年导航 / onPageChange）
// ============================================================
final List<_DemoCard> _mobileCards = [
  (
    'renderDate / renderLabel 日卡子标题',
    AntCalendar(
      layout: AntCalendarLayout.card,
      defaultValue: _date(DateTime.now().year, DateTime.now().month, 10),
      renderDate: (d) => Text('${d.day}'),
      renderLabel: (d) => d.day % 5 == 0
          ? Text('休', style: TextStyle(fontSize: 9.sp, color: Colors.red))
          : null,
    ),
  ),
  (
    '年导航按钮 + onPageChange',
    _PageChangeCard(),
  ),
];

class _PageChangeCard extends StatefulWidget {
  @override
  State<_PageChangeCard> createState() => _PageChangeCardState();
}

class _PageChangeCardState extends State<_PageChangeCard> {
  String _page = '';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCalendar(
          layout: AntCalendarLayout.card,
          showYearNavButtons: true,
          defaultValue: _date(now.year, now.month, 10),
          onPageChange: (y, m) => setState(() => _page = '$y-$m'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w),
          child: _resultText(context, '当前页', _page),
        ),
      ],
    );
  }
}

// ============================================================
// 分区 8：Picker 弹层（AntCalendarPicker）
// ============================================================
class _PickerSection {
  const _PickerSection();

  List<_DemoCard> get cards => [
        (
          '单选弹窗（标题 / 确认 / 关闭按钮）',
          _PickerCard(
            selectionMode: AntCalendarSelectionMode.single,
            title: '选择日期',
          ),
        ),
        (
          '范围弹窗（min / max 限制）',
          _PickerCard(
            selectionMode: AntCalendarSelectionMode.range,
            title: '选择范围',
            min: _date(DateTime.now().year, DateTime.now().month, 1),
            max: _date(DateTime.now().year, DateTime.now().month + 2, 1),
          ),
        ),
      ];
}

class _PickerCard extends StatefulWidget {
  const _PickerCard({
    required this.selectionMode,
    this.title,
    this.min,
    this.max,
  });

  final AntCalendarSelectionMode selectionMode;
  final String? title;
  final DateTime? min;
  final DateTime? max;

  @override
  State<_PickerCard> createState() => _PickerCardState();
}

class _PickerCardState extends State<_PickerCard> {
  String _confirmed = '';
  String _events = '';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCalendarPicker(
          selectionMode: widget.selectionMode,
          title: widget.title,
          min: widget.min ?? _date(now.year, now.month, 1),
          max: widget.max,
          onConfirm: (dates) => setState(
            () => _confirmed = dates.map(_fmt).join(' ~ '),
          ),
          onMaskClick: () => setState(() => _events = 'onMaskClick'),
          onClose: () => setState(() => _events = '$_events onClose'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
            decoration: BoxDecoration(
              border: Border.all(color: AntTheme.of(context).colorSplit),
              borderRadius: BorderRadius.circular(AntTheme.of(context).borderRadius),
            ),
            child: Text(
              _confirmed.isEmpty ? '点击选择日期' : _confirmed,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.w),
          child: _resultText(context, '确认值', _confirmed),
        ),
        if (_events.isNotEmpty)
          _resultText(context, '事件', _events),
      ],
    );
  }
}
