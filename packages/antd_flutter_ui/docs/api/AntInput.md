<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInput

> 种类：类

```dart
class AntInput
```

输入框 — 通过鼠标或键盘输入内容，是最基础的表单域包装。

对齐 antd React Input 组件，支持前后缀、前后置标签、清除、字数统计、
校验状态与三种尺寸。

```dart
AntInput(
  placeholder: '请输入',
  onChange: (v) => print(v),
)
```

## 构造函数

### `AntInput({super.key, this.value, this.defaultValue, this.onChange, this.onPressEnter, this.disabled = false, this.size = AntInputSize.middle, this.prefix, this.suffix, this.addonBefore, this.addonAfter, this.allowClear = false, this.maxLength, this.showCount = false, this.status = AntInputStatus.normal, this.placeholder, this.readOnly = false, this.bordered = true, this.keyboardType, this.focusNode, this.controller, this.autofocus = false, this.obscureText = false, this.inputFormatters})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onPressEnter` | `VoidCallback?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `size` | `AntInputSize` | = AntInputSize.middle | — |
| `prefix` | `Widget?` | 可选 | — |
| `suffix` | `Widget?` | 可选 | — |
| `addonBefore` | `Widget?` | 可选 | — |
| `addonAfter` | `Widget?` | 可选 | — |
| `allowClear` | `bool` | = false | — |
| `maxLength` | `int?` | 可选 | — |
| `showCount` | `bool` | = false | — |
| `status` | `AntInputStatus` | = AntInputStatus.normal | — |
| `placeholder` | `String?` | 可选 | — |
| `readOnly` | `bool` | = false | — |
| `bordered` | `bool` | = true | — |
| `keyboardType` | `TextInputType?` | 可选 | — |
| `focusNode` | `FocusNode?` | 可选 | — |
| `controller` | `TextEditingController?` | 可选 | — |
| `autofocus` | `bool` | = false | — |
| `obscureText` | `bool` | = false | — |
| `inputFormatters` | `List<TextInputFormatter>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `addonAfter` | `Widget?` | 后置标签 |
| `addonBefore` | `Widget?` | 前置标签 |
| `allowClear` | `bool` | 是否显示清除按钮 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `bordered` | `bool` | 是否显示边框 |
| `controller` | `TextEditingController?` | 文本控制器 |
| `defaultValue` | `String?` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `focusNode` | `FocusNode?` | 焦点节点 |
| `inputFormatters` | `List<TextInputFormatter>?` | 输入格式化 |
| `keyboardType` | `TextInputType?` | 键盘类型 |
| `maxLength` | `int?` | 最大输入长度 |
| `obscureText` | `bool` | 是否隐藏文本（密码框用） |
| `onChange` | `ValueChanged<String>?` | 输入变化回调 |
| `onPressEnter` | `VoidCallback?` | 按下回车回调 |
| `placeholder` | `String?` | 占位文本 |
| `prefix` | `Widget?` | 前缀图标 |
| `readOnly` | `bool` | 是否只读 |
| `showCount` | `bool` | 是否显示字数统计 |
| `size` | `AntInputSize` | 尺寸 |
| `status` | `AntInputStatus` | 校验状态 |
| `suffix` | `Widget?` | 后缀图标 |
| `value` | `String?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntInput>` | — |

