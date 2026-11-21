/// antd_picker example — 弹层选择器族演示画廊（Picker / DatePicker / TimePicker / Cascader）。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntResponsive.breakpointOf 断点布局
///   （desktop 宽屏双栏 / phone 窄屏单栏），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：Picker 单列/多列联动、受控操作；DatePicker 年月日；
///   TimePicker 时分秒；Cascader 级联 / CascaderView 内嵌
library;

import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdPickerGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// antd 选择器画廊根组件。
class AntdPickerGalleryApp extends StatefulWidget {
  const AntdPickerGalleryApp({super.key});

  @override
  State<AntdPickerGalleryApp> createState() => _AntdPickerGalleryAppState();
}

class _AntdPickerGalleryAppState extends State<AntdPickerGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    'Picker 滚轮选择',
    'DatePicker 日期',
    'TimePicker 时间',
    'Cascader 级联',
    'CascaderView 内嵌',
    '受控操作',
  ];

  static final List<List<_DemoCard>> _sectionCards = [
    _pickerCards,
    _datePickerCards,
    _timePickerCards,
    _cascaderCards,
    _cascaderViewCards,
    [], // 受控分区为 StatefulWidget，见 _buildSectionBody
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_image_viewer / antd_splitter example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdPicker Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Picker 选择器族'),
                  actions: [
                    IconButton(
                      onPressed: () => setState(() => _isDark = !_isDark),
                      icon: Icon(_isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined),
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
                      _sectionBody(context, layout, i),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionBody(BuildContext pageContext, AntLayoutData layout, int index) {
    final cards = index == _sectionTitles.length - 1
        ? const _ControlledSection().cards
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
                    constraints: BoxConstraints(maxWidth: 480.w),
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

/// 触发器外壳（带边框的入口文本）。
Widget _triggerBox(BuildContext context, String text) {
  final theme = AntTheme.of(context);
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
    decoration: BoxDecoration(
      border: Border.all(color: theme.colorSplit),
      borderRadius: BorderRadius.circular(theme.borderRadius),
    ),
    child: Text(text, style: TextStyle(fontSize: 14.sp)),
  );
}

Widget _resultText(BuildContext context, String label, String value) {
  final theme = AntTheme.of(context);
  return Text(
    value.isEmpty ? '$label：未选择' : '$label：$value',
    style: TextStyle(fontSize: 14.sp, color: theme.colorText),
  );
}

// ── Picker 滚轮选择 ─────────────────────────────────────────
const _seasons = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '春', value: 'spring'),
  AntPickerColumnItem(label: '夏', value: 'summer'),
  AntPickerColumnItem(label: '秋', value: 'autumn'),
  AntPickerColumnItem(label: '冬', value: 'winter'),
];

const _fruits = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '苹果', value: 'apple'),
  AntPickerColumnItem(label: '香蕉', value: 'banana'),
  AntPickerColumnItem(label: '橙子', value: 'orange'),
  AntPickerColumnItem(label: '葡萄', value: 'grape'),
];

final List<_DemoCard> _pickerCards = [
  (
    '单列选择',
    AntPicker(
      columns: const [_seasons],
      title: '请选择季节',
      child: const _TriggerBox(text: '打开单列选择器'),
    ),
  ),
  (
    '多列选择（列间独立滚动）',
    AntPicker(
      columns: const [_seasons, _fruits],
      title: '选择季节与水果',
      child: const _TriggerBox(text: '打开多列选择器'),
    ),
  ),
];

/// 触发器入口（const 构造）。
class _TriggerBox extends StatelessWidget {
  const _TriggerBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => _triggerBox(context, text);
}

// ── DatePicker 日期（年月日） ────────────────────────────────
final List<_DemoCard> _datePickerCards = [
  (
    '基础（年月日）',
    AntDatePicker(
      defaultValue: DateTime(2026, 1, 1),
      onChange: (d) => debugPrint('date: $d'),
    ),
  ),
  (
    '允许清除',
    const AntDatePicker(allowClear: true, placeholder: '选择日期'),
  ),
];

