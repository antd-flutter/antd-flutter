<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntEllipsis

> 种类：类

```dart
class AntEllipsis
```

文本省略 — 多行文本按行数截断，支持展开收起。

对齐 antd-mobile Ellipsis 组件。

## 构造函数

### `AntEllipsis({super.key, required this.content, this.direction = AntEllipsisDirection.end, this.rows = 1, this.expandText, this.collapseText, this.onContentClick, this.style})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `content` | `String` | 可选 | — |
| `direction` | `AntEllipsisDirection` | = AntEllipsisDirection.end | — |
| `rows` | `int` | = 1 | — |
| `expandText` | `String?` | 可选 | — |
| `collapseText` | `String?` | 可选 | — |
| `onContentClick` | `GestureTapCallback?` | 可选 | — |
| `style` | `TextStyle?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `collapseText` | `String?` | 收起文案 |
| `content` | `String` | 文本内容 |
| `direction` | `AntEllipsisDirection` | 截断方向 |
| `expandText` | `String?` | 展开文案 |
| `onContentClick` | `GestureTapCallback?` | 点击文本内容回调 |
| `rows` | `int` | 展示的行数 |
| `style` | `TextStyle?` | 文本样式透传 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntEllipsis>` | — |

