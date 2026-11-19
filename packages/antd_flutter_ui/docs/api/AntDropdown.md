<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDropdown

> 种类：类

```dart
class AntDropdown
```

下拉菜单 — 页面上的菜单导航。

对齐 antd React Dropdown 组件，支持悬停/点击触发、
四个方向弹出位置、受控显示、分割线与危险项。

```dart
AntDropdown(
  items: [
    AntDropdownItem(key: '1', label: '菜单项一'),
    AntDropdownItem(key: '2', label: '菜单项二'),
  ],
  child: AntButton(child: Text('下拉菜单')),
)
```

## 构造函数

### `AntDropdown({super.key, required this.child, this.items = const [], this.trigger = AntDropdownTrigger.hover, this.placement = AntDropdownPlacement.bottomLeft, this.open, this.onOpenChange, this.controller, this.onClick, this.arrow = false, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `items` | `List<AntDropdownItem>` | = const [] | — |
| `trigger` | `AntDropdownTrigger` | = AntDropdownTrigger.hover | — |
| `placement` | `AntDropdownPlacement` | = AntDropdownPlacement.bottomLeft | — |
| `open` | `bool?` | 可选 | — |
| `onOpenChange` | `ValueChanged<bool>?` | 可选 | — |
| `controller` | `AntDropdownController?` | 可选 | — |
| `onClick` | `ValueChanged<String>?` | 可选 | — |
| `arrow` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `arrow` | `bool` | 是否显示箭头 |
| `child` | `Widget` | 触发元素 |
| `controller` | `AntDropdownController?` | 程序化控制器（可选） |
| `disabled` | `bool` | 是否禁用 |
| `items` | `List<AntDropdownItem>` | 下拉菜单项列表 |
| `onClick` | `ValueChanged<String>?` | 点击菜单项回调 |
| `onOpenChange` | `ValueChanged<bool>?` | 显示状态变化回调 |
| `open` | `bool?` | 受控显示状态 |
| `placement` | `AntDropdownPlacement` | 弹出位置 |
| `trigger` | `AntDropdownTrigger` | 触发方式 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntDropdown>` | — |

