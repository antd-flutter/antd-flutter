<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGetLineHeight

> 种类：函数

```dart
double antGetLineHeight(double fontSize)
```

Computes the line height for a font size.

与 antd `getLineHeight` 一致：`(fontSize + 8) / fontSize`。

```dart
antGetLineHeight(14); // 22 / 14 ≈ 1.5714
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `fontSize` | `double` | 可选 | — |

返回 `double`。

