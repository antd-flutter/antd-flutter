<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntListItem

> 种类：类

```dart
class AntListItem
```

列表条目 — 主内容 / 右侧 extra / 操作组。

## 构造函数

### `AntListItem({super.key, required this.content, this.extra, this.actions, this.onTap})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `content` | `Widget` | 可选 | — |
| `extra` | `Widget?` | 可选 | — |
| `actions` | `List<AntListAction>?` | 可选 | — |
| `onTap` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actions` | `List<AntListAction>?` | 操作组（底部横向排列） |
| `content` | `Widget` | 主内容 |
| `extra` | `Widget?` | 右侧附加内容 |
| `onTap` | `VoidCallback?` | 条目点击回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

