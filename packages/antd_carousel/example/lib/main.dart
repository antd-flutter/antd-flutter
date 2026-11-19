/// antd_carousel example — Carousel 走马灯演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntLayoutData 断点布局
///   （desktop 宽屏双栏 Wrap / phone 窄屏单栏 Column），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：基础轮播 / 自动播放 / 无限循环（连续滑动不回弹）/
///   指示点位置与样式 / 箭头 / 垂直轮播 / 手势切换 /
///   受控 Controller（goTo 程序化跳转）/ 自定义 item（含视差变换效果）
library;

import 'dart:math' as math;

import 'package:antd_carousel/antd_carousel.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdCarouselGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// antd 走马灯画廊根组件。
class AntdCarouselGalleryApp extends StatefulWidget {
  const AntdCarouselGalleryApp({super.key});

  @override
  State<AntdCarouselGalleryApp> createState() => _AntdCarouselGalleryAppState();
}

class _AntdCarouselGalleryAppState extends State<AntdCarouselGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    '基础轮播',
    '自动播放',
    '无限循环',
    '指示器与箭头',
    '垂直轮播',
    '受控 Controller',
    '自定义 item / 视差',
  ];

  /// 演示用页面内容（色块 + 文字）。
  List<Widget> _demoPages(int count, {List<String>? labels}) {
    final theme = AntThemeData.light();
    return [
      for (var i = 0; i < count; i++)
        Container(
          alignment: Alignment.center,
          color: theme.colorPrimary.withValues(
            alpha: 0.15 + 0.2 * (i % 3),
          ),
          child: Text(
            labels != null && i < labels.length ? labels[i] : '第 ${i + 1} 页',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
        ),
    ];
  }

  List<_DemoCard> _buildCards() {
    return [
      (
        '基础轮播',
        AntCarousel(
          height: 160.w,
          children: _demoPages(3),
        ),
      ),
      (
        '自动播放（3s）',
        AntCarousel(
          height: 160.w,
          autoplay: true,
          children: _demoPages(4),
        ),
      ),
      (
        '无限循环（连续滑动不回弹）',
        AntCarousel(
          height: 160.w,
          loop: true,
          autoplay: true,
          children: _demoPages(3),
        ),
      ),
      (
        '指示点位置（上/左/右）+ 箭头',
        Column(
          children: [
            AntCarousel(
              height: 140.w,
              dotPosition: AntCarouselDotPosition.top,
              arrows: true,
              children: _demoPages(3),
            ),
            SizedBox(height: 12.w),
            Row(
              children: [
                Expanded(
                  child: AntCarousel(
                    height: 120.w,
                    dotPosition: AntCarouselDotPosition.left,
                    children: _demoPages(3),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AntCarousel(
                    height: 120.w,
                    dotPosition: AntCarouselDotPosition.right,
                    children: _demoPages(3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      (
        '垂直轮播',
        AntCarousel(
          height: 200.w,
          vertical: true,
          autoplay: true,
          children: _demoPages(3),
        ),
      ),
      (
        '受控 Controller（goTo 程序化跳转）',
        const _ControlledDemo(),
      ),
      (
        '自定义 item / 视差变换效果',
        const _ParallaxDemo(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_tree / antd_upload example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdCarousel Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Carousel 走马灯'),
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
                      _buildSection(i, layout),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(int index, AntLayoutData layout) {
    final cards = _buildCards();
    // 每个标签页只展示对应形态（受控与视差页为独立 StatefulWidget）。
    final filtered = <_DemoCard>[
      if (index == 6)
        cards.last
      else if (index == 5)
        cards[5]
      else
        cards[index],
    ];
    final widgets = [
      for (final (title, widget) in filtered)
        _Card(
          title: title,
          child: widget,
        ),
    ];
    // R35.4：desktop 宽屏双栏 Wrap（卡片限宽）、phone 窄屏单栏 Column，
    // 窗口缩放无溢出。
    final isWide = layout.width >= 768 ||
        layout.breakpoint == AntBreakpoint.lg ||
        layout.breakpoint == AntBreakpoint.xl ||
        layout.breakpoint == AntBreakpoint.xxl;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: isWide
            ? Wrap(
                spacing: 16.w,
                runSpacing: 16.w,
                children: [
                  for (final card in widgets)
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 560.w),
                      child: card,
                    ),
                ],
              )
            : Column(
                children: [
                  for (final card in widgets)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.w),
                      child: card,
                    ),
                ],
              ),
      ),
    );
  }
}

/// 演示卡片容器。
class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.w),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorText,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(theme.borderRadiusSM),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// 受控 Controller 演示：goTo / 上一页 / 下一页 + onChange 日志。
class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  final _controller = AntCarouselController();
  int _current = 0;
  final List<int> _log = [];

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      children: [
        AntCarousel(
          height: 140.w,
          controller: _controller,
          onChange: (i) => setState(() {
            _current = i;
            _log.add(i);
          }),
          children: [
            for (var i = 0; i < 4; i++)
              Container(
                alignment: Alignment.center,
                color: theme.colorPrimary.withValues(alpha: 0.1 + 0.15 * i),
                child: Text(
                  '第 ${i + 1} 页',
                  style: TextStyle(fontSize: 20.sp, color: theme.colorText),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.w),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: [
            for (var i = 0; i < 4; i++)
              OutlinedButton(
                onPressed: () => _controller.goTo(i),
                child: Text('goTo(${i + 1})'),
              ),
            OutlinedButton(
              onPressed: () => _controller.goTo((_current + 3) % 4),
              child: const Text('上一页'),
            ),
            OutlinedButton(
              onPressed: () => _controller.goTo((_current + 1) % 4),
              child: const Text('下一页'),
            ),
          ],
        ),
        SizedBox(height: 8.w),
        Text(
          '当前页：第 ${_current + 1} 页　onChange 日志：$_log',
          style: TextStyle(fontSize: 12.sp, color: theme.colorTextSecondary),
        ),
      ],
    );
  }
}

/// 视差 / 页面变换演示：滑动时按页面偏移做缩放 + 透明度 + 水平位移。
///
/// 说明：antd React Carousel 本体不提供视差/变换能力（R30.1 评估结论），
/// 此处演示「自定义 item」路线：子项通过 NotificationListener 感知
/// 滚动偏移，按页面进度做 Transform（自绘实现，不引入三方依赖）。
class _ParallaxDemo extends StatefulWidget {
  const _ParallaxDemo();

  @override
  State<_ParallaxDemo> createState() => _ParallaxDemoState();
}

class _ParallaxDemoState extends State<_ParallaxDemo> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SizedBox(
      height: 180.w,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 4,
        itemBuilder: (context, i) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              // 页面进度 p ∈ (-1, 1)：0 为当前页居中。
              double p = 0;
              if (_pageController.hasClients &&
                  _pageController.position.haveDimensions &&
                  _pageController.page != null) {
                p = (_pageController.page! - i).clamp(-1.0, 1.0);
              }
              final t = 1 - p.abs(); // 越居中越接近 1
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translateByDouble(p * 40.w, 0.0, 0.0, 1.0)
                  ..scaleByDouble(0.85 + 0.15 * t, 0.85 + 0.15 * t, 1.0, 1.0)
                  ..rotateZ(p * 0.05),
                child: Opacity(
                  opacity: 0.5 + 0.5 * t,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorPrimary.withValues(alpha: 0.7),
                    Color(0xFF36CFC9).withValues(alpha: 0.6),
                    Color(0xFF722ED1).withValues(alpha: 0.5),
                  ],
                  transform: const GradientRotation(math.pi / 6),
                ),
                borderRadius: BorderRadius.circular(theme.borderRadiusLG),
              ),
              child: Text(
                '视差页面 ${i + 1}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorWhite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
