<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPageIndicator

> 种类：类

```dart
class AntPageIndicator
```

Ant Design 页码指示器。

## 构造函数

### `AntPageIndicator({super.key, required this.total, this.current, this.defaultCurrent = 0, this.direction = AntPageIndicatorDirection.horizontal, this.color = AntPageIndicatorPresetColor.primary, this.dotColor, this.activeDotColor, this.dotSize, this.activeDotSize, this.dotSpacing})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `total` | `int` | 可选 | — |
| `current` | `int?` | 可选 | — |
| `defaultCurrent` | `int` | = 0 | — |
| `direction` | `AntPageIndicatorDirection` | = AntPageIndicatorDirection.horizontal | — |
| `color` | `AntPageIndicatorPresetColor` | = AntPageIndicatorPresetColor.primary | — |
| `dotColor` | `Color?` | 可选 | — |
| `activeDotColor` | `Color?` | 可选 | — |
| `dotSize` | `double?` | 可选 | — |
| `activeDotSize` | `double?` | 可选 | — |
| `dotSpacing` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeDotColor` | `Color?` | 自定义激活点颜色（覆盖 color 预设） |
| `activeDotSize` | `double?` | 激活点尺寸（逻辑像素，内部 .w 缩放 |
| `color` | `AntPageIndicatorPresetColor` | 预设配色 |
| `current` | `int?` | 受控当前页（为 null 时内部自管理，初始值取 defaultCurrent） |
| `defaultCurrent` | `int` | 非受控模式下的默认当前页 |
| `direction` | `AntPageIndicatorDirection` | 排列方向 |
| `dotColor` | `Color?` | 自定义普通点颜色（覆盖 color 预设） |
| `dotSize` | `double?` | 普通点尺寸（逻辑像素，内部 .w 缩放 |
| `dotSpacing` | `double?` | 点间距（逻辑像素，内部 .w 缩放 |
| `total` | `int` | 点总数（页数） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPageIndicator>` | — |

