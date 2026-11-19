<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAppState

> 种类：类

```dart
class AntAppState
```

AntApp 的状态，即静态 API 句柄（对应 antd App 的 useApp 返回值）。

经 `AntApp.of` 获取后即可在任意位置调用全局反馈，
无需依赖当前页面的 `BuildContext`。

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_overlayContext` | `BuildContext` | 获取弹出全局反馈所用的上下文 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_mapMessageType` | `AntMessageType` | — |
| `_mapNotificationType` | `AntNotificationType` | — |
| `_mapPlacement` | `AntNotificationPlacement` | — |
| `build` | `Widget` | — |
| `messageShow` | `AntMessageHandle` | 弹出一条全局提示（委托 AntMessage.show，合并 AntApp.message 默认配置） |
| `modal` | `Future<bool?>` | 弹出确认对话框（委托 showAntModal），返回用户选择 |
| `notificationShow` | `void` | 弹出一条通知提醒框（委托 AntNotification.show） |

