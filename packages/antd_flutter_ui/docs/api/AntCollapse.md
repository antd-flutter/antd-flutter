<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCollapse

> 种类：类

```dart
class AntCollapse
```

折叠面板 — 内容分组折叠展示。

对齐 antd React Collapse 组件。

## 构造函数

### `AntCollapse({super.key, required this.items, this.keyOf, this.labelBuilder, this.childBuilder, this.extraBuilder, this.disabledOf, this.forceRenderOf, this.accordion = false, this.activeKey, this.defaultActiveKey, this.onChange, this.expandIconPosition = AntCollapseExpandIconPosition.left, this.expandIcon, this.bordered = true, this.size = AntCollapseSize.middle})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `labelBuilder` | `AntCollapseLabelBuilder<T>?` | 可选 | — |
| `childBuilder` | `AntCollapseChildBuilder<T>?` | 可选 | — |
| `extraBuilder` | `AntCollapseExtraBuilder<T>?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `forceRenderOf` | `bool Function(T item)?` | 可选 | — |
| `accordion` | `bool` | = false | — |
| `activeKey` | `List<Object>?` | 可选 | — |
| `defaultActiveKey` | `List<Object>?` | 可选 | — |
| `onChange` | `ValueChanged<List<Object>>?` | 可选 | — |
| `expandIconPosition` | `AntCollapseExpandIconPosition` | = AntCollapseExpandIconPosition.left | — |
| `expandIcon` | `Widget Function(BuildContext context, bool isExpanded)?` | 可选 | — |
| `bordered` | `bool` | = true | — |
| `size` | `AntCollapseSize` | = AntCollapseSize.middle | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `accordion` | `bool` | 手风琴模式（同时只展开一个面板） |
| `activeKey` | `List<Object>?` | 受控展开 key 集合（accordion 模式下最多一个） |
| `bordered` | `bool` | 是否有边框（false 为无边框变体 borderless） |
| `childBuilder` | `AntCollapseChildBuilder<T>?` | 面板内容构建器 |
| `defaultActiveKey` | `List<Object>?` | 默认展开 key 集合 |
| `disabledOf` | `bool Function(T item)?` | 是否禁用 |
| `expandIcon` | `Widget Function(BuildContext context, bool isExpanded)?` | 自定义箭头构建（isExpanded 表示当前是否展开） |
| `expandIconPosition` | `AntCollapseExpandIconPosition` | 箭头位置 |
| `extraBuilder` | `AntCollapseExtraBuilder<T>?` | 面板右侧附加内容构建器 |
| `forceRenderOf` | `bool Function(T item)?` | 是否强制渲染内容 |
| `items` | `List<T>` | 面板列表 |
| `keyOf` | `Object Function(T item)?` | 面板 key 提取器，默认使用下标 |
| `labelBuilder` | `AntCollapseLabelBuilder<T>?` | 面板标题构建器，未提供时回退为 Text('$item') |
| `onChange` | `ValueChanged<List<Object>>?` | 展开状态变化回调 |
| `size` | `AntCollapseSize` | 尺寸 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCollapse<T>>` | — |

