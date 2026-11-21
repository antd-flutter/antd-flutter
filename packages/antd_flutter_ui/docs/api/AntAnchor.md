<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAnchor

> 种类：类

```dart
class AntAnchor
```

锚点 — 用于跳转到页面指定位置。

对齐 antd React Anchor 组件，支持垂直/水平方向、
受控激活状态、点击与变化回调。

```dart
AntAnchor<Section>(
  items: sections,
  keyOf: (section) => section.id,
  titleBuilder: (context, section, index) => Text(section.title),
  onClick: (section) => print('clicked: ${section.id}'),
)
```

## 构造函数

### `AntAnchor({super.key, this.items = const [], this.keyOf, this.titleBuilder, this.childrenOf, this.direction = AntAnchorDirection.vertical, this.controller, this.onClick, this.onChange, this.scrollController, this.targetKeys = const {}, this.topOffset = 0, this.autoScroll = true, this.scrollDuration = const Duration(milliseconds: 300)})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | = const [] | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `titleBuilder` | `AntAnchorTitleBuilder<T>?` | 可选 | — |
| `childrenOf` | `List<T> Function(T item)?` | 可选 | — |
| `direction` | `AntAnchorDirection` | = AntAnchorDirection.vertical | — |
| `controller` | `AntAnchorController?` | 可选 | — |
| `onClick` | `ValueChanged<T>?` | 可选 | — |
| `onChange` | `ValueChanged<Object?>?` | 可选 | — |
| `scrollController` | `ScrollController?` | 可选 | — |
| `targetKeys` | `Map<Object, GlobalKey>` | = const {} | — |
| `topOffset` | `double` | = 0 | — |
| `autoScroll` | `bool` | = true | — |
| `scrollDuration` | `Duration` | = const Duration(milliseconds: 300) | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autoScroll` | `bool` | 点击锚点后是否自动滚动到目标区块 |
| `childrenOf` | `List<T> Function(T item)?` | 子锚点提取器，用于嵌套锚点 |
| `controller` | `AntAnchorController?` | 受控控制器 |
| `direction` | `AntAnchorDirection` | 锚点方向 |
| `items` | `List<T>` | 锚点链接项列表 |
| `keyOf` | `Object Function(T item)?` | 提取锚点唯一标识，默认使用扁平化后的下标 |
| `onChange` | `ValueChanged<Object?>?` | 激活项变化回调 |
| `onClick` | `ValueChanged<T>?` | 点击链接回调 |
| `scrollController` | `ScrollController?` | 页面内容区的滚动控制器 |
| `scrollDuration` | `Duration` | 点击后滚动动画时长 |
| `targetKeys` | `Map<Object, GlobalKey>` | 锚点 key → 内容区块 GlobalKey 的映射 |
| `titleBuilder` | `AntAnchorTitleBuilder<T>?` | 标题构建器，未提供时回退为 Text('$item') |
| `topOffset` | `double` | 滚动定位时预留的顶部偏移（例如固定导航栏高度） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntAnchor<T>>` | — |

