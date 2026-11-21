<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntStatisticCountdown

> 种类：类

```dart
class AntStatisticCountdown
```

倒计时统计 — 倒计时显示组件。

对齐 antd React Statistic.Countdown 组件。

## 构造函数

### `AntStatisticCountdown({super.key, this.title, required this.value, this.format = 'HH:mm:ss', this.valueStyle, this.onFinish})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `title` | `String?` | 可选 | — |
| `value` | `dynamic` | 可选 | — |
| `format` | `String` | = 'HH:mm:ss' | — |
| `valueStyle` | `TextStyle?` | 可选 | — |
| `onFinish` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `format` | `String` | 格式化模板（支持 DD/HH/mm/ss） |
| `onFinish` | `VoidCallback?` | 倒计时结束回调 |
| `title` | `String?` | 标题 |
| `value` | `dynamic` | 目标时间戳（毫秒）或 Duration |
| `valueStyle` | `TextStyle?` | 数值样式 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntStatisticCountdown>` | — |

