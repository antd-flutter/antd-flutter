/// antd_transfer example — 穿梭框演示画廊（泛型数据源版）。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit 断点布局（desktop 宽屏双栏 / phone 窄屏单栏），
///   窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 所有示例都由用户自定义模型 `_FileItem` 驱动，组件只通过
///   keyOf/titleBuilder/descriptionOf/childrenOf/disabledOf 读取数据
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_transfer/antd_transfer.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdTransferGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// ------------------------------------------------------------
/// 用户自定义模型：不继承任何组件基类，也不实现任何接口。
/// ------------------------------------------------------------
class _FileItem {
  const _FileItem(
    this.id,
    this.name, {
    this.description,
    this.disabled = false,
    this.children = const <_FileItem>[],
  });

  final int id;
  final String name;
  final String? description;
  final bool disabled;
  final List<_FileItem> children;
}

Object _fileKey(_FileItem item) => item.id;

Widget _fileTitle(BuildContext context, _FileItem item) => Text(item.name);

String? _fileDescription(_FileItem item) => item.description;

List<_FileItem> _fileChildren(_FileItem item) => item.children;

bool _fileDisabled(_FileItem item) => item.disabled;

String _fileSearchText(_FileItem item) =>
    '${item.name} ${item.description ?? ''}';

/// antd 穿梭框画廊根组件。
class AntdTransferGalleryApp extends StatefulWidget {
  const AntdTransferGalleryApp({super.key});

  @override
  State<AntdTransferGalleryApp> createState() => _AntdTransferGalleryAppState();
}

class _AntdTransferGalleryAppState extends State<AntdTransferGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    '基础与多选',
    '受控模式',
    '树形穿梭',
    '搜索与自定义',
    '自定义模型',
  ];

  static final List<List<_DemoCard>> _sectionCards = [
    _basicCards,
    [], // 受控分区为 StatefulWidget，见 _sectionBody
    _treeCards,
    _customCards,
    _modelCards,
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_picker / antd_form example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdTransfer Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Transfer 穿梭框'),
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
    final cards = index == 1
        ? [
            (
              '受控模式（targetKeys / selectedKeys）',
              const _ControlledSection() as Widget,
            ),
          ]
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

Widget _resultText(BuildContext context, String label, String value) {
  final theme = AntTheme.of(context);
  return Padding(
    padding: EdgeInsets.only(top: 8.w),
    child: Text(
      value.isEmpty ? '$label：未穿梭' : '$label：$value',
      style: TextStyle(fontSize: 14.sp, color: theme.colorText),
    ),
  );
}

// ── 演示数据 ─────────────────────────────────────────────
final List<_FileItem> _plainData = [
  for (var i = 1; i <= 8; i++) _FileItem(i, '选项 $i'),
];

const _disabledData = <_FileItem>[
  _FileItem(1, '选项 A'),
  _FileItem(2, '选项 B（禁用）', disabled: true),
  _FileItem(3, '选项 C'),
  _FileItem(4, '选项 D（禁用）', disabled: true),
  _FileItem(5, '选项 E'),
];

const _treeData = <_FileItem>[
  _FileItem(
    1,
    '组件库',
    children: [
      _FileItem(
        11,
        '通用组件',
        children: [_FileItem(111, 'Button 按钮'), _FileItem(112, 'Icon 图标')],
      ),
      _FileItem(
        12,
        '布局组件',
        children: [_FileItem(121, 'Grid 栅格'), _FileItem(122, 'Divider 分隔线')],
      ),
    ],
  ),
  _FileItem(
    2,
    '数据录入',
    children: [
      _FileItem(21, 'Input 输入框'),
      _FileItem(22, 'Select 选择器'),
      _FileItem(23, 'Switch 开关（禁用）', disabled: true),
    ],
  ),
];

const _modelData = <_FileItem>[
  _FileItem(1, '需求文档', description: '产品需求说明'),
  _FileItem(2, '设计稿', description: '交互与视觉稿'),
  _FileItem(3, '接口文档', description: '后端 API 定义'),
  _FileItem(4, '测试报告', description: '回归测试结果'),
];

String _nameOfKey(Object key) {
  String? found;
  void walk(List<_FileItem> items) {
    for (final item in items) {
      if (item.id == key) found = item.name;
      walk(item.children);
    }
  }

  walk(_plainData);
  walk(_disabledData);
  walk(_treeData);
  walk(_modelData);
  return found ?? '$key';
}

String _namesOf(List<Object> keys) => keys.map(_nameOfKey).join('、');

AntTransfer<_FileItem> _transfer({
  required List<_FileItem> dataSource,
  List<Object>? targetKeys,
  List<Object> defaultTargetKeys = const <Object>[],
  AntTransferOnChange? onChange,
  AntTransferOnSelectChange? onSelectChange,
  List<String> titles = const ['Source', 'Target'],
  List<String> operations = const ['', ''],
  bool showSearch = false,
  bool oneWay = false,
  bool defaultExpandAll = false,
  bool Function(String input, _FileItem item)? filterOption,
  Widget Function(BuildContext context, _FileItem item)? titleBuilder,
}) {
  return AntTransfer<_FileItem>(
    dataSource: dataSource,
    keyOf: _fileKey,
    titleBuilder: titleBuilder ?? _fileTitle,
    descriptionOf: _fileDescription,
    childrenOf: _fileChildren,
    disabledOf: _fileDisabled,
    searchTextOf: _fileSearchText,
    targetKeys: targetKeys,
    defaultTargetKeys: defaultTargetKeys,
    onChange: onChange,
    onSelectChange: onSelectChange,
    titles: titles,
    operations: operations,
    showSearch: showSearch,
    oneWay: oneWay,
    defaultExpandAll: defaultExpandAll,
    filterOption: filterOption,
  );
}

// ── 基础与多选 ───────────────────────────────────────────
final List<_DemoCard> _basicCards = [
  (
    '基础穿梭',
    Builder(
      builder: (context) {
        String last = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 280,
                  child: _transfer(
                    dataSource: _plainData,
                    onChange: (keys, dir, moved) =>
                        setState(() => last = '${_namesOf(moved)}（$dir）'),
                  ),
                ),
                _resultText(context, '最近移动', last),
              ],
            );
          },
        );
      },
    ),
  ),
  (
    '多选批量穿梭',
    Builder(
      builder: (context) {
        String last = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 280,
                  child: _transfer(
                    dataSource: _plainData,
                    titles: const ['候选', '已选'],
                    onSelectChange: (s, t) {},
                    onChange: (keys, dir, moved) =>
                        setState(() => last = '共 ${moved.length} 项（$dir）'),
                  ),
                ),
                _resultText(context, '批量结果', last),
              ],
            );
          },
        );
      },
    ),
  ),
  (
    '禁用项',
    Builder(
      builder: (context) => SizedBox(
        height: 240,
        child: _transfer(
          dataSource: _disabledData,
          defaultTargetKeys: const <Object>[3],
        ),
      ),
    ),
  ),
];

