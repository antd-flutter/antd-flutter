<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntHsv

> 种类：类

```dart
class AntHsv
```

HSV 颜色模型值。

```dart
final hsv = AntHsv(h: 210, s: 0.9, v: 1.0);
final color = AntFastColor.of(hsv);
```

## 构造函数

### `AntHsv({required this.h, required this.s, required this.v, this.a = 1})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `h` | `double` | 可选 | — |
| `s` | `double` | 可选 | — |
| `v` | `double` | 可选 | — |
| `a` | `double` | = 1 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `a` | `double` | 透明度（0-1），默认 1 |
| `h` | `double` | 色相（0-360） |
| `s` | `double` | HSV 饱和度（0-1） |
| `v` | `double` | 明度（0-1） |

