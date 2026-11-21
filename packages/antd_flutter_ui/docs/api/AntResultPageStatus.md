<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntResultPageStatus

> 种类：枚举

```dart
enum AntResultPageStatus
```

ResultPage 结果页状态。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `success` | 成功 |
| `error` | 错误 |
| `info` | 信息 |
| `warning` | 警告 |
| `waiting` | 等待 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `icon` | `IconData` | 状态对应的默认语义图标 |
| `statusLabel` | `String` | 状态对应的主色令牌取值函数名（便于按主题取色） |

