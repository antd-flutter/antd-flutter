/// antd_swipe_action example — AntSwipeAction 演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - 画廊模式：侧栏分区 + 分区内容，覆盖 SwipeAction 全部关键形态
/// - 无内置默认文案（R34 暂不涉及）：动作按钮文案由使用方传入
library;

import 'package:antd_swipe_action/antd_swipe_action.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdSwipeActionGalleryApp());
}

/// 演示分区定义。
class _Section {
  const _Section(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

/// antd 滑动操作画廊根组件。
class AntdSwipeActionGalleryApp extends StatefulWidget {
  const AntdSwipeActionGalleryApp({super.key});

  @override
  State<AntdSwipeActionGalleryApp> createState() =>
      _AntdSwipeActionGalleryAppState();
}

class _AntdSwipeActionGalleryAppState extends State<AntdSwipeActionGalleryApp> {
  bool _isDark = false;

  static const List<_Section> _sections = [
    _Section('左右滑基础', _basicSection),
    _Section('fling 快甩', _flingSection),
    _Section('rubber-band 弹性', _rubberBandSection),
    _Section('danger 危险操作', _dangerSection),
    _Section('disabled 禁用', _disabledSection),
    _Section('closeOnAction', _closeOnActionSection),
    _Section('多按钮', _multiButtonSection),
    _Section('ListView 手势竞争', _listSection),
    _Section('onOpened / onClosed', _callbackSection),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? AntThemeData.dark() : AntThemeData.light();
    return AntTheme(
      data: theme,
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'Ant Design SwipeAction',
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
                          'SwipeAction 滑动操作',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: theme.colorText,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: widget.isDark ? '切换亮色' : '切换暗色',
                        icon: Icon(
                          widget.isDark
                              ? AntIcons.sunOutlined
                              : AntIcons.moonOutlined,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: theme.colorText,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Builder(key: UniqueKey(), builder: section.builder),
                  ],
                ),
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

/// 滑动操作行容器（统一卡片外观）。
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.title, this.subtitle = ''});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      color: theme.colorBgContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15, color: theme.colorText)),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: theme.colorTextSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 各分区实现
// ---------------------------------------------------------------------------

/// ① 左右滑基础。
Widget _basicSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: '左滑 / 右滑基础',
    description:
        '左滑（rightActions）露出右侧按钮、右滑（leftActions）露出左侧按钮；'
        '松手超过按钮总宽一半自动展开，否则回弹。',
    child: Column(
      children: [
        AntSwipeAction(
          rightActions: [
            AntSwipeActionItem(
              text: '删除',
              color: theme.colorError,
              onPressed: () {},
            ),
          ],
          child: const _ActionRow(title: '左滑试试', subtitle: 'left swipe →'),
        ),
        const SizedBox(height: 12),
        AntSwipeAction(
          leftActions: [
            AntSwipeActionItem(
              text: '置顶',
              color: theme.colorPrimary,
              onPressed: () {},
            ),
          ],
          child: const _ActionRow(title: '右滑试试', subtitle: '← right swipe'),
        ),
        const SizedBox(height: 12),
        AntSwipeAction(
          rightActions: [
            AntSwipeActionItem(
              text: '编辑',
              color: theme.colorPrimary,
              onPressed: () {},
            ),
          ],
          leftActions: [
            AntSwipeActionItem(
              text: '标记',
              color: theme.colorWarning,
              onPressed: () {},
            ),
          ],
          child: const _ActionRow(title: '双向都可滑', subtitle: '← 左滑有编辑 / 右滑有标记 →'),
        ),
      ],
    ),
  );
}

/// ② fling 快甩。
Widget _flingSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: 'fling 快甩判定',
    description:
        '松手速度超过 500px/s 即按甩动方向直接开/关，无需拖过半程。'
        '轻轻快甩一下体验展开；展开态再快甩关闭。',
    child: AntSwipeAction(
      rightActions: [
        AntSwipeActionItem(
          text: '快甩展开',
          color: theme.colorPrimary,
          onPressed: () {},
        ),
      ],
      child: const _ActionRow(title: '快速甩动这一行', subtitle: 'fling：快甩即开 / 再快甩即关'),
    ),
  );
}

/// ③ rubber-band 全滑出弹性。
Widget _rubberBandSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: 'rubber-band 弹性过拉',
    description:
        '拖过按钮总宽后进入弹性阻尼：每 1px 手指位移仅拉动 1/9px，最多过拉 100px；'
        '松手回弹吸附。继续拖到底体验橡皮筋手感。',
    child: AntSwipeAction(
      rightActions: [
        AntSwipeActionItem(
          text: '继续拉',
          color: theme.colorPrimary,
          onPressed: () {},
        ),
      ],
      child: const _ActionRow(title: '拖过按钮总宽继续拉', subtitle: 'rubber-band：1/9 阻尼 + 100px 过拉上限'),
    ),
  );
}

/// ④ danger 红色危险操作。
Widget _dangerSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: 'danger 危险操作',
    description: '危险动作用 AntThemeData.colorError 红色背景，对齐 antd-mobile 的 danger 语义。',
    child: AntSwipeAction(
      rightActions: [
        AntSwipeActionItem(
          text: '更多',
          color: theme.colorFillTertiary,
          onPressed: () {},
        ),
        AntSwipeActionItem(
          text: '删除',
          color: theme.colorError,
          onPressed: () {},
        ),
      ],
      child: const _ActionRow(title: '包含红色删除的行', subtitle: '左滑查看 danger 按钮'),
    ),
  );
}

