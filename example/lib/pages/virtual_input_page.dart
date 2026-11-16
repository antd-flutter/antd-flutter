import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class VirtualInputPage extends StatelessWidget {
  const VirtualInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Section(
            title: '基础用法',
            child: AntVirtualInput(
              placeholder: '请输入金额',
              onChange: (v) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('当前值: $v')));
              },
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '可清空',
            child: const AntVirtualInput(
              placeholder: '请输入',
              clearable: true,
              defaultValue: '100',
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '带确认键',
            child: AntVirtualInput(
              placeholder: '请输入密码',
              confirmText: '确定',
              onEnterPress: (v) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('确认: $v')));
              },
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '自定义按键',
            child: const AntVirtualInput(
              placeholder: '请输入金额（支持小数）',
              customKey: '.',
              confirmText: '确定',
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '禁用',
            child: const AntVirtualInput(
              placeholder: '禁用状态',
              disabled: true,
              defaultValue: '123',
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '自动聚焦',
            child: const AntVirtualInput(
              placeholder: '自动展开键盘',
              autoFocus: true,
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '受控模式',
            child: _ControlledDemo(),
          ),
        ],
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  String _value = '88';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntVirtualInput(
          value: _value,
          placeholder: '受控输入',
          clearable: true,
          onChange: (v) => setState(() => _value = v),
        ),
        SizedBox(height: 8.w),
        Text(
          '当前值: $_value',
          style: TextStyle(
            fontSize: 14.sp,
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
    final theme = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.w),
        border: Border.all(color: theme.colorSplit, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}