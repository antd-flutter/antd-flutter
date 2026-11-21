<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPasscodeInput

> 种类：类

```dart
class AntPasscodeInput
```

密码格子输入 — 用于验证码/密码场景的格子输入组件。

对齐 antd-mobile React PasscodeInput。默认内置 `AntNumberKeyboard`，
点击格子区域可展开/收起键盘。

## 构造函数

### `AntPasscodeInput({super.key, this.value, this.defaultValue = '', this.onChange, this.onFill, this.length = 6, this.plain = false, this.error = false, this.separated = false, this.keyboard = true, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String` | = '' | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onFill` | `ValueChanged<String>?` | 可选 | — |
| `length` | `int` | = 6 | — |
| `plain` | `bool` | = false | — |
| `error` | `bool` | = false | — |
| `separated` | `bool` | = false | — |
| `keyboard` | `bool` | = true | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动展开键盘 |
| `defaultValue` | `String` | 非受控初始值 |
| `error` | `bool` | 是否错误状态 |
| `keyboard` | `bool` | 是否内置数字键盘 |
| `length` | `int` | 格子数量 |
| `onChange` | `ValueChanged<String>?` | 值变化回调 |
| `onFill` | `ValueChanged<String>?` | 填满回调（值长度达到 length 时触发） |
| `plain` | `bool` | 是否明文展示 |
| `separated` | `bool` | 是否格子分离 |
| `value` | `String?` | 受控当前值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPasscodeInput>` | — |