/// ⑤ disabled 禁用。
Widget _disabledSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: 'disabled 禁用操作',
    description: 'AntSwipeActionItem.disabled: true 的按钮置灰且点击不触发回调（拖拽展开不受影响）。',
    child: AntSwipeAction(
      rightActions: [
        AntSwipeActionItem(
          text: '置灰不可点',
          color: theme.colorFillTertiary,
          disabled: true,
          onPressed: () {},
        ),
        AntSwipeActionItem(
          text: '正常按钮',
          color: theme.colorPrimary,
          onPressed: () {},
        ),
      ],
      child: const _ActionRow(title: '含禁用按钮的行', subtitle: '左滑对比 disabled 与正常按钮'),
    ),
  );
}

/// ⑥ closeOnAction。
Widget _closeOnActionSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: 'closeOnAction 收起策略',
    description:
        'closeOnAction: true（默认）点击操作后自动收起；false 时保持展开，适合连续操作场景。',
    child: Column(
      children: [
        AntSwipeAction(
          closeOnAction: true,
          rightActions: [
            AntSwipeActionItem(
              text: '点击后收起',
              color: theme.colorPrimary,
              onPressed: () {},
            ),
          ],
          child: const _ActionRow(title: 'closeOnAction: true（默认）'),
        ),
        const SizedBox(height: 12),
        AntSwipeAction(
          closeOnAction: false,
          rightActions: [
            AntSwipeActionItem(
              text: '点击后保持',
              color: theme.colorSuccess,
              onPressed: () {},
            ),
          ],
          child: const _ActionRow(title: 'closeOnAction: false'),
        ),
      ],
    ),
  );
}

/// ⑦ 多按钮。
Widget _multiButtonSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: '多按钮',
    description: '按钮逐个横向排布，总宽超出可视区时由 rubber-band 弹性兜底。',
    child: AntSwipeAction(
      rightActions: [
        AntSwipeActionItem(
          text: '置顶',
          color: theme.colorPrimary,
          onPressed: () {},
        ),
        AntSwipeActionItem(
          text: '静音',
          color: theme.colorWarning,
          onPressed: () {},
        ),
        AntSwipeActionItem(
          text: '更多',
          color: theme.colorFillTertiary,
          onPressed: () {},
        ),
        AntSwipeActionItem(
          text: '删除',
          color: theme.colorError,
          onPressed: () {},
        ),
      ],
      leftActions: [
        AntSwipeActionItem(
          text: '标记',
          color: theme.colorSuccess,
          onPressed: () {},
        ),
        AntSwipeActionItem(
          text: '归档',
          color: theme.colorFillTertiary,
          onPressed: () {},
        ),
      ],
      child: const _ActionRow(title: '右 4 个 / 左 2 个按钮', subtitle: '左滑 4 按钮、右滑 2 按钮'),
    ),
  );
}

/// ⑧ ListView 手势竞争。
Widget _listSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: 'ListView 手势竞争',
    description:
        '方向相关手势识别：横向拖拽由 SwipeAction 消费，纵向滚动由 ListView 消费，互不冲突。'
        '在下方列表中左右滑行内容、同时上下滚动整个列表验证。',
    child: Container(
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        itemCount: 16,
        itemBuilder: (_, i) => AntSwipeAction(
          rightActions: [
            AntSwipeActionItem(
              text: '删除',
              color: theme.colorError,
              onPressed: () {},
            ),
          ],
          leftActions: [
            AntSwipeActionItem(
              text: '标记',
              color: theme.colorPrimary,
              onPressed: () {},
            ),
          ],
          child: _ActionRow(title: '列表条目 ${i + 1}', subtitle: '可左右滑，也可上下滚'),
        ),
      ),
    ),
  );
}

/// ⑨ onOpened / onClosed 回调。
class _CallbackDemo extends StatefulWidget {
  const _CallbackDemo();

  @override
  State<_CallbackDemo> createState() => _CallbackDemoState();
}

class _CallbackDemoState extends State<_CallbackDemo> {
  String _lastEvent = '尚未触发';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _DemoCard(
      title: 'onOpened / onClosed 回调',
      description: '展开/收起动画结束时各触发一次，可用于联动关闭其他已展开行等场景。',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntSwipeAction(
            onOpened: (direction) =>
                setState(() => _lastEvent = 'onOpened（$direction，已展开）'),
            onClosed: () => setState(() => _lastEvent = 'onClosed（已收起）'),
            rightActions: [
              AntSwipeActionItem(
                text: '操作',
                color: theme.colorPrimary,
                onPressed: () {},
              ),
            ],
            child: _ActionRow(title: '展开/收起观察下方事件', subtitle: '最近事件：$_lastEvent'),
          ),
          const SizedBox(height: 12),
          Text(
            '最近事件：$_lastEvent',
            style: TextStyle(fontSize: 13, color: theme.colorPrimary),
          ),
        ],
      ),
    );
  }
}

Widget _callbackSection(BuildContext context) => const _CallbackDemo();
