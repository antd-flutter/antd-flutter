/// antd_masonry example — Masonry 瀑布流演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntLayoutData 断点布局
///   （desktop 宽屏双栏 Wrap / phone 窄屏单栏 Column），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：基础瀑布流、随机高度列表、跨列 span、
///   动态添加（增量加载）、AntSliverMasonry sliver 变体
///   （CustomScrollView + SliverAppBar 组合演示）
library;

import 'package:antd_masonry/antd_masonry.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart' hide Card;

void main() {
  runApp(const AntdMasonryGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, String, Widget);

/// antd 瀑布流画廊根组件。
class AntdMasonryGalleryApp extends StatefulWidget {
  const AntdMasonryGalleryApp({super.key});

  @override
  State<AntdMasonryGalleryApp> createState() => _AntdMasonryGalleryAppState();
}

class _AntdMasonryGalleryAppState extends State<AntdMasonryGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    '基础瀑布流',
    '随机高度',
    '跨列 span',
    '动态添加',
    'Sliver 变体',
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_tree / antd_picker example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'AntdMasonry Demo',
          debugShowCheckedModeBanner: false,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          theme: AntThemeData.light().toThemeData(),
          darkTheme: AntThemeData.dark().toThemeData(),
          home: DefaultTabController(
            length: _sectionTitles.length,
            child: Scaffold(
              backgroundColor: AntTheme.of(context).colorBgLayout,
              appBar: AppBar(
                title: const Text('Masonry 瀑布流'),
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
              // R35.4：AntResponsiveInit 断点布局，缩放窗口不溢出。
              body: AntResponsiveInit(
                builder: (context, layout, _) => TabBarView(
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
                for (final card in _sectionCards(context, index))
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 560.w),
                    child: _sectionCard(pageContext, card.$1, card.$2, card.$3),
                  ),
              ],
            )
          : Column(
              children: [
                for (final card in _sectionCards(context, index))
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.w),
                    child:
                        _sectionCard(pageContext, card.$1, card.$2, card.$3),
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
        return _randomCards();
      case 2:
        return _spanCards();
      case 3:
        return [const _IncrementalSection().card];
      case 4:
        return _sliverCards();
      default:
        return [];
    }
  }

  // ============================================================
  // 分区 1：基础瀑布流
  // ============================================================

  List<_DemoCard> _basicCards() {
    return [
      (
        '基本用法（贪心最短列分配）',
        '不同高度项按贪心算法放入当前最矮列',
        AntMasonry(
          columns: 3,
          gutter: 16,
          children: const [
            AntMasonryItem(height: 100, child: _Tile('A')),
            AntMasonryItem(height: 150, child: _Tile('B')),
            AntMasonryItem(height: 80, child: _Tile('C')),
            AntMasonryItem(height: 130, child: _Tile('D')),
            AntMasonryItem(height: 90, child: _Tile('E')),
            AntMasonryItem(height: 120, child: _Tile('F')),
          ],
        ),
      ),
      (
        'columns 列数',
        'columns 控制列数，默认 3 列',
        AntMasonry(
          columns: 2,
          gutter: 12,
          children: [
            for (var i = 0; i < 4; i++)
              AntMasonryItem(height: 60 + i * 30, child: _Tile('项 ${i + 1}')),
          ],
        ),
      ),
    ];
  }

  // ============================================================
  // 分区 2：随机高度
  // ============================================================

  List<_DemoCard> _randomCards() {
    return [
      (
        '随机高度列表',
        '高度随机生成的列表，贪心分配自动均衡各列',
        AntMasonry(
          columns: 3,
          gutter: 12,
          children: [
            for (var i = 0; i < 12; i++)
              AntMasonryItem(
                height: 60 + (i * 37) % 120,
                child: _Tile('r$i'),
              ),
          ],
        ),
      ),
      (
        '响应式列数',
        'responsiveColumns 断点列数（xs:1 / sm:2 / lg:3 / xl:4），窗口缩放自适应',
        AntMasonry(
          responsiveColumns: const AntMasonryResponsive(
            xs: 1,
            sm: 2,
            lg: 3,
            xl: 4,
          ),
          gutter: 12,
          children: [
            for (var i = 0; i < 8; i++)
              AntMasonryItem(height: 70 + (i * 53) % 90, child: _Tile('rp$i')),
          ],
        ),
      ),
    ];
  }

  // ============================================================
  // 分区 3：跨列 span
  // ============================================================

  List<_DemoCard> _spanCards() {
    return [
      (
        '跨列 span 项',
        'span > 1 的项跨列放置（对照 staggered span tile 语义）',
        AntMasonry(
          columns: 3,
          gutter: 12,
          children: const [
            AntMasonryItem(height: 90, child: _Tile('普通')),
            AntMasonryItem(height: 110, span: 2, child: _Tile('span 2')),
            AntMasonryItem(height: 80, child: _Tile('普通')),
            AntMasonryItem(height: 100, span: 3, child: _Tile('span 3 整行')),
            AntMasonryItem(height: 120, child: _Tile('普通')),
          ],
        ),
      ),
    ];
  }

  // ============================================================
  // 分区 4：动态添加（增量加载）
  // ============================================================
}

