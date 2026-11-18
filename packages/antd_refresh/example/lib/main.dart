/// antd_refresh example — AntPullToRefresh / AntInfiniteScroll 演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - 画廊模式：侧栏分区 + 分区内容，覆盖 PullToRefresh 全部关键形态
/// - R34 国际化：语言切换控件演示 `AntPullToRefresh.locale` 文案变化
library;

import 'package:antd_refresh/antd_refresh.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdRefreshGalleryApp());
}

/// 演示分区定义。
class _Section {
  const _Section(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

/// antd 刷新画廊根组件。
class AntdRefreshGalleryApp extends StatefulWidget {
  const AntdRefreshGalleryApp({super.key});

  @override
  State<AntdRefreshGalleryApp> createState() => _AntdRefreshGalleryAppState();
}

class _AntdRefreshGalleryAppState extends State<AntdRefreshGalleryApp> {
  bool _isDark = false;

  static const List<_Section> _sections = [
    _Section('基础下拉刷新', _basicSection),
    _Section('桌面滚轮刷新', _wheelSection),
    _Section('国际化切换', _localeSection),
    _Section('自定义文案', _customTextSection),
    _Section('自定义 Header', _customHeaderSection),
    _Section('嵌入滚动视图', _scrollViewsSection),
    _Section('多级嵌套', _nestedSection),
    _Section('组合 InfiniteScroll', _comboSection),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? AntThemeData.dark() : AntThemeData.light();
    return AntTheme(
      data: theme,
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'Ant Design Refresh',
          debugShowCheckedModeBanner: false,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          theme: AntThemeData.light().toThemeData(),
          darkTheme: AntThemeData.dark().toThemeData(),
          home: _GalleryPage(
            sections: _sections,
            isDark: _isDark,
            onToggleDark: () => setState(() => _isDark = !_isDark),
          ),
        ),
      ),
    );
  }
}

/// 画廊页面：左侧分区导航 + 右侧内容。
class _GalleryPage extends StatefulWidget {
  const _GalleryPage({
    required this.sections,
    required this.isDark,
    required this.onToggleDark,
  });

  final List<_Section> sections;
  final bool isDark;
  final VoidCallback onToggleDark;

