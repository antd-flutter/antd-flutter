import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

/// Ant Design Icons for Flutter 预览应用。
///
/// 按 Outlined / Filled / TwoTone 三种风格分 Tab 浏览，
/// 支持实时搜索与点击复制图标常量名。
void main() {
  runApp(const AntdIconsGalleryApp());
}

class AntdIconsGalleryApp extends StatelessWidget {
  const AntdIconsGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ant Design Icons',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1677FF),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF1677FF),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ant Design Icons'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () => _showAboutDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Outlined (${AntIcons.outlinedIcons.length})'),
            Tab(text: 'Filled (${AntIcons.filledIcons.length})'),
            Tab(text: 'TwoTone (${AntIconsTwotone.twotoneIcons.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SearchBar(
              hintText: 'Search icons by name...',
              leading: const Icon(Icons.search),
              trailing: [
                if (_query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() => _query = '');
                    },
                  ),
              ],
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _IconGrid(
                  items: AntIcons.outlinedIcons,
                  query: _query,
                ),
                _IconGrid(
                  items: AntIcons.filledIcons,
                  query: _query),
                _TwotoneIconGrid(query: _query),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ant Design Icons for Flutter'),
        content: const Text(
          'Ant Design 图标库的 Flutter 移植版。\n\n'
          '• Outlined + Filled：TTF 字体图标（${''}698 个）\n'
          '• TwoTone：SVG 双色图标（150 个），支持自定义主色\n\n'
          '点击任意图标可复制其常量名。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Outlined / Filled 风格的图标网格（TTF 字体图标）。
class _IconGrid extends StatelessWidget {
  _IconGrid({required this.items, required this.query});

  final List<(String name, IconData icon)> items;
  final String query;

  late final List<(String name, IconData icon)> _filtered = _filter();

  List<(String name, IconData icon)> _filter() {
    if (query.isEmpty) return items;
    final q = query.toLowerCase();
    return items.where((e) => e.$1.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_filtered.isEmpty) {
      return _EmptyResult(query: query);
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 110,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.82,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final (name, icon) = _filtered[index];
        return _IconTile(
          name: name,
          child: AntdIcon(icon, size: 28),
        );
      },
    );
  }
}

/// TwoTone 风格的图标网格（SVG 双色图标，支持自定义主色）。
class _TwotoneIconGrid extends StatefulWidget {
  const _TwotoneIconGrid({required this.query});

  final String query;

  @override
  State<_TwotoneIconGrid> createState() => _TwotoneIconGridState();
}

class _TwotoneIconGridState extends State<_TwotoneIconGrid> {
  static const _presetColors = <Color>[
    Color(0xFF1677FF),
    Color(0xFF52C41A),
    Color(0xFFFA8C16),
    Color(0xFFF5222D),
    Color(0xFF722ED1),
    Color(0xFF13C2C2),
    Color(0xFFEB2F96),
    Color(0xFFFAAD14),
  ];

  Color _twoToneColor = _presetColors.first;

  List<(String name, String path)> get _filtered {
    final items = AntIconsTwotone.twotoneIcons;
    if (widget.query.isEmpty) return items;
    final q = widget.query.toLowerCase();
    return items.where((e) => e.$1.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'twoToneColor',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final color in _presetColors)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _ColorDot(
                            color: color,
                            selected: color == _twoToneColor,
                            onTap: () =>
                                setState(() => _twoToneColor = color),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (filtered.isEmpty)
          Expanded(child: _EmptyResult(query: widget.query))
        else
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 110,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.82,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final (name, path) = filtered[index];
                return _IconTile(
                  name: name,
                  prefix: 'AntIconsTwotone',
                  child: AntdIcon(path, size: 28, twoToneColor: _twoToneColor),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// 单个图标瓦片：点击复制常量名。
class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.name,
    required this.child,
    this.prefix = 'AntIcons',
  });

  final String name;
  final String prefix;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        final dartRef = '$prefix.$name';
        Clipboard.setData(ClipboardData(text: dartRef));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Copied: $dartRef'),
              duration: const Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
              width: 280,
            ),
          );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// 预设色圆点。
class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

/// 搜索无结果占位。
class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 12),
          Text('No icons found for "$query"'),
        ],
      ),
    );
  }
}