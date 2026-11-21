/// antd_image_viewer example — AntImageViewer 演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - 画廊模式：侧栏分区 + 分区内容，覆盖 ImageViewer 全部关键形态
///   （单图预览缩放/平移/双击缩放、多图切换（PreviewGroup 语义）、
///   受控开关、自定义初始页、自定义缩放上限、关闭交互）
library;

import 'package:antd_image_viewer/antd_image_viewer.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdImageViewerGalleryApp());
}

/// 演示图片地址。
const List<String> kDemoImages = [
  'https://picsum.photos/id/1015/600/400',
  'https://picsum.photos/id/1016/600/400',
  'https://picsum.photos/id/1020/600/400',
];

/// 演示分区定义。
class _Section {
  const _Section(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

/// antd 图片查看器画廊根组件。
class AntdImageViewerGalleryApp extends StatefulWidget {
  const AntdImageViewerGalleryApp({super.key});

  @override
  State<AntdImageViewerGalleryApp> createState() =>
      _AntdImageViewerGalleryAppState();
}

class _AntdImageViewerGalleryAppState extends State<AntdImageViewerGalleryApp> {
  bool _isDark = false;

  static const List<_Section> _sections = [
    _Section('单图预览（缩放 / 平移 / 双击缩放）', _singleSection),
    _Section('多图切换（PreviewGroup 语义）', _multiSection),
    _Section('受控开关（onClose / afterClose）', _controlledSection),
    _Section('自定义初始页', _defaultIndexSection),
    _Section('自定义缩放上限 / 关闭双击缩放', _customZoomSection),
    _Section('组合入口（卡片点击预览）', _comboSection),
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_splitter / antd_qrcode example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: MaterialApp(
          title: 'AntdImageViewer Demo',
          debugShowCheckedModeBanner: false,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          theme: AntThemeData.light().toThemeData(),
          darkTheme: AntThemeData.dark().toThemeData(),
          home: DefaultTabController(
            length: _sections.length,
            child: Scaffold(
              backgroundColor: AntTheme.of(context).colorBgLayout,
              appBar: AppBar(
                title: const Text('ImageViewer 图片查看器'),
                actions: [
                  IconButton(
                    onPressed: () => setState(() => _isDark = !_isDark),
                    icon: Icon(_isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    for (final s in _sections) Tab(text: s.title),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  for (final s in _sections) s.builder(context),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

/// 区块卡片容器。
Widget _sectionCard(BuildContext context, String title, Widget child) {
  final theme = AntTheme.of(context);
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(theme.s(16)),
    margin: EdgeInsets.only(bottom: theme.s(16)),
    decoration: BoxDecoration(
      color: theme.colorBgContainer,
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      border: Border.all(color: theme.colorSplit),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: theme.s(15))),
        SizedBox(height: theme.s(12)),
        child,
      ],
    ),
  );
}

Widget _page(BuildContext context, List<Widget> children) {
  final theme = AntTheme.of(context);
  return SingleChildScrollView(
    padding: EdgeInsets.all(theme.s(16)),
    child: Column(children: children),
  );
}

// ── 单图预览 ─────────────────────────────────────────────
class _SingleDemo extends StatefulWidget {
  const _SingleDemo();

  @override
  State<_SingleDemo> createState() => _SingleDemoState();
}

class _SingleDemoState extends State<_SingleDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () => setState(() => _open = true),
          child: const Text('预览单图'),
        ),
        AntImageViewer(
          images: [kDemoImages[0]],
          open: _open,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

Widget _singleSection(BuildContext context) => _page(context, [
      _sectionCard(
        context,
        '单图预览：双指缩放 / 拖拽平移 / 双击缩放 / 轻点关闭',
        const _SingleDemo(),
      ),
    ]);

// ── 多图切换（PreviewGroup 语义） ────────────────────────
class _MultiDemo extends StatefulWidget {
  const _MultiDemo();

  @override
  State<_MultiDemo> createState() => _MultiDemoState();
}

class _MultiDemoState extends State<_MultiDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      children: [
        Wrap(
          spacing: theme.s(8),
          children: [
            for (final src in kDemoImages)
              GestureDetector(
                onTap: () => setState(() => _open = true),
                child: Container(
                  width: theme.s(96),
                  height: theme.s(64),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.s(8)),
                    color: AntTheme.of(context).colorFillSecondary,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(src, fit: BoxFit.cover),
                ),
              ),
          ],
        ),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

Widget _multiSection(BuildContext context) => _page(context, [
      _sectionCard(
        context,
        '多图切换：点击缩略图打开，PageView 左右切换 + 页码指示',
        const _MultiDemo(),
      ),
    ]);

// ── 受控开关 ─────────────────────────────────────────────
class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  bool _open = false;
  String _log = '（暂无回调）';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: theme.s(8),
          runSpacing: theme.s(8),
          children: [
            FilledButton.tonal(
              onPressed: () => setState(() => _open = !_open),
              child: Text(_open ? '关闭' : '打开'),
            ),
          ],
        ),
        SizedBox(height: theme.s(8)),
        Text('回调日志：$_log', style: TextStyle(fontSize: theme.s(13))),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          onClose: () => setState(() {
            _open = false;
            _log = 'onClose';
          }),
          afterClose: () => setState(() => _log = 'onClose → afterClose'),
        ),
      ],
    );
  }
}

Widget _controlledSection(BuildContext context) => _page(context, [
      _sectionCard(
        context,
        '受控开关：open 由外部控制，onClose / afterClose 时序演示',
        const _ControlledDemo(),
      ),
    ]);

// ── 自定义初始页 ─────────────────────────────────────────
class _DefaultIndexDemo extends StatefulWidget {
  const _DefaultIndexDemo();

