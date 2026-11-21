library;

/// Flex 弹性布局演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class FlexPage extends StatelessWidget {
  const FlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认水平排列子元素'),
          _BasicDemo(),
          _Section(title: '垂直排列', description: 'vertical: true，主轴为垂直方向'),
          _VerticalDemo(),
          _Section(
            title: '主轴对齐',
            description: 'justify: start / center / end / spaceBetween',
          ),
          _JustifyDemo(),
          _Section(
            title: '交叉轴对齐',
            description: 'align: start / center / end / stretch',
          ),
          _AlignDemo(),
          _Section(
            title: '间距预设',
            description: 'gap: small(8) / middle(16) / large(24)',
          ),
          _GapPresetDemo(),
          _Section(
            title: '自定义间距',
            description: 'AntFlexGap.all / AntFlexGap.only',
          ),
          _GapCustomDemo(),
          _Section(title: '换行', description: 'wrap: true，子元素溢出后自动换行'),
          _WrapDemo(),
          _Section(title: '组合用法', description: 'justify + align + gap 组合'),
          _ComboDemo(),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(
            text: title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(
                text: description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 演示用色块
class _Box extends StatelessWidget {
  const _Box(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1677FF).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF1677FF).withValues(alpha: 0.3),
        ),
      ),
      child: AntText(
        text: label,
        style: const TextStyle(
          color: Color(0xFF1677FF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntFlex(children: [_Box('A'), _Box('B'), _Box('C')]),
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntFlex(
        vertical: true,
        children: [_Box('A'), _Box('B'), _Box('C')],
      ),
    );
  }
}

class _JustifyDemo extends StatelessWidget {
  const _JustifyDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _justifyRow('start', AntFlexJustify.start),
        const SizedBox(height: 12),
        _justifyRow('center', AntFlexJustify.center),
        const SizedBox(height: 12),
        _justifyRow('end', AntFlexJustify.end),
        const SizedBox(height: 12),
        _justifyRow('spaceBetween', AntFlexJustify.spaceBetween),
      ],
    );
  }

  Widget _justifyRow(String label, AntFlexJustify justify) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(
          text: label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntFlex(
            justify: justify,
            children: const [_Box('A'), _Box('B'), _Box('C')],
          ),
        ),
      ],
    );
  }
}

class _AlignDemo extends StatelessWidget {
  const _AlignDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _alignRow('start', AntFlexAlign.start),
        const SizedBox(height: 12),
        _alignRow('center', AntFlexAlign.center),
        const SizedBox(height: 12),
        _alignRow('end', AntFlexAlign.end),
        const SizedBox(height: 12),
        _alignRow('stretch', AntFlexAlign.stretch),
      ],
    );
  }

  Widget _alignRow(String label, AntFlexAlign align) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(
          text: label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntFlex(
            align: align,
            gap: const AntFlexGap.small(),
            children: const [
              _Box('A'),
              SizedBox(
                width: 48,
                height: 56,
                child: Center(
                  child: AntText(
                    text: 'B',
                    style: TextStyle(
                      color: Color(0xFF1677FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              _Box('C'),
            ],
          ),
        ),
      ],
    );
  }
}

class _GapPresetDemo extends StatelessWidget {
  const _GapPresetDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _gapRow('small (8)', const AntFlexGap.small()),
        const SizedBox(height: 12),
        _gapRow('middle (16)', const AntFlexGap.middle()),
        const SizedBox(height: 12),
        _gapRow('large (24)', const AntFlexGap.large()),
      ],
    );
  }

  Widget _gapRow(String label, AntFlexGap gap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(
          text: label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntFlex(
            gap: gap,
            children: const [_Box('A'), _Box('B'), _Box('C'), _Box('D')],
          ),
        ),
      ],
    );
  }
}

class _GapCustomDemo extends StatelessWidget {
  const _GapCustomDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AntText(
          text: 'AntFlexGap.all(32) — 单值',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntFlex(
            gap: AntFlexGap.all(32),
            children: [_Box('A'), _Box('B'), _Box('C')],
          ),
        ),
        const SizedBox(height: 12),
        const AntText(
          text: 'AntFlexGap.only(row: 8, column: 20) — 行列分别',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntFlex(
            wrap: true,
            gap: AntFlexGap.only(row: 8, column: 20),
            children: [
              _Box('A'),
              _Box('B'),
              _Box('C'),
              _Box('D'),
              _Box('E'),
              _Box('F'),
            ],
          ),
        ),
      ],
    );
  }
}

class _WrapDemo extends StatelessWidget {
  const _WrapDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntFlex(
        wrap: true,
        gap: AntFlexGap.small(),
        children: [
          _Box('1'),
          _Box('2'),
          _Box('3'),
          _Box('4'),
          _Box('5'),
          _Box('6'),
          _Box('7'),
          _Box('8'),
          _Box('9'),
          _Box('10'),
        ],
      ),
    );
  }
}

class _ComboDemo extends StatelessWidget {
  const _ComboDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntFlex(
        justify: AntFlexJustify.center,
        align: AntFlexAlign.center,
        gap: AntFlexGap.middle(),
        children: [_Box('A'), _Box('B'), _Box('C')],
      ),
    );
  }
}