  @override
  State<_GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<_GalleryPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final section = widget.sections[_selectedIndex];
    return Scaffold(
      body: Row(
        children: [
          // 侧栏导航
          Container(
            width: 220,
            color: theme.colorBgLayout,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Refresh 下拉刷新',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorText,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: widget.isDark ? '切换亮色' : '切换暗色',
                        icon: Icon(
                          widget.isDark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: theme.colorText,
                        ),
                        onPressed: widget.onToggleDark,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    children: [
                      for (var i = 0; i < widget.sections.length; i++)
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            selected: i == _selectedIndex,
                            selectedTileColor: theme.colorPrimaryBg,
                            title: Text(
                              widget.sections[i].title,
                              style: TextStyle(
                                fontSize: 13,
                                color: i == _selectedIndex
                                    ? theme.colorPrimary
                                    : theme.colorText,
                              ),
                            ),
                            onTap: () => setState(() => _selectedIndex = i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: theme.colorBorderSecondary),
          // 分区内容
          Expanded(
            child: KeyedSubtree(
              key: ValueKey(_selectedIndex),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Text(
                      section.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: theme.colorText,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Builder(key: UniqueKey(), builder: section.builder),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 分区通用展示容器（标题 + 说明 + 示例区）。
class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 13, color: theme.colorTextSecondary),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 刷新演示容器：固定高度 + 说明文字
// ---------------------------------------------------------------------------

/// 模拟刷新耗时。
Future<void> _fakeRefresh() => Future<void>.delayed(const Duration(seconds: 2));

/// 固定高度的刷新演示框。
class _RefreshBox extends StatelessWidget {
  const _RefreshBox({required this.child, this.height = 360});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// 列表条目。
class _ItemTile extends StatelessWidget {
  const _ItemTile(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorBorderSecondary)),
      ),
      child: Row(
        children: [
          Expanded(child: Text('列表条目 ${index + 1}')),
          Icon(Icons.chevron_right, size: 18, color: theme.colorTextQuaternary),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 各分区实现
// ---------------------------------------------------------------------------

/// ① 基础下拉刷新。
Widget _basicSection(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DemoCard(
          title: '基础用法',
          description: '触摸端：手指按住列表顶部下拉，越过阈值（默认 50）松手即触发刷新。',
          child: _RefreshBox(
            child: AntPullToRefresh(
              onRefresh: _fakeRefresh,
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (_, i) => _ItemTile(i),
              ),
            ),
          ),
        ),
        _DemoCard(
          title: 'enableRefresh: false',
          description: '禁用下拉刷新，列表可正常滚动但不再响应下拉手势。',
          child: _RefreshBox(
            height: 240,
            child: AntPullToRefresh(
              enableRefresh: false,
              onRefresh: _fakeRefresh,
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (_, i) => _ItemTile(i),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// ② 桌面端滚轮刷新。
Widget _wheelSection(BuildContext context) {
  return _DemoCard(
    title: '桌面端滚轮刷新',
    description:
        '桌面/触控板重点：列表已滚到顶部后，滚轮继续向上滚（overscroll）即触发刷新，'
        '与移动端下拉为同一手势通路。Web 端可用鼠标滚轮在顶部继续上滚体验。',
    child: _RefreshBox(
      child: AntPullToRefresh(
        onRefresh: _fakeRefresh,
        child: ListView.builder(
          itemCount: 12,
          itemBuilder: (_, i) => _ItemTile(i),
        ),
      ),
    ),
  );
}

/// ③ 国际化切换（R34）。
class _LocaleDemo extends StatefulWidget {
  const _LocaleDemo();

  @override
  State<_LocaleDemo> createState() => _LocaleDemoState();
}

class _LocaleDemoState extends State<_LocaleDemo> {
  /// 可切换语言全集（与 AntRefreshStrings 内置语言对应）。
  static const List<(String, Locale)> _locales = [
    ('中文', Locale('zh')),
    ('English', Locale('en')),
    ('日本語', Locale('ja')),
    ('한국어', Locale('ko')),
    ('Français', Locale('fr')),
    ('Deutsch', Locale('de')),
    ('Español', Locale('es')),
    ('Русский', Locale('ru')),
    ('Português', Locale('pt')),
    ('Italiano', Locale('it')),
    ('العربية', Locale('ar')),
  ];

  Locale _locale = const Locale('zh');

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _DemoCard(
      title: '国际化切换（AntPullToRefresh.locale）',
      description:
          '切换语言后观察刷新各阶段文案变化（下拉中 / 释放刷新 / 加载中 / 刷新完成）。'
          'locale 仅在未显式传入 pullingText 等文案时生效；未命中语言回退中文。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (label, locale) in _locales)
                ChoiceChip(
                  label: Text(label),
                  selected: _locale == locale,
                  selectedColor: theme.colorPrimary,
                  backgroundColor: theme.colorFillSecondary,
                  labelStyle: TextStyle(
                    color: _locale == locale
                        ? Colors.white
                        : theme.colorText,
                  ),
                  onSelected: (_) => setState(() => _locale = locale),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _RefreshBox(
            height: 300,
            child: AntPullToRefresh(
              locale: _locale,
              onRefresh: _fakeRefresh,
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (_, i) => _ItemTile(i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _localeSection(BuildContext context) => const _LocaleDemo();

/// ④ 自定义文案。
Widget _customTextSection(BuildContext context) {
  return _DemoCard(
    title: '自定义各阶段文案',
    description:
        'pullingText / releasingText / finishingText / completeText 逐项覆写；'
        '也可用 strings: AntRefreshStrings.copyWith(...) 整体覆写。',
    child: _RefreshBox(
      child: AntPullToRefresh(
        pullingText: '继续拉，别停 ~',
        releasingText: '松手，开始刷新！',
        finishingText: '玩命加载中…',
        completeText: '搞定 ✓',
        onRefresh: _fakeRefresh,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, i) => _ItemTile(i),
        ),
      ),
    ),
  );
}

/// ⑤ 自定义 Header。
class _CustomHeaderDemo extends StatefulWidget {
  const _CustomHeaderDemo();

  @override
  State<_CustomHeaderDemo> createState() => _CustomHeaderDemoState();
}

class _CustomHeaderDemoState extends State<_CustomHeaderDemo> {
  AntPullToRefreshStatus _status = AntPullToRefreshStatus.idle;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _DemoCard(
      title: '自定义 Header',
      description:
          'header 传入任意 Widget 替换默认状态提示；配合 pullStatusChange 回调'
          '在自定义头部中渲染状态（idle/pulling/canRelease/refreshing/complete）。',
      child: _RefreshBox(
        child: AntPullToRefresh(
          pullStatusChange: (status) => setState(() => _status = status),
          header: Container(
            height: 40,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_status == AntPullToRefreshStatus.refreshing)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    _status == AntPullToRefreshStatus.canRelease
                        ? Icons.publish
                        : Icons.arrow_downward,
                    size: 18,
                    color: theme.colorPrimary,
                  ),
                const SizedBox(width: 8),
                Text(
                  switch (_status) {
                    AntPullToRefreshStatus.idle => '自定义头部：待命中',
                    AntPullToRefreshStatus.pulling => '自定义头部：下拉中',
                    AntPullToRefreshStatus.canRelease => '自定义头部：松手吧！',
                    AntPullToRefreshStatus.refreshing => '自定义头部：刷新中',
                    AntPullToRefreshStatus.complete => '自定义头部：完成',
                  },
                  style: TextStyle(
                    fontSize: 13,
                    color: _status == AntPullToRefreshStatus.idle
                        ? theme.colorTextSecondary
                        : theme.colorPrimary,
                  ),
                ),
              ],
            ),
          ),
          onRefresh: _fakeRefresh,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, i) => _ItemTile(i),
          ),
        ),
      ),
    );
  }
}

Widget _customHeaderSection(BuildContext context) => const _CustomHeaderDemo();

/// ⑥ 嵌入不同滚动视图。
class _ScrollViewsDemo extends StatefulWidget {
  const _ScrollViewsDemo();

  @override
  State<_ScrollViewsDemo> createState() => _ScrollViewsDemoState();
}

class _ScrollViewsDemoState extends State<_ScrollViewsDemo> {
  /// 当前演示的滚动视图类型。
  int _kind = 0;
  static const List<String> _kindNames = ['ListView', 'CustomScrollView', 'NestedScrollView'];

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: '嵌入不同滚动视图',
      description: 'PullToRefresh 包裹任意可滚动组件：ListView / CustomScrollView / NestedScrollView。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (var i = 0; i < _kindNames.length; i++)
                ChoiceChip(
                  label: Text(_kindNames[i]),
                  selected: _kind == i,
                  onSelected: (_) => setState(() => _kind = i),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _RefreshBox(
            child: AntPullToRefresh(
              key: ValueKey(_kind),
              onRefresh: _fakeRefresh,
              child: switch (_kind) {
                0 => ListView.builder(
                    itemCount: 12,
                    itemBuilder: (_, i) => _ItemTile(i),
                  ),
                1 => CustomScrollView(
                    slivers: [
                      const SliverAppBar(
                        title: Text('CustomScrollView'),
                        automaticallyImplyLeading: false,
                      ),
                      SliverList.builder(
                        itemCount: 12,
                        itemBuilder: (_, i) => _ItemTile(i),
                      ),
                    ],
                  ),
                _ => NestedScrollView(
                    headerSliverBuilder: (_, _) => [
                      const SliverAppBar(
                        title: Text('NestedScrollView'),
                        automaticallyImplyLeading: false,
                        pinned: true,
                      ),
                    ],
                    body: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (_, i) => _ItemTile(i),
                    ),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _scrollViewsSection(BuildContext context) => const _ScrollViewsDemo();

/// ⑦ 多级嵌套：PullToRefresh 内嵌 PullToRefresh。
Widget _nestedSection(BuildContext context) {
  return _DemoCard(
    title: '多级嵌套（内层优先）',
    description:
        'PullToRefresh 内嵌 PullToRefresh：手指在内层列表上时由内层消费下拉手势并触发内层刷新；'
        '滚到外层列表顶部再下拉触发外层刷新。',
    child: _RefreshBox(
      height: 420,
      child: AntPullToRefresh(
        onRefresh: _fakeRefresh,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              height: 260,
              clipBehavior: Clip.antiAlias,
              child: AntPullToRefresh(
                onRefresh: _fakeRefresh,
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (_, i) => _ItemTile(i),
                ),
              ),
            ),
            for (var i = 8; i < 14; i++) _ItemTile(i),
          ],
        ),
      ),
    ),
  );
}

/// ⑧ 组合使用：下拉刷新 + 上拉加载。
class _ComboDemo extends StatefulWidget {
  const _ComboDemo();

  @override
  State<_ComboDemo> createState() => _ComboDemoState();
}

class _ComboDemoState extends State<_ComboDemo> {
  int _pageStart = 0;

  Future<void> _refresh() async {
    await _fakeRefresh();
    setState(() => _pageStart = 0);
  }

  Future<bool> _loadMore() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    // 第 4 页之后没有更多数据。
    if (_pageStart >= 30) {
      return false;
    }
    setState(() => _pageStart += 10);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: 'PullToRefresh + AntInfiniteScroll',
      description:
          '下拉刷新重置数据、上拉自动加载下一页（第 4 页后提示「没有更多了」）。'
          'AntInfiniteScroll 与 PullToRefresh 同包（antd_refresh）直接使用。',
      child: _RefreshBox(
        height: 460,
        child: AntPullToRefresh(
          onRefresh: _refresh,
          child: AntInfiniteScroll(
            loadMore: _loadMore,
            child: ListView(
              children: [
                for (var i = 0; i < _pageStart + 10; i++) _ItemTile(i),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _comboSection(BuildContext context) => const _ComboDemo();
