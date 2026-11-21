<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntHotkeyCombo

> 种类：类

```dart
class AntHotkeyCombo
```

一组快捷键组合（按键集合 + 修饰键集合），支持相等比较用于冲突检测。

## 构造函数

### `AntHotkeyCombo(this.keys, this.modifiers)`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `keys` | `Set<LogicalKeyboardKey>` | 可选 | — |
| `modifiers` | `Set<AntHotkeyModifier>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `keys` | `Set<LogicalKeyboardKey>` | 非修饰键集合 |
| `modifiers` | `Set<AntHotkeyModifier>` | 修饰键集合 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `toString` | `String` | — |

