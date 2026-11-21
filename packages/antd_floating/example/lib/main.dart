/// antd_floating example — Floating 浮动组件演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntLayoutData 断点布局，
///   窗口缩放无溢出；暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：
///   - FloatingPanel：拖拽吸附 / Controller 程序化展开收起 / 边缘锚点 / 高度回调
///   - FloatingBubble：拖拽 / Controller 边缘磁吸 / 点击回调 / 菜单 / 多实例 / 显示隐藏
library;

import 'package:antd_floating/antd_floating.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart' hide Card;

void main() {
  runApp(const AntdFloatingGalleryApp());
}

/// antd 浮动组件画廊根组件。
class AntdFloatingGalleryApp extends StatefulWidget {
  const AntdFloatingGalleryApp({super.key});

  @override
  State<AntdFloatingGalleryApp> createState() => _AntdFloatingGalleryAppState();
}

class _AntdFloatingGalleryAppState extends State<AntdFloatingGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    'FloatingPanel',
    'FloatingBubble',
    '气泡多实例',
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_masonry / antd_tree example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'AntdFloating Demo',
          debugShowCheckedModeBanner: false,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          theme: AntThemeData.light().toThemeData(),
          darkTheme: AntThemeData.dark().toThemeData(),
          home: DefaultTabController(
            length: _sectionTitles.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Floating 浮动'),
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
                    _panelSection(context, layout),
                    _bubbleSection(context, layout),
                    _multiBubbleSection(context, layout),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isWide(AntLayoutData layout) =>
      layout.width >= 768 ||
      layout.breakpoint == AntBreakpoint.lg ||
      layout.breakpoint == AntBreakpoint.xl ||
      layout.breakpoint == AntBreakpoint.xxl;

  Widget _sectionShell(
      BuildContext context, AntLayoutData layout, List<Widget> cards) {
    final isWide = _isWide(layout);
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
                    child: card,
                  ),
              ],
            )
          : Column(
              children: [
                for (final card in cards)
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.w),
                    child: card,
                  ),
              ],
            ),
    );
  }

  Widget _demoCard(
      BuildContext pageContext, String title, String desc, Widget demo) {
    final theme = AntTheme.of(pageContext);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.fontSizeLG.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            desc,
            style: TextStyle(
              fontSize: theme.fontSizeSM.sp,
              color: theme.colorTextSecondary,
            ),
          ),
          SizedBox(height: 12.w),
          demo,
        ],
      ),
    );
  }

  // ============================================================
  // 分区 1：FloatingPanel（拖拽吸附 / Controller / 边缘锚点）
  // ============================================================

  Widget _panelSection(BuildContext context, AntLayoutData layout) {
    final pageContext = context;
    return _sectionShell(context, layout, [
      _demoCard(pageContext,
        '拖拽吸附 + 程序化控制',
        '把手拖拽松手吸附最近锚点；按钮程序化展开/收起',
        const _PanelDemo(),
      ),
      _demoCard(pageContext,
        '边缘锚点（低/中/高三档）',
        'anchors 最低 0.25，可收起为贴底窄条',
        const SizedBox(
          height: 360,
          child: AntFloatingPanel(
            anchors: [0.25, 0.6, 1],
            child: Center(child: Text('边缘锚点面板内容')),
          ),
        ),
      ),
    ]);
  }

  // ============================================================
  // 分区 2：FloatingBubble（拖拽 / 磁吸 / 点击回调 / 菜单）
  // ============================================================

  Widget _bubbleSection(BuildContext context, AntLayoutData layout) {
    final pageContext = context;
    return _sectionShell(context, layout, [
      _demoCard(pageContext,
        '拖拽 + 边缘磁吸 + 点击回调',
        '拖拽气泡，松手点击「吸附边缘」磁吸到左/右；点击气泡有回调',
        const _BubbleDemo(),
      ),
      _demoCard(pageContext,
        '拖拽松手自动吸附边缘',
        'autoSnapToEdge: true —— 拖拽气泡松手后自动贴靠最近左/右边缘',
        const _AutoSnapBubbleDemo(),
      ),
      _demoCard(pageContext,
        '菜单展开 + 显示隐藏',
        '配置 menu 的气泡点击展开动作列表；Controller 控制显示/隐藏',
        const _BubbleMenuDemo(),
      ),
    ]);
  }

  // ============================================================
  // 分区 3：气泡多实例
  // ============================================================

  Widget _multiBubbleSection(BuildContext context, AntLayoutData layout) {
    return _sectionShell(context, layout, [
      const _MultiBubbleDemo(),
    ]);
  }
}

// ============================================================
// 演示：FloatingPanel 拖拽吸附 + Controller
// ============================================================

class _PanelDemo extends StatefulWidget {
  const _PanelDemo();

  @override
  State<_PanelDemo> createState() => _PanelDemoState();
}

