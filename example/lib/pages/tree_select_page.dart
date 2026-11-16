library;

/// AntTreeSelect demo 页面
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

const _treeData = <AntTreeSelectOption>[
  AntTreeSelectOption(value: 'zj', label: '浙江', children: [
    AntTreeSelectOption(value: 'hz', label: '杭州'),
    AntTreeSelectOption(value: 'nb', label: '宁波'),
  ]),
  AntTreeSelectOption(value: 'js', label: '江苏', children: [
    AntTreeSelectOption(value: 'nj', label: '南京'),
    AntTreeSelectOption(value: 'sz', label: '苏州'),
  ]),
  AntTreeSelectOption(value: 'gd', label: '广东', children: [
    AntTreeSelectOption(value: 'gz', label: '广州'),
    AntTreeSelectOption(value: 'sz2', label: '深圳'),
  ]),
];

class TreeSelectPage extends StatelessWidget {
  const TreeSelectPage({super.key});

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
            theme: t,
            child: _BasicDemo(),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '默认展开全部',
            theme: t,
            child: AntTreeSelect(
              treeData: _treeData,
              treeDefaultExpandAll: true,
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '多选',
            theme: t,
            child: _MultipleDemo(),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用选项',
            theme: t,
            child: AntTreeSelect(
              treeData: const [
                AntTreeSelectOption(value: 'a', label: '可用'),
                AntTreeSelectOption(value: 'b', label: '禁用项', disabled: true),
              ],
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '三种尺寸',
            theme: t,
            child: Column(
              children: [
                AntTreeSelect(
                  treeData: _treeData,
                  size: AntTreeSelectSize.large,
                  placeholder: '大号',
                ),
                SizedBox(height: 8.h),
                AntTreeSelect(
                  treeData: _treeData,
                  size: AntTreeSelectSize.middle,
                  placeholder: '中号',
                ),
                SizedBox(height: 8.h),
                AntTreeSelect(
                  treeData: _treeData,
                  size: AntTreeSelectSize.small,
                  placeholder: '小号',
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '允许清除',
            theme: t,
            child: AntTreeSelect(
              treeData: _treeData,
              defaultValue: 'nj',
              allowClear: true,
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            theme: t,
            child: AntTreeSelect(
              treeData: _treeData,
              disabled: true,
              defaultValue: 'sz',
              placeholder: '禁用',
            ),
          ),
        ],
      ),
    );
  }
}

class _BasicDemo extends StatefulWidget {
  @override
  State<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<_BasicDemo> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTreeSelect(
          treeData: _treeData,
          placeholder: '请选择城市',
          onChange: (v) => setState(() => _selected = v as String?),
        ),
        if (_selected != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text('已选：$_selected'),
          ),
      ],
    );
  }
}

class _MultipleDemo extends StatefulWidget {
  @override
  State<_MultipleDemo> createState() => _MultipleDemoState();
}

class _MultipleDemoState extends State<_MultipleDemo> {
  List<String>? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTreeSelect(
          treeData: _treeData,
          treeDefaultExpandAll: true,
          multiple: true,
          placeholder: '请选择（多选）',
          onChange: (v) => setState(() => _selected = v as List<String>?),
        ),
        if (_selected != null && _selected!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text('已选：${_selected!.join('、')}'),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.theme, required this.child});

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
            style: TextStyle(fontSize: t.fontSizeLG.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}