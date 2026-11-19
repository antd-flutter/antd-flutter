<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntBorderBeam

> 种类：类

```dart
class AntBorderBeam
```

边框流光 — 圆角矩形边框上有一段渐变流光沿边框循环移动。

## 构造函数

### `AntBorderBeam({super.key, required this.child, this.size = kAntBorderBeamDefaultSize, this.colorPrimary, this.colorSecondary, this.duration = const Duration(seconds: kAntBorderBeamDefaultDurationSeconds), this.reverse = false, this.borderRadius, this.initialOffset = 0, this.padding})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `size` | `double` | = kAntBorderBeamDefaultSize | — |
| `colorPrimary` | `Color?` | 可选 | — |
| `colorSecondary` | `Color?` | 可选 | — |
| `duration` | `Duration` | = const Duration(seconds: kAntBorderBeamDefaultDurationSeconds) | — |
| `reverse` | `bool` | = false | — |
| `borderRadius` | `BorderRadius?` | 可选 | — |
| `initialOffset` | `double` | = 0 | — |
| `padding` | `EdgeInsets?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `borderRadius` | `BorderRadius?` | 圆角 |
| `child` | `Widget` | 容器内容 |
| `colorPrimary` | `Color?` | 流光主色，默认取主题 colorPrimary |
| `colorSecondary` | `Color?` | 流光副色，默认取主题 colorBorder |
| `duration` | `Duration` | 动画周期，默认 6 秒 |
| `initialOffset` | `double` | 初始相位（0~1），默认 0 |
| `padding` | `EdgeInsets?` | 内容内边距 |
| `reverse` | `bool` | 是否反向流动，默认 false |
| `size` | `double` | 边框宽度，默认 3 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntBorderBeam>` | — |

