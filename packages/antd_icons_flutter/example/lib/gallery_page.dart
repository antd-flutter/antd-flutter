/// 图标画廊主页面。
///
/// - 搜索框置顶：输入即过滤当前 tab 图标列表，各 tab 独立保留搜索状态
/// - tab 切换：AntSegmented（自举 antd-flutter 组件）
/// - 嵌入模式：隐藏顶部导航（标题栏 / 主题切换 / 关于）
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'l10n/app_localizations.dart';

/// 画廊页面。
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key, required this.embedded});

  /// 是否嵌入模式（隐藏顶部导航）。
  final bool embedded;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  static const int _tabCount = 3;

  final TextEditingController _searchController = TextEditingController();

  /// 每个 tab 独立的搜索关键字。
  final Map<int, String> _queries = {
    for (var i = 0; i < _tabCount; i++) i: '',
  };

  int _tabIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AppStrings get _strings => AppLocalizations.of(context);

  void _onTabChanged(String value) {
    final index = switch (value) {
      'filled' => 1,
      'twotone' => 2,
      _ => 0,
    };
    setState(() {
      // 退出前保存旧 tab 的关键字，进入新 tab 恢复其关键字。
      _tabIndex = index;
      _searchController.text = _queries[index] ?? '';
    });
  }

  void _onQueryChanged(String value) {
    setState(() => _queries[_tabIndex] = value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final strings = _strings;

    final content = Column(
      children: [
        // 搜索框置顶（嵌入模式同样保留，供宿主页面聚焦过滤）。
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: AntSearchBar(
            controller: _searchController,
            placeholder: strings.searchPlaceholder,
            showCancelButton: AntSearchBarCancelMode.never,
            onChange: _onQueryChanged,
            onSearch: _onQueryChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: AntSegmented<String>(
            value: switch (_tabIndex) {
              1 => 'filled',
              2 => 'twotone',
              _ => 'outlined',
            },
            options: const ['outlined', 'filled', 'twotone'],
            labelOf: (value) => switch (value) {
              'filled' => strings.tabFilled(AntIcons.filledIcons.length),
              'twotone' => strings.tabTwoTone(AntIconsTwotone.twotoneIcons.length),
              _ => strings.tabOutlined(AntIcons.outlinedIcons.length),
            },
            onChange: _onTabChanged,
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );

    if (widget.embedded) {
      // 嵌入模式：仅渲染搜索框 + 图标内容区，不渲染顶部导航。
      return SafeArea(child: content);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle),
        centerTitle: false,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: themeModeController,
            builder: (context, isDark, _) => IconButton(
              icon: Icon(isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined),
              tooltip: isDark ? strings.themeLight : strings.themeDark,
              onPressed: themeModeController.toggle,
            ),
          ),
          IconButton(
            icon: const Icon(AntIcons.infoCircleOutlined),
            tooltip: strings.aboutTooltip,
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildBody() {
    final query = _queries[_tabIndex] ?? '';
    return switch (_tabIndex) {
      0 => _IconGrid(
          items: AntIcons.outlinedIcons,
          query: query,
        ),
      1 => _IconGrid(
          items: AntIcons.filledIcons,
          query: query,
        ),
      _ => _TwotoneIconGrid(query: query),
    };
  }

  void _showAboutDialog(BuildContext context) {
    final strings = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.aboutTitle),
        content: Text(strings.aboutBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.close),
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

  Color? _twoToneColorOverride;

  /// 当前双色主色（默认跟随主题色，用户可点选预设覆盖）。
  Color get _twoToneColor => _twoToneColorOverride ?? AntTheme.of(context).colorPrimary;

  set _twoToneColor(Color color) => _twoToneColorOverride = color;

  List<(String name, String path)> get _filtered {
    final items = AntIconsTwotone.twotoneIcons;
    final query = widget.query;
    if (query.isEmpty) return items;
    final q = query.toLowerCase();
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
                AppLocalizations.of(context).twoToneColorLabel,
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
              content:
                  Text(AppLocalizations.of(context).copied(dartRef)),
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
            AntIcons.fileSearchOutlined,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context).emptyResult(query)),
        ],
      ),
    );
  }
}
