/// antd_tokens 示例应用。
///
/// 展示种子令牌、颜色令牌映射与阴影令牌。
library;

import 'package:antd_tokens/antd_tokens.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

void main() {
  runApp(const AntdTokensExampleApp());
}

class AntdTokensExampleApp extends StatelessWidget {
  const AntdTokensExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'antd_tokens Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const TokensExamplePage(),
    );
  }
}

class TokensExamplePage extends StatefulWidget {
  const TokensExamplePage({super.key});

  @override
  State<TokensExamplePage> createState() => _TokensExamplePageState();
}

class _TokensExamplePageState extends State<TokensExamplePage> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    final seed = _isDark ? AntSeedToken.dark() : const AntSeedToken();
    final colorTokens = _isDark
        ? AntColorTokens.dark(seed)
        : AntColorTokens.light(seed);
    final shadowTokens = AntShadowTokens.generate(seed.colorShadow);

    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: colorTokens.colorBgLayout,
        appBar: AppBar(
          title: const Text('antd_tokens 示例'),
          backgroundColor: colorTokens.colorBgContainer,
          actions: [
            IconButton(
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() => _isDark = !_isDark),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ==================== 种子令牌 ====================
            const _SectionTitle('种子令牌 (AntSeedToken)'),
            _SeedTokenTable(seed: seed),
            const SizedBox(height: 24),

            // ==================== 颜色令牌 ====================
            const _SectionTitle('颜色令牌 (AntColorTokens)'),
            _ColorTokenGrid(tokens: colorTokens),
            const SizedBox(height: 24),

            // ==================== 阴影令牌 ====================
            const _SectionTitle('阴影令牌 (AntShadowTokens)'),
            _ShadowDemo(shadows: shadowTokens, bg: colorTokens.colorBgContainer),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 种子令牌表
// ============================================================

class _SeedTokenTable extends StatelessWidget {
  final AntSeedToken seed;

  const _SeedTokenTable({required this.seed});

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('colorPrimary', seed.colorPrimary),
      ('colorSuccess', seed.colorSuccess),
      ('colorWarning', seed.colorWarning),
      ('colorError', seed.colorError),
      ('colorInfo', seed.colorInfo),
      ('fontSize', seed.fontSize.toString()),
      ('borderRadius', seed.borderRadius.toString()),
      ('controlHeight', seed.controlHeight.toString()),
      ('lineWidth', seed.lineWidth.toString()),
      ('sizeUnit', seed.sizeUnit.toString()),
    ];

    return Card(
      child: Column(
        children: rows.map((r) {
          final (key, value) = r;
          final isColor = key.startsWith('color');
          return ListTile(
            dense: true,
            leading: isColor
                ? Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _parseColor(value),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  )
                : null,
            title: Text(key, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
            trailing: Text(value,
                style: TextStyle(
                    fontFamily: 'monospace', fontSize: 13, color: Colors.grey.shade700,),),
          );
        }).toList(),
      ),
    );
  }

  Color _parseColor(String hex) {
    if (hex.startsWith('#')) {
      final v = hex.replaceFirst('#', '');
      if (v.length == 6) {
        return Color(int.parse('FF$v', radix: 16));
      }
    }
    return Colors.grey;
  }
}

// ============================================================
// 颜色令牌网格
// ============================================================

class _ColorTokenGrid extends StatelessWidget {
  final AntColorTokens tokens;

  const _ColorTokenGrid({required this.tokens});

  @override
  Widget build(BuildContext context) {
    final items = <(String, Color)>[
      ('colorPrimary', tokens.colorPrimary),
      ('colorSuccess', tokens.colorSuccess),
      ('colorWarning', tokens.colorWarning),
      ('colorError', tokens.colorError),
      ('colorInfo', tokens.colorInfo),
      ('colorText', tokens.colorText),
      ('colorTextSecondary', tokens.colorTextSecondary),
      ('colorTextTertiary', tokens.colorTextTertiary),
      ('colorBgContainer', tokens.colorBgContainer),
      ('colorBgElevated', tokens.colorBgElevated),
      ('colorBgLayout', tokens.colorBgLayout),
      ('colorBorder', tokens.colorBorder),
      ('colorBorderSecondary', tokens.colorBorderSecondary),
      ('colorFill', tokens.colorFill),
      ('colorFillSecondary', tokens.colorFillSecondary),
      ('colorFillTertiary', tokens.colorFillTertiary),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.6,
      children: items.map((item) {
        final (name, color) = item;
        return Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(name,
                style: const TextStyle(fontSize: 8, fontFamily: 'monospace'),
                overflow: TextOverflow.ellipsis,),
          ],
        );
      }).toList(),
    );
  }
}

// ============================================================
// 阴影演示
// ============================================================

class _ShadowDemo extends StatelessWidget {
  final AntShadowTokens shadows;
  final Color bg;

  const _ShadowDemo({required this.shadows, required this.bg});

  @override
  Widget build(BuildContext context) {
    final demos = <(String, List<BoxShadow>)>[
      ('boxShadow', shadows.boxShadow),
      ('boxShadowSecondary', shadows.boxShadowSecondary),
      ('boxShadowTertiary', shadows.boxShadowTertiary),
      ('boxShadowCard', shadows.boxShadowCard),
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: demos.map((d) {
        final (label, shadow) = d;
        return Column(
          children: [
            Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                boxShadow: shadow,
              ),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),),
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