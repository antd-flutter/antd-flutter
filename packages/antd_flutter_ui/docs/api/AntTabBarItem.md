<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTabBarItem

> 种类：类

```dart
class AntTabBarItem
```

底部标签栏项。

对齐 antd-mobile TabBar.Item：
- `key` — 唯一标识
- `title` — 标题文字
- `titleWidget` — 自定义标题（优先于 `title`）
- `icon` — 图标
- `activeIcon` — 激活时图标（默认与 `icon` 相同）
- `badgeText` — 文字角标（如 '5'、'99+'）
- `badgeDot` — 红点角标

## 构造函数

### `AntTabBarItem({required this.key, this.title, this.titleWidget, this.icon, this.activeIcon, this.badgeText, this.badgeDot = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `titleWidget` | `Widget?` | 可选 | — |
| `icon` | `IconData?` | 可选 | — |
| `activeIcon` | `IconData?` | 可选 | — |
| `badgeText` | `String?` | 可选 | — |
| `badgeDot` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeIcon` | `IconData?` | 激活时图标（默认与 icon 相同） |
| `badgeDot` | `bool` | 红点角标 |
| `badgeText` | `String?` | 文字角标（如 '5'、'99+'） |
| `icon` | `IconData?` | 图标 |
| `key` | `String` | 唯一标识 |
| `title` | `String?` | 标题文字 |
| `titleWidget` | `Widget?` | 自定义标题 Widget（优先于 title） |

