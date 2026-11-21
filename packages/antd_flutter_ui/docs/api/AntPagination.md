<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPagination

> 种类：类

```dart
class AntPagination
```

分页 — 采用分页的形式分隔长列表，每次只加载一个页面。

对齐 antd React Pagination 组件，支持受控/非受控页码、
每页条数切换、快速跳转、总条数显示和简单模式。

```dart
AntPagination(
  total: 100,
  onChange: (page) => print('page: $page'),
)
```

## 构造函数

### `AntPagination({super.key, this.current, this.defaultCurrent = 1, this.total = 0, this.pageSize, this.defaultPageSize = 10, this.showSizeChanger = false, this.showQuickJumper = false, this.showTotal = false, this.pageItemBuilder, this.totalBuilder, this.simple = false, this.disabled = false, this.size = AntPaginationSize.normal, this.pageSizeOptions = const [10, 20, 50, 100], this.onChange, this.onPageSizeChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `current` | `int?` | 可选 | — |
| `defaultCurrent` | `int` | = 1 | — |
| `total` | `int` | = 0 | — |
| `pageSize` | `int?` | 可选 | — |
| `defaultPageSize` | `int` | = 10 | — |
| `showSizeChanger` | `bool` | = false | — |
| `showQuickJumper` | `bool` | = false | — |
| `showTotal` | `bool` | = false | — |
| `pageItemBuilder` | `AntPaginationPageItemBuilder?` | 可选 | — |
| `totalBuilder` | `AntPaginationTotalBuilder?` | 可选 | — |
| `simple` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |
| `size` | `AntPaginationSize` | = AntPaginationSize.normal | — |
| `pageSizeOptions` | `List<int>` | = const [10, 20, 50, 100] | — |
| `onChange` | `ValueChanged<int>?` | 可选 | — |
| `onPageSizeChange` | `ValueChanged<int>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `current` | `int?` | 当前页码（受控） |
| `defaultCurrent` | `int` | 初始页码（非受控） |
| `defaultPageSize` | `int` | 初始每页条数（非受控） |
| `disabled` | `bool` | 是否禁用 |
| `onChange` | `ValueChanged<int>?` | 页码改变回调 |
| `onPageSizeChange` | `ValueChanged<int>?` | 每页条数改变回调 |
| `pageItemBuilder` | `AntPaginationPageItemBuilder?` | 页码项内容构建器，渲染在既有页码按钮容器内 |
| `pageSize` | `int?` | 每页条数（受控） |
| `pageSizeOptions` | `List<int>` | 每页条数选项 |
| `showQuickJumper` | `bool` | 是否显示快速跳转输入框 |
| `showSizeChanger` | `bool` | 是否显示每页条数切换器 |
| `showTotal` | `bool` | 是否显示总条数 |
| `simple` | `bool` | 简单模式 |
| `size` | `AntPaginationSize` | 尺寸 |
| `total` | `int` | 总条数 |
| `totalBuilder` | `AntPaginationTotalBuilder?` | 总条数构建器，替换默认「共 N 条」文案 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPagination>` | — |

