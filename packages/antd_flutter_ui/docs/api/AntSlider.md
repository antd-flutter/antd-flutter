<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSlider

> 种类：类

```dart
class AntSlider
```

滑动输入条 — 滑动型输入器，展示当前值和可选范围。

对齐 antd React Slider 组件。

## 构造函数

### `AntSlider({super.key, this.value, this.defaultValue = 0, this.min = 0, this.max = 100, this.step = 1, this.onChange, this.onChangeEnd, this.disabled = false, this.marks = const [], this.tooltipVisible = false, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double?` | 可选 | — |
| `defaultValue` | `double` | = 0 | — |
| `min` | `double` | = 0 | — |
| `max` | `double` | = 100 | — |
| `step` | `double` | = 1 | — |
| `onChange` | `ValueChanged<double>?` | 可选 | — |
| `onChangeEnd` | `ValueChanged<double>?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `marks` | `List<AntSliderMark>` | = const [] | — |
| `tooltipVisible` | `bool` | = false | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动聚焦 |
| `defaultValue` | `double` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `marks` | `List<AntSliderMark>` | 刻度标记 |
| `max` | `double` | 最大值 |
| `min` | `double` | 最小值 |
| `onChange` | `ValueChanged<double>?` | 值变化回调 |
| `onChangeEnd` | `ValueChanged<double>?` | 拖动结束回调 |
| `step` | `double` | 步长，0 表示连续 |
| `tooltipVisible` | `bool` | 提示是否常显（默认仅拖拽时显示） |
| `value` | `double?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSlider>` | — |

