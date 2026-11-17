<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 barrel 变更后重跑 gen-docs 命令 -->

# antd_tokens API 索引

> 自动生成时间：2026-11-17T13:07:28.180308；共 17 个顶层导出。
>
> antd_tokens — Ant Design v6 Design Token 系统
> 
> 对应 antd 的 Seed → Map → Alias 三层令牌推导链：
> - [AntSeedToken] — 种子令牌（colorPrimary、fontSize、borderRadius 等）
> - [antGenFontSizes] / [antGenRadius] / … — 令牌生成算法
> - [AntColorTokens] — 完整颜色令牌集（亮色/暗色工厂）
> - [AntShadowTokens] — 阴影令牌
> 
> 文件按 R25/R26 细粒度分层：
> - `src/generators/` — 令牌派生算法（font / radius / size / control_height / motion）
> - `src/css/` — CSS 字符串令牌数据层（AntColorTokensCss）
> - `ant_token_generators.dart` — generators 聚合出口（兼容既有引用）

## 顶层导出

### 类（10）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntColorTokens` | 类 | Ant Design 颜色令牌集 |
| `AntColorTokensCss` | 类 | CSS 字符串形式的颜色令牌（原始值，调试与导出用） |
| `AntControlHeightToken` | 类 | 控件高度令牌，对应 antd Map Token 的控件高度部分（genControlHeight） |
| `AntFontMapToken` | 类 | 字号映射令牌，对应 antd Map Token 的字体部分（genFontMapToken） |
| `AntFontSizePair` | 类 | 字号-行高对 |
| `AntMotionDurationToken` | 类 | 动效时长令牌，对应 antd Map Token 的 motionDuration 系列 |
| `AntRadiusToken` | 类 | 圆角令牌，对应 antd Map Token 的圆角部分（genRadius） |
| `AntSeedToken` | 类 | Ant Design 种子令牌配置 |
| `AntShadowTokens` | 类 | Ant Design 阴影令牌集 |
| `AntSizeMapToken` | 类 | 尺寸映射令牌，对应 antd Map Token 的尺寸部分（genSizeMapToken） |

### 函数（7）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `antGenControlHeight` | 函数 | Generates control height variants from a base height |
| `antGenFontMapToken` | 函数 | Generates the font map token from a base font size |
| `antGenFontSizes` | 函数 | Generates the 10-step font size ladder from a base size |
| `antGenMotionDuration` | 函数 | Generates motion duration tokens from seed motion values |
| `antGenRadius` | 函数 | Generates the radius token ladder from a base radius |
| `antGenSizeMapToken` | 函数 | Generates the size map token from seed size values |
| `antGetLineHeight` | 函数 | Computes the line height for a font size |

## 类 / 枚举成员

### `AntSeedToken`（37 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `AntFontSizePair`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `lineHeight` | 字段 | 推荐行高，按 (size + 8) / size 计算 |
| `size` | 字段 | 字号（逻辑像素），恒为偶数（除 antGenFontSizes 中回填的基准字号外） |

