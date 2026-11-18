<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSwipeAction

> 种类：类

```dart
class AntSwipeAction
```

滑动操作 — 左滑/右滑行内容露出操作按钮，松手吸附展开或收起。

对齐 antd-mobile SwipeAction 组件：拖动时按钮跟随位移，松手超过
按钮总宽一半自动展开，否则回弹关闭；点击操作按钮执行回调并收起。

## 构造函数

### `AntSwipeAction({super.key, required this.child, this.rightActions = const [], this.leftActions = const [], this.closeOnAction = true, this.actionWidth = kAntSwipeActionWidth, this.onOpened, this.onClosed})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `rightActions` | `List<AntSwipeActionItem>` | = const [] | — |
| `leftActions` | `List<AntSwipeActionItem>` | = const [] | — |
| `closeOnAction` | `bool` | = true | — |
| `actionWidth` | `double` | = kAntSwipeActionWidth | — |
| `onOpened` | `ValueChanged<String>?` | 可选 | — |
| `onClosed` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actionWidth` | `double` | 单个操作按钮宽度（默认 72） |
| `child` | `Widget` | 行内容 |
| `closeOnAction` | `bool` | 点击操作按钮后是否自动收起（默认 true） |
| `leftActions` | `List<AntSwipeActionItem>` | 右滑露出的左侧操作按钮 |
| `onClosed` | `VoidCallback?` | 收起回调 |
| `onOpened` | `ValueChanged<String>?` | 展开回调（side 标识展开侧） |
| `rightActions` | `List<AntSwipeActionItem>` | 左滑露出的右侧操作按钮 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSwipeAction>` | — |

