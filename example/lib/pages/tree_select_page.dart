library;

/// AntTreeSelect demo 页面
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 业务模型：城市节点。
class _City {
  const _City(this.code, this.name, {this.children = const [], this.disabled = false});

  final String code;
  final String name;
  final List<_City> children;
  final bool disabled;
}

const _treeData = <_City>[
  _City('zj', '浙江', children: [_City('hz', '杭州'), _City('nb', '宁波')]),
  _City('js', '江苏', children: [_City('nj', '南京'), _City('sz', '苏州')]),
  _City('gd', '广东', children: [_City('gz', '广州'), _City('sz2', '深圳')]),
];

const _disabledData = <_City>[
  _City('a', '可用'),
  _City('b', '禁用项', disabled: true),
];

AntTreeSelect<_City> _treeSelect({
  List<_City> data = _treeData,
  AntTreeSelectSize size = AntTreeSelectSize.middle,
  bool multiple = false,
  bool disabled = false,
  bool allowClear = false,
  bool defaultExpandAll = false,
  Object? defaultValue,
  Object? value,
  String placeholder = '请选择',
  ValueChanged<Object?>? onChange,
}) {
  return AntTreeSelect<_City>(
    dataSource: data,
    keyOf: (item) => item.code,
    labelOf: (item) => item.name,
    titleBuilder: (context, item) => Text(item.name),
    childrenOf: (item) => item.children,
    disabledOf: (item) => item.disabled,
    size: size,
    multiple: multiple,
    disabled: disabled,
    allowClear: allowClear,
    treeDefaultExpandAll: defaultExpandAll,
    defaultValue: defaultValue,
    value: value,
    placeholder: placeholder,
    onChange: onChange,
  );
}

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
          _Section(title: '基础用法', theme: t, child: const _BasicDemo()),
          SizedBox(height: 16.h),
          _Section(
            title: '默认展开全部',
            theme: t,
            child: _treeSelect(defaultExpandAll: true),
          ),
          SizedBox(height: 16.h),
          _Section(title: '多选', theme: t, child: const _MultipleDemo()),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用选项',
            theme: t,
            child: _treeSelect(data: _disabledData),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '三种尺寸',
            theme: t,
            child: Column(
              children: [
                _treeSelect(size: AntTreeSelectSize.large, placeholder: '大号'),
                SizedBox(height: 8.h),
                _treeSelect(size: AntTreeSelectSize.middle, placeholder: '中号'),
                SizedBox(height: 8.h),
                _treeSelect(size: AntTreeSelectSize.small, placeholder: '小号'),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '允许清除',
            theme: t,
            child: _treeSelect(defaultValue: 'nj', allowClear: true),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            theme: t,
            child: _treeSelect(
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
  const _BasicDemo();

  @override
  State<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<_BasicDemo> {
  Object? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _treeSelect(
          placeholder: '请选择城市',
          onChange: (v) => setState(() => _selected = v),
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
  const _MultipleDemo();

  @override
  State<_MultipleDemo> createState() => _MultipleDemoState();
}

class _MultipleDemoState extends State<_MultipleDemo> {
  List<Object> _selected = const [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _treeSelect(
          multiple: true,
          defaultExpandAll: true,
          placeholder: '请选择（多选）',
          onChange: (v) => setState(
            () => _selected = v is List ? List<Object>.from(v) : const [],
          ),
        ),
        if (_selected.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text('已选：${_selected.join('、')}'),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
  });

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
            style: TextStyle(
              fontSize: t.fontSizeLG.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
