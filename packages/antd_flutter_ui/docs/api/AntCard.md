<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCard

> 种类：类

```dart
class AntCard
```

卡片 — 通用卡片容器。

对齐 antd React Card 组件。

## 构造函数

### `AntCard({super.key, this.title, this.extra, required this.child, this.cover, this.actions, this.bordered = true, this.hoverable = false, this.size = AntCardSize.standard, this.loading = false, this.onTap})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `title` | `Widget?` | 可选 | — |
| `extra` | `Widget?` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `cover` | `AntCardCover?` | 可选 | — |
| `actions` | `List<AntCardAction>?` | 可选 | — |
| `bordered` | `bool` | = true | — |
| `hoverable` | `bool` | = false | — |
| `size` | `AntCardSize` | = AntCardSize.standard | — |
| `loading` | `bool` | = false | — |
| `onTap` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actions` | `List<AntCardAction>?` | 底部操作列表 |
| `bordered` | `bool` | 是否有边框 |
| `child` | `Widget` | 卡片内容 |
| `cover` | `AntCardCover?` | 封面图 |
| `extra` | `Widget?` | 右上角操作区 |
| `hoverable` | `bool` | 是否可悬浮（悬浮时阴影加深） |
| `loading` | `bool` | 是否加载中 |
| `onTap` | `VoidCallback?` | 点击回调 |
| `size` | `AntCardSize` | 尺寸 |
| `title` | `Widget?` | 卡片标题 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCard>` | — |

