<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSideBarItem

> 种类：类

```dart
class AntSideBarItem
```

侧边导航栏项。

## 构造函数

### `AntSideBarItem({required this.key, this.title, this.titleWidget, this.badgeText, this.badgeDot = false, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `titleWidget` | `Widget?` | 可选 | — |
| `badgeText` | `String?` | 可选 | — |
| `badgeDot` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `badgeDot` | `bool` | 圆点角标 |
| `badgeText` | `String?` | 文字角标 |
| `disabled` | `bool` | 是否禁用 |
| `key` | `String` | 唯一标识 |
| `title` | `String?` | 标题文字 |
| `titleWidget` | `Widget?` | 自定义标题 Widget（优先于 title） |

