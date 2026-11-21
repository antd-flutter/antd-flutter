/// antd_tree example — Tree / TreeSelect 演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntLayoutData 断点布局
///   （desktop 宽屏双栏 Wrap / phone 窄屏单栏 Column），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：基础树、多选 checkbox 树（父子联动/严格模式）、
///   受控树（expandedKeys/selectedKeys/checkedKeys 程序化操控）、
///   异步加载（loadData 模拟）、默认展开、TreeSelect 下拉选择
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdTreeGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// antd 树画廊根组件。
class AntdTreeGalleryApp extends StatefulWidget {
  const AntdTreeGalleryApp({super.key});

  @override
  State<AntdTreeGalleryApp> createState() => _AntdTreeGalleryAppState();
}

class _AntdTreeGalleryAppState extends State<AntdTreeGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    '基础树',
    '多选 checkbox 树',
    '受控树',
    '异步加载',
    '默认展开',
    'TreeSelect',
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_picker / antd_upload example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdTree Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Tree 树形控件族'),
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

  Widget _sectionBody(
      BuildContext pageContext, AntLayoutData layout, int index) {
    final cards = _sectionCards(context, index);
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

  List<_DemoCard> _sectionCards(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _basicCards();
      case 1:
        return _checkableCards();
      case 2:
        return const _ControlledSection().cards;
      case 3:
        return [const _AsyncLoadSection().card];
      case 4:
        return _defaultExpandCards();
      case 5:
        return _treeSelectCards();
      default:
        return [];
    }
  }
}

// ============================================================
// 演示数据
// ============================================================

const _basicTreeData = [
  AntTreeNode(
    key: 'zj',
    title: '浙江',
    children: [
      AntTreeNode(
        key: 'hz',
        title: '杭州',
        children: [
          AntTreeNode(key: 'xh', title: '西湖区'),
          AntTreeNode(key: 'lc', title: '临安区'),
        ],
      ),
      AntTreeNode(key: 'nb', title: '宁波'),
    ],
  ),
  AntTreeNode(
    key: 'js',
    title: '江苏',
    children: [
      AntTreeNode(key: 'nj', title: '南京'),
      AntTreeNode(key: 'sz', title: '苏州'),
    ],
  ),
  AntTreeNode(key: 'gd', title: '广东'),
];

// ============================================================
// 分区 1：基础树
// ============================================================

List<_DemoCard> _basicCards() {
  return [
    (
      '基础用法（选中）',
      _BasicTree(),
    ),
    (
      'showLine 连接线',
      AntTree(treeData: _basicTreeData, showLine: true),
    ),
    (
      '禁用节点',
      AntTree(
        treeData: const [
          AntTreeNode(key: 'a', title: '禁用节点 0-0', disabled: true),
          AntTreeNode(
            key: 'b',
            title: '可操作 0-1',
            children: [
              AntTreeNode(key: 'b1', title: '子节点 0-1-0'),
            ],
          ),
        ],
      ),
    ),
  ];
}

class _BasicTree extends StatefulWidget {
  const _BasicTree();

  @override
  State<_BasicTree> createState() => _BasicTreeState();
}

class _BasicTreeState extends State<_BasicTree> {
  List<String> _selected = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTree(
          treeData: _basicTreeData,
          selectedKeys: _selected,
          onSelect: (keys) => setState(() => _selected = keys),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '选中', _selected.join('、')),
      ],
    );
  }
}

// ============================================================
// 分区 2：多选 checkbox 树
// ============================================================

List<_DemoCard> _checkableCards() {
  return [
    (
      'checkbox 勾选（父子联动）',
      _CheckableTree(),
    ),
    (
      'checkStrictly 严格模式（父子不联动）',
      AntTree(
        treeData: _basicTreeData,
        checkable: true,
        checkStrictly: true,
        defaultCheckedKeys: const ['xh'],
      ),
    ),
  ];
}

class _CheckableTree extends StatefulWidget {
  const _CheckableTree();

  @override
  State<_CheckableTree> createState() => _CheckableTreeState();
}

class _CheckableTreeState extends State<_CheckableTree> {
  List<String> _checked = [];
  List<String> _halfChecked = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTree(
          treeData: _basicTreeData,
          checkable: true,
          checkedKeys: _checked,
          onCheck: (checked, halfChecked) =>
              setState(() {
                _checked = checked;
                _halfChecked = halfChecked;
              }),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '勾选', _checked.join('、')),
        _resultText(context, '半选', _halfChecked.join('、')),
      ],
    );
  }
}

// ============================================================
// 分区 3：受控树（expandedKeys / selectedKeys / checkedKeys 程序化操控）
// ============================================================

class _ControlledSection {
  const _ControlledSection();

  List<_DemoCard> get cards => [
        (
          '受控展开/勾选（按钮程序化操控，R35 判定：标准受控模式，无 Controller）',
          _ControlledTree(),
        ),
      ];
}

class _ControlledTree extends StatefulWidget {
  const _ControlledTree();

  @override
  State<_ControlledTree> createState() => _ControlledTreeState();
}

class _ControlledTreeState extends State<_ControlledTree> {
  /// 全部父节点 key（等价 expandAll）。
  static const _allParentKeys = ['zj', 'hz', 'js'];

