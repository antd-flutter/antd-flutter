# Map Token 生成器（ant_token_generators）

## 简介

`ant_token_generators.dart` 精确移植 antd `themes/shared/` 下的令牌生成函数，负责把 **Seed Token** 派生为 **Map Token**（中间映射层）。该层是种子与最终组件令牌之间的"算法缓冲区"：字号、圆角、间距、控件高度、动效时长均在此时完成阶梯化。

生成函数一览（与 antd 一一对应）：

| Dart 函数 | antd 对应 | 输出 |
| --- | --- | --- |
| antGenFontSizes | genFontSizes | `List<AntFontSizePair>`（10 阶） |
| antGenFontMapToken | genFontMapToken | `AntFontMapToken` |
| antGenRadius | genRadius | `AntRadiusToken` |
| antGenSizeMapToken | genSizeMapToken | `AntSizeMapToken` |
| antGenControlHeight | genControlHeight | `AntControlHeightToken` |
| antGenMotionDuration | genCommonMapToken（动效部分） | `AntMotionDurationToken` |
| antGetLineHeight | getLineHeight | `double` |

## 使用场景

- 查询某字号/圆角/间距档位的精确推导值，用于与 antd Web 端输出对拍。
- 只需要 Map 层（不涉及颜色）做布局与排版定制的场景。
- `antd_theme` 包内部装配完整 Alias Token 时调用。

## API 参数表

### antGenFontSizes

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| base | double | 基准字号（种子 `fontSize`），如 14 |

返回 10 阶 `AntFontSizePair` 列表。算法与 antd 一致：`size = base * e^(i/5)`（`i = index - 1`），`index > 1` 向下取整否则向上取整，再 `floor(intSize / 2) * 2` 取偶；`fontSizes[1]` 回填为基准值本身。行高由 `antGetLineHeight` 计算：`(size + 8) / size`。

### AntFontSizePair

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| size | double | 字号（逻辑像素），恒为偶数（基准回填项除外） |
| lineHeight | double | 推荐行高 |

### antGenFontMapToken / AntFontMapToken

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| fontSize | double | 基准字号 |

| 字段 | 类型 | 默认值（base=14） | 与 antd v6 对应 |
| --- | --- | --- | --- |
| fontSizeSM | double | 12 | fontSizeSM（阶梯 index 0） |
| fontSize | double | 14 | fontSize（index 1） |
| fontSizeLG | double | 16 | fontSizeLG（index 2） |
| fontSizeXL | double | 20 | fontSizeXL（index 3） |
| fontSizeHeading1…5 | double | 38 / 30 / 22 / 20 / 16 | 标题 1–5（index 6/5/4/3/2） |
| lineHeight / lineHeightLG / lineHeightSM | double | ≈1.5714 / 1.5 / ≈1.6667 | 行高三档 |
| fontHeight / fontHeightLG / fontHeightSM | double | 22 / 24 / 20 | `lineHeight × fontSize` 取整 |
| lineHeightHeading1…5 | double | — | 标题行高（对应阶梯） |

### antGenRadius / AntRadiusToken

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| radiusBase | double | 圆角基数（种子 `borderRadius`） |

按基数所在区间推导（与 antd `genRadius` 完全一致）。以基数 6 为例：LG 8、SM 6、XS 2、Outer 4。

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| borderRadius | double | 等于基数 |
| borderRadiusXS | double | 特小圆角 |
| borderRadiusSM | double | 小圆角 |
| borderRadiusLG | double | 大圆角 |
| borderRadiusOuter | double | 外部（弹出层）圆角 |

### antGenSizeMapToken / AntSizeMapToken

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| sizeUnit | double | 尺寸单位（种子，默认 4） |
| sizeStep | double | 尺寸步长（种子，默认 4） |

公式：`unit × (step ± n)`。默认值：XXL 48 / XL 32 / LG 24 / MD 20 / MS 16 / size 16 / SM 12 / XS 8 / XXS 4。

### antGenControlHeight / AntControlHeightToken

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| controlHeight | double | 控件基准高度（种子，默认 32） |

比例派生：SM = 0.75×（24）、XS = 0.5×（16）、LG = 1.25×（40）。

### antGenMotionDuration / AntMotionDurationToken

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| motionUnit | double | 动效时长单位（秒，默认 0.1） |
| motionBase | double | 动效时长基数（秒，默认 0） |
| motion | bool | 是否启用动效；`false` 时 fast/mid/slow 全部为 0 |

派生：fast = base + unit、mid = base + 2×unit、slow = base + 3×unit，保留一位小数。默认 0.1 / 0.2 / 0.3 秒。

## 代码示例

### 从种子派生全部 Map Token

```dart
import 'package:antd_tokens/antd_tokens.dart';

const seed = AntSeedToken();

final font = antGenFontMapToken(seed.fontSize);
print(font.fontSizeHeading1); // 38

final radius = antGenRadius(seed.borderRadius);
print(radius.borderRadiusLG); // 8

final size = antGenSizeMapToken(sizeUnit: seed.sizeUnit, sizeStep: seed.sizeStep);
print(size.sizeXXL); // 48

final height = antGenControlHeight(seed.controlHeight);
print(height.controlHeightLG); // 40

final motion = antGenMotionDuration(
  motionUnit: seed.motionUnit,
  motionBase: seed.motionBase,
  motion: seed.motion,
);
print(motion.mid); // 0.2
```

### 自定义字号与圆角基数

```dart
final font = antGenFontMapToken(16);
final radius = antGenRadius(10);
// 与 antd theme 中配置 { fontSize: 16, borderRadius: 10 } 的派生结果一致
```

## 注意事项

- **算法为精确移植**：所有生成函数与 antd `themes/shared/` 逐行对齐（含取整方向与取偶规则），输出值可直接与 antd Web 端对拍；请勿"顺手优化"取整逻辑，否则会破坏一致性。
- **仅覆盖 Map 层**：本文件不产出颜色令牌；颜色由 `AntColorTokens` 独立派生（见 color-token.md）。
- **与 antd_theme 包的关系**：业务代码一般不直接调用这些函数；`antd_theme` 在装配主题时使用它们生成完整令牌组。
