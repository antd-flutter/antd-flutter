<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarCellRenderInfo

> 种类：类

```dart
class AntCalendarCellRenderInfo
```

单元格渲染信息（antd v6 cellRender / fullCellRender 的 info 参数对齐）。

## 构造函数

### `AntCalendarCellRenderInfo({required this.isToday, required this.isSelected, required this.isCurrentMonth, required this.isDisabled, required this.isInValidRange, this.type = AntCalendarCellType.date, this.originNode})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `isToday` | `bool` | 可选 | — |
| `isSelected` | `bool` | 可选 | — |
| `isCurrentMonth` | `bool` | 可选 | — |
| `isDisabled` | `bool` | 可选 | — |
| `isInValidRange` | `bool` | 可选 | — |
| `type` | `AntCalendarCellType` | = AntCalendarCellType.date | — |
| `originNode` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isCurrentMonth` | `bool` | 是否属于当前展示月份 |
| `isDisabled` | `bool` | 是否被禁用（disabledDate / min/max / validRange 之外） |
| `isInValidRange` | `bool` | 是否在 validRange 内（未配置 validRange 时恒为 true） |
| `isSelected` | `bool` | 是否为选中日期 |
| `isToday` | `bool` | 是否为今天 |
| `originNode` | `Widget?` | 默认渲染节点（antd v6 info.originNode 的降级近似）： cellRender / fullC… |
| `type` | `AntCalendarCellType` | 单元格类型（antd v6 info.type）：日期格为 AntCalendarCellType.date， 月… |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `toString` | `String` | — |

