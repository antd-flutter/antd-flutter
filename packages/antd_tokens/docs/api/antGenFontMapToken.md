<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGenFontMapToken

> 种类：函数

```dart
AntFontMapToken antGenFontMapToken(double fontSize)
```

Generates the font map token from a base font size.

对应 antd `genFontMapToken`：先经 `antGenFontSizes` 生成阶梯，
再按固定索引映射为组件字号 / 标题字号 / 行高 / fontHeight。

```dart
final font = antGenFontMapToken(14);
font.fontSize;        // 14
font.fontSizeHeading1; // 38
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `fontSize` | `double` | 可选 | — |

返回 `AntFontMapToken`。

