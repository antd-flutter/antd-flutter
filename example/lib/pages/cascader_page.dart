library;

/// AntCascader demo 页面
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

/// 省市区数据
const _regionOptions = <AntCascaderOption>[
  AntCascaderOption(value: 'zj', label: '浙江', children: [
    AntCascaderOption(value: 'hz', label: '杭州', children: [
      AntCascaderOption(value: 'xh', label: '西湖区'),
      AntCascaderOption(value: 'yh', label: '余杭区'),
    ]),
    AntCascaderOption(value: 'nb', label: '宁波', children: [
      AntCascaderOption(value: 'js', label: '江东区'),
      AntCascaderOption(value: 'yz', label: '鄞州区'),
    ]),
  ]),
  AntCascaderOption(value: 'js', label: '江苏', children: [
    AntCascaderOption(value: 'nj', label: '南京', children: [
      AntCascaderOption(value: 'xl', label: '玄武区'),
      AntCascaderOption(value: 'gl', label: '鼓楼区'),
    ]),
    AntCascaderOption(value: 'sz', label: '苏州', children: [
      AntCascaderOption(value: 'gs', label: '姑苏区'),
    ]),
  ]),
  AntCascaderOption(value: 'gd', label: '广东', children: [
    AntCascaderOption(value: 'gz', label: '广州', children: [
      AntCascaderOption(value: 'th', label: '天河区'),
      AntCascaderOption(value: 'yw', label: '越秀区'),
    ]),
    AntCascaderOption(value: 'sz', label: '深圳', children: [
      AntCascaderOption(value: 'ns', label: '南山区'),
      AntCascaderOption(value: 'ft', label: '福田区'),
    ]),
  ]),
];

class CascaderPage extends StatelessWidget {
  const CascaderPage({super.key});

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
            title: '默认值',
            theme: t,
            child: AntCascader(
              options: _regionOptions,
              defaultValue: const ['zj', 'hz', 'xh'],
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '选择即改变 (changeOnSelect)',
            theme: t,
            child: _ChangeOnSelectDemo(),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用选项',
            theme: t,
            child: AntCascader(
              options: const [
                AntCascaderOption(value: 'a', label: '可用', children: [
                  AntCascaderOption(value: 'a1', label: '子项A1'),
                ]),
                AntCascaderOption(value: 'b', label: '禁用项', disabled: true, children: [
                  AntCascaderOption(value: 'b1', label: '子项B1'),
                ]),
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
                AntCascader(
                  options: _regionOptions,
                  size: AntCascaderSize.large,
                  placeholder: '大号',
                ),
                SizedBox(height: 8.h),
                AntCascader(
                  options: _regionOptions,
                  size: AntCascaderSize.middle,
                  placeholder: '中号',
                ),
                SizedBox(height: 8.h),
                AntCascader(
                  options: _regionOptions,
                  size: AntCascaderSize.small,
                  placeholder: '小号',
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '允许清除',
            theme: t,
            child: AntCascader(
              options: _regionOptions,
              defaultValue: const ['gd', 'sz', 'ns'],
              allowClear: true,
              placeholder: '请选择',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            theme: t,
            child: AntCascader(
              options: _regionOptions,
              disabled: true,
              defaultValue: const ['js', 'nj', 'xl'],
              placeholder: '禁用',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '受控用法',
            theme: t,
            child: _ControlledDemo(),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 基础用法
// ============================================================

class _BasicDemo extends StatefulWidget {
  @override
  State<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<_BasicDemo> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader(
          options: _regionOptions,
          placeholder: '请选择省/市/区',
          onChange: (path) => setState(() => _selected = path.join(' > ')),
        ),
        if (_selected.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
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
  @override
  State<_ChangeOnSelectDemo> createState() => _ChangeOnSelectDemoState();
}

class _ChangeOnSelectDemoState extends State<_ChangeOnSelectDemo> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader(
          options: _regionOptions,
          placeholder: '选择任意层级',
          changeOnSelect: true,
          onChange: (path) => setState(() => _selected = path.join(' > ')),
        ),
        if (_selected.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
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
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  List<String>? _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntCascader(
          options: _regionOptions,
          value: _value,
          placeholder: '受控选择',
          onChange: (path) => setState(() => _value = path),
        ),
        SizedBox(height: 8.h),
        AntButton(
          size: AntButtonSize.small,
          onTap: () => setState(() => _value = const ['gd', 'gz', 'th']),
          child: const Text('设置为广州天河'),
        ),
        SizedBox(height: 8.h),
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