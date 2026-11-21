<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntLoadingSpeed

> 种类：类

```dart
class AntLoadingSpeed
```

Loading 旋转速度配置（每秒旋转圈数）。

## 构造函数

### `AntLoadingSpeed._(this.revolutionsPerSecond)`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `revolutionsPerSecond` | `double` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `revolutionsPerSecond` | `double` | 每秒旋转圈数 |
| `fast` | `AntLoadingSpeed` | 快速（每秒 2 圈） |
| `normal` | `AntLoadingSpeed` | 默认速度（约每秒 1.4 圈，对齐 antd-mobile 观感） |
| `slow` | `AntLoadingSpeed` | 慢速（每秒 0.8 圈） |

