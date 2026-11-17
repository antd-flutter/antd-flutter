<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antParseColor

> 种类：函数

```dart
Color antParseColor(String cssColor)
```

解析 CSS 颜色字符串为 Flutter `Color`。

支持 `#rgb`、`#rrggbb`、`#rrggbbaa`（可带前导 `#`）、
`rgb(r,g,b)` 与 `rgba(r,g,b,a)` 格式；数值两侧允许空白。

`cssColor` 为待解析的 CSS 颜色字符串，前导/尾随空白会被忽略。

返回对应的 `Color`；带 `#rrggbbaa` 时第 1 个字节作为 alpha（00 为全透明）。
若格式无法识别或通道缺失，返回不透明黑色（`#000000`）作为兜底值，
不抛出异常。

注意：静默兜底便于容错但可能掩盖格式错误，解析外部输入
（如后端下发的颜色）时建议先做格式校验或对比解析结果。

```dart
final primary = antParseColor('#1677FF'); // Color(0xFF1677FF)
final semi = antParseColor('rgba(22, 119, 255, 0.5)');
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `cssColor` | `String` | 可选 | 为待解析的 CSS 颜色字符串，前导/尾随空白会被忽略。 |

返回 `Color`。

