library;

/// TimePicker 时间选择框演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class TimePickerPage extends StatelessWidget {
  const TimePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Section(title: '基础用法', description: '点击弹出时分秒滚轮面板'),
            _BasicDemo(),
            _Section(title: '默认值', description: 'defaultValue 预填时间'),
            _DefaultValueDemo(),
            _Section(title: '清除', description: 'allowClear: true'),
            _ClearDemo(),
            _Section(title: '步长', description: 'hourStep / minuteStep / secondStep'),
            _StepDemo(),
            _Section(title: '尺寸', description: 'size: large / middle / small'),
            _SizeDemo(),
            _Section(title: '禁用', description: 'disabled: true'),
            _DisabledDemo(),
          ],
        ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntTitle(title, level: AntTitleLevel.h4),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(text: description!, type: AntTypographyType.secondary),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AntFlex(wrap: true, gap: const AntFlexGap.all(24), children: children);
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntTimePicker(
          placeholder: '请选择时间',
          onChange: (t) => debugPrint('time: $t'),
        ),
      ),
    ]);
  }
}

class _DefaultValueDemo extends StatelessWidget {
  const _DefaultValueDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntTimePicker(
          defaultValue: const TimeOfDay(hour: 10, minute: 30),
          onChange: (t) => debugPrint('time: $t'),
        ),
      ),
    ]);
  }
}

class _ClearDemo extends StatelessWidget {
  const _ClearDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntTimePicker(
          defaultValue: const TimeOfDay(hour: 10, minute: 30),
          allowClear: true,
        ),
      ),
    ]);
  }
}

class _StepDemo extends StatelessWidget {
  const _StepDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntTimePicker(
          hourStep: 2,
          minuteStep: 10,
          secondStep: 10,
          placeholder: '步长',
        ),
      ),
    ]);
  }
}

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 180,
        child: AntTimePicker(size: AntTimePickerSize.large, placeholder: '大号'),
      ),
      SizedBox(
        width: 180,
        child: AntTimePicker(size: AntTimePickerSize.middle, placeholder: '中号'),
      ),
      SizedBox(
        width: 180,
        child: AntTimePicker(size: AntTimePickerSize.small, placeholder: '小号'),
      ),
    ]);
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return _Row(children: [
      SizedBox(
        width: 200,
        child: AntTimePicker(disabled: true, placeholder: '禁用'),
      ),
    ]);
  }
}