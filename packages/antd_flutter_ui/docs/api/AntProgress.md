<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntProgress

> 种类：类

```dart
class AntProgress
```

进度条 — 展示操作的当前进度。

对齐 antd React Progress 组件。

## 构造函数

### `AntProgress({super.key, this.type = AntProgressType.line, this.percent = 0, this.size, this.strokeWidth, this.strokeColor, this.trailColor, this.showInfo = true, this.status = AntProgressStatus.normal, this.strokeLinecap = StrokeCap.round, this.format})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `type` | `AntProgressType` | = AntProgressType.line | — |
| `percent` | `double` | = 0 | — |
| `size` | `double?` | 可选 | — |
| `strokeWidth` | `double?` | 可选 | — |
| `strokeColor` | `Color?` | 可选 | — |
| `trailColor` | `Color?` | 可选 | — |
| `showInfo` | `bool` | = true | — |
| `status` | `AntProgressStatus` | = AntProgressStatus.normal | — |
| `strokeLinecap` | `StrokeCap` | = StrokeCap.round | — |
| `format` | `String Function(double percent)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `format` | `String Function(double percent)?` | 自定义百分比文字 |
| `percent` | `double` | 百分比 0~100 |
| `showInfo` | `bool` | 是否显示百分比文字 |
| `size` | `double?` | line 模式：轨道粗细 |
| `status` | `AntProgressStatus` | 状态色 |
| `strokeColor` | `Color?` | 自定义进度条颜色 |
| `strokeLinecap` | `StrokeCap` | circle 模式线帽形状 |
| `strokeWidth` | `double?` | circle 模式圆弧粗细 |
| `trailColor` | `Color?` | 轨道颜色 |
| `type` | `AntProgressType` | 进度条类型 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntProgress>` | — |

