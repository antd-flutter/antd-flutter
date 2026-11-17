# AntColorTokens — 颜色令牌

## 简介

`AntColorTokens` 对应 antd v6 令牌体系中的 **颜色 Map Token + Alias Token** 两层，从 `AntSeedToken` 生成完整颜色令牌集（亮色 / 暗色）。对应 antd 的 `genColorMapToken` + `generateNeutralColorPalettes` + `alias.ts` 颜色部分。

派生结构：

```text
AntSeedToken（种子）
  └─ AntColorTokens.light / AntColorTokens.dark
       ├─ Map Token 层：功能色板（primary/success/warning/error/info/link 各 10 阶）
       │                + 中性色（文字/填充/背景/边框，按 alpha 或亮度派生）
       └─ Alias Token 层：语义别名（colorSplit、colorTextPlaceholder、controlItemBgHover 等）
```

每个令牌同时以两种形式提供：

- `AntColorTokens` 上的 getter：Flutter `Color`，供运行时直接使用；
- `css` 字段（`AntColorTokensCss`）：CSS 字符串（hex / rgba），供调试与和 antd Web 端输出对拍。

## 使用场景

- 通过 `antd_theme` 装配亮色 / 暗色主题（本类是主题颜色的唯一来源）。
- Widget 层按语义取色，如 `colors.colorBgContainer`、`colors.colorTextSecondary`。
- 定制品牌色后验证派生色板是否符合预期（借助 `css` 对拍 antd 官方值）。

## API 参数表

### 工厂构造

| 工厂 | 参数 | 说明 |
| --- | --- | --- |
| AntColorTokens.light | `AntSeedToken seed` | 亮色主题，对应 antd `theme.defaultAlgorithm` |
| AntColorTokens.dark | `AntSeedToken seed` | 暗色主题，对应 antd `theme.darkAlgorithm` |

### 字段

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| css | AntColorTokensCss | CSS 字符串形式的原始令牌（调试/导出用） |
| isDark | bool | 是否暗色主题 |

### 令牌分组（getter 均返回 Color）

以下列出各分组与派生规则；完整字段清单见 `AntColorTokensCss`（字段名与 antd v6 令牌名一一对应）。

| 分组 | 代表字段 | 派生规则 |
| --- | --- | --- |
| 基色 | colorBgBase、colorTextBase、colorWhite、colorShadow、colorBgMask | 来自种子或主题回退值 |
| 文字 | colorText、colorTextSecondary/Tertiary/Quaternary | 文字基色按 alpha：88%（暗 85%）/ 65% / 45% / 25% |
| 填充 | colorFill 及 Secondary/Tertiary/Quaternary | 文字基色按 alpha：15%（暗 18%）/ 6%（暗 12%）/ 4%（暗 8%）/ 2%（暗 4%） |
| 背景 | colorBgContainer、colorBgElevated、colorBgLayout、colorBgSpotlight、colorBgBlur、colorBgSolid* | 背景基色按亮度 darken/lighten，或按 alpha |
| 边框 | colorBorder、colorBorderSecondary、colorBorderDisabled、colorBorderBg、colorSplit | 背景基色按亮度；colorSplit 为最小 alpha 等价色 |
| 功能色板 | color{Primary,Success,Warning,Error,Info}{,Bg,BgHover,Border,BorderHover,Hover,Active,TextHover,Text,TextActive} | 各 10 阶色板按固定索引映射（见下） |
| 链接 | colorLink、colorLinkHover、colorLinkActive | 种子 colorLink（回退 colorInfo）色板第 4/6/7 阶 |
| 控件别名 | controlOutline、controlTmpOutline、controlItemBg* | Alias 层由 Map 层派生 |
| 文字别名 | colorTextHeading/Label/Description/Placeholder/Disabled/LightSolid、colorHighlight、colorIcon(Hover) | Alias 层派生（如 colorTextPlaceholder = colorTextQuaternary） |

色板索引映射（`palette[n]`）：

| 令牌后缀 | 亮色 | 暗色 |
| --- | --- | --- |
| Bg | [0] | [0] |
| BgHover | [1] | [1] |
| Border | [2] | [2] |
| BorderHover | [3] | [3] |
| Hover | Primary [4]；Success/Warning/Error/Info [3] | 同亮色规则 |
| 主色（无后缀） | [5] | [5] |
| Active | [6] | [6] |
| TextHover / Text / TextActive | [7] / [8] / [9] | [7] / [8] / [9]（暗色色板本身不同） |

## 代码示例

### 自定义种子生成亮暗两套颜色

```dart
import 'package:antd_tokens/antd_tokens.dart';

const seed = AntSeedToken(colorPrimary: '#6a3ce8');

final light = AntColorTokens.light(seed);
light.colorPrimary;        // #6a3ce8
light.colorPrimaryBg;      // 色板第 1 阶（浅背景）
light.colorTextSecondary;  // 文字基色 65% alpha

final dark = AntColorTokens.dark(AntSeedToken.dark());
dark.colorPrimary;         // 暗色色板第 6 阶（比亮色更亮）
dark.colorBgContainer;     // 暗色容器背景
```

### 读取 CSS 原始值进行对拍

```dart
final colors = AntColorTokens.light(const AntSeedToken());
print(colors.css.colorPrimaryBg); // 与 antd Web 端 token.colorPrimaryBg 应一致
```

## 注意事项

- **亮暗色工厂差异**：
  - 暗色主题使用 `dark` 色板算法（同一种子生成更亮的第 6 阶主色，如 `#1677ff` → `#1668dc`）；
  - 暗色下 `colorPrimaryBg` / `colorPrimaryBgHover` 被覆盖为 `colorPrimaryBorder` / `colorPrimaryBorderHover`，与 antd 实现一致；
  - 中性色的 alpha / 亮度系数在亮暗两套中不同（如 `colorText` 亮 0.88 / 暗 0.85）。
- **实色调整方向相反**：实色调整在亮色主题为 darken、暗色主题为 lighten，这是暗色背景上保持层次感的关键。
- **性能提示**：getter 每次调用都会解析 `css` 字符串为 `Color`；在热点路径（如 build 方法高频执行）请先取出 `Color` 缓存为局部变量，或由 `antd_theme` 层统一缓存。
- **与 antd_theme 包的关系**：本包不持有全局主题状态；主题的注册、切换与 `ThemeData` 式消费入口在 `antd_theme` 中，业务代码应优先通过 `antd_theme` 获取当前 `AntColorTokens`，而非自行调用工厂。
- **colorBgBlur 亮色为透明**：与 antd 一致，亮色主题不提供毛玻璃背景色。
