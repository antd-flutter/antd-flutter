library;

/// Space 间距演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SpacePage extends StatelessWidget {
  const SpacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认水平排列，子元素间自动添加间距'),
          _BasicDemo(),
          _Section(title: '垂直方向', description: 'direction: vertical，垂直排列子元素'),
          _VerticalDemo(),
          _Section(title: '间距预设', description: 'size: small(8) / middle(16) / large(24)'),
          _SizePresetDemo(),
          _Section(title: '自定义间距', description: 'AntSpaceSize.all / AntSpaceSize.only'),
          _SizeCustomDemo(),
          _Section(title: '对齐方式', description: 'align: start / center / end / baseline'),
          _AlignDemo(),
          _Section(title: '分隔符', description: 'split: 在子元素之间插入分隔符'),
          _SplitDemo(),
          _Section(title: '换行', description: 'wrap: true，子元素溢出后自动换行'),
          _WrapDemo(),
          _Section(title: '组合用法', description: 'direction + size + align + split 组合'),
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
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
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
        border: Border.all(color: const Color(0xFF1677FF).withValues(alpha: 0.3)),
      ),
      child: Text(label,
          style: const TextStyle(
            color: Color(0xFF1677FF),
            fontSize: 14,
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
      child: const AntSpace(
        size: AntSpaceSize.middle(),
        children: [
          _Box('A'),
          _Box('B'),
          _Box('C'),
        ],
      ),
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
      child: const AntSpace(
        direction: AntSpaceDirection.vertical,
        size: AntSpaceSize.middle(),
        children: [
          _Box('A'),
          _Box('B'),
          _Box('C'),
        ],
      ),
    );
  }
}

class _SizePresetDemo extends StatelessWidget {
  const _SizePresetDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sizeRow('small (8)', const AntSpaceSize.small()),
        const SizedBox(height: 12),
        _sizeRow('middle (16)', const AntSpaceSize.middle()),
        const SizedBox(height: 12),
        _sizeRow('large (24)', const AntSpaceSize.large()),
      ],
    );
  }

  Widget _sizeRow(String label, AntSpaceSize size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntSpace(
            size: size,
            children: const [_Box('A'), _Box('B'), _Box('C'), _Box('D')],
          ),
        ),
      ],
    );
  }
}

class _SizeCustomDemo extends StatelessWidget {
  const _SizeCustomDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AntSpaceSize.all(32) — 单值',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntSpace(
            size: AntSpaceSize.all(32),
            children: [_Box('A'), _Box('B'), _Box('C')],
          ),
        ),
        const SizedBox(height: 12),
        const Text('AntSpaceSize.only(horizontal: 8, vertical: 20) — 分别设置',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntSpace(
            wrap: true,
            size: AntSpaceSize.only(horizontal: 8, vertical: 20),
            children: [
              _Box('A'), _Box('B'), _Box('C'),
              _Box('D'), _Box('E'), _Box('F'),
            ],
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
        _alignRow('start', AntSpaceAlign.start),
        const SizedBox(height: 12),
        _alignRow('center（默认）', AntSpaceAlign.center),
        const SizedBox(height: 12),
        _alignRow('end', AntSpaceAlign.end),
        const SizedBox(height: 12),
        _alignRow('baseline', AntSpaceAlign.baseline),
      ],
    );
  }

  Widget _alignRow(String label, AntSpaceAlign align) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AntSpace(
            align: align,
            size: const AntSpaceSize.middle(),
            children: [
              const _Box('A'),
              SizedBox(
                width: 48,
                height: 56,
                child: Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                      color: const Color(0xFF1677FF),
                      fontWeight: FontWeight.w500,
                      fontSize: align == AntSpaceAlign.baseline ? 28 : 14,
                    ),
                  ),
                ),
              ),
              const _Box('C'),
            ],
          ),
        ),
      ],
    );
  }
}

class _SplitDemo extends StatelessWidget {
  const _SplitDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const AntSpace(
        size: AntSpaceSize.middle(),
        split: AntDivider(type: AntDividerType.vertical),
        children: [
          Text('Link A', style: TextStyle(color: Color(0xFF1677FF))),
          Text('Link B', style: TextStyle(color: Color(0xFF1677FF))),
          Text('Link C', style: TextStyle(color: Color(0xFF1677FF))),
        ],
      ),
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
      child: const AntSpace(
        wrap: true,
        size: AntSpaceSize.small(),
        children: [
          _Box('1'), _Box('2'), _Box('3'), _Box('4'), _Box('5'),
          _Box('6'), _Box('7'), _Box('8'), _Box('9'), _Box('10'),
        ],
      ),
    );
  }
}

class _ComboDemo extends StatelessWidget {
  const _ComboDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('垂直方向 + 大间距 + 分隔线',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntSpace(
            direction: AntSpaceDirection.vertical,
            size: AntSpaceSize.large(),
            split: AntDivider(),
            children: [
              Text('Item 1'),
              Text('Item 2'),
              Text('Item 3'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text('水平方向 + 居中对齐 + 小间距',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const AntSpace(
            align: AntSpaceAlign.center,
            size: AntSpaceSize.small(),
            children: [
              _Box('A'),
              _Box('B'),
              _Box('C'),
            ],
          ),
        ),
      ],
    );
  }
}