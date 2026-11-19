<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarPicker

> 种类：类

```dart
class AntCalendarPicker
```

底部弹窗日历选择器 — 点击触发器弹出底部面板，内含日历视图。

## 构造函数

### `AntCalendarPicker({super.key, this.selectionMode = AntCalendarSelectionMode.single, this.value, this.defaultValue = const [], this.onChange, this.min, this.max, this.weekStartsOn = AntCalendarWeekStartsOn.sunday, this.allowClear = true, this.title, this.confirmText, this.cancelText, this.onConfirm, this.onCancel, this.visible, this.onClose, this.onMaskClick, this.showCloseButton = true, this.closeOnMaskClick = true, this.child, this.locale})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `selectionMode` | `AntCalendarSelectionMode` | = AntCalendarSelectionMode.single | — |
| `value` | `List<DateTime>?` | 可选 | — |
| `defaultValue` | `List<DateTime>` | = const [] | — |
| `onChange` | `ValueChanged<List<DateTime>>?` | 可选 | — |
| `min` | `DateTime?` | 可选 | — |
| `max` | `DateTime?` | 可选 | — |
| `weekStartsOn` | `AntCalendarWeekStartsOn` | = AntCalendarWeekStartsOn.sunday | — |
| `allowClear` | `bool` | = true | — |
| `title` | `String?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `onConfirm` | `ValueChanged<List<DateTime>>?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |
| `visible` | `bool?` | 可选 | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `onMaskClick` | `VoidCallback?` | 可选 | — |
| `showCloseButton` | `bool` | = true | — |
| `closeOnMaskClick` | `bool` | = true | — |
| `child` | `Widget?` | 可选 | — |
| `locale` | `AntCalendarLocale?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 点击已选日期是否清除选择 |
| `cancelText` | `String?` | 取消按钮文本 |
| `child` | `Widget?` | 触发器组件（点击打开面板） |
| `closeOnMaskClick` | `bool` | 点击遮罩是否关闭 |
| `confirmText` | `String?` | 确认按钮文本 |
| `defaultValue` | `List<DateTime>` | 非受控初始值 |
| `locale` | `AntCalendarLocale?` | 国际化文案 |
| `max` | `DateTime?` | 最大可选日期 |
| `min` | `DateTime?` | 最小可选日期 |
| `onCancel` | `VoidCallback?` | 取消回调 |
| `onChange` | `ValueChanged<List<DateTime>>?` | 选择变化回调（弹窗内选择时触发） |
| `onClose` | `VoidCallback?` | 关闭回调 |
| `onConfirm` | `ValueChanged<List<DateTime>>?` | 确认回调 |
| `onMaskClick` | `VoidCallback?` | 遮罩点击回调（antd-mobile onMaskClick 对齐）：经遮罩关闭面板时 触发（onClose 之后） |
| `selectionMode` | `AntCalendarSelectionMode` | 选择模式 |
| `showCloseButton` | `bool` | 是否展示面板右上角关闭按钮（antd-mobile Popup showCloseButton 对齐，默认 true） |
| `title` | `String?` | 面板标题 |
| `value` | `List<DateTime>?` | 受控值 |
| `visible` | `bool?` | 受控可见性 |
| `weekStartsOn` | `AntCalendarWeekStartsOn` | 周起始日 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCalendarPicker>` | — |

