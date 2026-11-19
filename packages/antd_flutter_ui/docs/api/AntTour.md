<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTour

> 种类：类

```dart
class AntTour
```

漫游式引导 — 分步引导用户了解产品功能的气泡卡片组件。

对齐 antd React Tour 组件：支持 target 元素锚定、遮罩镂空高亮、
多步导航（上一步/下一步/完成/跳过）、受控 open 与 current、
每步独立 placement / mask / arrow 配置。

## 构造函数

### `AntTour({super.key, required this.steps, this.open = false, this.current, this.placement = AntTourPlacement.bottomCenter, this.mask = true, this.arrow = true, this.maskClosable = false, this.skipConfirm = false, this.skipConfirmTitle, this.stepTransitionDuration = const Duration(milliseconds: 300), this.adaptivePosition = true, this.onStepChange, this.onFinish, this.onClose})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `steps` | `List<AntTourStep>` | 可选 | — |
| `open` | `bool` | = false | — |
| `current` | `int?` | 可选 | — |
| `placement` | `AntTourPlacement` | = AntTourPlacement.bottomCenter | — |
| `mask` | `bool` | = true | — |
| `arrow` | `bool` | = true | — |
| `maskClosable` | `bool` | = false | — |
| `skipConfirm` | `bool` | = false | — |
| `skipConfirmTitle` | `String?` | 可选 | — |
| `stepTransitionDuration` | `Duration` | = const Duration(milliseconds: 300) | — |
| `adaptivePosition` | `bool` | = true | — |
| `onStepChange` | `ValueChanged<int>?` | 可选 | — |
| `onFinish` | `VoidCallback?` | 可选 | — |
| `onClose` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `adaptivePosition` | `bool` | 内容定位自适应翻转（参考 tutorialcoachmark 的内容避让机制） |
| `arrow` | `bool` | 是否显示箭头 |
| `current` | `int?` | 受控当前步索引（非空时由外部控制步进） |
| `mask` | `bool` | 是否显示挖孔遮罩 |
| `maskClosable` | `bool` | 点击遮罩是否可关闭引导 |
| `onClose` | `VoidCallback?` | 引导关闭（跳过 / 点击遮罩关闭）回调 |
| `onFinish` | `VoidCallback?` | 引导完成（最后一步点击完成）回调 |
| `onStepChange` | `ValueChanged<int>?` | 步骤变化回调（current 为当前步索引） |
| `open` | `bool` | 受控打开状态 |
| `placement` | `AntTourPlacement` | 默认引导卡片位置 |
| `skipConfirm` | `bool` | 跳过前是否弹出确认弹窗（参考 tutorialcoachmark 的 onSkip 确认机制） |
| `skipConfirmTitle` | `String?` | 跳过确认弹窗标题（skipConfirm 为 true 时生效） |
| `stepTransitionDuration` | `Duration` | 步骤间过渡动画时长（挖孔位移 + 卡片重入场） |
| `steps` | `List<AntTourStep>` | 引导步骤集合 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTour>` | — |

