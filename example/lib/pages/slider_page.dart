library;

/// Slider 滑动输入条演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SliderPage extends StatelessWidget {
  const SliderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Section(title: '基础用法', description: '拖动滑块选择值'),
            _BasicDemo(),
            _Section(title: '默认值与范围', description: 'defaultValue / min / max / step'),
            _RangeDemo(),
            _Section(title: '刻度标记', description: 'marks 显示刻度文本'),
            _MarksDemo(),
            _Section(title: '提示气泡', description: 'tooltipVisible 控制气泡显示'),
            _TooltipDemo(),
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

class _SliderWrap extends StatelessWidget {
  const _SliderWrap({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: child,
      ),
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return const _SliderWrap(
      child: AntSlider(),
    );
  }
}

class _RangeDemo extends StatelessWidget {
  const _RangeDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SliderWrap(child: AntSlider(defaultValue: 30)),
        _SliderWrap(child: AntSlider(defaultValue: 60, min: 0, max: 100, step: 10)),
      ],
    );
  }
}

class _MarksDemo extends StatelessWidget {
  const _MarksDemo();
  @override
  Widget build(BuildContext context) {
    return _SliderWrap(
      child: AntSlider(
        defaultValue: 30,
        min: 0,
        max: 100,
        marks: const [
          AntSliderMark(value: 0, label: '0°C'),
          AntSliderMark(value: 25, label: '25°C'),
          AntSliderMark(value: 50, label: '50°C'),
          AntSliderMark(value: 75, label: '75°C'),
          AntSliderMark(value: 100, label: '100°C'),
        ],
      ),
    );
  }
}

class _TooltipDemo extends StatelessWidget {
  const _TooltipDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SliderWrap(child: AntSlider(defaultValue: 50, tooltipVisible: true)),
        _SliderWrap(child: AntSlider(defaultValue: 50, tooltipVisible: false)),
      ],
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _SliderWrap(
      child: AntSlider(defaultValue: 40, disabled: true),
    );
  }
}