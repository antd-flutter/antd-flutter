<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFlexGap

> 种类：类

```dart
class AntFlexGap
```

Flex 间距配置。

对齐 antd React 的 gap 属性，支持三种形式：
- 预设尺寸：`AntFlexGap.small` / `AntFlexGap.middle` / `AntFlexGap.large`
- 单值：`AntFlexGap.all`（同时设置行间距和列间距）
- 双值：`AntFlexGap.only`（分别设置行间距和列间距）

## 构造函数

### `AntFlexGap._(this.size, this.rowValue, this.columnValue)`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `size` | `AntFlexGapSize?` | 可选 | — |
| `rowValue` | `double?` | 可选 | — |
| `columnValue` | `double?` | 可选 | — |

### `AntFlexGap.all(double value)`

单值 — 同时设置行间距和列间距。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double` | 可选 | — |

### `AntFlexGap.large()`

大间距预设。

### `AntFlexGap.middle()`

中间距预设。

### `AntFlexGap.only({double? row, double? column})`

分别设置行间距和列间距。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `row` | `double?` | 可选 | — |
| `column` | `double?` | 可选 | — |

### `AntFlexGap.small()`

小间距预设。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `columnValue` | `double?` | 自定义列间距值（主轴方向，元素与元素之间） |
| `rowValue` | `double?` | 自定义行间距值（交叉轴方向，换行时行与行之间） |
| `size` | `AntFlexGapSize?` | 间距预设 |

