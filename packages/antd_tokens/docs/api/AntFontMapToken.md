<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFontMapToken

> 种类：类

```dart
class AntFontMapToken
```

字号映射令牌，对应 antd Map Token 的字体部分（`genFontMapToken`）。

由 `antGenFontMapToken` 从基准字号派生，包含组件字号、
标题字号、行高与 fontHeight 三组映射。

## 构造函数

### `AntFontMapToken({required this.fontSizeSM, required this.fontSize, required this.fontSizeLG, required this.fontSizeXL, required this.fontSizeHeading1, required this.fontSizeHeading2, required this.fontSizeHeading3, required this.fontSizeHeading4, required this.fontSizeHeading5, required this.lineHeight, required this.lineHeightLG, required this.lineHeightSM, required this.fontHeight, required this.fontHeightLG, required this.fontHeightSM, required this.lineHeightHeading1, required this.lineHeightHeading2, required this.lineHeightHeading3, required this.lineHeightHeading4, required this.lineHeightHeading5})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `fontSizeSM` | `double` | 可选 | — |
| `fontSize` | `double` | 可选 | — |
| `fontSizeLG` | `double` | 可选 | — |
| `fontSizeXL` | `double` | 可选 | — |
| `fontSizeHeading1` | `double` | 可选 | — |
| `fontSizeHeading2` | `double` | 可选 | — |
| `fontSizeHeading3` | `double` | 可选 | — |
| `fontSizeHeading4` | `double` | 可选 | — |
| `fontSizeHeading5` | `double` | 可选 | — |
| `lineHeight` | `double` | 可选 | — |
| `lineHeightLG` | `double` | 可选 | — |
| `lineHeightSM` | `double` | 可选 | — |
| `fontHeight` | `double` | 可选 | — |
| `fontHeightLG` | `double` | 可选 | — |
| `fontHeightSM` | `double` | 可选 | — |
| `lineHeightHeading1` | `double` | 可选 | — |
| `lineHeightHeading2` | `double` | 可选 | — |
| `lineHeightHeading3` | `double` | 可选 | — |
| `lineHeightHeading4` | `double` | 可选 | — |
| `lineHeightHeading5` | `double` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `fontHeight` | `double` | 默认 fontHeight（lineHeight  fontSize 四舍五入取整） |
| `fontHeightLG` | `double` | 大号 fontHeight |
| `fontHeightSM` | `double` | 小号 fontHeight |
| `fontSize` | `double` | 默认组件字号（等于基准字号） |
| `fontSizeHeading1` | `double` | 标题 1 字号（阶梯 index 6，最大） |
| `fontSizeHeading2` | `double` | 标题 2 字号（阶梯 index 5） |
| `fontSizeHeading3` | `double` | 标题 3 字号（阶梯 index 4） |
| `fontSizeHeading4` | `double` | 标题 4 字号（阶梯 index 3） |
| `fontSizeHeading5` | `double` | 标题 5 字号（阶梯 index 2） |
| `fontSizeLG` | `double` | 大号组件字号（阶梯 index 2） |
| `fontSizeSM` | `double` | 小号组件字号（阶梯 index 0） |
| `fontSizeXL` | `double` | 特大号组件字号（阶梯 index 3） |
| `lineHeight` | `double` | 默认行高（对应 AntFontSizePair.lineHeight index 1） |
| `lineHeightHeading1` | `double` | 标题 1 行高 |
| `lineHeightHeading2` | `double` | 标题 2 行高 |
| `lineHeightHeading3` | `double` | 标题 3 行高 |
| `lineHeightHeading4` | `double` | 标题 4 行高 |
| `lineHeightHeading5` | `double` | 标题 5 行高 |
| `lineHeightLG` | `double` | 大号文本行高（阶梯 index 2） |
| `lineHeightSM` | `double` | 小号文本行高（阶梯 index 0） |

