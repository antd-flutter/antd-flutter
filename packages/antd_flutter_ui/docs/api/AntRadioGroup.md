<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRadioGroup

> 种类：类

```dart
class AntRadioGroup
```

单选框组 — 包裹一组 `AntRadio` / `AntRadioButton`，统一管理选中值。

对齐 antd React Radio.Group。

## 构造函数

### `AntRadioGroup({super.key, this.value, this.defaultValue, this.options = const [], this.disabled = false, this.onChange, this.optionType = AntRadioGroupOptionType.normal, this.buttonStyle = AntRadioButtonStyle.outline, this.direction = AntRadioGroupDirection.horizontal, this.children})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `T?` | 可选 | — |
| `defaultValue` | `T?` | 可选 | — |
| `options` | `List<AntRadioOption<T>>` | = const [] | — |
| `disabled` | `bool` | = false | — |
| `onChange` | `ValueChanged<T?>?` | 可选 | — |
| `optionType` | `AntRadioGroupOptionType` | = AntRadioGroupOptionType.normal | — |
| `buttonStyle` | `AntRadioButtonStyle` | = AntRadioButtonStyle.outline | — |
| `direction` | `AntRadioGroupDirection` | = AntRadioGroupDirection.horizontal | — |
| `children` | `List<Widget>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `buttonStyle` | `AntRadioButtonStyle` | 按钮风格（仅 optionType 为 button 时生效） |
| `children` | `List<Widget>?` | 直接传入 AntRadio / AntRadioButton 子组件 |
| `defaultValue` | `T?` | 非受控初始选中值 |
| `direction` | `AntRadioGroupDirection` | 排列方向 |
| `disabled` | `bool` | 是否整体禁用 |
| `onChange` | `ValueChanged<T?>?` | 变化回调 |
| `optionType` | `AntRadioGroupOptionType` | 选项风格 |
| `options` | `List<AntRadioOption<T>>` | 选项列表 |
| `value` | `T?` | 受控选中值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntRadioGroup<T>>` | — |