class _PanelDemoState extends State<_PanelDemo> {
  final AntFloatingPanelController _controller = AntFloatingPanelController();
  double _ratio = 0.6;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: [
            OutlinedButton(
              onPressed: () => _controller.expand(),
              child: const Text('展开'),
            ),
            OutlinedButton(
              onPressed: () => _controller.collapse(),
              child: const Text('收起'),
            ),
            OutlinedButton(
              onPressed: () => _controller.resetToInitial(),
              child: const Text('重置'),
            ),
            OutlinedButton(
              onPressed: () => _controller.snapToAnchorAt(1),
              child: const Text('中间锚点'),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Text(
          '当前高度比例：${_ratio.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: theme.fontSizeSM.sp,
            color: theme.colorTextSecondary,
          ),
        ),
        SizedBox(
          height: 360,
          child: AntFloatingPanel(
            controller: _controller,
            onHeightChange: (p) => setState(() => _ratio = p),
            child: ListView(
              children: [
                for (var i = 1; i <= 12; i++)
                  ListTile(dense: true, title: Text('列表项 $i')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 演示：FloatingBubble 拖拽 + 磁吸 + 点击回调
// ============================================================

class _BubbleDemo extends StatefulWidget {
  const _BubbleDemo();

  @override
  State<_BubbleDemo> createState() => _BubbleDemoState();
}

class _BubbleDemoState extends State<_BubbleDemo> {
  final AntFloatingBubbleController _controller = AntFloatingBubbleController();
  String _last = '（尚未点击）';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AntTheme.of(context).colorFillQuaternary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '点击回调：$_last',
              style: TextStyle(
                fontSize: AntTheme.of(context).fontSizeSM.sp,
                color: AntTheme.of(context).colorTextSecondary,
              ),
            ),
          ),
          AntFloatingBubble(
            controller: _controller,
            initialPos: const Offset(280, 220),
            onClick: () => setState(() => _last = DateTime.now()
                .toIso8601String()
                .substring(11, 19)),
            child: const Icon(Icons.touch_app),
          ),
          Positioned(
            left: 8.w,
            bottom: 8.w,
            child: Wrap(
              spacing: 8.w,
              children: [
                OutlinedButton(
                  onPressed: () => _controller.snapToNearestEdge(),
                  child: const Text('吸附边缘'),
                ),
                OutlinedButton(
                  onPressed: () => _controller.moveTo(const Offset(10, 10)),
                  child: const Text('移到左上'),
                ),
                OutlinedButton(
                  onPressed: () => _controller.resetPosition(),
                  child: const Text('重置'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 演示：拖拽松手自动吸附边缘（autoSnapToEdge）
// ============================================================

class _AutoSnapBubbleDemo extends StatelessWidget {
  const _AutoSnapBubbleDemo();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorFillQuaternary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '拖拽气泡松手 → 自动吸附最近左/右边缘',
              style: TextStyle(
                fontSize: theme.fontSizeSM.sp,
                color: theme.colorTextSecondary,
              ),
            ),
          ),
          const AntFloatingBubble(
            initialPos: Offset(120, 180),
            autoSnapToEdge: true,
            child: Icon(Icons.swipe),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 演示：菜单展开 + 显示隐藏
// ============================================================

class _BubbleMenuDemo extends StatefulWidget {
  const _BubbleMenuDemo();

  @override
  State<_BubbleMenuDemo> createState() => _BubbleMenuDemoState();
}

class _BubbleMenuDemoState extends State<_BubbleMenuDemo> {
  final AntFloatingBubbleController _controller = AntFloatingBubbleController();
  bool _visible = true;
  String _action = '（无）';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorFillQuaternary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '最近动作：$_action',
              style: TextStyle(
                fontSize: theme.fontSizeSM.sp,
                color: theme.colorTextSecondary,
              ),
            ),
          ),
          AntFloatingBubble(
            controller: _controller,
            initialPos: const Offset(280, 60),
            menu: [
              AntFloatingBubbleMenuAction(
                label: '新建',
                icon: const Icon(Icons.add),
                onClick: () => setState(() => _action = '新建'),
              ),
              AntFloatingBubbleMenuAction(
                label: '搜索',
                icon: const Icon(Icons.search),
                onClick: () => setState(() => _action = '搜索'),
              ),
              AntFloatingBubbleMenuAction(
                label: '设置',
                icon: const Icon(Icons.settings),
                onClick: () => setState(() => _action = '设置'),
              ),
            ],
          ),
          Positioned(
            left: 8.w,
            bottom: 8.w,
            child: OutlinedButton(
              onPressed: () {
                _visible = !_visible;
                _visible ? _controller.show() : _controller.hide();
                setState(() {});
              },
              child: Text(_visible ? '隐藏气泡' : '显示气泡'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 演示：气泡多实例
// ============================================================

class _MultiBubbleDemo extends StatelessWidget {
  const _MultiBubbleDemo();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    Widget card(String title, Color color, IconData icon, Offset pos) =>
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.colorBgContainer,
            borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
            border: Border.all(color: theme.colorBorderSecondary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: theme.fontSizeLG.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorText,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                '独立实例，互不影响；可分别拖拽',
                style: TextStyle(
                  fontSize: theme.fontSizeSM.sp,
                  color: theme.colorTextSecondary,
                ),
              ),
              SizedBox(height: 12.w),
              SizedBox(
                height: 220,
                child: AntFloatingBubble(
                  initialPos: pos,
                  backgroundColor: color,
                  onClick: () {},
                  child: Icon(icon),
                ),
              ),
            ],
          ),
        );
    return Column(
      children: [
        card('实例 A（主色）', theme.colorPrimary, Icons.edit, const Offset(180, 100)),
        SizedBox(height: 16.w),
        card('实例 B（金色）', const Color(0xFFFAAD14), Icons.star, const Offset(30, 120)),
        SizedBox(height: 16.w),
        card('实例 C（仅 Y 轴）', const Color(0xFF52C41A), Icons.vertical_align_center,
            const Offset(140, 40)),
      ],
    );
  }
}
