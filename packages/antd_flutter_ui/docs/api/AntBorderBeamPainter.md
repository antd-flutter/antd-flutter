<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntBorderBeamPainter

> 种类：类

```dart
class AntBorderBeamPainter
```

边框流光画笔 — 普通色边框 + 沿边框循环移动的渐变流光段。

## 构造函数

### `AntBorderBeamPainter({required this.progress, required this.colorPrimary, required this.colorSecondary, required this.size, required this.borderRadius, required this.reverse})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `progress` | `Animation<double>` | 可选 | — |
| `colorPrimary` | `Color` | 可选 | — |
| `colorSecondary` | `Color` | 可选 | — |
| `size` | `double` | 可选 | — |
| `borderRadius` | `BorderRadius` | 可选 | — |
| `reverse` | `bool` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `borderRadius` | `BorderRadius` | 圆角 |
| `colorPrimary` | `Color` | 流光主色 |
| `colorSecondary` | `Color` | 流光副色 |
| `progress` | `Animation<double>` | 动画进度（0~1 循环） |
| `reverse` | `bool` | 是否反向流动 |
| `size` | `double` | 边框宽度 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `paint` | `void` | — |
| `shouldRepaint` | `bool` | — |

