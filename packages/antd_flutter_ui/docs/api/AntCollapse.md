<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCollapse

> 种类：类

```dart
class AntCollapse
```

折叠面板 — 内容分组折叠展示。

对齐 antd React Collapse 组件。

## 构造函数

### `AntCollapse({super.key, required this.items, this.accordion = false, this.activeKey, this.defaultActiveKey, this.onChange, this.expandIconPosition = AntCollapseExpandIconPosition.left, this.expandIcon, this.bordered = true, this.size = AntCollapseSize.middle})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntCollapsePanel>` | 可选 | — |
| `accordion` | `bool` | = false | — |
| `activeKey` | `List<String>?` | 可选 | — |
| `defaultActiveKey` | `List<String>?` | 可选 | — |
| `onChange` | `ValueChanged<List<String>>?` | 可选 | — |
| `expandIconPosition` | `AntCollapseExpandIconPosition` | = AntCollapseExpandIconPosition.left | — |
| `expandIcon` | `Widget Function(BuildContext context, bool isExpanded)?` | 可选 | — |
| `bordered` | `bool` | = true | — |
| `size` | `AntCollapseSize` | = AntCollapseSize.middle | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `accordion` | `bool` | 手风琴模式（同时只展开一个面板） |
| `activeKey` | `List<String>?` | 受控展开 key 集合（accordion 模式下最多一个） |
| `bordered` | `bool` | 是否有边框（false 为无边框变体 borderless） |
| `defaultActiveKey` | `List<String>?` | 默认展开 key 集合 |
| `expandIcon` | `Widget Function(BuildContext context, bool isExpanded)?` | 自定义箭头构建（isExpanded 表示当前是否展开） |
| `expandIconPosition` | `AntCollapseExpandIconPosition` | 箭头位置 |
| `items` | `List<AntCollapsePanel>` | 面板列表 |
| `onChange` | `ValueChanged<List<String>>?` | 展开状态变化回调 |
| `size` | `AntCollapseSize` | 尺寸 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCollapse>` | — |

