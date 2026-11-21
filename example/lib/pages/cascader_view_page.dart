import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 地区业务模型
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
      _Region('nb', '宁波'),
    ],
  ),
  _Region(
    'js',
    '江苏',
    children: [
      _Region('nj', '南京'),
      _Region('sz', '苏州', children: [_Region('gusu', '姑苏区')]),
    ],
  ),
  _Region(
    'gd',
    '广东',
    children: [
      _Region(
        'gz',
        '广州',
        children: [_Region('th', '天河区'), _Region('by', '白云区')],
      ),
      _Region('sz_gd', '深圳'),
    ],
  ),
];

const _disabledRegions = <_Region>[
  _Region('a', '选项 A'),
  _Region('b', '选项 B（禁用）', disabled: true, children: [_Region('b1', '子选项 B1')]),
  _Region('c', '选项 C'),
];

Object _keyOf(_Region region) => region.code;

List<_Region> _childrenOf(_Region region) => region.children;

Widget _labelBuilder(BuildContext context, _Region region) => Text(region.name);

bool _disabledOf(_Region region) => region.disabled;

class CascaderViewPage extends StatelessWidget {
  const CascaderViewPage({super.key});

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
            child: AntCascaderView<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              onChange: (value, items) => debugPrint(
                'onChange: ${value.map((r) => r.name)}, '
                'items: ${items.map((r) => r?.name)}',
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '默认值（key 数组）',
            child: AntCascaderView<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              defaultValue: const ['zj', 'hz'],
              onChange: (value, items) =>
                  debugPrint('onChange: ${value.map((r) => r.name)}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(title: '受控模式', child: const _ControlledCascaderView()),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义占位文本',
            child: AntCascaderView<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              placeholder: '请选择地区',
              onChange: (value, items) =>
                  debugPrint('onChange: ${value.map((r) => r.name)}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义选中图标',
            child: AntCascaderView<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              activeIcon: Icon(AntIcons.starFilled, size: theme.s(16)),
              onChange: (value, items) =>
                  debugPrint('onChange: ${value.map((r) => r.name)}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '禁用选项',
            child: AntCascaderView<_Region>(
              dataSource: _disabledRegions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              disabledOf: _disabledOf,
              onChange: (value, items) =>
                  debugPrint('onChange: ${value.map((r) => r.name)}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'onTabsChange 回调',
            child: AntCascaderView<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              onTabsChange: (index) => debugPrint('onTabsChange: $index'),
              onChange: (value, items) =>
                  debugPrint('onChange: ${value.map((r) => r.name)}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义高度',
            child: AntCascaderView<_Region>(
              dataSource: _regions,
              keyOf: _keyOf,
              childrenOf: _childrenOf,
              labelBuilder: _labelBuilder,
              height: 200,
              onChange: (value, items) =>
                  debugPrint('onChange: ${value.map((r) => r.name)}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlledCascaderView extends StatefulWidget {
  const _ControlledCascaderView();

  @override
  State<_ControlledCascaderView> createState() =>
      _ControlledCascaderViewState();
}

class _ControlledCascaderViewState extends State<_ControlledCascaderView> {
  List<Object>? _value;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final label = _value?.isNotEmpty == true
        ? _value!
              .map((value) => value is _Region ? value.name : '$value')
              .join(' / ')
        : '未选择';
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(10)),
          decoration: BoxDecoration(
            color: t.colorFillSecondary,
            borderRadius: BorderRadius.circular(t.borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '当前选择',
                style: TextStyle(fontSize: t.s(14), color: t.colorText),
              ),
              Text(
                label,
                style: TextStyle(fontSize: t.s(14), color: t.colorPrimary),
              ),
            ],
          ),
        ),
        SizedBox(height: t.s(8)),
        AntCascaderView<_Region>(
          dataSource: _regions,
          keyOf: _keyOf,
          childrenOf: _childrenOf,
          labelBuilder: _labelBuilder,
          value: _value,
          onChange: (value, items) => setState(() => _value = value),
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
