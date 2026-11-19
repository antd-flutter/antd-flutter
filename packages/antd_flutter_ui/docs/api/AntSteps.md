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
AntSteps(
  current: 1,
  items: [
    AntStepsItem(title: 'Finished', description: 'Step 1 done'),
    AntStepsItem(title: 'In Progress', description: 'Step 2 running'),
    AntStepsItem(title: 'Waiting', description: 'Step 3 pending'),
  ],
)
```

## 构造函数

### `AntSteps({super.key, this.current = 0, this.items = const [], this.direction = AntStepsDirection.horizontal, this.status = AntStepsStatus.process, this.size = AntStepsSize.normal, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `current` | `int` | = 0 | — |
| `items` | `List<AntStepsItem>` | = const [] | — |
| `direction` | `AntStepsDirection` | = AntStepsDirection.horizontal | — |
| `status` | `AntStepsStatus` | = AntStepsStatus.process | — |
| `size` | `AntStepsSize` | = AntStepsSize.normal | — |
| `onChange` | `ValueChanged<int>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `current` | `int` | 当前步骤索引，从 0 开始 |
| `direction` | `AntStepsDirection` | 排列方向 |
| `items` | `List<AntStepsItem>` | 步骤项列表 |
| `onChange` | `ValueChanged<int>?` | 点击切换步骤回调 |
| `size` | `AntStepsSize` | 尺寸 |
| `status` | `AntStepsStatus` | 当前步骤的状态 |

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
| `_buildDescription` | `Widget` | — |
| `_buildHorizontal` | `Widget` | — |
| `_buildHorizontalStep` | `Widget` | — |
| `_buildTitle` | `Widget` | — |
| `_buildVertical` | `Widget` | — |
| `_buildVerticalStep` | `Widget` | — |
| `_resolveStatus` | `AntStepsStatus` | 计算指定索引步骤的状态 |
| `build` | `Widget` | — |

