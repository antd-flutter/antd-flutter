<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMenu

> 种类：类

```dart
class AntMenu
```

导航菜单 — 为页面和功能提供导航的菜单列表。

## 构造函数

### `AntMenu({super.key, this.items = const [], this.keyOf, this.childrenOf, this.labelBuilder, this.iconBuilder, this.extraBuilder, this.typeOf, this.disabledOf, this.dangerOf, this.dashedOf, this.tooltipTitleOf, this.collapsedLabelOf, this.mode = AntMenuMode.inline, this.theme = AntMenuTheme.light, this.selectedKeys, this.defaultSelectedKeys = const [], this.openKeys, this.defaultOpenKeys = const [], this.onClick, this.onItemClick, this.onSelect, this.onDeselect, this.onSelectedKeysChange, this.onOpenChange, this.selectable = true, this.multiple = false, this.triggerSubMenuAction = AntMenuTrigger.hover, this.subMenuOpenDelay = const Duration(milliseconds: 100), this.subMenuCloseDelay = const Duration(milliseconds: 100), this.inlineCollapsed = false, this.inlineIndent = 24, this.expandIcon, this.overflowedIndicator, this.disabled = false, this.tooltip = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | = const [] | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `childrenOf` | `List<T> Function(T item)?` | 可选 | — |
| `labelBuilder` | `AntMenuLabelBuilder<T>?` | 可选 | — |
| `iconBuilder` | `AntMenuIconBuilder<T>?` | 可选 | — |
| `extraBuilder` | `AntMenuExtraBuilder<T>?` | 可选 | — |
| `typeOf` | `AntMenuItemType Function(T item)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `dangerOf` | `bool Function(T item)?` | 可选 | — |
| `dashedOf` | `bool Function(T item)?` | 可选 | — |
| `tooltipTitleOf` | `AntMenuTooltipTitleOf<T>?` | 可选 | — |
| `collapsedLabelOf` | `String? Function(T item)?` | 可选 | — |
| `mode` | `AntMenuMode` | = AntMenuMode.inline | — |
| `theme` | `AntMenuTheme` | = AntMenuTheme.light | — |
| `selectedKeys` | `List<Object>?` | 可选 | — |
| `defaultSelectedKeys` | `List<Object>` | = const [] | — |
| `openKeys` | `List<Object>?` | 可选 | — |
| `defaultOpenKeys` | `List<Object>` | = const [] | — |
| `onClick` | `ValueChanged<T>?` | 可选 | — |
| `onItemClick` | `ValueChanged<T>?` | 可选 | — |
| `onSelect` | `ValueChanged<T>?` | 可选 | — |
| `onDeselect` | `ValueChanged<T>?` | 可选 | — |
| `onSelectedKeysChange` | `ValueChanged<List<Object>>?` | 可选 | — |
| `onOpenChange` | `ValueChanged<List<Object>>?` | 可选 | — |
| `selectable` | `bool` | = true | — |
| `multiple` | `bool` | = false | — |
| `triggerSubMenuAction` | `AntMenuTrigger` | = AntMenuTrigger.hover | — |
| `subMenuOpenDelay` | `Duration` | = const Duration(milliseconds: 100) | — |
| `subMenuCloseDelay` | `Duration` | = const Duration(milliseconds: 100) | — |
| `inlineCollapsed` | `bool` | = false | — |
| `inlineIndent` | `double` | = 24 | — |
| `expandIcon` | `Widget?` | 可选 | — |
| `overflowedIndicator` | `Widget?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `tooltip` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `childrenOf` | `List<T> Function(T item)?` | 子菜单提取器 |
| `collapsedLabelOf` | `String? Function(T item)?` | 折叠态无 icon 时用于取首字母的文本（builder 渲染时无法反推文字） |
| `dangerOf` | `bool Function(T item)?` | 是否危险项（红色文字） |
| `dashedOf` | `bool Function(T item)?` | 分割线是否为虚线 |
| `defaultOpenKeys` | `List<Object>` | 非受控默认展开子菜单 key 列表 |
| `defaultSelectedKeys` | `List<Object>` | 非受控默认选中 key 列表 |
| `disabled` | `bool` | 是否禁用整个菜单 |
| `disabledOf` | `bool Function(T item)?` | 是否禁用 |
| `expandIcon` | `Widget?` | 自定义展开箭头 |
| `extraBuilder` | `AntMenuExtraBuilder<T>?` | 右侧附加内容构建器 |
| `iconBuilder` | `AntMenuIconBuilder<T>?` | 图标构建器 |
| `inlineCollapsed` | `bool` | 内嵌模式折叠（仅显示图标，子菜单以浮层展开） |
| `inlineIndent` | `double` | 内嵌缩进（每级） |
| `items` | `List<T>` | 菜单项列表（任意用户模型） |
| `keyOf` | `Object Function(T item)?` | 提取菜单唯一标识，默认使用层级下标 |
| `labelBuilder` | `AntMenuLabelBuilder<T>?` | 菜单标题构建器，未提供时回退为 Text('$item') |
| `mode` | `AntMenuMode` | 菜单模式 |
| `multiple` | `bool` | 是否多选（需 selectable 为 true） |
| `onClick` | `ValueChanged<T>?` | 点击菜单项回调（回传用户模型） |
| `onDeselect` | `ValueChanged<T>?` | 取消选中回调（仅 multiple 下生效） |
| `onItemClick` | `ValueChanged<T>?` | 点击菜单项回调（回传用户模型，与 onClick 同时触发） |
| `onOpenChange` | `ValueChanged<List<Object>>?` | 子菜单展开/折叠回调 |
| `onSelect` | `ValueChanged<T>?` | 选中回调（多选时每次加入选中集合都会触发） |
| `onSelectedKeysChange` | `ValueChanged<List<Object>>?` | 选中集合变化回调（多选时回传完整集合） |
| `openKeys` | `List<Object>?` | 受控展开子菜单 key 列表 |
| `overflowedIndicator` | `Widget?` | 水平模式溢出时的折叠图标（默认 ···） |
| `selectable` | `bool` | 是否可选中（默认 true） |
| `selectedKeys` | `List<Object>?` | 受控选中 key 列表 |
| `subMenuCloseDelay` | `Duration` | 悬浮收起延迟 |
| `subMenuOpenDelay` | `Duration` | 悬浮展开延迟 |
| `theme` | `AntMenuTheme` | 主题 |
| `tooltip` | `bool` | 折叠态（inlineCollapsed）下是否用 Tooltip 展示标题 |
| `tooltipTitleOf` | `AntMenuTooltipTitleOf<T>?` | 折叠态 Tooltip 标题提取器 |
| `triggerSubMenuAction` | `AntMenuTrigger` | 子菜单触发方式（默认悬浮 |
| `typeOf` | `AntMenuItemType Function(T item)?` | 菜单项类型提取器，默认按 childrenOf 是否为空推断 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntMenu<T>>` | — |

