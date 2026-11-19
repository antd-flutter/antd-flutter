<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCheckbox

> 种类：类

```dart
class AntCheckbox
```

复选框 — 在一组备选项中进行多选。

对齐 antd React Checkbox 组件，支持半选、禁用、受控/非受控。
在 `AntCheckboxGroup` children 模式下传入 `AntCheckbox.value` 可与组联动。

## 构造函数

### `AntCheckbox({super.key, this.checked, this.defaultChecked = false, this.indeterminate = false, this.disabled = false, this.onChange, this.value, required this.child, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `checked` | `bool?` | 可选 | — |
| `defaultChecked` | `bool` | = false | — |
| `indeterminate` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |
| `onChange` | `ValueChanged<bool>?` | 可选 | — |
| `value` | `dynamic` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动聚焦 |
| `checked` | `bool?` | 受控选中状态 |
| `child` | `Widget` | 标签 |
| `defaultChecked` | `bool` | 非受控初始选中状态 |
| `disabled` | `bool` | 是否禁用 |
| `indeterminate` | `bool` | 半选状态（仅影响样式，不影响 checked） |
| `onChange` | `ValueChanged<bool>?` | 变化回调 |
| `value` | `dynamic` | 组内标识值（在 AntCheckboxGroup children 模式下用于联动） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCheckbox>` | — |

