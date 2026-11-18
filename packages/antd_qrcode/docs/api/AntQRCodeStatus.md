<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntQRCodeStatus

> 种类：枚举

```dart
enum AntQRCodeStatus
```

二维码状态 — 对齐 antd v6 QRCode 的 status。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `active` | 正常（默认） |
| `expired` | 已过期 — 显示覆盖层，点击可刷新 |
| `scanned` | 已扫描 — 显示已扫描覆盖层 |

