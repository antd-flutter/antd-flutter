<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSwitch

> 种类：类

```dart
class AntSwitch
```

开关组件 — 对齐 antd React Switch。

## 构造函数

### `AntSwitch({super.key, this.checked, this.defaultChecked = false, this.disabled = false, this.loading = false, this.size = AntSwitchSize.middle, this.checkedChildren, this.unCheckedChildren, this.onChange, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `checked` | `bool?` | 可选 | — |
| `defaultChecked` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |
| `loading` | `bool` | = false | — |
| `size` | `AntSwitchSize` | = AntSwitchSize.middle | — |
| `checkedChildren` | `Widget?` | 可选 | — |
| `unCheckedChildren` | `Widget?` | 可选 | — |
| `onChange` | `ValueChanged<bool>?` | 可选 | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动聚焦 |
| `checked` | `bool?` | 受控选中状态 |
| `checkedChildren` | `Widget?` | 选中时显示的内容 |
| `defaultChecked` | `bool` | 非受控初始选中状态 |
| `disabled` | `bool` | 是否禁用 |
| `loading` | `bool` | 是否加载中（此时不可切换） |
| `onChange` | `ValueChanged<bool>?` | 变化回调 |
| `size` | `AntSwitchSize` | 尺寸 |
| `unCheckedChildren` | `Widget?` | 未选中时显示的内容 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSwitch>` | — |

