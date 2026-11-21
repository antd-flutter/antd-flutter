/// antd_tree example — Tree / TreeSelect 演示画廊（泛型数据源版）。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntLayoutData 断点布局
///   （desktop 宽屏双栏 Wrap / phone 窄屏单栏 Column），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 所有示例都用用户自定义模型 `_Region` 驱动，组件只通过
///   keyOf/titleBuilder/childrenOf/disabledOf 读取数据
library;

import 'dart:async';

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdTreeGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// ------------------------------------------------------------
/// 用户自定义模型：不继承任何组件基类，也不实现任何接口。
/// ------------------------------------------------------------
class _Region {
  const _Region(
    this.id,
    this.name, {
    this.children = const <_Region>[],
    this.disabled = false,
    this.checkable = true,
  });

  final int id;
  final String name;
  final List<_Region> children;
  final bool disabled;
  final bool checkable;

  _Region copyWith({List<_Region>? children}) => _Region(
    id,
    name,
    children: children ?? this.children,
    disabled: disabled,
    checkable: checkable,
  );
}

Object _regionKey(_Region region) => region.id;

Widget _regionTitle(BuildContext context, _Region region) => Text(region.name);

List<_Region> _regionChildren(_Region region) => region.children;

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
    '自定义模型',
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
    final cards = _sectionCards(context, index);
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
      case 6:
        return _customModelCards();
      default:
        return [];
    }
  }
}

// ============================================================
// 演示数据
// ============================================================

const _basicTreeData = <_Region>[
  _Region(
    1,
    '浙江',
    children: [
      _Region(2, '杭州', children: [_Region(3, '西湖区'), _Region(4, '临安区')]),
      _Region(5, '宁波'),
    ],
  ),
  _Region(6, '江苏', children: [_Region(7, '南京'), _Region(8, '苏州')]),
  _Region(9, '广东'),
];

/// 把 key 集合还原成名称（按 DFS 顺序）。
String _labelsOf(Iterable<Object> keys) {
  final wanted = keys.toSet();
  final names = <String>[];
  void walk(List<_Region> items) {
    for (final region in items) {
      if (wanted.contains(region.id)) names.add(region.name);
      walk(region.children);
    }
  }

  walk(_basicTreeData);
  return names.join('、');
}

// ============================================================
// 分区 1：基础树
// ============================================================

List<_DemoCard> _basicCards() {
  return [
    ('基础用法（选中，用户模型驱动）', _BasicTree()),
    (
      'showLine 连接线',
      AntTree<_Region>(
        dataSource: _basicTreeData,
        keyOf: _regionKey,
        titleBuilder: _regionTitle,
        childrenOf: _regionChildren,
        showLine: true,
      ),
    ),
    (
      '禁用节点',
      AntTree<_Region>(
        dataSource: const [
          _Region(10, '禁用节点 0-0', disabled: true),
          _Region(11, '可操作 0-1', children: [_Region(12, '子节点 0-1-0')]),
        ],
        keyOf: _regionKey,
        titleBuilder: _regionTitle,
        childrenOf: _regionChildren,
        disabledOf: (region) => region.disabled,
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
  Set<Object> _selected = <Object>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTree<_Region>(
          dataSource: _basicTreeData,
          keyOf: _regionKey,
          titleBuilder: _regionTitle,
          childrenOf: _regionChildren,
          selectedKeys: _selected,
          onSelect: (keys) => setState(() => _selected = keys),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '选中', _labelsOf(_selected)),
      ],
    );
  }
}

// ============================================================
// 分区 2：多选 checkbox 树
// ============================================================

