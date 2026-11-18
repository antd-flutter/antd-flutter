<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRow

> 种类：类

```dart
class AntRow
```

栅格行 — 24 栅格系统的行容器。

对齐 antd React Row 组件，配合 `AntCol` 实现栅格布局。

```dart
AntRow(
  gutter: 16,
  children: [
    AntCol(span: 12, child: Text('左半')),
    AntCol(span: 12, child: Text('右半')),
  ],
)
```

## 构造函数

### `AntRow({super.key, this.align = AntRowAlign.top, this.justify = AntRowJustify.start, this.gutter = 0, this.verticalGutter, this.wrap = false, this.children = const []})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `align` | `AntRowAlign` | = AntRowAlign.top | — |
| `justify` | `AntRowJustify` | = AntRowJustify.start | — |
| `gutter` | `double` | = 0 | — |
| `verticalGutter` | `double?` | 可选 | — |
| `wrap` | `bool` | = false | — |
| `children` | `List<Widget>` | = const [] | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `align` | `AntRowAlign` | 垂直对齐方式 |
| `children` | `List<Widget>` | 子元素列表，通常为 AntCol |
| `gutter` | `double` | 栅格间距（水平方向，逻辑像素，自动缩放） |
| `justify` | `AntRowJustify` | 水平分布方式 |
| `verticalGutter` | `double?` | 垂直间距（wrap 换行时行与行之间的间距） |
| `wrap` | `bool` | 是否允许换行 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |
| `_mapCrossAxisAlignment` | `CrossAxisAlignment` | 映射交叉轴对齐方式 |
| `_mapMainAxisAlignment` | `MainAxisAlignment` | 映射主轴分布方式 |
| `_mapWrapAlignment` | `WrapAlignment` | 映射 Wrap 主轴分布方式 |
| `_mapWrapCrossAlignment` | `WrapCrossAlignment` | 映射 Wrap 交叉轴对齐方式 |