class _IncrementalSection extends StatefulWidget {
  const _IncrementalSection();

  _DemoCard get card => (
        '动态添加（增量加载）',
        '点击加载 6 条新数据，setState 替换数据列表（R35 判定：无 Controller，受控刷新）',
        this,
      );

  @override
  State<_IncrementalSection> createState() => _IncrementalSectionState();
}

class _IncrementalSectionState extends State<_IncrementalSection> {
  final List<int> _items = List.generate(6, (i) => i);

  void _loadMore() {
    final base = _items.length;
    setState(() {
      _items.addAll(List.generate(6, (i) => base + i));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: [
            FilledButton(onPressed: _loadMore, child: const Text('加载 6 条')),
            OutlinedButton(
              onPressed: () => setState(() => _items.clear()),
              child: const Text('清空'),
            ),
          ],
        ),
        SizedBox(height: 12.w),
        Text('当前 ${_items.length} 条',
            style: TextStyle(fontSize: 13.sp, color: theme.colorTextSecondary)),
        SizedBox(height: 8.w),
        AntMasonry(
          columns: 3,
          gutter: 10,
          children: [
            for (final i in _items)
              AntMasonryItem(height: 70 + (i * 41) % 100, child: _Tile('#$i')),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// 分区 5：Sliver 变体（R33）
// ============================================================

List<_DemoCard> _sliverCards() {
  return [
    (
      'AntSliverMasonry + SliverAppBar',
      'sliver 变体在 CustomScrollView 中与其他 sliver 组合（R33 强制项）',
      SizedBox(
        height: 360,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('瀑布流'),
              centerTitle: true,
              pinned: true,
              backgroundColor: Colors.blue.shade100,
            ),
            AntSliverMasonry(
              columns: 2,
              gutter: 10,
              children: [
                for (var i = 0; i < 16; i++)
                  AntMasonryItem(
                    height: 80 + (i * 29) % 100,
                    child: _Tile('sliver #$i'),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
    (
      'AntSliverMasonry 跨列 span',
      'sliver 变体同样支持 span 跨列',
      SizedBox(
        height: 300,
        child: CustomScrollView(
          slivers: [
            AntSliverMasonry(
              columns: 3,
              gutter: 10,
              children: const [
                AntMasonryItem(height: 90, child: _Tile('s1')),
                AntMasonryItem(height: 110, span: 2, child: _Tile('s2 wide')),
                AntMasonryItem(height: 80, child: _Tile('s3')),
                AntMasonryItem(height: 100, child: _Tile('s4')),
              ],
            ),
          ],
        ),
      ),
    ),
  ];
}

// ============================================================
// 公共小组件
// ============================================================

/// 瀑布流占位块。
class _Tile extends StatelessWidget {
  const _Tile(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorPrimaryBg,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      alignment: Alignment.center,
      child: Text(label, style: TextStyle(fontSize: 14.sp)),
    );
  }
}

/// 卡片容器。
Widget _sectionCard(
    BuildContext context, String title, String desc, Widget child) {
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
          padding: EdgeInsets.only(bottom: 4.w),
          child: Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 12.w),
          child: Text(desc,
              style: TextStyle(
                  fontSize: 12.sp, color: theme.colorTextSecondary)),
        ),
        child,
      ],
    ),
  );
}
