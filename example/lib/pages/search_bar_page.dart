import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SearchBarPage extends StatelessWidget {
  const SearchBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntSearchBar(
              placeholder: '请输入搜索内容',
              onChange: (v) => debugPrint('onChange: $v'),
              onSearch: (v) => debugPrint('onSearch: $v'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '带取消按钮（聚焦时显示）',
            child: AntSearchBar(
              placeholder: '搜索',
              showCancelButton: AntSearchBarCancelMode.focus,
              onCancel: () => debugPrint('onCancel'),
              onSearch: (v) => debugPrint('onSearch: $v'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '始终显示取消按钮',
            child: AntSearchBar(
              placeholder: '搜索',
              showCancelButton: AntSearchBarCancelMode.always,
              cancelText: '取消',
              onCancel: () => debugPrint('onCancel'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义取消文本',
            child: AntSearchBar(
              placeholder: '搜索',
              showCancelButton: AntSearchBarCancelMode.always,
              cancelText: '关闭',
              onCancel: () => debugPrint('onCancel'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '仅聚焦时显示清除',
            child: AntSearchBar(
              placeholder: '搜索',
              defaultValue: '预填内容',
              onlyShowClearWhenFocus: true,
              onClear: () => debugPrint('onClear'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '禁止清除',
            child: const AntSearchBar(
              placeholder: '搜索',
              defaultValue: '不可清除',
              clearable: false,
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '最大长度限制',
            child: AntSearchBar(
              placeholder: '最多 5 个字',
              maxLength: 5,
              onChange: (v) => debugPrint('onChange: $v'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义搜索图标',
            child: AntSearchBar(
              placeholder: '搜索',
              searchIcon: Icon(AntIcons.searchOutlined, size: theme.s(18)),
              onSearch: (v) => debugPrint('onSearch: $v'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(title: '受控模式', child: const _ControlledSearchBar()),
        ],
      ),
    );
  }
}

class _ControlledSearchBar extends StatefulWidget {
  const _ControlledSearchBar();

  @override
  State<_ControlledSearchBar> createState() => _ControlledSearchBarState();
}

class _ControlledSearchBarState extends State<_ControlledSearchBar> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntSearchBar(
          value: _value,
          placeholder: '受控搜索',
          onChange: (v) => setState(() => _value = v),
          onSearch: (v) => debugPrint('onSearch: $v'),
        ),
        SizedBox(height: theme.s(8)),
        Text(
          '当前值: $_value',
          style: TextStyle(
            fontSize: theme.s(12),
            color: AntTheme.of(context).colorTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(t.s(12)),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: t.s(14),
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: t.s(12)),
          child,
        ],
      ),
    );
  }
}
