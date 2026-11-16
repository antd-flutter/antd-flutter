import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

const _options = <AntCascaderOption>[
  AntCascaderOption(value: 'zj', label: '浙江', children: [
    AntCascaderOption(value: 'hz', label: '杭州', children: [
      AntCascaderOption(value: 'xh', label: '西湖区'),
      AntCascaderOption(value: 'yh', label: '余杭区'),
    ]),
    AntCascaderOption(value: 'nb', label: '宁波'),
  ]),
  AntCascaderOption(value: 'js', label: '江苏', children: [
    AntCascaderOption(value: 'nj', label: '南京'),
    AntCascaderOption(value: 'sz', label: '苏州', children: [
      AntCascaderOption(value: 'gusu', label: '姑苏区'),
    ]),
  ]),
  AntCascaderOption(value: 'gd', label: '广东', children: [
    AntCascaderOption(value: 'gz', label: '广州', children: [
      AntCascaderOption(value: 'th', label: '天河区'),
      AntCascaderOption(value: 'by', label: '白云区'),
    ]),
    AntCascaderOption(value: 'sz_gd', label: '深圳'),
  ]),
];

const _disabledOptions = <AntCascaderOption>[
  AntCascaderOption(value: 'a', label: '选项 A'),
  AntCascaderOption(value: 'b', label: '选项 B（禁用）', disabled: true, children: [
    AntCascaderOption(value: 'b1', label: '子选项 B1'),
  ]),
  AntCascaderOption(value: 'c', label: '选项 C'),
];

class CascaderViewPage extends StatelessWidget {
  const CascaderViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntCascaderView(
              options: _options,
              onChange: (value, items) =>
                  debugPrint('onChange: $value, items: ${items.map((e) => e?.label)}'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '默认值',
            child: AntCascaderView(
              options: _options,
              defaultValue: ['zj', 'hz'],
              onChange: (value, items) => debugPrint('onChange: $value'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '受控模式',
            child: const _ControlledCascaderView(),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义占位文本',
            child: AntCascaderView(
              options: _options,
              placeholder: '请选择地区',
              onChange: (value, items) => debugPrint('onChange: $value'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义选中图标',
            child: AntCascaderView(
              options: _options,
              activeIcon: Icon(AntIcons.starFilled, size: 16.sp),
              onChange: (value, items) => debugPrint('onChange: $value'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用选项',
            child: AntCascaderView(
              options: _disabledOptions,
              onChange: (value, items) => debugPrint('onChange: $value'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: 'onTabsChange 回调',
            child: AntCascaderView(
              options: _options,
              onTabsChange: (index) => debugPrint('onTabsChange: $index'),
              onChange: (value, items) => debugPrint('onChange: $value'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义高度',
            child: AntCascaderView(
              options: _options,
              height: 200,
              onChange: (value, items) => debugPrint('onChange: $value'),
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
  List<String>? _value;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final label = _value?.isNotEmpty == true
        ? _value!.map((v) => _findLabel(_options, v)).join(' / ')
        : '未选择';
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: t.colorFillSecondary,
            borderRadius: BorderRadius.circular(t.borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('当前选择', style: TextStyle(fontSize: 14.sp, color: t.colorText)),
              Text(label, style: TextStyle(fontSize: 14.sp, color: t.colorPrimary)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        AntCascaderView(
          options: _options,
          value: _value,
          onChange: (value, items) => setState(() => _value = value),
        ),
      ],
    );
  }

  String _findLabel(List<AntCascaderOption> options, String value) {
    for (final option in options) {
      if (option.value == value) return option.label;
      if (option.children != null) {
        final label = _findLabel(option.children!, value);
        if (label != value) return label;
      }
    }
    return value;
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
      padding: EdgeInsets.all(12.w),
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
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}