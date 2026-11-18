<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSegmented

> 种类：类

```dart
class AntSegmented
```

分段控制器 — 展示多个选项并允许用户选择其中单个选项。

对齐 antd React Segmented 组件。

## 构造函数

### `AntSegmented({super.key, required this.options, this.value, this.defaultValue, this.onChange, this.block = false, this.size = AntSegmentedSize.middle, this.disabled = false, this.shape = AntSegmentedShape.rounded, this.direction = AntSegmentedDirection.horizontal})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `options` | `List<Object>` | 可选 | — |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `block` | `bool` | = false | — |
| `size` | `AntSegmentedSize` | = AntSegmentedSize.middle | — |
| `disabled` | `bool` | = false | — |
| `shape` | `AntSegmentedShape` | = AntSegmentedShape.rounded | — |
| `direction` | `AntSegmentedDirection` | = AntSegmentedDirection.horizontal | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `block` | `bool` | 是否占满整行 |
| `defaultValue` | `String?` | 非受控初始选中值（缺省为 options 首项的值） |
| `direction` | `AntSegmentedDirection` | 排列方向（对齐 antd orientation）：horizontal（默认）/ vertical |
| `disabled` | `bool` | 是否全局禁用 |
| `onChange` | `ValueChanged<String>?` | 选中值变化回调 |
| `options` | `List<Object>` | 选项列表，支持 String 或 AntSegmentedItem |
| `shape` | `AntSegmentedShape` | 形状 |
| `size` | `AntSegmentedSize` | 控件尺寸 |
| `value` | `String?` | 受控选中值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSegmented>` | — |

