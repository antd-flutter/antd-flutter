/// antd_color 示例应用。
///
/// 展示色板生成、FastColor 操作与颜色解析。
library;

import 'package:antd_color/antd_color.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdColorExampleApp());
}

class AntdColorExampleApp extends StatelessWidget {
  const AntdColorExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'antd_color Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ColorExamplePage(),
    );
  }
}

class ColorExamplePage extends StatelessWidget {
  const ColorExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    final palettes = antGeneratePresetPalettes();
    final darkPalettes = antGeneratePresetPalettes(dark: true);

    return Scaffold(
      appBar: AppBar(title: const Text('antd_color 示例')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== 预设色板 ====================
          const _SectionTitle('预设色板（亮色）'),
          ...palettes.entries.map(
            (e) => _PaletteRow(
              name: e.key,
              palette: e.value,
            ),
          ),
          const SizedBox(height: 24),

          const _SectionTitle('预设色板（暗色）'),
          ...darkPalettes.entries.take(5).map(
                (e) => _PaletteRow(
                  name: e.key,
                  palette: e.value,
                ),
              ),
          const SizedBox(height: 24),

          // ==================== FastColor 操作 ====================
          const _SectionTitle('FastColor 操作'),
          _FastColorDemo(),
          const SizedBox(height: 24),

          // ==================== 颜色解析 ====================
          const _SectionTitle('antParseColor 解析'),
          _ParseColorDemo(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ============================================================
// 色板行
// ============================================================

class _PaletteRow extends StatelessWidget {
  final String name;
  final List<String> palette;

  const _PaletteRow({required this.name, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(name, style: Theme.of(context).textTheme.labelMedium),
          ),
          ...palette.map(
            (hex) => Expanded(
              child: Container(
                height: 36,
                color: antParseColor(hex),
                child: Center(
                  child: Text(
                    hex == palette[5] ? '主色' : '',
                    style: const TextStyle(fontSize: 9, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FastColor 演示
// ============================================================

class _FastColorDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final base = AntFastColor.fromString('#1677ff');
    final darkened = base.darken(20);
    final lightened = base.lighten(20);
    final mixed = base.mix(AntFastColor.fromString('#52c41a'), 50);
    final tinted = base.tint(30);
    final shaded = base.shade(30);

    final demos = <(String, AntFastColor)>[
      ('原色 #1677ff', base),
      ('darken(20)', darkened),
      ('lighten(20)', lightened),
      ('mix(#52c41a, 50)', mixed),
      ('tint(30)', tinted),
      ('shade(30)', shaded),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: demos.map((d) {
        final (label, color) = d;
        return Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: antParseColor(color.toHexString()),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(
              color.toHexString(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ============================================================
// antParseColor 演示
// ============================================================

class _ParseColorDemo extends StatelessWidget {
  static const samples = [
    '#1677ff',
    '#f53',
    '#1677ff80',
    'rgb(22, 119, 255)',
    'rgba(0, 0, 0, 0.88)',
    'hsl(210, 100%, 50%)',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: samples.map((s) {
        return Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: antParseColor(s),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 4),
            Text(s, style: Theme.of(context).textTheme.labelSmall),
          ],
        );
      }).toList(),
    );
  }
}

// ============================================================
// 区块标题
// ============================================================

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
