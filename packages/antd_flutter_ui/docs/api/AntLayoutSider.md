<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntLayoutSider

> 种类：类

```dart
class AntLayoutSider
```

侧边栏 — 可折叠的页面侧边导航容器。

对齐 antd React Layout.Sider 组件。

```dart
AntLayoutSider(
  collapsible: true,
  child: Text('侧边内容'),
  onCollapse: (collapsed) => print(collapsed),
)
```

## 构造函数

### `AntLayoutSider({super.key, this.width = _kSiderWidth, this.collapsedWidth = _kSiderCollapsedWidth, this.collapsible = false, this.defaultCollapsed = false, this.collapsed, this.theme = AntLayoutSiderTheme.dark, this.breakpoint, this.trigger, this.child, this.onCollapse, this.onBreakpoint})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `width` | `double` | = _kSiderWidth | — |
| `collapsedWidth` | `double` | = _kSiderCollapsedWidth | — |
| `collapsible` | `bool` | = false | — |
| `defaultCollapsed` | `bool` | = false | — |
| `collapsed` | `bool?` | 可选 | — |
| `theme` | `AntLayoutSiderTheme` | = AntLayoutSiderTheme.dark | — |
| `breakpoint` | `double?` | 可选 | — |
| `trigger` | `Widget?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `onCollapse` | `ValueChanged<bool>?` | 可选 | — |
| `onBreakpoint` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `breakpoint` | `double?` | 响应式断点（逻辑像素） |
| `child` | `Widget?` | 子元素 |
| `collapsed` | `bool?` | 受控折叠状态 |
| `collapsedWidth` | `double` | 折叠后宽度 |
| `collapsible` | `bool` | 是否可折叠 |
| `defaultCollapsed` | `bool` | 初始是否折叠（非受控模式） |
| `onBreakpoint` | `VoidCallback?` | 触发响应式断点回调 |
| `onCollapse` | `ValueChanged<bool>?` | 折叠状态变化回调 |
| `theme` | `AntLayoutSiderTheme` | 主题 |
| `trigger` | `Widget?` | 自定义折叠触发器 |
| `width` | `double` | 展开宽度 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntLayoutSider>` | — |

