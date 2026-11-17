# AntSeedToken — 种子令牌

## 简介

`AntSeedToken` 对应 antd v6 主题体系中的 **Seed Token**（`components/theme/themes/seed.ts`），是整个令牌派生链的最小输入集。用户只需配置少量种子值（品牌主色、基准字号、圆角基数等），其余全部令牌由算法逐层派生：

```text
AntSeedToken（种子）
  → antGenFontSizes / antGenRadius / antGenSizeMapToken / antGenControlHeight …（Map Token 层）
  → AntColorTokens.light / AntColorTokens.dark（颜色 Map + Alias 层）
  → AntShadowTokens.generate（Alias 层阴影）
```

字段默认值与 antd v6 默认种子**完全一致**（如 `colorPrimary: #1677ff`、`fontSize: 14`、`borderRadius: 6`）。

## 使用场景

- **品牌定制**：仅覆盖 `colorPrimary`（可连同 `colorSuccess` / `colorWarning` / `colorError` / `colorInfo`），派生出整套装件色板。
- **暗色主题**：使用 `AntSeedToken.dark()` 工厂生成暗色种子，交给 `AntColorTokens.dark()`。
- **密度/形态调整**：修改 `fontSize`、`borderRadius`、`controlHeight`、`sizeStep` 等改变整体视觉密度。
- **运行时动态换肤**：借助 `copyWith` 在不变更对象引用语义的情况下派生新种子。

## API 参数表

### 颜色种子

| 字段 | 类型 | 默认值 | 与 antd v6 对应 | 说明 |
| --- | --- | --- | --- | --- |
| colorPrimary | String | `#1677ff` | `colorPrimary` | 品牌主色，派生 10 阶主色板 |
| colorSuccess | String | `#52c41a` | `colorSuccess` | 成功色，派生 10 阶成功色板 |
| colorWarning | String | `#faad14` | `colorWarning` | 警告色，派生 10 阶警告色板 |
| colorError | String | `#ff4d4f` | `colorError` | 错误色，派生 10 阶错误色板 |
| colorInfo | String | `#1677ff` | `colorInfo` | 信息色，派生 10 阶信息色板 |
| colorLink | String | `''` | `colorLink` | 链接色；空字符串回退使用 colorInfo |
| colorTextBase | String | `''` | `colorTextBase` | 文字基色；空则亮色 `#000` / 暗色 `#fff` |
| colorBgBase | String | `''` | `colorBgBase` | 背景基色；空则亮色 `#fff` / 暗色 `#000` |
| colorShadow | String | `''` | `colorShadow` | 阴影基色；空则亮色 `#000` / 暗色 `rgba(255,255,255,0.2)` |

### 字体与线条

| 字段 | 类型 | 默认值 | 与 antd v6 对应 | 说明 |
| --- | --- | --- | --- | --- |
| fontFamily | String | 系统栈 | `fontFamily` | 正文字体族 CSS 栈 |
| fontFamilyCode | String | 等宽栈 | `fontFamilyCode` | 代码字体族 |
| fontSize | double | `14` | `fontSize` | 基准字号（逻辑像素），字号阶梯输入 |
| lineWidth | double | `1` | `lineWidth` | 线宽 |
| lineType | String | `solid` | `lineType` | 线型 CSS 值 |

### 动效

| 字段 | 类型 | 默认值 | 与 antd v6 对应 | 说明 |
| --- | --- | --- | --- | --- |
| motionUnit | double | `0.1` | `motionUnit` | 动效时长单位（秒） |
| motionBase | double | `0` | `motionBase` | 动效时长基数（秒） |
| motion | bool | `true` | `motion` | 是否启用动效；`false` 时时长全部归零 |
| motionEaseOutCirc 等 8 项 | String | cubic-bezier 值 | `motionEase*` | 各动效缓动曲线（CSS cubic-bezier 表达） |

### 尺寸、控件、层级与其他

| 字段 | 类型 | 默认值 | 与 antd v6 对应 | 说明 |
| --- | --- | --- | --- | --- |
| borderRadius | double | `6` | `borderRadius` | 圆角基数，派生 XS/SM/LG/Outer |
| sizeUnit | double | `4` | `sizeUnit` | 尺寸单位 |
| sizeStep | double | `4` | `sizeStep` | 尺寸步长，派生 XXS…XXL 间距阶梯 |
| sizePopupArrow | double | `16` | `sizePopupArrow` | 弹出层箭头尺寸 |
| controlHeight | double | `32` | `controlHeight` | 控件基准高度，派生 XS/SM/LG |
| zIndexBase | int | `0` | `zIndexBase` | Z-Index 基数 |
| zIndexPopupBase | int | `1000` | `zIndexPopupBase` | 弹出层 Z-Index 基数 |
| opacityImage | double | `1` | `opacityImage` | 图片透明度 |
| wireframe | bool | `false` | `wireframe` | 是否线框模式 |
| focusOutline | bool | `true` | `focus` | 是否显示焦点轮廓 |

### 方法

| 成员 | 签名 | 说明 |
| --- | --- | --- |
| AntSeedToken | `const AntSeedToken({...})` | 全参数常量构造，所有字段有默认值 |
| copyWith | `AntSeedToken copyWith({...})` | 复制并覆盖指定字段，未传入字段保持原值 |
| AntSeedToken.dark | `factory AntSeedToken.dark({colorTextBase, colorBgBase, colorShadow})` | 暗色种子预设 |

## 代码示例

### 自定义品牌色生成完整令牌组

```dart
import 'package:antd_tokens/antd_tokens.dart';

const seed = AntSeedToken(
  colorPrimary: '#6a3ce8',
  borderRadius: 8,
);

final lightColors = AntColorTokens.light(seed);   // 亮色完整颜色令牌
final darkColors = AntColorTokens.dark(seed);     // 暗色完整颜色令牌
final shadows = AntShadowTokens.generate('#000'); // 阴影令牌
```

### 暗色主题

```dart
final darkSeed = AntSeedToken.dark();
final colors = AntColorTokens.dark(darkSeed);
// colors.colorPrimary 为暗色色板第 6 阶（#1677ff → 偏亮的 #1668dc，由算法生成）
```

## 注意事项

- **暗色工厂差异**：`AntSeedToken.dark()` 与 antd 行为一致——`colorPrimary` 保持不变，暗色主色由暗色色板算法自动生成；工厂仅显式设置中性色（文字/背景/阴影），便于调试与自定义。
- **空字符串语义**：`colorLink`、`colorTextBase`、`colorBgBase`、`colorShadow` 使用空字符串表示"交由算法按主题回退"，这是 Dart 侧与 antd `undefined` 的等价表达。
- **不可变对象**：所有字段为 `final`，定制请通过构造参数或 `copyWith`，不要尝试原地修改。
- **与 antd_theme 包的关系**：本包只负责令牌定义与派生算法；主题的装配、继承与 Widget 层消费在 `antd_theme` 包中完成。业务代码通常不直接构造 `AntSeedToken`，而是通过 `antd_theme` 的主题配置传入。
