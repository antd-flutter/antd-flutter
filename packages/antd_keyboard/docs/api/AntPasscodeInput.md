<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPasscodeInput

> 种类：类

```dart
class AntPasscodeInput
```

密码格子输入 — 用于验证码/密码场景的格子输入组件。

## 构造函数

### `AntPasscodeInput({super.key, this.value, this.defaultValue = '', this.onChange, this.onFill, this.onFocus, this.onBlur, this.length = 6, this.plain = false, this.error = false, this.separated = false, this.keyboard = true, this.autofocus = false, this.cellSize, this.cellGap, this.dotSize, this.borderRadius})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String` | = '' | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onFill` | `ValueChanged<String>?` | 可选 | — |
| `onFocus` | `VoidCallback?` | 可选 | — |
| `onBlur` | `VoidCallback?` | 可选 | — |
| `length` | `int` | = 6 | — |
| `plain` | `bool` | = false | — |
| `error` | `bool` | = false | — |
| `separated` | `bool` | = false | — |
| `keyboard` | `bool` | = true | — |
| `autofocus` | `bool` | = false | — |
| `cellSize` | `double?` | 可选 | — |
| `cellGap` | `double?` | 可选 | — |
| `dotSize` | `double?` | 可选 | — |
| `borderRadius` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动聚焦（移动端自动展开键盘，桌面端自动取焦） |
| `borderRadius` | `double?` | 圆角（默认 ant.s(8)） |
| `cellGap` | `double?` | 格子间距（separated 模式默认 ant.s(6)） |
| `cellSize` | `double?` | 格子尺寸（默认 ant.s(40)，对齐 antd-mobile） |
| `defaultValue` | `String` | 非受控初始值 |
| `dotSize` | `double?` | 掩码圆点尺寸（默认 ant.s(10)） |
| `error` | `bool` | 是否错误状态（切换为 true 时播放抖动动画） |
| `keyboard` | `bool` | 是否内置数字键盘 |
| `length` | `int` | 格子数量 |
| `onBlur` | `VoidCallback?` | 失焦回调 |
| `onChange` | `ValueChanged<String>?` | 值变化回调 |
| `onFill` | `ValueChanged<String>?` | 填满回调（值长度首次达到 length 时触发，删减后再次填满会再次触发） |
| `onFocus` | `VoidCallback?` | 聚焦回调 |
| `plain` | `bool` | 是否明文展示 |
| `separated` | `bool` | 是否格子分离 |
| `value` | `String?` | 受控当前值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPasscodeInput>` | — |

