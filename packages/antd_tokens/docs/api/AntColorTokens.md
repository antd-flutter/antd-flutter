<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntColorTokens

> 种类：类

```dart
class AntColorTokens
```

Ant Design 颜色令牌集。

包含 antd MapToken + AliasToken 中的全部颜色字段，
以 Flutter `Color` 形式提供，同时保留 CSS 字符串（`css`）用于调试与导出。

在 antd v6 令牌派生链中，本类同时覆盖两层：

```text
AntSeedToken（种子）
  └─ AntColorTokens.light / AntColorTokens.dark
       ├─ Map Token 层：色板派生（colorPrimaryBg…TextActive 等 10 阶）
       └─ Alias Token 层：语义别名（colorSplit、controlItemBgHover 等）
```

亮/暗主题的差异体现在：
- 色板使用 `dark` 主题算法生成，且 `colorPrimaryBg` 映射为 `colorPrimaryBorder`；
- 中性色（文字/填充/背景/边框）采用不同的 alpha / 亮度系数；
- 实色调整在亮色为 darken、暗色为 lighten，以在暗背景上保持层次感；
- `colorBgBlur` 亮色为透明（与 antd 一致，亮色主题不提供毛玻璃背景色）。

使用场景：
- 通过 `antd_theme` 装配亮色 / 暗色主题（本类是主题颜色的唯一来源）；
- Widget 层按语义取色，如 `colorBgContainer`、`colorTextSecondary`；
- 定制品牌色后借助 `css` 与 antd Web 端令牌值对拍。

性能提示：getter 每次调用都会解析 `css` 字符串为 `Color`；热点路径
（如 build 方法高频执行）请先取出 `Color` 缓存为局部变量，或由
`antd_theme` 层统一缓存。业务代码应优先通过 `antd_theme` 获取当前
`AntColorTokens`，而非自行调用工厂。

```dart
const seed = AntSeedToken(colorPrimary: '#6a3ce8');
final light = AntColorTokens.light(seed);
final dark = AntColorTokens.dark(seed);
light.colorPrimary; // #6a3ce8
dark.colorPrimary;  // 暗色色板第 6 阶（比亮色更亮）
```

## 构造函数

### `AntColorTokens._({required this.css, required this.isDark})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `css` | `AntColorTokensCss` | 可选 | — |
| `isDark` | `bool` | 可选 | — |

### `AntColorTokens._generate(AntSeedToken seed, {required bool isDark})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken` | 可选 | — |
| `isDark` | `bool` | 可选 | — |

### `AntColorTokens.dark(AntSeedToken seed)`

Generates the dark-theme color tokens from a seed.

