/// antd_transfer example — 穿梭框演示画廊（Transfer / TreeTransfer）。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit 断点布局（desktop 宽屏双栏 / phone 窄屏单栏），
///   窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：基础穿梭 / 多选 / 受控 / 禁用项 /
///   多级树形穿梭（勾父带子、半选、树形展示）/ 搜索过滤 / 自定义配置
library;

import 'package:antd_transfer/antd_transfer.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdTransferGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

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
  ];

  static final List<List<_DemoCard>> _sectionCards = [
    _basicCards,
    [], // 受控分区为 StatefulWidget，见 _buildSectionBody
    _treeCards,
    _customCards,
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
    final cards = index == 1
        ? [
            (
              '受控模式（targetKeys / selectedKeys）',
              const _ControlledSection() as Widget,
            )
          ]
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
  return Padding(
    padding: EdgeInsets.only(top: 8.w),
    child: Text(
      value.isEmpty ? '$label：未穿梭' : '$label：$value',
      style: TextStyle(fontSize: 14.sp, color: theme.colorText),
    ),
  );
}

// ── 演示数据 ─────────────────────────────────────────────
final List<AntTransferItem> _plainData = [
  for (var i = 1; i <= 8; i++)
    AntTransferItem(key: 'k$i', title: '选项 $i'),
];

final List<AntTransferItem> _disabledData = [
  const AntTransferItem(key: 'a', title: '选项 A'),
  const AntTransferItem(key: 'b', title: '选项 B（禁用）', disabled: true),
  const AntTransferItem(key: 'c', title: '选项 C'),
  const AntTransferItem(key: 'd', title: '选项 D（禁用）', disabled: true),
  const AntTransferItem(key: 'e', title: '选项 E'),
];

final List<AntTransferItem> _treeData = [
  const AntTransferItem(key: 'g1', title: '组件库', children: [
    AntTransferItem(key: 'g1-1', title: '通用组件', children: [
      AntTransferItem(key: 'btn', title: 'Button 按钮'),
      AntTransferItem(key: 'icon', title: 'Icon 图标'),
    ]),
    AntTransferItem(key: 'g1-2', title: '布局组件', children: [
      AntTransferItem(key: 'grid', title: 'Grid 栅格'),
      AntTransferItem(key: 'divider', title: 'Divider 分隔线'),
    ]),
  ]),
  const AntTransferItem(key: 'g2', title: '数据录入', children: [
    AntTransferItem(key: 'input', title: 'Input 输入框'),
    AntTransferItem(key: 'select', title: 'Select 选择器'),
    AntTransferItem(key: 'switch', title: 'Switch 开关（禁用）',
        disabled: true),
  ]),
];

// ── 基础与多选 ───────────────────────────────────────────
final List<_DemoCard> _basicCards = [
  (
    '基础穿梭',
    Builder(builder: (context) {
      String last = '';
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 280,
              child: AntTransfer(
                dataSource: _plainData,
                onChange: (keys, dir, moved) =>
                    setState(() => last = '${moved.join(', ')}（$dir）'),
              ),
            ),
            _resultText(context, '最近移动', last),
          ],
        );
      });
    }),
  ),
  (
    '多选批量穿梭',
    Builder(builder: (context) {
      String last = '';
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 280,
              child: AntTransfer(
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
      });
    }),
  ),
  (
    '禁用项',
    Builder(
      builder: (context) => SizedBox(
        height: 240,
        child: AntTransfer(
          dataSource: _disabledData,
          defaultTargetKeys: const ['c'],
        ),
      ),
    ),
  ),
];

// ── 树形穿梭 ─────────────────────────────────────────────
final List<_DemoCard> _treeCards = [
  (
    '多级树形穿梭（勾父带子 / 半选 / 树形展示）',
    Builder(builder: (context) {
      String last = '';
      return StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 360,
              child: AntTransfer(
                dataSource: _treeData,
                defaultExpandAll: true,
                onChange: (keys, dir, moved) =>
                    setState(() => last = '${moved.join(', ')}（$dir）'),
              ),
            ),
            _resultText(context, '树模式移动', last),
          ],
        );
      });
    }),
  ),
  (
    '树形穿梭 + 搜索过滤',
    Builder(
      builder: (context) => SizedBox(
        height: 360,
        child: AntTransfer(
          dataSource: _treeData,
          defaultExpandAll: true,
          showSearch: true,
          filterOption: (input, item) =>
              item.title.toLowerCase().contains(input.toLowerCase()),
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
        child: AntTransfer(
          dataSource: _plainData,
          showSearch: true,
          filterOption: (input, item) => item.title.contains(input),
        ),
      ),
    ),
  ),
  (
    '自定义配置（titles / operations / oneWay）',
    Builder(
      builder: (context) => SizedBox(
        height: 280,
        child: AntTransfer(
          dataSource: _plainData,
          titles: const ['待办', '已完成'],
          operations: const ['完成 →', '← 撤回'],
          oneWay: true,
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
    return Builder(builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        var targetKeys = <String>['k1', 'k2'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 280,
              child: AntTransfer(
                dataSource: _plainData,
                targetKeys: targetKeys,
                onChange: (keys, dir, moved) =>
                    setState(() => targetKeys = keys),
              ),
            ),
            _resultText(context, '受控 targetKeys', targetKeys.join(', ')),
            Padding(
              padding: EdgeInsets.only(top: 8.w),
              child: OutlinedButton(
                onPressed: () => setState(() => targetKeys = []),
                child: const Text('重置为空'),
              ),
            ),
          ],
        );
      });
    });
  }
}
