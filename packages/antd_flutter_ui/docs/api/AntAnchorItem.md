<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAnchorItem

> 种类：类

```dart
class AntAnchorItem
```

锚点链接项。

对齐 antd React Anchor 的 items 属性中的链接项：
- `key` — 唯一标识
- `title` — 文字标题
- `titleWidget` — 自定义标题 Widget（优先于 `title`）
- `children` — 子链接

## 构造函数

### `AntAnchorItem({required this.key, this.title, this.titleWidget, this.children = const []})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `titleWidget` | `Widget?` | 可选 | — |
| `children` | `List<AntAnchorItem>` | = const [] | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntAnchorItem>` | 子链接 |
| `key` | `String` | 唯一标识 |
| `title` | `String?` | 文字标题 |
| `titleWidget` | `Widget?` | 自定义标题 Widget（优先于 title） |

