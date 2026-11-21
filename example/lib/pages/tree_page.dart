library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 业务模型：地区。
class _Region {
  const _Region(this.code, this.name, {this.children = const [], this.disabled = false});

  final String code;
  final String name;
  final List<_Region> children;
  final bool disabled;
}

const _treeData = [
  _Region(
    'zj',
    '浙江',
    children: [
      _Region('hz', '杭州', children: [_Region('xh', '西湖区')]),
      _Region('nb', '宁波'),
    ],
  ),
  _Region(
    'js',
    '江苏',
    children: [_Region('nj', '南京'), _Region('sz', '苏州')],
  ),
];

const _lineTreeData = [
  _Region(
    'root',
    '根节点',
    children: [
      _Region(
        'c1',
        '子节点一',
        children: [
          _Region('c1-1', '叶子一'),
          _Region('c1-2', '禁用叶子', disabled: true),
        ],
      ),
      _Region('c2', '禁用子节点', disabled: true, children: [_Region('c2-1', '叶子二')]),
    ],
  ),
];

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  Set<Object> _expandedKeys = const {'zj'};
  Set<Object> _checkedKeys = const {};

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _tree({
    List<_Region> data = _treeData,
    Set<Object>? expandedKeys,
    Set<Object>? selectedKeys,
    Set<Object>? initialExpandedKeys,
    Set<Object>? initialSelectedKeys,
    bool checkable = false,
    bool checkStrictly = false,
    bool selectable = true,
    bool showLine = false,
    bool defaultExpandAll = false,
    ValueChanged<Set<Object>>? onExpand,
    ValueChanged<Set<Object>>? onSelect,
    void Function(Set<Object>, Set<Object>)? onCheck,
  }) {
    return AntTree<_Region>(
      dataSource: data,
      keyOf: (item) => item.code,
      titleBuilder: (context, item) => Text(item.name),
      childrenOf: (item) => item.children,
      disabledOf: (item) => item.disabled,
      expandedKeys: expandedKeys,
      defaultExpandedKeys: initialExpandedKeys,
      defaultExpandAll: defaultExpandAll,
      selectedKeys: selectedKeys,
      defaultSelectedKeys: initialSelectedKeys,
      checkable: checkable,
      checkStrictly: checkStrictly,
      selectable: selectable,
      showLine: showLine,
      onExpand: onExpand,
      onSelect: onSelect,
      onCheck: onCheck,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(t.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: _tree(onExpand: (_) => _toast(context, '展开状态变化')),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '默认展开',
            child: _tree(initialExpandedKeys: const {'zj'}),
          ),
          SizedBox(height: t.s(16)),
          _Section(title: '默认展开全部', child: _tree(defaultExpandAll: true)),
          SizedBox(height: t.s(16)),
          _Section(
            title: '受控展开',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tree(
                  expandedKeys: _expandedKeys,
                  onExpand: (keys) => setState(() => _expandedKeys = keys),
                ),
                SizedBox(height: t.s(8)),
                Wrap(
                  spacing: t.s(8),
                  children: [
                    AntButton(
                      onTap: () => setState(() => _expandedKeys = const {'zj'}),
                      child: const Text('展开浙江'),
                    ),
                    AntButton(
                      onTap: () => setState(() => _expandedKeys = const {'js'}),
                      child: const Text('展开江苏'),
                    ),
                    AntButton(
                      onTap: () => setState(() => _expandedKeys = const {}),
                      child: const Text('全部收起'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '可选中',
            child: _tree(
              initialExpandedKeys: const {'zj'},
              initialSelectedKeys: const {'hz'},
              onSelect: (keys) =>
                  _toast(context, '选中：${keys.isEmpty ? '无' : keys.join(', ')}'),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '可勾选（父子联动）',
            child: _tree(
              checkable: true,
              initialExpandedKeys: const {'zj', 'js'},
              onCheck: (checked, halfChecked) => setState(() {
                _checkedKeys = checked;
                _toast(
                  context,
                  '勾选：${checked.join(', ')}${halfChecked.isEmpty ? '' : '（半选：${halfChecked.join(', ')}）'}',
                );
              }),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '当前勾选',
            child: Text(
              _checkedKeys.isEmpty ? '未勾选任何节点' : _checkedKeys.join('、'),
              style: TextStyle(fontSize: t.fontSizeSM, color: t.colorText),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: 'checkStrictly 严格模式（父子不联动）',
            child: _tree(
              checkable: true,
              checkStrictly: true,
              initialExpandedKeys: const {'zj', 'js'},
              onCheck: (checked, _) => _toast(
                context,
                '勾选：${checked.isEmpty ? '无' : checked.join(', ')}',
              ),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '连接线与禁用',
            child: _tree(
              data: _lineTreeData,
              showLine: true,
              defaultExpandAll: true,
              selectable: false,
            ),
          ),
        ],
      ),
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
      padding: EdgeInsets.all(t.s(12)),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: t.fontSize,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: t.s(8)),
          child,
        ],
      ),
    );
  }
}
