<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMotionDurationToken

> 种类：类

```dart
class AntMotionDurationToken
```

动效时长令牌，对应 antd Map Token 的 `motionDuration*` 系列。

由 `antGenMotionDuration` 从 `motionBase + motionUnit × n` 派生。

## 构造函数

### `AntMotionDurationToken({required this.fast, required this.mid, required this.slow})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `fast` | `double` | 可选 | — |
| `mid` | `double` | 可选 | — |
| `slow` | `double` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `fast` | `double` | 快速动效时长（秒） |
| `mid` | `double` | 中速动效时长（秒） |
| `slow` | `double` | 慢速动效时长（秒） |

