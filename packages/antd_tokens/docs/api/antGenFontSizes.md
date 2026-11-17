<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGenFontSizes

> 种类：函数

```dart
List<AntFontSizePair> antGenFontSizes(double base)
```

Generates the 10-step font size ladder from a base size.

与 antd `genFontSizes` 一致:
- `size = base * e^(i/5)`，`i = index - 1`
- `index > 1` 时 floor，否则 ceil
- 再 `floor(intSize / 2) * 2` 取偶
- `fontSizes[1] = base`（index=1，即数组第 2 位）

注意：取整方向与取偶规则与 antd 逐行对齐，请勿"顺手优化"，
否则输出值无法与 antd Web 端对拍。

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `base` | `double` | 可选 | — |

返回 `List<AntFontSizePair>`。