  @override
  State<_DefaultIndexDemo> createState() => _DefaultIndexDemoState();
}

class _DefaultIndexDemoState extends State<_DefaultIndexDemo> {
  int _index = 1;
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('初始页下标：$_index', style: TextStyle(fontSize: theme.s(14))),
            SizedBox(width: theme.s(12)),
            FilledButton(
              onPressed: () => setState(() => _open = true),
              child: const Text('预览'),
            ),
          ],
        ),
        SizedBox(height: theme.s(8)),
        Slider(
          value: _index.toDouble(),
          min: 0,
          max: (kDemoImages.length - 1).toDouble(),
          divisions: kDemoImages.length - 1,
          label: '$_index',
          onChanged: (v) => setState(() => _index = v.round()),
        ),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          defaultIndex: _index,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

Widget _defaultIndexSection(BuildContext context) => _page(context, [
      _sectionCard(
        context,
        '自定义初始页：defaultIndex 指定打开时展示的图片',
        const _DefaultIndexDemo(),
      ),
    ]);

// ── 自定义缩放上限 / 关闭双击缩放 ────────────────────────
class _CustomZoomDemo extends StatefulWidget {
  const _CustomZoomDemo();

  @override
  State<_CustomZoomDemo> createState() => _CustomZoomDemoState();
}

class _CustomZoomDemoState extends State<_CustomZoomDemo> {
  bool _open = false;
  double _maxZoom = 5;
  bool _doubleTap = true;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FilledButton(
              onPressed: () => setState(() => _open = true),
              child: const Text('预览'),
            ),
            SizedBox(width: theme.s(16)),
            Text('maxZoomRatio: ${_maxZoom.toStringAsFixed(0)}',
                style: TextStyle(fontSize: theme.s(14))),
          ],
        ),
        Slider(
          value: _maxZoom,
          min: 2,
          max: 8,
          divisions: 6,
          label: _maxZoom.toStringAsFixed(0),
          onChanged: (v) => setState(() => _maxZoom = v),
        ),
        Row(
          children: [
            Switch(
              value: _doubleTap,
              onChanged: (v) => setState(() => _doubleTap = v),
            ),
            SizedBox(width: theme.s(8)),
            const Text('开启双击缩放'),
          ],
        ),
        AntImageViewer(
          images: [kDemoImages[2]],
          open: _open,
          maxZoomRatio: _maxZoom,
          enableCompositeZoom: _doubleTap,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

Widget _customZoomSection(BuildContext context) => _page(context, [
      _sectionCard(
        context,
        '自定义缩放：maxZoomRatio 上限 + enableCompositeZoom 双击开关',
        const _CustomZoomDemo(),
      ),
    ]);

// ── 组合入口 ─────────────────────────────────────────────
class _ComboDemo extends StatefulWidget {
  const _ComboDemo();

  @override
  State<_ComboDemo> createState() => _ComboDemoState();
}

class _ComboDemoState extends State<_ComboDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _open = true),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(theme.s(16)),
            decoration: BoxDecoration(
              color: theme.colorFillQuaternary,
              borderRadius: BorderRadius.circular(theme.borderRadiusLG),
            ),
            child: Row(
              children: [
                const Icon(AntIcons.pictureOutlined),
                SizedBox(width: theme.s(12)),
                Expanded(
                  child: Text(
                    '带图卡片（点击整卡预览大图）',
                    style: TextStyle(fontSize: theme.s(14)),
                  ),
                ),
                const Icon(AntIcons.rightOutlined),
              ],
            ),
          ),
        ),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

Widget _comboSection(BuildContext context) => _page(context, [
      _sectionCard(
        context,
        '与其他组件组合：卡片点击入口打开全屏预览',
        const _ComboDemo(),
      ),
    ]);
