<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSegmented

> 种类：类

```dart
class AntSegmented
```

分段控制器 — 展示多个选项并允许用户选择其中单个选项。

对齐 antd React Segmented 组件。选项为任意类型 `T`，字符串选项可直接
`AntSegmented(options: ['日', '周', '月'])`。

## 构造函数

### `AntSegmented({super.key, required this.options, this.value, this.defaultValue, this.labelOf, this.labelBuilder, this.iconBuilder, this.itemBuilder, this.disabledOf, this.onChange, this.block = false, this.size = AntSegmentedSize.middle, this.disabled = false, this.shape = AntSegmentedShape.rounded, this.direction = AntSegmentedDirection.horizontal})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `options` | `List<T>` | 可选 | — |
| `value` | `T?` | 可选 | — |
| `defaultValue` | `T?` | 可选 | — |
| `labelOf` | `String Function(T item)?` | 可选 | — |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `iconBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `onChange` | `ValueChanged<T>?` | 可选 | — |
| `block` | `bool` | = false | — |
| `size` | `AntSegmentedSize` | = AntSegmentedSize.middle | — |
| `disabled` | `bool` | = false | — |
| `shape` | `AntSegmentedShape` | = AntSegmentedShape.rounded | — |
| `direction` | `AntSegmentedDirection` | = AntSegmentedDirection.horizontal | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `block` | `bool` | 是否占满整行 |
| `defaultValue` | `T?` | 非受控初始选中值（缺省为 options 首项） |
| `direction` | `AntSegmentedDirection` | 排列方向（对齐 antd orientation）：horizontal（默认）/ vertical |
| `disabled` | `bool` | 是否全局禁用 |
| `disabledOf` | `bool Function(T item)?` | 选项是否禁用 |
| `iconBuilder` | `Widget Function(BuildContext context, T item)?` | 选项图标的自定义渲染 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 整项内容自定义渲染（含图标与文本），优先级最高 |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 选项文本的自定义渲染 |
| `labelOf` | `String Function(T item)?` | 选项的字符串 label 简写（未提供 labelBuilder 时作为文本渲染） |
| `onChange` | `ValueChanged<T>?` | 选中值变化回调 |
| `options` | `List<T>` | 选项列表（任意模型） |
| `shape` | `AntSegmentedShape` | 形状 |
| `size` | `AntSegmentedSize` | 控件尺寸 |
| `value` | `T?` | 受控选中值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSegmented<T>>` | — |

