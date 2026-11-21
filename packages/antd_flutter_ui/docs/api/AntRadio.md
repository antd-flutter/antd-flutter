<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRadio

> 种类：类

```dart
class AntRadio
```

单选框 — 在一组备选项中进行单选。

对齐 antd React Radio 组件，支持受控/非受控、禁用。

## 构造函数

### `AntRadio({super.key, this.checked, this.defaultChecked = false, this.disabled = false, this.onChange, required this.child, this.value, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `checked` | `bool?` | 可选 | — |
| `defaultChecked` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |
| `onChange` | `ValueChanged<bool>?` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `value` | `dynamic` | 可选 | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动聚焦 |
| `checked` | `bool?` | 受控选中状态 |
| `child` | `Widget` | 标签 |
| `defaultChecked` | `bool` | 非受控初始选中状态 |
| `disabled` | `bool` | 是否禁用 |
| `onChange` | `ValueChanged<bool>?` | 变化回调 |
| `value` | `dynamic` | 在组内使用时的值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntRadio>` | — |