// ── 树形穿梭 ─────────────────────────────────────────────
final List<_DemoCard> _treeCards = [
  (
    '多级树形穿梭（勾父带子 / 半选 / 树形展示）',
    Builder(
      builder: (context) {
        String last = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 360,
                  child: _transfer(
                    dataSource: _treeData,
                    defaultExpandAll: true,
                    onChange: (keys, dir, moved) =>
                        setState(() => last = '${_namesOf(moved)}（$dir）'),
                  ),
                ),
                _resultText(context, '树模式移动', last),
              ],
            );
          },
        );
      },
    ),
  ),
  (
    '树形穿梭 + 搜索过滤',
    Builder(
      builder: (context) => SizedBox(
        height: 360,
        child: _transfer(
          dataSource: _treeData,
          defaultExpandAll: true,
          showSearch: true,
          filterOption: (input, item) =>
              item.name.toLowerCase().contains(input.toLowerCase()),
        ),
      ),
    ),
  ),
];

// ── 搜索与自定义 ─────────────────────────────────────────
final List<_DemoCard> _customCards = [
  (
    '搜索过滤（扁平模式）',
    Builder(
      builder: (context) => SizedBox(
        height: 280,
        child: _transfer(
          dataSource: _plainData,
          showSearch: true,
          filterOption: (input, item) => item.name.contains(input),
        ),
      ),
    ),
  ),
  (
    '自定义配置（titles / operations / oneWay）',
    Builder(
      builder: (context) => SizedBox(
        height: 280,
        child: _transfer(
          dataSource: _plainData,
          titles: const ['待办', '已完成'],
          operations: const ['完成 →', '← 撤回'],
          oneWay: true,
        ),
      ),
    ),
  ),
];

// ── 自定义模型 ───────────────────────────────────────────
final List<_DemoCard> _modelCards = [
  (
    '自定义模型：keyOf + titleBuilder + descriptionOf',
    Builder(
      builder: (context) {
        String last = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: _transfer(
                    dataSource: _modelData,
                    titles: const ['全部文件', '已归档'],
                    titleBuilder: (context, item) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(AntIcons.fileTextOutlined, size: 12.sp),
                        SizedBox(width: 4.w),
                        Flexible(child: Text(item.name)),
                      ],
                    ),
                    onChange: (keys, dir, moved) =>
                        setState(() => last = '${_namesOf(moved)}（$dir）'),
                  ),
                ),
                _resultText(context, '归档结果', last),
              ],
            );
          },
        );
      },
    ),
  ),
  (
    '自定义模型：childrenOf + disabledOf 树形穿梭',
    Builder(
      builder: (context) => SizedBox(
        height: 360,
        child: _transfer(
          dataSource: _treeData,
          defaultExpandAll: true,
          titles: const ['待配置', '已启用'],
        ),
      ),
    ),
  ),
];

// ── 受控模式 ─────────────────────────────────────────────
class _ControlledSection extends StatelessWidget {
  const _ControlledSection();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            var targetKeys = <Object>[1, 2];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 280,
                  child: _transfer(
                    dataSource: _plainData,
                    targetKeys: targetKeys,
                    onChange: (keys, dir, moved) =>
                        setState(() => targetKeys = keys),
                  ),
                ),
                _resultText(context, '受控 targetKeys', _namesOf(targetKeys)),
                Padding(
                  padding: EdgeInsets.only(top: 8.w),
                  child: OutlinedButton(
                    onPressed: () => setState(() => targetKeys = <Object>[]),
                    child: const Text('重置为空'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
