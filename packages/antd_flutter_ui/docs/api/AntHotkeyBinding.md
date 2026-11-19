<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntHotkeyBinding

> 种类：类

```dart
class AntHotkeyBinding
```

单条热键绑定。

```dart
AntHotkeyBinding(
  keys: {LogicalKeyboardKey.escape},
  ignoreWithinEditable: false, // 控制键：输入框聚焦内仍触发
  onTrigger: close,
)
```

## 构造函数

### `AntHotkeyBinding({required this.keys, this.modifiers = const {}, required this.onTrigger, this.when, this.ignoreWithinEditable = true, this.transient = false, this.debugLabel})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `keys` | `Set<LogicalKeyboardKey>` | 可选 | — |
| `modifiers` | `Set<AntHotkeyModifier>` | = const {} | — |
| `onTrigger` | `VoidCallback` | 可选 | — |
| `when` | `bool Function()?` | 可选 | — |
| `ignoreWithinEditable` | `bool` | = true | — |
| `transient` | `bool` | = false | — |
| `debugLabel` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `debugLabel` | `String?` | 调试标签（冲突警告中标识绑定来源） |
| `ignoreWithinEditable` | `bool` | 输入框（EditableText）聚焦时是否忽略本绑定（默认 true） |
| `keys` | `Set<LogicalKeyboardKey>` | 快捷键（非修饰键） |
| `modifiers` | `Set<AntHotkeyModifier>` | 修饰键（ctrl/alt/shift/meta），精确匹配——绑定了 shift 则必须按住 shift |
| `onTrigger` | `VoidCallback` | 组合命中时触发 |
| `transient` | `bool` | 是否为临时绑定（弹层打开期间注册、关闭即注销，如 Esc 关闭） |
| `when` | `bool Function()?` | 额外触发条件（如「弹层打开时才生效」） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `combo` | `AntHotkeyCombo` | 本绑定的组合 |
| `containsCharacterKey` | `bool` | 是否包含字符类按键（字母/数字/符号/空格）——输入框聚焦内默认跳过的类别 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `matches` | `bool` | 当前按下状态是否命中本组合 |

