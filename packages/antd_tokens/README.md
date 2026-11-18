# antd_tokens

Ant Design v6 Design Token system for Flutter — seed tokens、token 生成算法、色彩 token 映射与阴影 token，移植自 antd `components/theme`。

## 安装

```yaml
dependencies:
  antd_tokens: ^1.0.0
```

## 用法

```dart
import 'package:antd_tokens/antd_tokens.dart';

// ── Seed token ───────────────────────────────────────────
const seed = AntSeedToken(); // 默认 seed，与 antd 默认值一致
const custom = AntSeedToken(
  colorPrimary: '#722ed1',
  fontSize: 16,
  borderRadius: 8,
);
final darkSeed = AntSeedToken.dark();

// ── Token 生成算法 ───────────────────────────────────────
final fontMap = antGenFontMapToken(14);
print(fontMap.fontSizeLG);       // 16
print(fontMap.fontSizeHeading1); // 38

final radius = antGenRadius(6);
print(radius.borderRadiusSM); // 4
print(radius.borderRadiusLG); // 8

final sizes = antGenSizeMapToken(sizeUnit: 4, sizeStep: 4);
print(sizes.size);   // 16
print(sizes.sizeLG); // 24

final heights = antGenControlHeight(32);
print(heights.controlHeightSM); // 24
print(heights.controlHeightLG); // 40

final motion = antGenMotionDuration(motionUnit: 0.1, motionBase: 0, motion: true);
print(motion.mid); // 0.2

// ── 色彩 token（Map + Alias） ────────────────────────────
final lightColors = AntColorTokens.light(seed);
final darkColors = AntColorTokens.dark(darkSeed);

final primary = lightColors.colorPrimary; // Color(0xFF1677FF)
print(lightColors.css.colorPrimary);      // #1677ff（原始 CSS 字符串）
print(lightColors.isDark);                // false

// ── 阴影 token ───────────────────────────────────────────
final shadows = AntShadowTokens.generate('#000000');
Container(
  decoration: BoxDecoration(
    boxShadow: shadows.boxShadow, // popup 阴影
    borderRadius: BorderRadius.circular(6),
  ),
);
// 其他：boxShadowSecondary / boxShadowTertiary / boxShadowCard
// boxShadowDrawerRight / boxShadowTabsOverflowLeft …
```

## 文档

- [API 文档总览](docs/api-index.md)

## License

MIT License，详见 [LICENSE](LICENSE)。
