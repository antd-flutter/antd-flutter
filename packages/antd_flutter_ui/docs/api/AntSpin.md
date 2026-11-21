<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSpin

> 种类：类

```dart
class AntSpin
```

加载中 — 用于页面或区块的等待状态。

对齐 antd React Spin 组件。

## 构造函数

### `AntSpin({super.key, this.spinning = true, this.size = AntSpinSize.middle, this.tip, this.child, this.indicator, this.indicatorType = AntSpinIndicatorType.circle, this.fullscreen = false, this.delay})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `spinning` | `bool` | = true | — |
| `size` | `AntSpinSize` | = AntSpinSize.middle | — |
| `tip` | `String?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `indicator` | `Widget?` | 可选 | — |
| `indicatorType` | `AntSpinIndicatorType` | = AntSpinIndicatorType.circle | — |
| `fullscreen` | `bool` | = false | — |
| `delay` | `Duration?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 包裹的内容（设置后进入包裹模式） |
| `delay` | `Duration?` | 延迟显示时长 |
| `fullscreen` | `bool` | 是否全屏遮罩加载模式（antd Spin fullscreen：居中指示器 + 全屏半透明遮罩） |
| `indicator` | `Widget?` | 自定义指示器（设置后替代默认指示器） |
| `indicatorType` | `AntSpinIndicatorType` | 指示器样式（仅在未提供 indicator 时生效） |
| `size` | `AntSpinSize` | 指示器尺寸 |
| `spinning` | `bool` | 是否处于加载中 |
| `tip` | `String?` | 加载文案（显示在指示器下方） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSpin>` | — |

