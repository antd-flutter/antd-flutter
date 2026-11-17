<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRgb

> 种类：类

```dart
class AntRgb
```

RGB 颜色模型值。

```dart
final rgb = AntRgb(r: 22, g: 119, b: 255);
final color = AntFastColor.of(rgb);
```

## 构造函数

### `AntRgb({required this.r, required this.g, required this.b, this.a = 1})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `r` | `int` | 可选 | — |
| `g` | `int` | 可选 | — |
| `b` | `int` | 可选 | — |
| `a` | `double` | = 1 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `a` | `double` | 透明度（0-1），默认 1 |
| `b` | `int` | 蓝色通道（0-255） |
| `g` | `int` | 绿色通道（0-255） |
| `r` | `int` | 红色通道（0-255） |

