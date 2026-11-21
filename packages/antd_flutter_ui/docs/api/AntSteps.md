<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSteps

> 种类：类

```dart
class AntSteps
```

步骤条 — 引导用户按照流程完成任务的导航条。

对齐 antd React Steps 组件，支持水平/垂直排列、四种状态、
自定义图标和点击切换。

```dart
AntSteps<Step>(
  current: 1,
  items: steps,
  titleBuilder: (context, step, index) => Text(step.title),
  descriptionBuilder: (context, step, index) => Text(step.description),
  statusOf: (step) => step.status,
)
```

## 构造函数

### `AntSteps({super.key, this.current = 0, this.items = const [], this.titleBuilder, this.descriptionBuilder, this.iconBuilder, this.statusOf, this.disabledOf, this.direction = AntStepsDirection.horizontal, this.status = AntStepsStatus.process, this.size = AntStepsSize.normal, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `current` | `int` | = 0 | — |
| `items` | `List<T>` | = const [] | — |
| `titleBuilder` | `AntStepsTitleBuilder<T>?` | 可选 | — |
| `descriptionBuilder` | `AntStepsDescriptionBuilder<T>?` | 可选 | — |
| `iconBuilder` | `AntStepsIconBuilder<T>?` | 可选 | — |
| `statusOf` | `AntStepsStatus? Function(T item)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `direction` | `AntStepsDirection` | = AntStepsDirection.horizontal | — |
| `status` | `AntStepsStatus` | = AntStepsStatus.process | — |
| `size` | `AntStepsSize` | = AntStepsSize.normal | — |
| `onChange` | `ValueChanged<T>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `current` | `int` | 当前步骤索引，从 0 开始 |
| `descriptionBuilder` | `AntStepsDescriptionBuilder<T>?` | 描述构建器，返回 null 时不展示描述 |
| `direction` | `AntStepsDirection` | 排列方向 |
| `disabledOf` | `bool Function(T item)?` | 是否禁用点击 |
| `iconBuilder` | `AntStepsIconBuilder<T>?` | 自定义图标构建器，优先于自动生成的圆圈内容 |
| `items` | `List<T>` | 步骤项列表 |
| `onChange` | `ValueChanged<T>?` | 点击切换步骤回调 |
| `size` | `AntStepsSize` | 尺寸 |
| `status` | `AntStepsStatus` | 当前步骤的状态 |
| `statusOf` | `AntStepsStatus? Function(T item)?` | 自定义状态，覆盖自动计算的状态 |
| `titleBuilder` | `AntStepsTitleBuilder<T>?` | 标题构建器，未提供时回退为 Text('$item') |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_circleSize` | `double` | — |
| `_connectorThickness` | `double` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildCircle` | `Widget` | — |
| `_buildCircleContent` | `Widget` | — |
| `_buildConnector` | `Widget` | — |
| `_buildDescription` | `Widget?` | — |
| `_buildHorizontal` | `Widget` | — |
| `_buildHorizontalStep` | `Widget` | — |
| `_buildTitle` | `Widget` | — |
| `_buildVertical` | `Widget` | — |
| `_buildVerticalStep` | `Widget` | — |
| `_isDisabled` | `bool` | — |
| `_resolveStatus` | `AntStepsStatus` | 计算指定索引步骤的状态 |
| `build` | `Widget` | — |

