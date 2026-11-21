<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntHotkeys

> 种类：类

```dart
class AntHotkeys
```

热键包裹 widget。

## 构造函数

### `AntHotkeys({super.key, required this.bindings, required this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `bindings` | `List<AntHotkeyBinding>` | 可选 | — |
| `child` | `Widget` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bindings` | `List<AntHotkeyBinding>` | 快捷键绑定列表（挂载期间全局生效） |
| `child` | `Widget` | 子组件 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntHotkeys>` | — |

