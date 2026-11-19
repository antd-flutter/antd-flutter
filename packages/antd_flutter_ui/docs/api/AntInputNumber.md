<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInputNumber

> 种类：类

```dart
class AntInputNumber
```

数字输入框 — 支持步进按钮、上下限、精度控制。

## 构造函数

### `AntInputNumber({super.key, this.value, this.defaultValue, this.min, this.max, this.step = 1, this.precision, this.disabled = false, this.controls = AntInputNumberControls.upDown, this.size = AntInputSize.middle, this.status = AntInputStatus.normal, this.onChange, this.onStep, this.placeholder, this.prefix, this.addonBefore, this.addonAfter, this.keyboardType, this.bordered = true, this.focusNode, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double?` | 可选 | — |
| `defaultValue` | `double?` | 可选 | — |
| `min` | `double?` | 可选 | — |
| `max` | `double?` | 可选 | — |
| `step` | `double` | = 1 | — |
| `precision` | `int?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `controls` | `AntInputNumberControls` | = AntInputNumberControls.upDown | — |
| `size` | `AntInputSize` | = AntInputSize.middle | — |
| `status` | `AntInputStatus` | = AntInputStatus.normal | — |
| `onChange` | `ValueChanged<double?>?` | 可选 | — |
| `onStep` | `ValueChanged<double?>?` | 可选 | — |
| `placeholder` | `String?` | 可选 | — |
| `prefix` | `Widget?` | 可选 | — |
| `addonBefore` | `Widget?` | 可选 | — |
| `addonAfter` | `Widget?` | 可选 | — |
| `keyboardType` | `TextInputType?` | 可选 | — |
| `bordered` | `bool` | = true | — |
| `focusNode` | `FocusNode?` | 可选 | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `addonAfter` | `Widget?` | 后置标签 |
| `addonBefore` | `Widget?` | 前置标签 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `bordered` | `bool` | 是否显示边框 |
| `controls` | `AntInputNumberControls` | 步进按钮模式 |
| `defaultValue` | `double?` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `focusNode` | `FocusNode?` | 焦点节点 |
| `keyboardType` | `TextInputType?` | 键盘类型 |
| `max` | `double?` | 最大值 |
| `min` | `double?` | 最小值 |
| `onChange` | `ValueChanged<double?>?` | 变化回调 |
| `onStep` | `ValueChanged<double?>?` | 步进回调 |
| `placeholder` | `String?` | 占位文本 |
| `precision` | `int?` | 数值精度（小数位数） |
| `prefix` | `Widget?` | 前缀 |
| `size` | `AntInputSize` | 尺寸 |
| `status` | `AntInputStatus` | 校验状态 |
| `step` | `double` | 步长 |
| `value` | `double?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntInputNumber>` | — |

