<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntIndexBarItem

> 种类：类

```dart
class AntIndexBarItem
```

索引栏分组项。

## 构造函数

### `AntIndexBarItem({required this.key, this.title, this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 分组内容 |
| `key` | `String` | 索引标识（如 'A'、'B'） |
| `title` | `String?` | 分组标题（默认取 key） |

