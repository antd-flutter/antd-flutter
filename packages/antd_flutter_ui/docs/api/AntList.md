<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntList

> 种类：类

```dart
class AntList
```

列表 — 通用数据列表。

对齐 antd React List 组件。

## 构造函数

### `AntList({super.key, required this.items, required this.itemBuilder, this.header, this.footer, this.size = AntListSize.middle, this.bordered = false, this.split = true, this.loading = false, this.pageSize, this.empty, this.keyOf})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `itemBuilder` | `AntListItemBuilder<T>` | 可选 | — |
| `header` | `Widget?` | 可选 | — |
| `footer` | `Widget?` | 可选 | — |
| `size` | `AntListSize` | = AntListSize.middle | — |
| `bordered` | `bool` | = false | — |
| `split` | `bool` | = true | — |
| `loading` | `bool` | = false | — |
| `pageSize` | `int?` | 可选 | — |
| `empty` | `Widget?` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bordered` | `bool` | 是否有边框 |
| `empty` | `Widget?` | 自定义空状态（默认 AntEmpty） |
| `footer` | `Widget?` | 底部 |
| `header` | `Widget?` | 头部 |
| `itemBuilder` | `AntListItemBuilder<T>` | 条目构建函数 |
| `items` | `List<T>` | 数据源 |
| `keyOf` | `Object Function(T item)?` | 条目 key 提取函数 |
| `loading` | `bool` | 是否加载中 |
| `pageSize` | `int?` | 每页条数（传值后启用内部分页，初始展示第一页） |
| `size` | `AntListSize` | 尺寸 |
| `split` | `bool` | 是否显示分割线 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntList<T>>` | — |

