<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# WheelPickerColumn

> 种类：类

```dart
class WheelPickerColumn
```

单列滚轮引擎组件 — 基于 CupertinoPicker 的 iOS 风格滚轮。

职责：按 `column` 渲染选项、经 `controller` 定位选中项、
滚动停止时通过 `onSelected` 回报选中索引；样式（字号/文字色/分割线）
由调用方注入，引擎自身不读主题。

## 构造函数

### `WheelPickerColumn({super.key, required this.column, required this.controller, required this.itemHeight, required this.fontSize, required this.colorText, required this.onSelected})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `column` | `AntPickerColumn` | 可选 | — |
| `controller` | `FixedExtentScrollController` | 可选 | — |
| `itemHeight` | `double` | 可选 | — |
| `fontSize` | `double` | 可选 | — |
| `colorText` | `Color` | 可选 | — |
| `onSelected` | `ValueChanged<int>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `colorText` | `Color` | 选项文字颜色 |
| `column` | `AntPickerColumn` | 列数据 |
| `controller` | `FixedExtentScrollController` | 滚轮滚动控制器（选中项定位） |
| `fontSize` | `double` | 选项文字字号 |
| `itemHeight` | `double` | 单项高度 |
| `onSelected` | `ValueChanged<int>` | 选中项索引变化回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

