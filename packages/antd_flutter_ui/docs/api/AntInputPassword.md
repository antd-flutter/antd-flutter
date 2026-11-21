<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInputPassword

> 种类：类

```dart
class AntInputPassword
```

密码框 — 在输入框基础上切换明文/密文。

对齐 antd React Input.Password，支持 visibilityToggle。

```dart
AntInputPassword(placeholder: '请输入密码')
```

## 构造函数

### `AntInputPassword({super.key, this.value, this.defaultValue, this.onChange, this.onPressEnter, this.disabled = false, this.placeholder, this.visibilityToggle = true, this.size = AntInputSize.middle, this.status = AntInputStatus.normal, this.controller, this.focusNode, this.autofocus = false, this.prefix})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onPressEnter` | `VoidCallback?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `visibilityToggle` | `bool` | = true | — |
| `size` | `AntInputSize` | = AntInputSize.middle | — |
| `status` | `AntInputStatus` | = AntInputStatus.normal | — |
| `controller` | `TextEditingController?` | 可选 | — |
| `focusNode` | `FocusNode?` | 可选 | — |
| `autofocus` | `bool` | = false | — |
| `prefix` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动聚焦 |
| `controller` | `TextEditingController?` | 文本控制器 |
| `defaultValue` | `String?` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `focusNode` | `FocusNode?` | 焦点节点 |
| `onChange` | `ValueChanged<String>?` | 输入变化回调 |
| `onPressEnter` | `VoidCallback?` | 按下回车回调 |
| `placeholder` | `String?` | 占位文本 |
| `prefix` | `Widget?` | 前缀图标 |
| `size` | `AntInputSize` | 尺寸 |
| `status` | `AntInputStatus` | 校验状态 |
| `value` | `String?` | 受控值 |
| `visibilityToggle` | `bool` | 是否显示明文切换按钮 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntInputPassword>` | — |

