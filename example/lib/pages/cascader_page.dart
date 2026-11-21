library;

/// AntCascader demo 页面
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 省市区数据模型
class _Region {
  const _Region(
    this.code,
    this.name, {
    this.children = const [],
    this.disabled = false,
  });

  final String code;
  final String name;
  final List<_Region> children;
  final bool disabled;
}

/// 省市区数据
const _regions = <_Region>[
  _Region(
    'zj',
    '浙江',
    children: [
      _Region(
        'hz',
        '杭州',
        children: [_Region('xh', '西湖区'), _Region('yh', '余杭区')],
      ),
      _Region(
        'nb',
        '宁波',
        children: [_Region('js', '江东区'), _Region('yz', '鄞州区')],
      ),
    ],
  ),
  _Region(
    'js',
    '江苏',
    children: [
      _Region(
        'nj',
        '南京',
        children: [_Region('xl', '玄武区'), _Region('gl', '鼓楼区')],
      ),
      _Region('sz', '苏州', children: [_Region('gs', '姑苏区')]),
    ],
  ),
  _Region(
    'gd',
    '广东',
    children: [
      _Region(
        'gz',
        '广州',
        children: [_Region('th', '天河区'), _Region('yw', '越秀区')],
      ),
      _Region(
        'sz_gd',
        '深圳',
        children: [_Region('ns', '南山区'), _Region('ft', '福田区')],
      ),
    ],
  ),
];

/// 禁用项演示数据
const _disabledRegions = <_Region>[
  _Region('a', '可用', children: [_Region('a1', '子项A1')]),
  _Region('b', '禁用项', disabled: true, children: [_Region('b1', '子项B1')]),
];

Object _keyOf(_Region region) => region.code;

List<_Region> _childrenOf(_Region region) => region.children;

Widget _labelBuilder(BuildContext context, _Region region) => Text(region.name);

bool _disabledOf(_Region region) => region.disabled;

class CascaderPage extends StatelessWidget {
  const CascaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(t.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(title: '基础用法', theme: t, child: const _BasicDemo()),
          SizedBox(height: t.s(16)),
          _Section(
            title: '默认值（key 数组）',
            theme: t,
            child: AntCascader<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              defaultValue: const ['zj', 'hz', 'xh'],
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '选择即改变 (changeOnSelect)',
            theme: t,
            child: const _ChangeOnSelectDemo(),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '禁用选项',
            theme: t,
            child: AntCascader<_Region>(
              dataSource: _disabledRegions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              disabledOf: _disabledOf,
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '三种尺寸',
            theme: t,
            child: Column(
              children: [
                AntCascader<_Region>(
                  dataSource: _regions,
                  keyOf: _keyOf,
                  childrenOf: _childrenOf,
                  labelBuilder: _labelBuilder,
                  size: AntCascaderSize.large,
                  placeholder: '大号',
                ),
                SizedBox(height: t.s(8)),
                AntCascader<_Region>(
                  dataSource: _regions,
                  keyOf: _keyOf,
                  childrenOf: _childrenOf,
                  labelBuilder: _labelBuilder,
                  size: AntCascaderSize.middle,
                  placeholder: '中号',
                ),
                SizedBox(height: t.s(8)),
                AntCascader<_Region>(
                  dataSource: _regions,
                  keyOf: _keyOf,
                  childrenOf: _childrenOf,
                  labelBuilder: _labelBuilder,
                  size: AntCascaderSize.small,
                  placeholder: '小号',
                ),
              ],
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '允许清除',
            theme: t,
            child: AntCascader<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              defaultValue: const ['gd', 'sz_gd', 'ns'],
              allowClear: true,
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '禁用状态',
            theme: t,
            child: AntCascader<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              disabled: true,
              defaultValue: const ['js', 'nj', 'xl'],
              placeholder: '禁用',
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(title: '受控用法', theme: t, child: const _ControlledDemo()),
        ],
      ),
    );
  }
}

// ============================================================
// 基础用法
// ============================================================

class _BasicDemo extends StatefulWidget {
  const _BasicDemo();

  @override
  State<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<_BasicDemo> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader<_Region>(
          dataSource: _regions,
          keyOf: _keyOf,
          childrenOf: _childrenOf,
          labelBuilder: _labelBuilder,
          placeholder: '请选择省/市/区',
          onChange: (path) => setState(
            () => _selected = path.map((region) => region.name).join(' > '),
          ),
        ),
        if (_selected.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: theme.s(8)),
            child: Text('已选：$_selected'),
          ),
      ],
    );
  }
}

// ============================================================
// changeOnSelect
// ============================================================

class _ChangeOnSelectDemo extends StatefulWidget {
  const _ChangeOnSelectDemo();

  @override
  State<_ChangeOnSelectDemo> createState() => _ChangeOnSelectDemoState();
}

class _ChangeOnSelectDemoState extends State<_ChangeOnSelectDemo> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader<_Region>(
          dataSource: _regions,
          keyOf: _keyOf,
          childrenOf: _childrenOf,
          labelBuilder: _labelBuilder,
          placeholder: '选择任意层级',
          changeOnSelect: true,
          onChange: (path) => setState(
            () => _selected = path.map((region) => region.name).join(' > '),
          ),
        ),
        if (_selected.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: theme.s(8)),
            child: Text('已选：$_selected'),
          ),
      ],
    );
  }
}

// ============================================================
// 受控用法
// ============================================================

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  List<Object>? _value;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader<_Region>(
          dataSource: _regions,
          keyOf: _keyOf,
          childrenOf: _childrenOf,
          labelBuilder: _labelBuilder,
          value: _value,
          placeholder: '受控选择',
          onChange: (path) => setState(() => _value = path),
        ),
        SizedBox(height: theme.s(8)),
        AntButton(
          size: AntButtonSize.small,
          onTap: () => setState(() => _value = const ['gd', 'gz', 'th']),
          child: const Text('设置为广州天河'),
        ),
        SizedBox(height: theme.s(8)),
        AntButton(
          size: AntButtonSize.small,
          onTap: () => setState(() => _value = const []),
          child: const Text('清空'),
        ),
      ],
    );
  }
}

// ============================================================
// _Section 容器
// ============================================================

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
              fontSize: theme.fontSizeLG,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: t.s(12)),
          child,
        ],
      ),
    );
  }
}
