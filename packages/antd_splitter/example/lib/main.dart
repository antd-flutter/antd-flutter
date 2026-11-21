/// antd_splitter example — AntSplitter 演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - 画廊模式：侧栏分区 + 分区内容，覆盖 Splitter 全部关键形态
///   （水平 / 垂直 / 双向嵌套 / min·max 拖拽限制 / 折叠 / 受控 / 懒拖拽 / 双击重置）
/// - 分割线样式（粗细/颜色）为组件内置令牌（splitBarSize = 2），无对外样式参数
library;

import 'package:antd_splitter/antd_splitter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdSplitterGalleryApp());
}

/// 演示分区定义。
class _Section {
  const _Section(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

/// antd 分割面板画廊根组件。
class AntdSplitterGalleryApp extends StatefulWidget {
  const AntdSplitterGalleryApp({super.key});

  @override
  State<AntdSplitterGalleryApp> createState() => _AntdSplitterGalleryAppState();
}

class _AntdSplitterGalleryAppState extends State<AntdSplitterGalleryApp> {
  bool _isDark = false;

  static const List<_Section> _sections = [
    _Section('基本用法', _basicSection),
    _Section('垂直布局', _verticalSection),
    _Section('双向嵌套', _nestedSection),
    _Section('拖拽限制（min / max / resizable）', _constraintSection),
    _Section('折叠面板', _collapseSection),
    _Section('三条分割线 + 全部可折叠（4 面板）', _threeBarsCollapseSection),
    _Section('受控模式', _controlledSectionBuilder),
    _Section('懒拖拽 + 回调', _lazySectionBuilder),
    _Section('双击重置', _doubleTapSection),
  ];

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'Ant Design Splitter',
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

class _GalleryPage extends StatelessWidget {
  const _GalleryPage({
    required this.sections,
    required this.isDark,
    required this.onToggleDark,
  });

  final List<_Section> sections;
  final bool isDark;
  final VoidCallback onToggleDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ant Design Splitter'),
        actions: [
          IconButton(
            onPressed: onToggleDark,
            icon: Icon(isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                section.builder(context),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 面板内容占位。
Widget _panelContent(String label, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      border: Border.all(color: color.withValues(alpha: 0.3)),
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: Alignment.center,
    child: Text(label, style: TextStyle(color: color)),
  );
}

Widget _basicSection(BuildContext context) {
  return SizedBox(
    height: 200,
    child: AntSplitter(
      children: [
        AntSplitterPanel(child: _panelContent('面板 A', Colors.blue)),
        AntSplitterPanel(child: _panelContent('面板 B', Colors.green)),
      ],
    ),
  );
}

Widget _verticalSection(BuildContext context) {
  return SizedBox(
    height: 300,
    child: AntSplitter(
      layout: AntSplitterLayout.vertical,
      children: [
        AntSplitterPanel(child: _panelContent('上方面板', Colors.orange)),
        AntSplitterPanel(child: _panelContent('下方面板', Colors.purple)),
      ],
    ),
  );
}

/// 双向嵌套：外层水平分割，右面板内嵌垂直分割。
Widget _nestedSection(BuildContext context) {
  return SizedBox(
    height: 300,
    child: AntSplitter(
      children: [
        AntSplitterPanel(child: _panelContent('左侧面板', Colors.blue)),
        AntSplitterPanel(
          child: AntSplitter(
            layout: AntSplitterLayout.vertical,
            children: [
              AntSplitterPanel(child: _panelContent('右上面板', Colors.teal)),
              AntSplitterPanel(
                child: _panelContent('右下面板', Colors.deepOrange),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// 三条分割线 + 4 面板全部可折叠：验证多分割条下按钮定位与折叠恢复。
Widget _threeBarsCollapseSection(BuildContext context) {
  return SizedBox(
    height: 220,
    child: AntSplitter(
      onCollapse: (collapsed, sizes) {},
      children: [
        AntSplitterPanel(defaultSize: 150, collapsible: true, child: _panelContent('面板 1', Colors.blue)),
        AntSplitterPanel(defaultSize: 150, collapsible: true, child: _panelContent('面板 2', Colors.green)),
        AntSplitterPanel(defaultSize: 150, collapsible: true, child: _panelContent('面板 3', Colors.teal)),
        AntSplitterPanel(collapsible: true, child: _panelContent('面板 4', Colors.deepOrange)),
      ],
    ),
  );
}

Widget _constraintSection(BuildContext context) {
  return SizedBox(
    height: 200,
    child: AntSplitter(
      children: [
        AntSplitterPanel(
          defaultSize: 200,
          min: 120,
          max: 400,
          child: _panelContent('min 120 / max 400', Colors.blue),
        ),
        AntSplitterPanel(
          resizable: false,
          child: _panelContent('不可拖拽', Colors.red),
        ),
        AntSplitterPanel(child: _panelContent('自适应', Colors.green)),
      ],
    ),
  );
}

Widget _collapseSection(BuildContext context) {
  return SizedBox(
    height: 200,
    child: AntSplitter(
      onCollapse: (collapsed, sizes) {},
      children: [
        AntSplitterPanel(
          collapsible: true,
          child: _panelContent('可折叠 A', Colors.blue),
        ),
        AntSplitterPanel(
          collapsible: true,
          child: _panelContent('可折叠 B', Colors.green),
        ),
      ],
    ),
  );
}

Widget _controlledSectionBuilder(BuildContext context) => const _ControlledSection();

class _ControlledSection extends StatefulWidget {
  const _ControlledSection();

  @override
  State<_ControlledSection> createState() => _ControlledSectionState();
}

class _ControlledSectionState extends State<_ControlledSection> {
  double _sizeA = 300;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => setState(() => _sizeA = 200),
                child: const Text('A=200'),
              ),
              FilledButton(
                onPressed: () => setState(() => _sizeA = 400),
                child: const Text('A=400'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AntSplitter(
              children: [
                AntSplitterPanel(
                  size: _sizeA,
                  child: _panelContent('受控面板 A', Colors.blue),
                ),
                AntSplitterPanel(
                  child: _panelContent('自适应面板 B', Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _lazySectionBuilder(BuildContext context) => const _LazySection();

class _LazySection extends StatefulWidget {
  const _LazySection();

  @override
  State<_LazySection> createState() => _LazySectionState();
}

class _LazySectionState extends State<_LazySection> {
  String _log = '拖拽开始/结束/尺寸变化会显示在这里';

  void _setLog(String message) {
    if (mounted) setState(() => _log = message);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Column(
        children: [
          Text(_log, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          Expanded(
            child: AntSplitter(
              lazy: true,
              onResizeStart: (sizes) => _setLog('onResizeStart: $sizes'),
              onResizeEnd: (sizes) => _setLog('onResizeEnd: $sizes'),
              onResize: (sizes) => _setLog('onResize: $sizes'),
              children: [
                AntSplitterPanel(child: _panelContent('懒面板 A', Colors.blue)),
                AntSplitterPanel(child: _panelContent('懒面板 B', Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _doubleTapSection(BuildContext context) {
  return SizedBox(
    height: 200,
    child: AntSplitter(
      onDraggerDoubleClick: (index) {},
      children: [
        AntSplitterPanel(
          defaultSize: 200,
          child: _panelContent('面板 A（默认 200）', Colors.blue),
        ),
        AntSplitterPanel(
          defaultSize: 580,
          child: _panelContent('面板 B（默认 580）', Colors.green),
        ),
      ],
    ),
  );
}
