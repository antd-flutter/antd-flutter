<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMessage

> 种类：类

```dart
class AntMessage
```

全局提示 — 在页面顶部居中展示全局反馈信息。

对齐 antd React Message 组件：静态方法 `show` 弹出提示，
自动消失（默认 3s），可叠加多条，loading 类型默认不自动消失。

## 构造函数

### `AntMessage._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_overlayEntry` | `OverlayEntry?` | — |
| `_queue` | `List<_ActiveMessage>` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_remove` | `void` | — |
| `_resolveDuration` | `Duration?` | 各类型的默认消失策略 |
| `show` | `AntMessageHandle` | 弹出一条全局提示，返回句柄可手动关闭 |

