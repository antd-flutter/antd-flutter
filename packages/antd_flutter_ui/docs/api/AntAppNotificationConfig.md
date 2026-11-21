<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAppNotificationConfig

> 种类：类

```dart
class AntAppNotificationConfig
```

AntApp 全局 notification 默认配置。

## 构造函数

### `AntAppNotificationConfig({this.title, this.placement, this.duration, this.closable})`

创建 notification 全局默认配置。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `title` | `String?` | 可选 | — |
| `placement` | `AntAppNotificationPlacement?` | 可选 | — |
| `duration` | `Duration?` | 可选 | — |
| `closable` | `bool?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `closable` | `bool?` | 默认是否显示关闭按钮 |
| `duration` | `Duration?` | 默认自动关闭时长 |
| `placement` | `AntAppNotificationPlacement?` | 默认展示位置 |
| `title` | `String?` | 默认通知标题（调用处未传 title 时使用） |

