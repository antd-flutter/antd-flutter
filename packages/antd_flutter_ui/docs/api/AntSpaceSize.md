<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSpaceSize

> 种类：类

```dart
class AntSpaceSize
```

Space 间距配置。

对齐 antd React Space 的 size 属性，支持三种形式：
- 预设尺寸：`AntSpaceSize.small` / `AntSpaceSize.middle` / `AntSpaceSize.large`
- 单值：`AntSpaceSize.all`（同时设置水平和垂直间距）
- 双值：`AntSpaceSize.only`（分别设置水平和垂直间距）

## 构造函数

### `AntSpaceSize._(this.preset, this.horizontalValue, this.verticalValue)`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `preset` | `AntSpaceGapSize?` | 可选 | — |
| `horizontalValue` | `double?` | 可选 | — |
| `verticalValue` | `double?` | 可选 | — |

### `AntSpaceSize.all(double value)`

单值 — 同时设置水平和垂直间距。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double` | 可选 | — |

### `AntSpaceSize.large()`

大间距预设。

### `AntSpaceSize.middle()`

中间距预设。

### `AntSpaceSize.only({double? horizontal, double? vertical})`

分别设置水平和垂直间距。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `horizontal` | `double?` | 可选 | — |
| `vertical` | `double?` | 可选 | — |

### `AntSpaceSize.small()`

小间距预设。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `horizontalValue` | `double?` | 自定义水平间距值 |
| `preset` | `AntSpaceGapSize?` | 间距预设 |
| `verticalValue` | `double?` | 自定义垂直间距值 |