### `AntFontMapToken`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `fontHeight` | 字段 | 默认 fontHeight（lineHeight  fontSize 四舍五入取整） |
| `fontHeightLG` | 字段 | 大号 fontHeight |
| `fontHeightSM` | 字段 | 小号 fontHeight |
| `fontSize` | 字段 | 默认组件字号（等于基准字号） |
| `fontSizeHeading1` | 字段 | 标题 1 字号（阶梯 index 6，最大） |
| `fontSizeHeading2` | 字段 | 标题 2 字号（阶梯 index 5） |
| `fontSizeHeading3` | 字段 | 标题 3 字号（阶梯 index 4） |
| `fontSizeHeading4` | 字段 | 标题 4 字号（阶梯 index 3） |
| `fontSizeHeading5` | 字段 | 标题 5 字号（阶梯 index 2） |
| `fontSizeLG` | 字段 | 大号组件字号（阶梯 index 2） |
| `fontSizeSM` | 字段 | 小号组件字号（阶梯 index 0） |
| `fontSizeXL` | 字段 | 特大号组件字号（阶梯 index 3） |
| `lineHeight` | 字段 | 默认行高（对应 AntFontSizePair.lineHeight index 1） |
| `lineHeightHeading1` | 字段 | 标题 1 行高 |
| `lineHeightHeading2` | 字段 | 标题 2 行高 |
| `lineHeightHeading3` | 字段 | 标题 3 行高 |
| `lineHeightHeading4` | 字段 | 标题 4 行高 |
| `lineHeightHeading5` | 字段 | 标题 5 行高 |
| `lineHeightLG` | 字段 | 大号文本行高（阶梯 index 2） |
| `lineHeightSM` | 字段 | 小号文本行高（阶梯 index 0） |

### `AntRadiusToken`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `borderRadius` | 字段 | 基础圆角 |
| `borderRadiusLG` | 字段 | LG 圆角 |
| `borderRadiusOuter` | 字段 | 外部圆角 |
| `borderRadiusSM` | 字段 | SM 圆角 |
| `borderRadiusXS` | 字段 | XS 圆角 |

### `AntSizeMapToken`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `size` | 字段 | 默认间距（unit × step，默认 16） |
| `sizeLG` | 字段 | 大间距（unit × (step + 2)，默认 24） |
| `sizeMD` | 字段 | 中间距（unit × (step + 1)，默认 20） |
| `sizeMS` | 字段 | 中小间距（unit × step，默认 16） |
| `sizeSM` | 字段 | 小间距（unit × (step |
| `sizeXL` | 字段 | 超大间距（unit × (step + 4)，默认 32） |
| `sizeXS` | 字段 | 特小间距（unit × (step |
| `sizeXXL` | 字段 | 特大间距（unit × (step + 8)，默认 48） |
| `sizeXXS` | 字段 | 极小间距（unit × (step |

### `AntControlHeightToken`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `controlHeightLG` | 字段 | 大号控件高度（基准 × 1.25） |
| `controlHeightSM` | 字段 | 小号控件高度（基准 × 0.75） |
| `controlHeightXS` | 字段 | 特小号控件高度（基准 × 0.5） |

### `AntMotionDurationToken`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `fast` | 字段 | 快速动效时长（秒） |
| `mid` | 字段 | 中速动效时长（秒） |
| `slow` | 字段 | 慢速动效时长（秒） |

### `AntColorTokens`（112 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `AntShadowTokens`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntShadowTokens._` | 构造 | — |
| `AntShadowTokensgenerate` | 构造 | 从阴影基色生成阴影令牌集 |
| `boxShadow` | 字段 | 弹出层主阴影 |
| `boxShadowCard` | 字段 | Card 阴影 |
| `boxShadowDrawerDown` | 字段 | Drawer 下方阴影 |
| `boxShadowDrawerLeft` | 字段 | Drawer 左侧阴影 |
| `boxShadowDrawerRight` | 字段 | Drawer 右侧阴影 |
| `boxShadowDrawerUp` | 字段 | Drawer 上方阴影 |
| `boxShadowPopoverArrow` | 字段 | Popover 箭头阴影 |
| `boxShadowSecondary` | 字段 | 弹出层次级阴影 |
| `boxShadowTabsOverflowBottom` | 字段 | Tabs 下溢出阴影 |
| `boxShadowTabsOverflowLeft` | 字段 | Tabs 左溢出阴影 |
| `boxShadowTabsOverflowRight` | 字段 | Tabs 右溢出阴影 |
| `boxShadowTabsOverflowTop` | 字段 | Tabs 上溢出阴影 |
| `boxShadowTertiary` | 字段 | 三级阴影（轻量浮起） |

### `AntColorTokensCss`（107 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

