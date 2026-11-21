<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntNotification

> 种类：类

```dart
class AntNotification
```

通知提醒框 — 全局展示通知信息。

静态方法 `show` 在屏幕四角堆叠展示通知卡片，
多条通知按弹出顺序垂直排列，新通知带滑入动画。

## 构造函数

### `AntNotification._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_states` | `Map<AntNotificationPlacement, _PlacementState>` | 每个 placement 一份堆叠状态 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_stateOf` | `_PlacementState` | — |
| `closeAll` | `void` | 关闭指定 placement 下的所有通知 |
| `show` | `void` | 弹出一条通知 |

