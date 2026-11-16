import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class StepperPage extends StatelessWidget {
  const StepperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntStepper(
              defaultValue: 3,
              onChange: (v) => debugPrint('onChange: $v'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '范围限制',
            child: AntStepper(
              defaultValue: 5,
              min: 0,
              max: 10,
              onChange: (v) => debugPrint('onChange: $v'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '步长设置',
            child: AntStepper(
              defaultValue: 0,
              step: 5,
              onChange: (v) => debugPrint('onChange: $v'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '小数精度',
            child: AntStepper(
              defaultValue: 1.5,
              step: 0.1,
              digits: 1,
              onChange: (v) => debugPrint('onChange: $v'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '三种尺寸',
            child: AntSpace(
              align: AntSpaceAlign.center,
              children: [
                AntStepper(
                  defaultValue: 1,
                  size: AntStepperSize.small,
                ),
                AntStepper(
                  defaultValue: 1,
                  size: AntStepperSize.middle,
                ),
                AntStepper(
                  defaultValue: 1,
                  size: AntStepperSize.large,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '只读输入',
            child: AntStepper(
              defaultValue: 3,
              inputReadOnly: true,
              onChange: (v) => debugPrint('onChange: $v'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '允许清空',
            child: AntStepper(
              defaultValue: 3,
              allowEmpty: true,
              onChange: (v) => debugPrint('onChange: $v'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            child: AntStepper(
              defaultValue: 3,
              disabled: true,
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '受控模式',
            child: _ControlledDemo(),
          ),
        ],
      ),
    );
  }
}

/// 受控模式演示
class _ControlledDemo extends StatefulWidget {
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      vertical: true,
      gap: AntFlexGap.all(12.w),
      children: [
        AntStepper(
          value: _value,
          onChange: (v) => setState(() => _value = v ?? 0),
        ),
        Text('当前值: $_value'),
      ],
    );
  }
}

/// 演示区块
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: theme.fontSizeLG, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}