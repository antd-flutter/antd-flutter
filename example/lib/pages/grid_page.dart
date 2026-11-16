library;

/// Grid 栅格演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '24 栅格系统，span 表示占位格数'),
          _BasicDemo(),
          _Section(title: '栅格比例', description: 'span 12+12 / 8+8+8 / 6+6+6+6 / 4×6'),
          _RatioDemo(),
          _Section(title: '栅格间距', description: 'gutter 设置列间距，通过列内边距实现'),
          _GutterDemo(),
          _Section(title: '偏移', description: 'offset 设置列左侧偏移格数'),
          _OffsetDemo(),
          _Section(title: '垂直对齐', description: 'align: top / middle / bottom'),
          _AlignDemo(),
          _Section(title: '水平分布', description: 'justify: start / center / end / spaceAround / spaceBetween'),
          _JustifyDemo(),
          _Section(title: '换行', description: 'wrap: true，总 span 超过 24 时自动换行'),
          _WrapDemo(),
          _Section(title: 'flex 弹性', description: 'flex 属性让列按比例分配剩余空间，忽略 span'),
          _FlexDemo(),
          _Section(title: '组合用法', description: '嵌套栅格 + gutter + offset'),
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
          AntText(text: title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(text: description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
            ),
        ],
      ),
    );
  }
}

/// 演示用栅格块
class _Cell extends StatelessWidget {
  const _Cell(this.label, {this.color, this.height = 40});

  final String label;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF1677FF);
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: AntText(text: label,
          style: TextStyle(
            color: c,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          )),
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
      child: const AntRow(
        children: [
          AntCol(span: 12, child: _Cell('span 12')),
          AntCol(span: 12, child: _Cell('span 12')),
        ],
      ),
    );
  }
}

class _RatioDemo extends StatelessWidget {
  const _RatioDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ratioRow('span 12 + 12', const [
          AntCol(span: 12, child: _Cell('12')),
          AntCol(span: 12, child: _Cell('12')),
        ]),
        const SizedBox(height: 12),
        _ratioRow('span 8 × 3', const [
          AntCol(span: 8, child: _Cell('8')),
          AntCol(span: 8, child: _Cell('8')),
          AntCol(span: 8, child: _Cell('8')),
        ]),
        const SizedBox(height: 12),
        _ratioRow('span 6 × 4', const [
          AntCol(span: 6, child: _Cell('6')),
          AntCol(span: 6, child: _Cell('6')),
          AntCol(span: 6, child: _Cell('6')),
          AntCol(span: 6, child: _Cell('6')),
        ]),
        const SizedBox(height: 12),
        _ratioRow('span 4 × 6', const [
          AntCol(span: 4, child: _Cell('4')),
          AntCol(span: 4, child: _Cell('4')),
          AntCol(span: 4, child: _Cell('4')),
          AntCol(span: 4, child: _Cell('4')),
          AntCol(span: 4, child: _Cell('4')),
          AntCol(span: 4, child: _Cell('4')),
        ]),
      ],
    );
  }

  Widget _ratioRow(String label, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntRow(children: children),
        ),
      ],
    );
  }
}

class _GutterDemo extends StatelessWidget {
  const _GutterDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AntText(text: 'gutter: 16', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntRow(
            gutter: 16,
            children: [
              AntCol(span: 8, child: _Cell('8')),
              AntCol(span: 8, child: _Cell('8')),
              AntCol(span: 8, child: _Cell('8')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const AntText(text: 'gutter: 24', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntRow(
            gutter: 24,
            children: [
              AntCol(span: 6, child: _Cell('6')),
              AntCol(span: 6, child: _Cell('6')),
              AntCol(span: 6, child: _Cell('6')),
              AntCol(span: 6, child: _Cell('6')),
            ],
          ),
        ),
      ],
    );
  }
}

class _OffsetDemo extends StatelessWidget {
  const _OffsetDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntRow(
        children: [
          AntCol(span: 8, child: _Cell('span 8')),
          AntCol(span: 8, offset: 8, child: _Cell('offset 8')),
        ],
      ),
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
        _alignRow('top（默认）', AntRowAlign.top),
        const SizedBox(height: 12),
        _alignRow('middle', AntRowAlign.middle),
        const SizedBox(height: 12),
        _alignRow('bottom', AntRowAlign.bottom),
      ],
    );
  }

  Widget _alignRow(String label, AntRowAlign align) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 90,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntRow(
            align: align,
            children: const [
              AntCol(span: 8, child: _Cell('40', height: 40)),
              AntCol(span: 8, child: _Cell('60', height: 60, color: Color(0xFF52C41A))),
              AntCol(span: 8, child: _Cell('40', height: 40)),
            ],
          ),
        ),
      ],
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
        _justifyRow('start（默认）', AntRowJustify.start),
        const SizedBox(height: 12),
        _justifyRow('center', AntRowJustify.center),
        const SizedBox(height: 12),
        _justifyRow('end', AntRowJustify.end),
        const SizedBox(height: 12),
        _justifyRow('spaceAround', AntRowJustify.spaceAround),
        const SizedBox(height: 12),
        _justifyRow('spaceBetween', AntRowJustify.spaceBetween),
      ],
    );
  }

  Widget _justifyRow(String label, AntRowJustify justify) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntRow(
            justify: justify,
            children: const [
              AntCol(span: 4, child: _Cell('4')),
              AntCol(span: 4, child: _Cell('4')),
              AntCol(span: 4, child: _Cell('4')),
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
      child: const AntRow(
        wrap: true,
        gutter: 16,
        verticalGutter: 16,
        children: [
          AntCol(span: 12, child: _Cell('span 12')),
          AntCol(span: 12, child: _Cell('span 12')),
          AntCol(span: 8, child: _Cell('span 8')),
          AntCol(span: 8, child: _Cell('span 8')),
          AntCol(span: 8, child: _Cell('span 8')),
        ],
      ),
    );
  }
}

class _FlexDemo extends StatelessWidget {
  const _FlexDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntRow(
        gutter: 16,
        children: [
          AntCol(span: 8, child: _Cell('span 8')),
          AntCol(flex: 2, child: _Cell('flex 2', color: Color(0xFF52C41A))),
          AntCol(flex: 1, child: _Cell('flex 1', color: Color(0xFFFA8C16))),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntRow(
        gutter: 16,
        children: [
          AntCol(
            span: 12,
            child: AntRow(
              gutter: 8,
              children: [
                AntCol(span: 12, child: _Cell('内 12', color: Color(0xFF722ED1))),
                AntCol(span: 12, child: _Cell('内 12', color: Color(0xFF722ED1))),
              ],
            ),
          ),
          AntCol(
            span: 12,
            child: AntRow(
              gutter: 8,
              children: [
                AntCol(span: 8, child: _Cell('8', color: Color(0xFF13C2C2))),
                AntCol(span: 8, child: _Cell('8', color: Color(0xFF13C2C2))),
                AntCol(span: 8, child: _Cell('8', color: Color(0xFF13C2C2))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}