<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopupLayout

> 种类：类

```dart
class AntPopupLayout
```

弹层位置解析结果。

## 构造函数

### `AntPopupLayout({required this.direction, required this.align, required this.offset, required this.arrowOffset})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `direction` | `AntPopupDirection` | 可选 | — |
| `align` | `AntPopupAlign` | 可选 | — |
| `offset` | `Offset` | 可选 | — |
| `arrowOffset` | `double` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `align` | `AntPopupAlign` | 沿目标边缘的对齐 |
| `arrowOffset` | `double` | 箭头 tip 在气泡边缘上的位置： 垂直方向为距气泡左缘的距离，水平方向为距气泡上缘的距离 |
| `direction` | `AntPopupDirection` | 翻转决策后的最终方向 |
| `offset` | `Offset` | 气泡左上角相对视口（Overlay 全屏坐标系）的位置 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isVertical` | `bool` | 方向是否垂直（top/bottom） |
| `scaleAlignment` | `Offset` | 气泡出现动画的对齐锚点向量（朝向触发元素一侧 |