// ── TimePicker 时间（时分秒） ────────────────────────────────
final List<_DemoCard> _timePickerCards = [
  (
    '时分秒选择',
    AntTimePicker(
      defaultValue: const TimeOfDay(hour: 9, minute: 30),
      onChange: (t) => debugPrint('time: $t'),
    ),
  ),
  (
    '步进（小时步进 2）',
    const AntTimePicker(hourStep: 2, placeholder: '选择时间'),
  ),
];

// ── Cascader 级联 ───────────────────────────────────────────
const _regionOptions = <AntCascaderOption>[
  AntCascaderOption(value: 'zj', label: '浙江', children: [
    AntCascaderOption(value: 'hz', label: '杭州', children: [
      AntCascaderOption(value: 'xh', label: '西湖区'),
      AntCascaderOption(value: 'yh', label: '余杭区'),
    ]),
    AntCascaderOption(value: 'nb', label: '宁波', children: [
      AntCascaderOption(value: 'yz', label: '鄞州区'),
    ]),
  ]),
  AntCascaderOption(value: 'js', label: '江苏', children: [
    AntCascaderOption(value: 'nj', label: '南京', children: [
      AntCascaderOption(value: 'xw', label: '玄武区'),
    ]),
  ]),
];

const List<_DemoCard> _cascaderCards = [
  (
    '弹层级联选择（选中即变更）',
    AntCascader(
      options: _regionOptions,
      placeholder: '请选择地区',
      changeOnSelect: true,
    ),
  ),
  (
    '禁用态',
    AntCascader(options: _regionOptions, disabled: true),
  ),
];

// ── CascaderView 内嵌 ───────────────────────────────────────
const List<_DemoCard> _cascaderViewCards = [
  (
    '内嵌级联视图（不弹层）',
    AntCascaderView(options: _regionOptions),
  ),
];

// ── 受控操作 ────────────────────────────────────────────────
class _ControlledSection {
  const _ControlledSection();

  List<_DemoCard> get cards => [
        (
          'AntPicker 受控（value + 重置）',
          _ControlledPickerCard(),
        ),
        (
          'Cascader / DatePicker 受控',
          _ControlledFieldCard(),
        ),
      ];
}

class _ControlledPickerCard extends StatefulWidget {
  const _ControlledPickerCard();

  @override
  State<_ControlledPickerCard> createState() => _ControlledPickerCardState();
}

class _ControlledPickerCardState extends State<_ControlledPickerCard> {
  List<AntPickerValue> _pickerValue = <AntPickerValue>['spring'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntPicker(
          columns: [_seasons],
          value: _pickerValue,
          onConfirm: (vals) => setState(() => _pickerValue = vals),
          child: _triggerBox(context, '当前：${_pickerValue.join(', ')}'),
        ),
        SizedBox(height: 8.w),
        OutlinedButton(
          onPressed: () =>
              setState(() => _pickerValue = <AntPickerValue>['spring']),
          child: const Text('重置为「春」'),
        ),
      ],
    );
  }
}

class _ControlledFieldCard extends StatefulWidget {
  const _ControlledFieldCard();

  @override
  State<_ControlledFieldCard> createState() => _ControlledFieldCardState();
}

class _ControlledFieldCardState extends State<_ControlledFieldCard> {
  List<String> _cascaderValue = <String>[];
  DateTime? _dateValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader(
          options: _regionOptions,
          value: _cascaderValue.isEmpty ? null : _cascaderValue,
          onChange: (v) => setState(() => _cascaderValue = v),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '级联值', _cascaderValue.join(' / ')),
        SizedBox(height: 12.w),
        AntDatePicker(
          value: _dateValue,
          placeholder: '受控日期',
          onChange: (d) => setState(() => _dateValue = d),
        ),
        SizedBox(height: 8.w),
        _resultText(
            context, '日期值', _dateValue?.toIso8601String() ?? ''),
        SizedBox(height: 8.w),
        OutlinedButton(
          onPressed: () => setState(() => _dateValue = null),
          child: const Text('清空日期'),
        ),
      ],
    );
  }
}