  List<String> _expanded = const ['zj'];
  List<String> _checked = const [];
  List<String> _selected = const [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => _expanded = _allParentKeys),
              child: const Text('全部展开'),
            ),
            OutlinedButton(
              onPressed: () => setState(() => _expanded = const []),
              child: const Text('全部收起'),
            ),
            OutlinedButton(
              onPressed: () => setState(
                  () => _checked = const ['xh', 'lc', 'nb', 'nj', 'sz', 'gd']),
              child: const Text('勾选全部叶子'),
            ),
            OutlinedButton(
              onPressed: () => setState(() {
                _checked = const [];
                _selected = const ['zj'];
              }),
              child: const Text('清空勾选 + 选中浙江'),
            ),
          ],
        ),
        SizedBox(height: 12.w),
        AntTree(
          treeData: _basicTreeData,
          expandedKeys: _expanded,
          onExpand: (keys) => setState(() => _expanded = keys),
          selectedKeys: _selected,
          onSelect: (keys) => setState(() => _selected = keys),
          checkable: true,
          checkedKeys: _checked,
          onCheck: (keys, _) => setState(() => _checked = keys),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '展开', _expanded.join('、')),
        _resultText(context, '勾选', _checked.join('、')),
        _resultText(context, '选中', _selected.join('、')),
      ],
    );
  }
}

// ============================================================
// 分区 4：异步加载
// ============================================================

class _AsyncLoadSection {
  const _AsyncLoadSection();

  _DemoCard get card => ('异步加载子节点（模拟 loadData）', _AsyncLoadTree());
}

class _AsyncLoadTree extends StatefulWidget {
  const _AsyncLoadTree();

  @override
  State<_AsyncLoadTree> createState() => _AsyncLoadTreeState();
}

class _AsyncLoadTreeState extends State<_AsyncLoadTree> {
  /// 顶层节点：children 为空（isLeaf 语义），展开时模拟拉取。
  ///
  /// antd_tree 当前通过受控 treeData + onExpand 注入异步加载：
  /// 展开无子节点的父节点时拉取数据并 setState 更新 treeData。
  List<AntTreeNode> _treeData = const [
    AntTreeNode(key: 'srv', title: '服务器组 A（点展开加载）'),
    AntTreeNode(key: 'srv-b', title: '服务器组 B（点展开加载）'),
  ];

  final Set<String> _loaded = {};

  Future<void> _onExpand(List<String> keys) async {
    for (final key in keys) {
      if (_loaded.contains(key)) continue;
      _loaded.add(key);
      // 模拟网络延迟后注入子节点。
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        _treeData = [
          for (final node in _treeData)
            if (node.key == key)
              AntTreeNode(
                key: node.key,
                title: node.title,
                disabled: node.disabled,
                children: [
                  AntTreeNode(key: '$key-1', title: '$key 节点 1'),
                  AntTreeNode(key: '$key-2', title: '$key 节点 2'),
                ],
              )
            else
              node,
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AntTree(
      treeData: _treeData,
      expandedKeys: [
        for (final node in _treeData)
          if (node.children != null) node.key,
      ],
      onExpand: _onExpand,
      showLine: true,
    );
  }
}

// ============================================================
// 分区 5：默认展开
// ============================================================

List<_DemoCard> _defaultExpandCards() {
  return [
    (
      'defaultExpandedKeys 默认展开指定节点',
      AntTree(
        treeData: _basicTreeData,
        defaultExpandedKeys: const ['hz'],
      ),
    ),
    (
      'defaultExpandAll 默认展开全部',
      AntTree(treeData: _basicTreeData, defaultExpandAll: true),
    ),
  ];
}

// ============================================================
// 分区 6：TreeSelect
// ============================================================

const _treeSelectOptions = [
  AntTreeSelectOption(value: 'zj', label: '浙江', children: [
    AntTreeSelectOption(value: 'hz', label: '杭州'),
    AntTreeSelectOption(value: 'nb', label: '宁波'),
  ]),
  AntTreeSelectOption(value: 'js', label: '江苏', children: [
    AntTreeSelectOption(value: 'nj', label: '南京'),
    AntTreeSelectOption(value: 'sz', label: '苏州'),
  ]),
  AntTreeSelectOption(value: 'gd', label: '广东'),
];

List<_DemoCard> _treeSelectCards() {
  return [
    (
      'TreeSelect 单选',
      _TreeSelectSingle(),
    ),
    (
      'TreeSelect 多选',
      _TreeSelectMultiple(),
    ),
    (
      'TreeSelect 默认展开 + 小尺寸',
      AntTreeSelect(
        treeData: _treeSelectOptions,
        treeDefaultExpandAll: true,
        size: AntTreeSelectSize.small,
      ),
    ),
  ];
}

class _TreeSelectSingle extends StatefulWidget {
  const _TreeSelectSingle();

  @override
  State<_TreeSelectSingle> createState() => _TreeSelectSingleState();
}

class _TreeSelectSingleState extends State<_TreeSelectSingle> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTreeSelect(
          treeData: _treeSelectOptions,
          value: _value,
          onChange: (v) => setState(() => _value = v as String?),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '选择', _value ?? ''),
      ],
    );
  }
}

class _TreeSelectMultiple extends StatefulWidget {
  const _TreeSelectMultiple();

  @override
  State<_TreeSelectMultiple> createState() => _TreeSelectMultipleState();
}

class _TreeSelectMultipleState extends State<_TreeSelectMultiple> {
  List<String> _values = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTreeSelect(
          treeData: _treeSelectOptions,
          multiple: true,
          value: _values,
          onChange: (v) => setState(() => _values = (v as List?)?.cast<String>() ?? const []),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '多选', _values.join('、')),
      ],
    );
  }
}

// ============================================================
// 公共小组件
// ============================================================

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
          child:
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
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
