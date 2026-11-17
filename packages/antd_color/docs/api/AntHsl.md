<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntHsl

> 种类：类

```dart
class AntHsl
```

HSL 颜色模型值。

```dart
final hsl = AntHsl(h: 210, s: 0.9, l: 0.5);
final color = AntFastColor.of(hsl);
```

## 构造函数

### `AntHsl({required this.h, required this.s, required this.l, this.a = 1})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `h` | `double` | 可选 | — |
| `s` | `double` | 可选 | — |
| `l` | `double` | 可选 | — |
| `a` | `double` | = 1 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `a` | `double` | 透明度（0-1），默认 1 |
| `h` | `double` | 色相（0-360） |
| `l` | `double` | 亮度（0-1） |
| `s` | `double` | HSL 饱和度（0-1） |