List<_DemoCard> _checkableCards() {
  return [
    ('checkbox 勾选（父子联动）', _CheckableTree()),
    (
      'checkStrictly 严格模式（父子不联动）',
      AntTree<_Region>(
        dataSource: _basicTreeData,
        keyOf: _regionKey,
        titleBuilder: _regionTitle,
        childrenOf: _regionChildren,
        checkable: true,
        checkStrictly: true,
        defaultCheckedKeys: const <Object>{3},
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
  Set<Object> _checked = <Object>{};
  Set<Object> _halfChecked = <Object>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTree<_Region>(
          dataSource: _basicTreeData,
          keyOf: _regionKey,
          titleBuilder: _regionTitle,
          childrenOf: _regionChildren,
          checkable: true,
          checkedKeys: _checked,
          onCheck: (checked, halfChecked) => setState(() {
            _checked = checked;
            _halfChecked = halfChecked;
          }),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '勾选', _labelsOf(_checked)),
        _resultText(context, '半选', _labelsOf(_halfChecked)),
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
    ('受控展开/勾选（按钮程序化操控，R35 判定：标准受控模式，无 Controller）', _ControlledTree()),
  ];
}

class _ControlledTree extends StatefulWidget {
  const _ControlledTree();

  @override
  State<_ControlledTree> createState() => _ControlledTreeState();
}

class _ControlledTreeState extends State<_ControlledTree> {
  /// 全部父节点 key（等价 expandAll）。
  static const _allParentKeys = <Object>{1, 2, 6};

  Set<Object> _expanded = const <Object>{1};
  Set<Object> _checked = const <Object>{};
  Set<Object> _selected = const <Object>{};

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
              onPressed: () => setState(() => _expanded = const <Object>{}),
              child: const Text('全部收起'),
            ),
            OutlinedButton(
              onPressed: () =>
                  setState(() => _checked = const <Object>{3, 4, 5, 7, 8, 9}),
              child: const Text('勾选全部叶子'),
            ),
            OutlinedButton(
              onPressed: () => setState(() {
                _checked = const <Object>{};
                _selected = const <Object>{1};
              }),
              child: const Text('清空勾选 + 选中浙江'),
            ),
          ],
        ),
        SizedBox(height: 12.w),
        AntTree<_Region>(
          dataSource: _basicTreeData,
          keyOf: _regionKey,
          titleBuilder: _regionTitle,
          childrenOf: _regionChildren,
          expandedKeys: _expanded,
          onExpand: (keys) => setState(() => _expanded = keys),
          selectedKeys: _selected,
          onSelect: (keys) => setState(() => _selected = keys),
          checkable: true,
          checkedKeys: _checked,
          onCheck: (keys, _) => setState(() => _checked = keys),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '展开', _labelsOf(_expanded)),
        _resultText(context, '勾选', _labelsOf(_checked)),
        _resultText(context, '选中', _labelsOf(_selected)),
      ],
    );
  }
}

// ============================================================
// 分区 4：异步加载（按钮模拟 loadData）
// ============================================================

class _AsyncLoadSection {
  const _AsyncLoadSection();

  _DemoCard get card => ('异步加载子节点（按钮模拟 loadData）', _AsyncLoadTree());
}

class _AsyncLoadTree extends StatefulWidget {
  const _AsyncLoadTree();

  @override
  State<_AsyncLoadTree> createState() => _AsyncLoadTreeState();
}

class _AsyncLoadTreeState extends State<_AsyncLoadTree> {
  /// 顶层节点：children 为空，视为叶子；点击按钮模拟网络请求后注入子节点。
  List<_Region> _treeData = const [_Region(1, '服务器组 A'), _Region(2, '服务器组 B')];

  Set<Object> _expanded = <Object>{};
  bool _loading = false;

  Future<void> _load() async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _treeData = [
        for (final node in _treeData)
          node.copyWith(
            children: [
              _Region(node.id * 10 + 1, '${node.name} 节点 1'),
              _Region(node.id * 10 + 2, '${node.name} 节点 2'),
            ],
          ),
      ];
      _expanded = const <Object>{1, 2};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _loading ? null : _load,
          icon: Icon(AntIcons.cloudDownloadOutlined, size: 14.sp),
          label: Text(_loading ? '加载中…' : '模拟异步加载子节点'),
        ),
        SizedBox(height: 8.w),
        AntTree<_Region>(
          dataSource: _treeData,
          keyOf: _regionKey,
          titleBuilder: _regionTitle,
          childrenOf: _regionChildren,
          expandedKeys: _expanded,
          onExpand: (keys) => setState(() => _expanded = keys),
          showLine: true,
        ),
      ],
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
      AntTree<_Region>(
        dataSource: _basicTreeData,
        keyOf: _regionKey,
        titleBuilder: _regionTitle,
        childrenOf: _regionChildren,
        defaultExpandedKeys: const <Object>{2},
      ),
    ),
    (
      'defaultExpandAll 默认展开全部',
      AntTree<_Region>(
        dataSource: _basicTreeData,
        keyOf: _regionKey,
        titleBuilder: _regionTitle,
        childrenOf: _regionChildren,
        defaultExpandAll: true,
      ),
    ),
  ];
}

