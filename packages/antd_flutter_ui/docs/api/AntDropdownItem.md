<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDropdownItem

> 种类：类

```dart
class AntDropdownItem
```

下拉菜单项。

对齐 antd React Dropdown 的 menu.items 中的菜单项：
- `key` — 唯一标识
- `label` — 文字标签
- `labelWidget` — 自定义标签 Widget（优先于 `label`）
- `icon` — 图标
- `disabled` — 是否禁用
- `danger` — 是否危险项（红色文字）
- `type` — 项类型（item / divider）

## 构造函数

### `AntDropdownItem({required this.key, this.label, this.labelWidget, this.icon, this.disabled = false, this.danger = false, this.type = AntDropdownItemType.item})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `label` | `String?` | 可选 | — |
| `labelWidget` | `Widget?` | 可选 | — |
| `icon` | `IconData?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `danger` | `bool` | = false | — |
| `type` | `AntDropdownItemType` | = AntDropdownItemType.item | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `danger` | `bool` | 是否危险项（红色文字） |
| `disabled` | `bool` | 是否禁用 |
| `icon` | `IconData?` | 图标 |
| `key` | `String` | 唯一标识 |
| `label` | `String?` | 文字标签 |
| `labelWidget` | `Widget?` | 自定义标签 Widget（优先于 label） |
| `type` | `AntDropdownItemType` | 项类型 |

