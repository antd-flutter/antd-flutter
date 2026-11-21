/// antd_picker example — 弹层选择器族演示画廊（Picker / DatePicker / TimePicker / Cascader）。
///
/// - 数据源全部使用用户自定义模型（[_Season] / [_Fruit] / [_Region]），
///   通过 `keyOf` / `childrenOf` / `labelBuilder` 驱动，不构造组件库模型。
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntResponsive.breakpointOf 断点布局
///   （desktop 宽屏双栏 / phone 窄屏单栏），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：Picker 单列/多列联动、受控操作；DatePicker 年月日；
///   TimePicker 时分秒；Cascader 级联 / CascaderView 内嵌
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

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
                      icon: Icon(
                        _isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined,
                      ),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [for (final t in _sectionTitles) Tab(text: t)],
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

  Widget _sectionBody(
    BuildContext pageContext,
    AntLayoutData layout,
    int index,
  ) {
    final cards = index == _sectionTitles.length - 1
        ? const _ControlledSection().cards
        : _sectionCards[index];
    final isWide =
        layout.width >= 768 ||
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
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
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

// ── 用户自定义模型 ──────────────────────────────────────────
/// 通用选项模型（季节 / 水果共用，演示多列可共享同一泛型）
class _NamedOption {
  const _NamedOption(this.id, this.name);

  final String id;
  final String name;
}

/// 地区（树形）
class Region {
  const Region(
    this.code,
    this.name, [
    this.children = const [],
    this.disabled = false,
  ]);

  final String code;
  final String name;
  final List<Region> children;
  final bool disabled;
}

const _seasons = <_NamedOption>[
  _NamedOption('spring', '春'),
  _NamedOption('summer', '夏'),
  _NamedOption('autumn', '秋'),
  _NamedOption('winter', '冬'),
];

const _fruits = <_NamedOption>[
  _NamedOption('apple', '苹果'),
  _NamedOption('banana', '香蕉'),
  _NamedOption('orange', '橙子'),
  _NamedOption('grape', '葡萄'),
];

const _regions = <Region>[
  Region('zj', '浙江', [
    Region('hz', '杭州', [Region('xh', '西湖区'), Region('yh', '余杭区')]),
    Region('nb', '宁波', [Region('yz', '鄞州区')]),
  ]),
  Region('js', '江苏', [
    Region('nj', '南京', [Region('xw', '玄武区')]),
  ]),
];

AntPickerColumn<_NamedOption> _optionColumn(List<_NamedOption> dataSource) =>
    AntPickerColumn<_NamedOption>(
      dataSource: dataSource,
      keyOf: (option) => option.id,
      labelBuilder: (context, option) => Text(option.name),
    );

// ── Picker 滚轮选择 ─────────────────────────────────────────
final List<_DemoCard> _pickerCards = [
  (
    '单列选择（自定义模型）',
    AntPicker<_NamedOption>(
      columns: [_optionColumn(_seasons)],
      title: '请选择季节',
      child: const _TriggerBox(text: '打开单列选择器'),
    ),
  ),
  (
    '多列选择（列间独立滚动）',
    AntPicker<_NamedOption>(
      columns: [_optionColumn(_seasons), _optionColumn(_fruits)],
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
  ('允许清除', const AntDatePicker(allowClear: true, placeholder: '选择日期')),
  (
    '自定义展示（labelBuilder）',
    AntDatePicker(
      defaultValue: DateTime(2026, 1, 1),
      labelBuilder: (context, date) =>
          Text('${date.year} 年 ${date.month} 月 ${date.day} 日'),
    ),
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
  ('步进（小时步进 2）', const AntTimePicker(hourStep: 2, placeholder: '选择时间')),
  (
    '自定义展示（labelBuilder）',
    AntTimePicker(
      defaultValue: const TimeOfDay(hour: 9, minute: 30),
      labelBuilder: (context, time) => Text('${time.hour} 时 ${time.minute} 分'),
    ),
  ),
];

// ── Cascader 级联 ───────────────────────────────────────────
final List<_DemoCard> _cascaderCards = [
  (
    '弹层级联选择（选中即变更）',
    AntCascader<Region>(
      dataSource: _regions,
      keyOf: (region) => region.code,
      childrenOf: (region) => region.children,
      disabledOf: (region) => region.disabled,
      labelBuilder: (context, region) => Text(region.name),
      placeholder: '请选择地区',
      changeOnSelect: true,
    ),
  ),
  (
    '禁用态',
    AntCascader<Region>(
      dataSource: _regions,
      keyOf: (region) => region.code,
      childrenOf: (region) => region.children,
      labelBuilder: (context, region) => Text(region.name),
      disabled: true,
    ),
  ),
];

// ── CascaderView 内嵌 ───────────────────────────────────────
final List<_DemoCard> _cascaderViewCards = [
  (
    '内嵌级联视图（不弹层）',
    AntCascaderView<Region>(
      dataSource: _regions,
      keyOf: (region) => region.code,
      childrenOf: (region) => region.children,
      labelBuilder: (context, region) => Text(region.name),
    ),
  ),
];

// ── 受控操作 ────────────────────────────────────────────────
class _ControlledSection {
  const _ControlledSection();

  List<_DemoCard> get cards => [
    ('AntPicker 受控（value + 重置）', _ControlledPickerCard()),
    ('Cascader / DatePicker 受控', _ControlledFieldCard()),
  ];
}

class _ControlledPickerCard extends StatefulWidget {
  const _ControlledPickerCard();

  @override
  State<_ControlledPickerCard> createState() => _ControlledPickerCardState();
}

class _ControlledPickerCardState extends State<_ControlledPickerCard> {
  List<_NamedOption> _pickerValue = <_NamedOption>[_seasons.first];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntPicker<_NamedOption>(
          columns: [_optionColumn(_seasons)],
          value: _pickerValue,
          onConfirm: (options) => setState(() => _pickerValue = options),
          child: _triggerBox(
            context,
            '当前：${_pickerValue.map((option) => option.name).join('、')}',
          ),
        ),
        SizedBox(height: 8.w),
        OutlinedButton(
          onPressed: () =>
              setState(() => _pickerValue = <_NamedOption>[_seasons.first]),
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
  List<Region> _cascaderValue = <Region>[];
  DateTime? _dateValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader<Region>(
          dataSource: _regions,
          keyOf: (region) => region.code,
          childrenOf: (region) => region.children,
          labelBuilder: (context, region) => Text(region.name),
          value: _cascaderValue.isEmpty ? null : _cascaderValue,
          onChange: (regions) => setState(() => _cascaderValue = regions),
        ),
        SizedBox(height: 8.w),
        _resultText(
          context,
          '级联值',
          _cascaderValue.map((region) => region.name).join(' / '),
        ),
        SizedBox(height: 12.w),
        AntDatePicker(
          value: _dateValue,
          placeholder: '受控日期',
          onChange: (d) => setState(() => _dateValue = d),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '日期值', _dateValue?.toIso8601String() ?? ''),
        SizedBox(height: 8.w),
        OutlinedButton(
          onPressed: () => setState(() => _dateValue = null),
          child: const Text('清空日期'),
        ),
      ],
    );
  }
}
