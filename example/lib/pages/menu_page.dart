library;

/// Menu 导航菜单演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _MenuData {
  const _MenuData({
    required this.key,
    this.label,
    this.icon,
    this.children = const [],
    this.disabled = false,
    this.type = AntMenuItemType.item,
  });

  final String key;
  final String? label;
  final Widget? icon;
  final List<_MenuData> children;
  final bool disabled;
  final AntMenuItemType type;
}

Widget _menu({
  Key? key,
  List<_MenuData> items = const [],
  AntMenuMode mode = AntMenuMode.inline,
  AntMenuTheme theme = AntMenuTheme.light,
  List<Object>? selectedKeys,
  List<Object> defaultSelectedKeys = const [],
  List<Object>? openKeys,
  List<Object> defaultOpenKeys = const [],
  ValueChanged<String>? onClick,
  ValueChanged<_MenuData>? onItemClick,
  ValueChanged<_MenuData>? onSelect,
  ValueChanged<_MenuData>? onDeselect,
  ValueChanged<List<Object>>? onSelectedKeysChange,
  ValueChanged<List<Object>>? onOpenChange,
  bool selectable = true,
  bool multiple = false,
  AntMenuTrigger triggerSubMenuAction = AntMenuTrigger.hover,
  bool inlineCollapsed = false,
  double inlineIndent = 24,
  Widget? expandIcon,
  Widget? overflowedIndicator,
  bool disabled = false,
  bool tooltip = true,
}) {
  return AntMenu<_MenuData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    childrenOf: (item) => item.children,
    labelBuilder: (context, item, index) => Text(item.label ?? ''),
    iconBuilder: (context, item) => item.icon,
    typeOf: (item) => item.type,
    disabledOf: (item) => item.disabled,
    collapsedLabelOf: (item) => item.label,
    mode: mode,
    theme: theme,
    selectedKeys: selectedKeys,
    defaultSelectedKeys: defaultSelectedKeys,
    openKeys: openKeys,
    defaultOpenKeys: defaultOpenKeys,
    onClick: onClick == null ? null : (item) => onClick(item.key),
    onItemClick: onItemClick,
    onSelect: onSelect,
    onDeselect: onDeselect,
    onSelectedKeysChange: onSelectedKeysChange,
    onOpenChange: onOpenChange,
    selectable: selectable,
    multiple: multiple,
    triggerSubMenuAction: triggerSubMenuAction,
    inlineCollapsed: inlineCollapsed,
    inlineIndent: inlineIndent,
    expandIcon: expandIcon,
    overflowedIndicator: overflowedIndicator,
    disabled: disabled,
    tooltip: tooltip,
  );
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认 inline 模式，垂直内嵌展示'),
          _BasicDemo(),
          _Section(title: '水平模式', description: 'mode=horizontal，顶部导航栏'),
          _HorizontalDemo(),
          _Section(title: '暗色主题', description: 'theme=dark'),
          _DarkDemo(),
          _Section(title: '垂直模式与浮层', description: 'mode=vertical，子菜单以浮层展开'),
          _VerticalDemo(),
          _Section(
            title: '多选与回调',
            description: 'multiple=true，onSelect / onDeselect 分别回调',
          ),
          _MultipleDemo(),
          _Section(title: '折叠模式', description: 'inlineCollapsed=true，仅显示图标'),
          _CollapsedDemo(),
          _Section(
            title: '分组与分割线',
            description: 'type=group 分组标题，type=divider 分割线',
          ),
          _GroupDividerDemo(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 基本用法
// ------------------------------------------------------------

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _menu(
        defaultSelectedKeys: const ['1'],
        items: const [
          _MenuData(key: '1', label: '导航一'),
          _MenuData(key: '2', label: '导航二'),
          _MenuData(
            key: 'sub1',
            label: '子菜单',
            children: [
              _MenuData(key: '3', label: '选项 3'),
              _MenuData(key: '4', label: '选项 4'),
            ],
          ),
          _MenuData(key: '5', label: '导航三', disabled: true),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 水平模式
// ------------------------------------------------------------

class _HorizontalDemo extends StatelessWidget {
  const _HorizontalDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _menu(
        mode: AntMenuMode.horizontal,
        defaultSelectedKeys: const ['mail'],
        items: const [
          _MenuData(
            key: 'mail',
            label: '邮件',
            icon: Icon(AntIcons.mailOutlined, size: 16),
          ),
          _MenuData(
            key: 'app',
            label: '应用',
            icon: Icon(AntIcons.appstoreOutlined, size: 16),
          ),
          _MenuData(
            key: 'sub1',
            label: '更多',
            children: [
              _MenuData(key: '1-1', label: '选项 1'),
              _MenuData(key: '1-2', label: '选项 2'),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 暗色主题
// ------------------------------------------------------------

class _DarkDemo extends StatelessWidget {
  const _DarkDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: _menu(
        theme: AntMenuTheme.dark,
        defaultSelectedKeys: const ['1'],
        items: const [
          _MenuData(
            key: '1',
            label: '导航一',
            icon: Icon(AntIcons.mailOutlined, size: 16),
          ),
          _MenuData(
            key: '2',
            label: '导航二',
            icon: Icon(AntIcons.appstoreOutlined, size: 16),
          ),
          _MenuData(
            key: 'sub1',
            label: '子菜单',
            icon: Icon(AntIcons.settingOutlined, size: 16),
            children: [
              _MenuData(key: '3', label: '选项 3'),
              _MenuData(key: '4', label: '选项 4'),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 折叠模式
// ------------------------------------------------------------

class _CollapsedDemo extends StatelessWidget {
  const _CollapsedDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _menu(
        inlineCollapsed: true,
        defaultSelectedKeys: const ['1'],
        items: const [
          _MenuData(
            key: '1',
            label: '导航一',
            icon: Icon(AntIcons.mailOutlined, size: 18),
          ),
          _MenuData(
            key: '2',
            label: '导航二',
            icon: Icon(AntIcons.calendarOutlined, size: 18),
          ),
          _MenuData(
            key: 'sub1',
            label: '子菜单',
            icon: Icon(AntIcons.settingOutlined, size: 18),
            children: [_MenuData(key: '3', label: '选项 3')],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 分组与分割线
// ------------------------------------------------------------

class _GroupDividerDemo extends StatelessWidget {
  const _GroupDividerDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _menu(
        defaultSelectedKeys: const ['1'],
        items: const [
          _MenuData(
            key: 'grp1',
            label: '分组一',
            type: AntMenuItemType.group,
            children: [
              _MenuData(key: '1', label: '选项 1'),
              _MenuData(key: '2', label: '选项 2'),
            ],
          ),
          _MenuData(key: 'd1', type: AntMenuItemType.divider),
          _MenuData(
            key: 'grp2',
            label: '分组二',
            type: AntMenuItemType.group,
            children: [
              _MenuData(key: '3', label: '选项 3'),
              _MenuData(key: '4', label: '选项 4'),
            ],
          ),
        ],
      ),
    );
  }
}
// ------------------------------------------------------------
// 垂直模式与浮层
// ------------------------------------------------------------

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _menu(
        mode: AntMenuMode.vertical,
        defaultSelectedKeys: const ['1-1'],
        items: const [
          _MenuData(key: '1', label: '导航一'),
          _MenuData(
            key: 'sub1',
            label: '子菜单',
            children: [
              _MenuData(key: '1-1', label: '选项 1-1'),
              _MenuData(key: '1-2', label: '选项 1-2'),
              _MenuData(
                key: 'nested',
                label: '二级子菜单',
                children: [_MenuData(key: '1-2-1', label: '选项 1-2-1')],
              ),
            ],
          ),
          _MenuData(key: '2', label: '导航二'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// 多选与回调
// ------------------------------------------------------------

class _MultipleDemo extends StatefulWidget {
  const _MultipleDemo();

  @override
  State<_MultipleDemo> createState() => _MultipleDemoState();
}

class _MultipleDemoState extends State<_MultipleDemo> {
  List<Object> _selected = const [];
  String _last = '暂无';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 220,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _menu(
            multiple: true,
            selectedKeys: _selected,
            onSelectedKeysChange: (keys) => setState(() => _selected = keys),
            onSelect: (item) =>
                setState(() => _last = 'onSelect: ${item.label}'),
            onDeselect: (item) =>
                setState(() => _last = 'onDeselect: ${item.label}'),
            items: const [
              _MenuData(
                key: 'a',
                label: '选项 A',
                icon: Icon(AntIcons.mailOutlined, size: 16),
              ),
              _MenuData(
                key: 'b',
                label: '选项 B',
                icon: Icon(AntIcons.appstoreOutlined, size: 16),
              ),
              _MenuData(
                key: 'c',
                label: '选项 C',
                icon: Icon(AntIcons.settingOutlined, size: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('已选: ${_selected.isEmpty ? '无' : _selected.join(', ')}'),
        Text(_last),
      ],
    );
  }
}
