<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMenuItem

> 种类：类

```dart
class AntMenuItem
```

菜单项。

## 构造函数

### `AntMenuItem({required this.key, this.label, this.labelWidget, this.icon, this.children = const [], this.disabled = false, this.danger = false, this.type = AntMenuItemType.item})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `label` | `String?` | 可选 | — |
| `labelWidget` | `Widget?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `children` | `List<AntMenuItem>` | = const [] | — |
| `disabled` | `bool` | = false | — |
| `danger` | `bool` | = false | — |
| `type` | `AntMenuItemType` | = AntMenuItemType.item | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntMenuItem>` | 子菜单项 |
| `danger` | `bool` | 是否危险操作（红色文字） |
| `disabled` | `bool` | 是否禁用 |
| `icon` | `Widget?` | 图标 |
| `key` | `String` | 唯一标识 |
| `label` | `String?` | 标题文字 |
| `labelWidget` | `Widget?` | 自定义标题组件 |
| `type` | `AntMenuItemType` | 菜单项类型 |