对应 antd `theme.darkAlgorithm` 的颜色部分：色板按 `dark` 主题生成，
且暗色下 `colorPrimaryBg`/`colorPrimaryBgHover` 取边框色（与 antd 一致）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken` | 可选 | — |

### `AntColorTokens.light(AntSeedToken seed)`

Generates the light-theme color tokens from a seed.

对应 antd `theme.defaultAlgorithm` 的颜色部分：
色板按 `default` 主题生成，中性色基于 `#fff` 背景、`#000` 文字。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `css` | `AntColorTokensCss` | CSS 字符串形式的原始令牌值（调试与导出用），见 AntColorTokensCss |
| `isDark` | `bool` | Whether this token set was generated for the dark theme. |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `colorBgBase` | `Color` | 背景基色（亮 #fff / 暗 #000，派生自种子） |
| `colorBgBlur` | `Color` | 毛玻璃背景色（暗色为基色 4% alpha，亮色透明） |
| `colorBgContainer` | `Color` | 容器背景色（亮色等于基色，暗色 lighten 8%） |
| `colorBgContainerDisabled` | `Color` | 禁用容器背景色（Alias：等于 colorFillTertiary） |
| `colorBgElevated` | `Color` | 浮层背景色（暗色 lighten 12%，亮色等于基色） |
| `colorBgLayout` | `Color` | 布局背景色（亮色 darken 4%，暗色等于基色） |
| `colorBgMask` | `Color` | 遮罩背景色（黑色 45% 透明度） |
| `colorBgSolid` | `Color` | 实底背景色（基色 100%/暗色 95% alpha） |
| `colorBgSolidActive` | `Color` | 实底背景 active 色（基色 95%/暗色 90% alpha） |
| `colorBgSolidHover` | `Color` | 实底背景 hover 色（基色 75%/暗色 100% alpha） |
| `colorBgSpotlight` | `Color` | 聚光背景色（亮色为文字基色 85% alpha，暗色 lighten 26%） |
| `colorBgTextActive` | `Color` | 文字背景 active 色（Alias：等于 colorFill） |
| `colorBgTextHover` | `Color` | 文字背景 hover 色（Alias：等于 colorFillSecondary） |
| `colorBorder` | `Color` | 默认边框色（背景基色 darken 15%/暗色 lighten 26%） |
| `colorBorderBg` | `Color` | 边框与背景交界色（Alias：等于 colorBgContainer） |
| `colorBorderDisabled` | `Color` | 禁用态边框色（与 colorBorder 同值） |
| `colorBorderSecondary` | `Color` | 次级边框色（背景基色 darken 6%/暗色 lighten 19%） |
| `colorError` | `Color` | 错误色色板第 6 阶主色值（色板第 6 阶） |
| `colorErrorActive` | `Color` | 错误色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorErrorAffix` | `Color` | 错误色缀件色（Alias：等于 colorError） |
| `colorErrorBg` | `Color` | 错误色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorErrorBgActive` | `Color` | — |
| `colorErrorBgHover` | `Color` | 错误色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorErrorBgHoverFilled` | `Color` | 错误色填充 hover 背景（色板第 2/4 阶 50% 混合） |
| `colorErrorBorder` | `Color` | 错误色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorErrorBorderHover` | `Color` | 错误色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorErrorHover` | `Color` | 错误色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorErrorOutline` | `Color` | 错误色焦点轮廓色（Alias：colorErrorBg 的最小 alpha 等价色） |
| `colorErrorText` | `Color` | 错误色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorErrorTextActive` | `Color` | 错误色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorErrorTextHover` | `Color` | 错误色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorFill` | `Color` | 默认填充色（文字基色 15%/暗色 18% alpha） |
| `colorFillAlter` | `Color` | 斑马纹/间隔填充色（Alias：等于 colorFillQuaternary） |
| `colorFillContent` | `Color` | 内容填充色（Alias：等于 colorFillSecondary） |
| `colorFillContentHover` | `Color` | 内容填充 hover 色（Alias：等于 colorFill） |
| `colorFillQuaternary` | `Color` | 四级填充色（基色 2%/暗色 4% alpha） |
| `colorFillSecondary` | `Color` | 次级填充色（基色 6%/暗色 12% alpha） |
| `colorFillTertiary` | `Color` | 三级填充色（基色 4%/暗色 8% alpha） |
| `colorHighlight` | `Color` | 高亮色（Alias：等于 colorError） |
| `colorIcon` | `Color` | 图标默认色（Alias：等于 colorTextTertiary） |
| `colorIconHover` | `Color` | 图标 hover 色（Alias：等于 colorText） |
| `colorInfo` | `Color` | 信息色色板第 6 阶主色值（色板第 6 阶） |
| `colorInfoActive` | `Color` | 信息色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorInfoBg` | `Color` | 信息色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorInfoBgHover` | `Color` | 信息色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorInfoBorder` | `Color` | 信息色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorInfoBorderHover` | `Color` | 信息色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorInfoHover` | `Color` | 信息色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorInfoText` | `Color` | 信息色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorInfoTextActive` | `Color` | 信息色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorInfoTextHover` | `Color` | 信息色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorLink` | `Color` | 链接色（种子 colorLink/colorInfo 色板第 6 阶） |
| `colorLinkActive` | `Color` | 链接 active 色（链接色板第 7 阶） |
| `colorLinkHover` | `Color` | 链接 hover 色（链接色板第 4 阶） |
| `colorPrimary` | `Color` | 主色色板第 6 阶主色值（色板第 6 阶） |
| `colorPrimaryActive` | `Color` | 主色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorPrimaryBg` | `Color` | 主色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorPrimaryBgHover` | `Color` | 主色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorPrimaryBorder` | `Color` | 主色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorPrimaryBorderHover` | `Color` | 主色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorPrimaryHover` | `Color` | 主色hover 态色值（色板中间阶） |
| `colorPrimaryText` | `Color` | 主色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorPrimaryTextActive` | `Color` | 主色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorPrimaryTextHover` | `Color` | 主色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorShadow` | `Color` | 阴影基色（派生自种子 AntSeedToken.colorShadow） |
| `colorSplit` | `Color` | 分割线色（Alias：colorBorderSecondary 在容器背景上的最小 alpha 等价色） |
| `colorSuccess` | `Color` | 成功色色板第 6 阶主色值（色板第 6 阶） |
| `colorSuccessActive` | `Color` | 成功色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorSuccessBg` | `Color` | 成功色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorSuccessBgHover` | `Color` | 成功色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorSuccessBorder` | `Color` | 成功色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorSuccessBorderHover` | `Color` | 成功色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorSuccessHover` | `Color` | 成功色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorSuccessText` | `Color` | 成功色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorSuccessTextActive` | `Color` | 成功色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorSuccessTextHover` | `Color` | 成功色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorText` | `Color` | 默认文字色（文字基色 88%/暗色 85% alpha） |
| `colorTextBase` | `Color` | 文字基色（亮 #000 / 暗 #fff，派生自种子） |
| `colorTextDescription` | `Color` | 描述文字色（Alias：等于 colorTextTertiary） |
| `colorTextDisabled` | `Color` | 禁用态文字色（Alias：等于 colorTextQuaternary） |
| `colorTextHeading` | `Color` | 标题文字色（Alias：等于 colorText） |
| `colorTextLabel` | `Color` | 表单标签文字色（Alias：等于 colorTextSecondary） |
| `colorTextLightSolid` | `Color` | 深色底上的白色文字色（Alias：等于 colorWhite） |
| `colorTextPlaceholder` | `Color` | 占位符文字色（Alias：等于 colorTextQuaternary） |
| `colorTextQuaternary` | `Color` | 四级文字色（基色 25% alpha） |
| `colorTextSecondary` | `Color` | 次要文字色（基色 65% alpha） |
| `colorTextTertiary` | `Color` | 三级文字色（基色 45% alpha） |
| `colorWarning` | `Color` | 警告色色板第 6 阶主色值（色板第 6 阶） |
| `colorWarningActive` | `Color` | 警告色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorWarningAffix` | `Color` | 警告色缀件色（Alias：等于 colorWarning） |
| `colorWarningBg` | `Color` | 警告色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorWarningBgHover` | `Color` | 警告色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorWarningBorder` | `Color` | 警告色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorWarningBorderHover` | `Color` | 警告色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorWarningHover` | `Color` | 警告色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorWarningOutline` | `Color` | 警告色焦点轮廓色（Alias：colorWarningBg 的最小 alpha 等价色） |
| `colorWarningText` | `Color` | 警告色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorWarningTextActive` | `Color` | 警告色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorWarningTextHover` | `Color` | 警告色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorWhite` | `Color` | 纯白色常量 #fff |
| `controlItemBgActive` | `Color` | 控件条目选中背景（Alias：等于 colorPrimaryBg） |
| `controlItemBgActiveDisabled` | `Color` | 控件条目选中禁用背景（Alias：等于 colorFill） |
| `controlItemBgActiveHover` | `Color` | 控件条目选中 hover 背景（Alias：等于 colorPrimaryBgHover） |
| `controlItemBgHover` | `Color` | 控件条目 hover 背景（Alias：等于 colorFillTertiary） |
| `controlOutline` | `Color` | 控件焦点轮廓色（Alias：colorPrimaryBg 在容器背景上的最小 alpha 等价色） |
| `controlTmpOutline` | `Color` | 控件临时轮廓色（Alias：等于 colorFillQuaternary） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_generateAlias` | `AntColorTokensCss` | — |

