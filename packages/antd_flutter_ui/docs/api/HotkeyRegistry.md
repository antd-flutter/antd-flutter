<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# HotkeyRegistry

> 种类：类

```dart
class HotkeyRegistry
```

热键注册中心（全局单例）。

```dart
HotkeyRegistry.instance.register(binding);
HotkeyRegistry.instance.unregister(binding);
```

## 构造函数

### `HotkeyRegistry._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_bindings` | `List<AntHotkeyBinding>` | — |
| `_handlerInstalled` | `bool` | — |
| `instance` | `HotkeyRegistry` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bindingCount` | `int` | 当前已注册绑定数（测试用） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_ensureHandler` | `void` | — |
| `_handleKey` | `bool` | — |
| `_warnConflicts` | `void` | 冲突检测：同组合的非临时绑定同时存在时输出警告（不阻止注册—— LIFO 分发保证后注册者先命中，运行时不中断） |
| `clear` | `void` | 注销所有绑定（测试隔离用） |
| `dispatch` | `bool` | 按当前按下状态分发：LIFO 遍历，首个命中（组合匹配 + when 通过 + 焦点语义通过）的绑定触发回调并终止传播 |
| `register` | `void` | 注册绑定 |
| `unregister` | `void` | 注销绑定 |
| `_focusWithinEditable` | `bool` | 焦点是否位于可编辑文本（EditableText）内 |

