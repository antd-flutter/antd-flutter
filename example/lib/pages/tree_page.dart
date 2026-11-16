library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

const _treeData = [
  AntTreeNode(
    key: 'zj',
    title: '浙江',
    children: [
      AntTreeNode(
        key: 'hz',
        title: '杭州',
        children: [AntTreeNode(key: 'xh', title: '西湖区')],
      ),
      AntTreeNode(key: 'nb', title: '宁波'),
    ],
  ),
  AntTreeNode(
    key: 'js',
    title: '江苏',
    children: [
      AntTreeNode(key: 'nj', title: '南京'),
      AntTreeNode(key: 'sz', title: '苏州'),
    ],
  ),
];

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  List<String> _expandedKeys = const ['zj'];
  List<String> _checkedKeys = const [];

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntTree(
              treeData: _treeData,
              onExpand: (_) => _toast(context, '展开状态变化'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '默认展开',
            child: AntTree(
              treeData: _treeData,
              defaultExpandedKeys: ['zj'],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '默认展开全部',
            child: AntTree(treeData: _treeData, defaultExpandAll: true),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '受控展开',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntTree(
                  treeData: _treeData,
                  expandedKeys: _expandedKeys,
                  onExpand: (keys) =>
                      setState(() => _expandedKeys = keys),
                ),
                SizedBox(height: 8.w),
                Wrap(
                  spacing: 8.w,
                  children: [
                    AntButton(
                      onTap: () => setState(() => _expandedKeys = const ['zj']),
                      child: const Text('展开浙江'),
                    ),
                    AntButton(
                      onTap: () => setState(() => _expandedKeys = const ['js']),
                      child: const Text('展开江苏'),
                    ),
                    AntButton(
                      onTap: () => setState(() => _expandedKeys = const []),
                      child: const Text('全部收起'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '可选中',
            child: AntTree(
              treeData: _treeData,
              defaultExpandedKeys: const ['zj'],
              defaultSelectedKeys: const ['hz'],
              onSelect: (keys) =>
                  _toast(context, '选中：${keys.isEmpty ? '无' : keys.join(', ')}'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '可勾选（父子联动）',
            child: AntTree(
              treeData: _treeData,
              checkable: true,
              defaultExpandedKeys: const ['zj', 'js'],
              onCheck: (checked, halfChecked) => setState(() {
                _checkedKeys = checked;
                _toast(context,
                    '勾选：${checked.join(', ')}${halfChecked.isEmpty ? '' : '（半选：${halfChecked.join(', ')}）'}');
              }),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '当前勾选',
            child: Text(
              _checkedKeys.isEmpty ? '未勾选任何节点' : _checkedKeys.join('、'),
              style: TextStyle(fontSize: t.fontSizeSM.sp, color: t.colorText),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'checkStrictly 严格模式（父子不联动）',
            child: AntTree(
              treeData: _treeData,
              checkable: true,
              checkStrictly: true,
              defaultExpandedKeys: const ['zj', 'js'],
              onCheck: (checked, _) =>
                  _toast(context, '勾选：${checked.isEmpty ? '无' : checked.join(', ')}'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '连接线与禁用',
            child: AntTree(
              treeData: [
                AntTreeNode(
                  key: 'root',
                  title: '根节点',
                  children: [
                    AntTreeNode(
                      key: 'c1',
                      title: '子节点一',
                      children: [
                        AntTreeNode(key: 'c1-1', title: '叶子一'),
                        AntTreeNode(
                          key: 'c1-2',
                          title: '禁用叶子',
                          disabled: true,
                        ),
                      ],
                    ),
                    AntTreeNode(
                      key: 'c2',
                      title: '禁用子节点',
                      disabled: true,
                      children: [AntTreeNode(key: 'c2-1', title: '叶子二')],
                    ),
                  ],
                ),
              ],
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
  const _Section({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
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
              fontSize: t.fontSize.sp,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: 8.w),
          child,
        ],
      ),
    );
  }
}
