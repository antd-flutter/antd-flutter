<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# resolveActiveModifiers

> 种类：函数

```dart
Set<AntHotkeyModifier> resolveActiveModifiers(Set<LogicalKeyboardKey> pressedKeys)
```

从当前按下键集合解析生效的修饰键。

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `pressedKeys` | `Set<LogicalKeyboardKey>` | 可选 | — |

返回 `Set<AntHotkeyModifier>`。

