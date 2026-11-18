# antd_color

Ant Design v6 color system for Flutter — fast color manipulation, palette generation, and CSS color parsing, ported from `@ant-design/fast-color`。

## 安装

```yaml
dependencies:
  antd_color: ^1.0.0
```

## 用法

```dart
import 'package:antd_color/antd_color.dart';

// ── 颜色操作 ──────────────────────────────────────────────
// 从任意 CSS 颜色字符串创建（AntFastColor.of 的简写）
final base = AntFastColor('#1677ff');

final lighter = base.lighten(20);   // 变亮（百分比 0-100）
final darker = base.darken(10);     // 变暗
final mixed = base.mix('#ffffff', 50); // 混色
final tinted = base.tint(20);       // 与白色混合
final shaded = base.shade(10);      // 与黑色混合
final semi = base.setA(0.45);       // 调整 alpha

print(base.toHexString());  // #1677ff
print(base.toRgbString());  // rgb(22,119,255)
print(base.toHsl());        // AntHsl(h: 215, s: 1.0, l: 0.54)
print(base.toHsv());        // AntHsv(h: 215, s: 0.91, v: 1.0)
print(base.isDark());       // false
print(base.getLuminance()); // ~0.21（WCAG 相对亮度）

// ── 10 阶色板生成 ─────────────────────────────────────────
final palette = antGeneratePalette('#1677ff');
// palette[0] … palette[9] — hex 字符串，由浅到深

// 暗色主题色板
final darkPalette = antGeneratePalette(
  '#1677ff',
  AntPaletteOptions(theme: 'dark', backgroundColor: '#141414'),
);

// ── 预设色板（13 组） ─────────────────────────────────────
final presets = antGeneratePresetPalettes(); // Map<String, List<String>>
final blue = presets['blue']!;               // 10 阶 hex
final darkPresets = antGeneratePresetPalettes(dark: true);
final seed = AntPresetColors.blue; // #1677FF

// ── AntColor 色板包装 ────────────────────────────────────
final antBlue = AntColor.fromSeed('#1677ff');
print(antBlue.main);        // step 6 — 主色
print(antBlue[5]);          // 按阶数取值
final primary = antBlue.step6Color;   // Flutter Color
final antBlueDark = AntColor.fromSeedDark('#1677ff');

// ── CSS 颜色字符串解析 ───────────────────────────────────
final c1 = antParseColor('#1677ff');
final c2 = antParseColor('rgba(22, 119, 255, 0.6)');
```

## 文档

- [API 文档总览](docs/api-index.md)

## License

MIT License，详见 [LICENSE](LICENSE)。
