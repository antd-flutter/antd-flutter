<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntEscapeClosable

> 种类：类

```dart
class AntEscapeClosable
```

Esc 关闭包裹件。

## 构造函数

### `AntEscapeClosable({super.key, required this.onEscape, required this.child, this.enabled = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `onEscape` | `VoidCallback` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `enabled` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 弹层内容 |
| `enabled` | `bool` | 是否启用（组件不希望 Esc 关闭时传 false，行为退化为直通） |
| `onEscape` | `VoidCallback` | 按 Esc 时回调（组件关闭动作） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntEscapeClosable>` | — |

