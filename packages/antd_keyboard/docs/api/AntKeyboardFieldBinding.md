<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardFieldBinding

> 种类：类

```dart
class AntKeyboardFieldBinding
```

键盘文本绑定：把 `AntKeyboardController` 连接到真实的
`TextEditingController` / `FocusNode`。

设计吸收自 `flutter_onscreen_keyboard` 的 `OnscreenKeyboardController`
与 field state 绑定：软键盘不再只回调字符串，而是直接在光标/选区处编辑
文本，支持 inputFormatters、`enter` 提交/换行、`tab` 插入、emoji 退格。

## 构造函数

### `AntKeyboardFieldBinding({required this.controller, this.focusNode, this.maxLines = 1, this.inputFormatters = const [], this.onChanged})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `controller` | `TextEditingController` | 可选 | — |
| `focusNode` | `FocusNode?` | 可选 | — |
| `maxLines` | `int` | = 1 | — |
| `inputFormatters` | `List<TextInputFormatter>` | = const [] | — |
| `onChanged` | `ValueChanged<String>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `controller` | `TextEditingController` | — |
| `focusNode` | `FocusNode?` | — |
| `inputFormatters` | `List<TextInputFormatter>` | — |
| `maxLines` | `int` | — |
| `onChanged` | `ValueChanged<String>?` | — |

