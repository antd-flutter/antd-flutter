<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntStepper

> 种类：类

```dart
class AntStepper
```

步进器 — 移动端数值调节组件。

## 构造函数

### `AntStepper({super.key, this.value, this.defaultValue, this.min, this.max, this.step = 1, this.digits, this.disabled = false, this.inputReadOnly = false, this.allowEmpty = false, this.size = AntStepperSize.middle, this.onChange, this.onFocus, this.onBlur})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double?` | 可选 | — |
| `defaultValue` | `double?` | 可选 | — |
| `min` | `double?` | 可选 | — |
| `max` | `double?` | 可选 | — |
| `step` | `double` | = 1 | — |
| `digits` | `int?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `inputReadOnly` | `bool` | = false | — |
| `allowEmpty` | `bool` | = false | — |
| `size` | `AntStepperSize` | = AntStepperSize.middle | — |
| `onChange` | `ValueChanged<double?>?` | 可选 | — |
| `onFocus` | `VoidCallback?` | 可选 | — |
| `onBlur` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowEmpty` | `bool` | 是否允许清空 |
| `defaultValue` | `double?` | 非受控初始值 |
| `digits` | `int?` | 小数位数精度 |
| `disabled` | `bool` | 是否禁用 |
| `inputReadOnly` | `bool` | 输入框是否只读 |
| `max` | `double?` | 最大值 |
| `min` | `double?` | 最小值 |
| `onBlur` | `VoidCallback?` | 失焦回调 |
| `onChange` | `ValueChanged<double?>?` | 变化回调 |
| `onFocus` | `VoidCallback?` | 聚焦回调 |
| `size` | `AntStepperSize` | 尺寸 |
| `step` | `double` | 步长 |
| `value` | `double?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntStepper>` | — |

