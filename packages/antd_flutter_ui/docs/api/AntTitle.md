<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTitle

> 种类：类

```dart
class AntTitle
```

Ant Design 标题组件。

对应 antd `<Typography.Title level={1..5}>`。
默认 colorTextHeading、fontWeightStrong、下边距 titleMarginBottom。

## 构造函数

### `AntTitle(String text, {super.key, this.level = AntTitleLevel.h1, super.type, super.disabled, super.copyable, super.copyConfig, super.editable, super.editConfig, super.ellipsis, super.code, super.mark, super.underline, super.delete, super.keyboard, super.italic, super.onTap, super.selectable, super.style})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String` | 可选 | — |
| `level` | `AntTitleLevel` | = AntTitleLevel.h1 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_overrideStrong` | `bool` | 内部标记：是否允许 strong 覆盖（默认构造强制 strong=true） |
| `level` | `AntTitleLevel` | 标题层级（h1 ~ h5） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `strong` | `bool` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTypography>` | — |

