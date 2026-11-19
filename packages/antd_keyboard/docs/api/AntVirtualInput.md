<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntVirtualInput

> 种类：类

```dart
class AntVirtualInput
```

虚拟输入 — 通过内置数字键盘输入的只读输入框。

对齐 antd-mobile React VirtualInput。点击输入框展开数字键盘，
不唤起系统软键盘，适用于安全输入场景。

## 构造函数

### `AntVirtualInput({super.key, this.value, this.defaultValue = '', this.onChange, this.placeholder, this.clearable = false, this.disabled = false, this.confirmText, this.onEnterPress, this.randomOrder = false, this.customKey, this.keyboardLayout, this.keyboardTheme, this.keyboardDesktop = false, this.keyboardPreset, this.keyboardAlignTop = false, this.keyboardShowControlBar = false, this.autoFocus = false, this.onFocus, this.onBlur})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String` | = '' | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `placeholder` | `String?` | 可选 | — |
| `clearable` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |
| `confirmText` | `String?` | 可选 | — |
| `onEnterPress` | `ValueChanged<String>?` | 可选 | — |
| `randomOrder` | `bool` | = false | — |
| `customKey` | `String?` | 可选 | — |
| `keyboardLayout` | `AntKeyboardLayout?` | 可选 | — |
| `keyboardTheme` | `AntKeyboardThemeData?` | 可选 | — |
| `keyboardDesktop` | `bool` | = false | — |
| `keyboardPreset` | `AntKeyboardPreset?` | 可选 | — |
| `keyboardAlignTop` | `bool` | = false | — |
| `keyboardShowControlBar` | `bool` | = false | — |
| `autoFocus` | `bool` | = false | — |
| `onFocus` | `VoidCallback?` | 可选 | — |
| `onBlur` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autoFocus` | `bool` | 是否自动聚焦 |
| `clearable` | `bool` | 是否可清空 |
| `confirmText` | `String?` | 键盘确认按钮文案 |
| `customKey` | `String?` | 键盘自定义按键 |
| `defaultValue` | `String` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `keyboardAlignTop` | `bool` | 键盘弹出对齐：贴底（默认）/贴顶（桌面展示形态可切换） |
| `keyboardDesktop` | `bool` | 键盘桌面密度（展示形态由调用方决定） |
| `keyboardLayout` | `AntKeyboardLayout?` | 通用键盘布局（优先级高于 keyboardPreset |
| `keyboardPreset` | `AntKeyboardPreset?` | 键盘预设类型（便捷参数 |
| `keyboardShowControlBar` | `bool` | 桌面展示形态下显示控制条（贴底/贴顶切换按钮） |
| `keyboardTheme` | `AntKeyboardThemeData?` | 键盘主题覆盖 |
| `onBlur` | `VoidCallback?` | 失焦回调 |
| `onChange` | `ValueChanged<String>?` | 值变化回调 |
| `onEnterPress` | `ValueChanged<String>?` | 确认回调（回车/确认键） |
| `onFocus` | `VoidCallback?` | 聚焦回调 |
| `placeholder` | `String?` | 占位文案 |
| `randomOrder` | `bool` | 键盘数字是否乱序 |
| `value` | `String?` | 受控当前值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntVirtualInput>` | — |