// ============================================================
// 分区 6：TreeSelect
// ============================================================

const _treeSelectData = <_Region>[
  _Region(1, '浙江', children: [_Region(2, '杭州'), _Region(5, '宁波')]),
  _Region(6, '江苏', children: [_Region(7, '南京'), _Region(8, '苏州')]),
  _Region(9, '广东'),
];

List<_DemoCard> _treeSelectCards() {
  return [
    ('TreeSelect 单选（用户模型）', _TreeSelectSingle()),
    ('TreeSelect 多选（用户模型）', _TreeSelectMultiple()),
    (
      'TreeSelect 默认展开 + 小尺寸',
      AntTreeSelect<_Region>(
        dataSource: _treeSelectData,
        keyOf: _regionKey,
        labelOf: (region) => region.name,
        titleBuilder: _regionTitle,
        childrenOf: _regionChildren,
        treeDefaultExpandAll: true,
        size: AntTreeSelectSize.small,
      ),
    ),
    (
      'TreeSelect 自定义 titleBuilder',
      AntTreeSelect<_Region>(
        dataSource: _treeSelectData,
        keyOf: _regionKey,
        labelOf: (region) => region.name,
        titleBuilder: (context, region) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AntIcons.environmentOutlined, size: 12.sp),
            SizedBox(width: 4.w),
            Text(region.name),
          ],
        ),
        childrenOf: _regionChildren,
        treeDefaultExpandAll: true,
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
  Object? _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTreeSelect<_Region>(
          dataSource: _treeSelectData,
          keyOf: _regionKey,
          labelOf: (region) => region.name,
          titleBuilder: _regionTitle,
          childrenOf: _regionChildren,
          value: _value,
          onChange: (v) => setState(() => _value = v),
        ),
        SizedBox(height: 8.w),
        _resultText(
          context,
          '选择',
          _labelsOf(_value == null ? const [] : [_value!]),
        ),
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
  List<Object> _values = <Object>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTreeSelect<_Region>(
          dataSource: _treeSelectData,
          keyOf: _regionKey,
          labelOf: (region) => region.name,
          titleBuilder: _regionTitle,
          childrenOf: _regionChildren,
          multiple: true,
          value: _values,
          onChange: (v) => setState(
            () => _values = (v as List?)?.cast<Object>() ?? const <Object>[],
          ),
        ),
        SizedBox(height: 8.w),
        _resultText(context, '多选', _labelsOf(_values)),
      ],
    );
  }
}

// ============================================================
// 分区 7：自定义模型（children / disabled / checkable / 勾选）
// ============================================================

List<_DemoCard> _customModelCards() {
  return [
    ('自定义模型：keyOf + titleBuilder + childrenOf', _CustomModelTree()),
    (
      '自定义模型：disabledOf + checkableOf',
      AntTree<_Region>(
        dataSource: const [
          _Region(20, '锁定节点', disabled: true),
          _Region(21, '不可勾选节点', checkable: false),
          _Region(22, '普通节点'),
        ],
        keyOf: _regionKey,
        titleBuilder: _regionTitle,
        childrenOf: _regionChildren,
        disabledOf: (region) => region.disabled,
        checkableOf: (region) => region.checkable,
        checkable: true,
        defaultExpandAll: true,
      ),
    ),
  ];
}

class _CustomModelTree extends StatefulWidget {
  const _CustomModelTree();

  @override
  State<_CustomModelTree> createState() => _CustomModelTreeState();
}

class _CustomModelTreeState extends State<_CustomModelTree> {
  Object? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTree<_Region>(
          dataSource: _basicTreeData,
          keyOf: _regionKey,
          titleBuilder: (context, region) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                region.children.isEmpty
                    ? AntIcons.fileOutlined
                    : AntIcons.folderOutlined,
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(region.name),
            ],
          ),
          childrenOf: _regionChildren,
          selectedKeys: _selected == null ? const <Object>{} : {_selected!},
          onSelect: (keys) =>
              setState(() => _selected = keys.isEmpty ? null : keys.first),
        ),
        SizedBox(height: 8.w),
        _resultText(
          context,
          '选中',
          _labelsOf(_selected == null ? const [] : [_selected!]),
        ),
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
  return Text(
    value.isEmpty ? '$label：未选择' : '$label：$value',
    style: TextStyle(fontSize: 14.sp, color: theme.colorText),
  );
}
