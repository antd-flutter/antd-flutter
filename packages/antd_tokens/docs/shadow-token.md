# AntShadowTokens — 阴影令牌

## 简介

`AntShadowTokens` 对应 antd v6 Alias Token 中的 `boxShadow*` 系列（`alias.ts` 中的阴影生成公式），负责把 CSS box-shadow 字符串换算为 Flutter `BoxShadow` 列表，保证 Flutter 端阴影与 antd Web 端视觉一致。

阴影颜色不是固定的：由种子令牌的 **阴影基色**（`AntSeedToken.colorShadow`）按各层 alpha 系数派生。暗色主题传入 `rgba(255, 255, 255, 0.2)` 即得到白色系阴影，与 antd `theme.darkAlgorithm` 输出一致。

## 使用场景

- 弹出层（Dropdown / Tooltip / Popover / Modal）使用 `boxShadow`。
- Card、Drawer（四个方向）、Tabs 溢出渐隐使用对应方向令牌。
- 暗色主题切换时用暗色阴影基色重新生成一套令牌。

## API 参数表

### AntShadowTokens.generate

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| colorShadow | String | 无（必传） | 阴影基色 CSS 值；亮色推荐 `#000`，暗色推荐 `rgba(255, 255, 255, 0.2)` |

与 antd `alias.ts` 一致的颜色派生公式：

```ts
const shadowBaseColor = new FastColor(mergedToken.colorShadow);
const shadowBaseAlpha = shadowBaseColor.a;
const getShadowColor = (alpha) =>
  shadowBaseColor.clone().setA(shadowBaseAlpha * alpha).toRgbString();
```

Dart 侧同样经过 `setA(baseAlpha × alpha) → toRgbString() → antParseColor` 链路，确保两位小数 alpha 精度对齐（如暗色 `0.2 × 0.08 = 0.016 → 0.02`）。

### 字段（均为 `List<BoxShadow>`）

| 字段 | 对应 antd | 层数 | 说明 |
| --- | --- | --- | --- |
| boxShadow | boxShadow | 3 | 弹出层主阴影（offset 0,6 / 0,3 / 0,9） |
| boxShadowSecondary | boxShadowSecondary | 3 | 次级阴影（当前与主阴影同值，与 antd v6 一致） |
| boxShadowTertiary | boxShadowTertiary | 3 | 三级轻量浮起阴影 |
| boxShadowPopoverArrow | boxShadowPopoverArrow | 1 | Popover 箭头阴影 |
| boxShadowCard | boxShadowCard | 3 | Card 阴影 |
| boxShadowDrawerRight / Left / Up / Down | boxShadowDrawer* | 3 | Drawer 四方向阴影（Up 与主阴影同值） |
| boxShadowTabsOverflowLeft / Right / Top / Bottom | boxShadowTabsOverflow* | 1 | Tabs 溢出渐隐阴影（近似 inset） |

### 阴影层 alpha 系数

| 令牌 | 系数（依次各层） |
| --- | --- |
| 主阴影 / Drawer | 0.08 / 0.12 / 0.05 |
| 三级阴影 | 0.05 / 0.03 / 0.03 |
| Popover 箭头 | 0.05 |
| Card | 0.16 / 0.12 / 0.09 |
| Tabs 溢出 | 0.08 |

## 代码示例

### 基本用法

```dart
import 'package:antd_tokens/antd_tokens.dart';

final shadows = AntShadowTokens.generate('#000'); // 亮色

Container(
  decoration: BoxDecoration(
    color: colors.colorBgContainer,
    borderRadius: BorderRadius.circular(8),
    boxShadow: shadows.boxShadow, // 弹出层主阴影
  ),
);
```

### 从种子取阴影基色（推荐）

```dart
const seed = AntSeedToken();
final base = seed.colorShadow.isNotEmpty ? seed.colorShadow : '#000';
final shadows = AntShadowTokens.generate(base);
```

### 暗色主题

```dart
final shadows = AntShadowTokens.generate('rgba(255, 255, 255, 0.2)');
// 各层颜色为白色低透明度，与 antd darkAlgorithm 输出一致
```

## 注意事项

- **Tabs 溢出阴影为近似实现**：antd 中该组为 CSS `inset` 阴影，Flutter `BoxShadow` 不支持 inset，本实现用普通阴影（负 spread + 偏移）近似模拟边缘渐隐，视觉存在细微差异。
- **alpha 精度刻意对齐**：颜色生成特意走过 CSS 字符串序列化（而非直接构造 `Color`），以复现 antd `_formatAlpha` 的两位小数舍入；请勿改为直接计算。
- **私有构造**：`AntShadowTokens` 仅能通过 `AntShadowTokens.generate` 创建，保证所有令牌来自同一基色，视觉自洽。
- **与 antd_theme 包的关系**：`antd_theme` 在装配主题时按当前亮暗模式自动选择阴影基色并生成阴影令牌；业务代码一般直接从主题读取，无需自行调用 `generate`。
