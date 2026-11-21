<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntResultStatus

> 种类：枚举

```dart
enum AntResultStatus
```

Result 结果状态。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `success` | 成功 — 对勾图标 |
| `error` | 错误 — 叉号图标 |
| `info` | 信息 — 信息图标 |
| `warning` | 警告 — 警告图标 |
| `notFound` | 404 — 页面不存在（数字大字） |
| `forbidden` | 403 — 无权限（数字大字） |
| `serverError` | 500 — 服务器错误（数字大字） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `icon` | `IconData` | 语义状态对应的默认图标 |
| `statusLabel` | `String` | 状态对应的展示文案（语义名或数字） |

