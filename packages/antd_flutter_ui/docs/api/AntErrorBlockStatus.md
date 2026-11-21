<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntErrorBlockStatus

> 种类：枚举

```dart
enum AntErrorBlockStatus
```

ErrorBlock 错误块状态。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `defaultStatus` | 默认 — 一般错误提示 |
| `empty` | 空数据 — 列表/内容为空 |
| `disconnected` | 断网 — 网络连接异常 |
| `busy` | 繁忙 — 系统繁忙 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `defaultDescription` | `String` | 状态对应的默认描述文案 |
| `defaultTitle` | `String` | 状态对应的默认标题（对齐 antd-mobile v5 中文文案） |

