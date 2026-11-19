<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntJumboTabItem

> 种类：类

```dart
class AntJumboTabItem
```

大选项卡项。

## 构造函数

### `AntJumboTabItem({required this.key, this.title, this.titleWidget, this.description, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `titleWidget` | `Widget?` | 可选 | — |
| `description` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `description` | `String?` | 描述文字（标题下方小字） |
| `disabled` | `bool` | 是否禁用 |
| `key` | `String` | 唯一标识 |
| `title` | `String?` | 主标题 |
| `titleWidget` | `Widget?` | 自定义主标题 Widget（优先于 title） |

