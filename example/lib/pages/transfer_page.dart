import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 业务模型：可穿梭的条目/组件。
class _Comp {
  const _Comp(
    this.key,
    this.title, {
    this.description,
    this.children = const [],
    this.disabled = false,
  });

  final String key;
  final String title;
  final String? description;
  final List<_Comp> children;
  final bool disabled;
}

const _defaultData = <_Comp>[
  _Comp('a', '选项A'),
  _Comp('b', '选项B'),
  _Comp('c', '选项C'),
  _Comp('d', '选项D'),
  _Comp('e', '选项E'),
  _Comp('f', '选项F'),
];

const _disabledData = <_Comp>[
  _Comp('a', '选项A'),
  _Comp('b', '选项B（禁用）', disabled: true),
  _Comp('c', '选项C'),
  _Comp('d', '选项D（禁用）', disabled: true),
  _Comp('e', '选项E'),
];

const _treeData = <_Comp>[
  _Comp(
    'p1',
    '组件 1',
    children: [
      _Comp('p1-1', '按钮', description: '通用'),
      _Comp('p1-2', '图标', description: '通用'),
    ],
  ),
  _Comp(
    'p2',
    '组件 2',
    children: [
      _Comp('p2-1', '输入框'),
      _Comp('p2-2', '选择器'),
      _Comp('p2-3', '穿梭框（禁用）', disabled: true),
    ],
  ),
  _Comp('l1', '布局'),
];

AntTransfer<_Comp> _transfer({
  List<_Comp> data = _defaultData,
  List<Object>? targetKeys,
  List<Object> defaultTargetKeys = const [],
  bool showSearch = false,
  bool oneWay = false,
  bool disabled = false,
  bool defaultExpandAll = false,
  List<String> operations = const ['', ''],
  List<String> titles = const ['待选', '已选'],
  void Function(List<Object>, AntTransferDirection, List<Object>)? onChange,
}) {
  return AntTransfer<_Comp>(
    dataSource: data,
    keyOf: (item) => item.key,
    titleBuilder: (context, item) => Text(item.title),
    descriptionOf: (item) => item.description,
    childrenOf: (item) => item.children,
    disabledOf: (item) => item.disabled,
    searchTextOf: (item) => item.title,
    targetKeys: targetKeys,
    defaultTargetKeys: defaultTargetKeys,
    showSearch: showSearch,
    oneWay: oneWay,
    disabled: disabled,
    defaultExpandAll: defaultExpandAll,
    titles: titles,
    operations: operations,
    onChange: onChange,
  );
}

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

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
            child: _transfer(
              onChange: (keys, direction, moves) =>
                  debugPrint('onChange: $keys, $direction, $moves'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '默认目标项',
            child: _transfer(defaultTargetKeys: const ['b']),
          ),
          SizedBox(height: theme.s(16)),
          _Section(title: '带搜索', child: _transfer(showSearch: true)),
          SizedBox(height: theme.s(16)),
          _Section(title: '禁用选项', child: _transfer(data: _disabledData)),
          SizedBox(height: theme.s(16)),
          _Section(title: '单向模式', child: _transfer(oneWay: true)),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义操作文案',
            child: _transfer(operations: const ['右移', '左移']),
          ),
          SizedBox(height: theme.s(16)),
          _Section(title: '禁用状态', child: _transfer(disabled: true)),
          SizedBox(height: theme.s(16)),
          _Section(title: '受控用法', child: const _ControlledTransfer()),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '树形穿梭（TreeTransfer）',
            child: _transfer(
              data: _treeData,
              showSearch: true,
              defaultExpandAll: true,
              onChange: (keys, direction, moves) =>
                  debugPrint('tree onChange: $keys, $direction, $moves'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlledTransfer extends StatefulWidget {
  const _ControlledTransfer();

  @override
  State<_ControlledTransfer> createState() => _ControlledTransferState();
}

class _ControlledTransferState extends State<_ControlledTransfer> {
  List<Object> _targetKeys = const ['b'];

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      children: [
        _transfer(
          targetKeys: _targetKeys,
          onChange: (keys, direction, moves) =>
              setState(() => _targetKeys = keys),
        ),
        SizedBox(height: theme.s(8)),
        Text(
          '当前 targetKeys: $_targetKeys',
          style: TextStyle(
            fontSize: theme.s(14),
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
      width: double.infinity,
      padding: EdgeInsets.all(t.s(16)),
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
              fontSize: t.s(16),
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
