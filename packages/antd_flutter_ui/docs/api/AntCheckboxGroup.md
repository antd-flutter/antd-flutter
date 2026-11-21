<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCheckboxGroup

> 种类：类

```dart
class AntCheckboxGroup
```

复选框组 — 包裹一组 `AntCheckbox`，统一管理选中值。

对齐 antd React Checkbox.Group，支持 options、受控 value、禁用。

```dart
AntCheckboxGroup<String>(
  options: const ['A', 'B'],
  onChange: (vals) => print(vals),
)

AntCheckboxGroup<Tag>(
  options: tags,                        // List<Tag>
  labelOf: (tag) => tag.name,
  onChange: (tags) => print(tags),
)
```

## 构造函数

### `AntCheckboxGroup({super.key, this.value, this.defaultValue = const [], this.options = const [], this.labelOf, this.labelBuilder, this.itemBuilder, this.disabledOf, this.disabled = false, this.onChange, this.direction = AntCheckboxGroupDirection.horizontal, this.children})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `List<T>?` | 可选 | — |
| `defaultValue` | `List<T>` | = const [] | — |
| `options` | `List<T>` | = const [] | — |
| `labelOf` | `String Function(T item)?` | 可选 | — |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `onChange` | `ValueChanged<List<T>>?` | 可选 | — |
| `direction` | `AntCheckboxGroupDirection` | = AntCheckboxGroupDirection.horizontal | — |
| `children` | `List<Widget>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<Widget>?` | 直接传入 AntCheckbox 子组件（与 options 二选一） |
| `defaultValue` | `List<T>` | 非受控初始选中值集合 |
| `direction` | `AntCheckboxGroupDirection` | 排列方向 |
| `disabled` | `bool` | 是否整体禁用 |
| `disabledOf` | `bool Function(T item)?` | 选项是否禁用 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 整项自定义渲染（含复选框外观），优先级最高 |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 选项 label 的自定义渲染 |
| `labelOf` | `String Function(T item)?` | 选项的字符串 label 简写（未提供 labelBuilder 时作为文本渲染） |
| `onChange` | `ValueChanged<List<T>>?` | 变化回调 |
| `options` | `List<T>` | 选项列表（任意模型） |
| `value` | `List<T>?` | 受控选中值集合 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCheckboxGroup<T>>` | — |

