<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMenu

> 种类：类

```dart
class AntMenu
```

导航菜单 — 为页面和功能提供导航的菜单列表。

对齐 antd React Menu 组件，支持内嵌/垂直/水平三种模式、
亮/暗主题、受控/非受控选中与展开、分组与分割线。

```dart
AntMenu(
  items: [
    AntMenuItem(key: '1', label: '菜单项一'),
    AntMenuItem(key: 'sub1', label: '子菜单', children: [
      AntMenuItem(key: '1-1', label: '子项 1'),
    ]),
  ],
)
```

## 构造函数

### `AntMenu({super.key, this.items = const [], this.mode = AntMenuMode.inline, this.theme = AntMenuTheme.light, this.selectedKeys, this.defaultSelectedKeys = const [], this.openKeys, this.defaultOpenKeys = const [], this.onClick, this.onOpenChange, this.inlineCollapsed = false, this.inlineIndent = 24})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntMenuItem>` | = const [] | — |
| `mode` | `AntMenuMode` | = AntMenuMode.inline | — |
| `theme` | `AntMenuTheme` | = AntMenuTheme.light | — |
| `selectedKeys` | `List<String>?` | 可选 | — |
| `defaultSelectedKeys` | `List<String>` | = const [] | — |
| `openKeys` | `List<String>?` | 可选 | — |
| `defaultOpenKeys` | `List<String>` | = const [] | — |
| `onClick` | `ValueChanged<String>?` | 可选 | — |
| `onOpenChange` | `ValueChanged<List<String>>?` | 可选 | — |
| `inlineCollapsed` | `bool` | = false | — |
| `inlineIndent` | `double` | = 24 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `defaultOpenKeys` | `List<String>` | 非受控默认展开子菜单 key 列表 |
| `defaultSelectedKeys` | `List<String>` | 非受控默认选中 key 列表 |
| `inlineCollapsed` | `bool` | 内嵌模式折叠（仅显示图标） |
| `inlineIndent` | `double` | 内嵌缩进 |
| `items` | `List<AntMenuItem>` | 菜单项列表 |
| `mode` | `AntMenuMode` | 菜单模式 |
| `onClick` | `ValueChanged<String>?` | 点击菜单项回调 |
| `onOpenChange` | `ValueChanged<List<String>>?` | 子菜单展开/折叠回调 |
| `openKeys` | `List<String>?` | 受控展开子菜单 key 列表 |
| `selectedKeys` | `List<String>?` | 受控选中 key 列表 |
| `theme` | `AntMenuTheme` | 主题 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntMenu>` | — |

