<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAppMessageConfig

> 种类：类

```dart
class AntAppMessageConfig
```

AntApp 全局 message 默认配置。

在 `AntApp` 上设置后，经 `AntApp.of(context).message.show(...)` 弹出的
提示将合并这些默认值（调用处的显式参数优先）。

## 构造函数

### `AntAppMessageConfig({this.type, this.duration, this.closable})`

创建 message 全局默认配置。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `type` | `AntAppMessageType?` | 可选 | — |
| `duration` | `Duration?` | 可选 | — |
| `closable` | `bool?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `closable` | `bool?` | 默认是否显示关闭按钮 |
| `duration` | `Duration?` | 默认自动关闭时长 |
| `type` | `AntAppMessageType?` | 默认提示类型 |

