<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPicker

> 种类：类

```dart
class AntPicker
```

底部弹出选择器 — 弹出面板中展示多列滚轮。

## 构造函数

### `AntPicker({super.key, required this.columns, this.value, this.defaultValue = const [], this.title, this.confirmText = '确定', this.cancelText = '取消', this.onConfirm, this.onCancel, this.onSelect, this.closeOnMaskClick = true, this.visible, this.onClose, this.child, this.itemHeight = 40, this.pickerHeight = 260})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `columns` | `List<AntPickerColumn>` | 可选 | — |
| `value` | `List<AntPickerValue>?` | 可选 | — |
| `defaultValue` | `List<AntPickerValue>` | = const [] | — |
| `title` | `String?` | 可选 | — |
| `confirmText` | `String` | = '确定' | — |
| `cancelText` | `String` | = '取消' | — |
| `onConfirm` | `ValueChanged<List<AntPickerValue>>?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |
| `onSelect` | `ValueChanged<List<AntPickerValue>>?` | 可选 | — |
| `closeOnMaskClick` | `bool` | = true | — |
| `visible` | `bool?` | 可选 | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `itemHeight` | `double` | = 40 | — |
| `pickerHeight` | `double` | = 260 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `cancelText` | `String` | 取消按钮文本 |
| `child` | `Widget?` | 触发器组件（点击打开面板） |
| `closeOnMaskClick` | `bool` | 点击遮罩是否关闭 |
| `columns` | `List<AntPickerColumn>` | 列数据 |
| `confirmText` | `String` | 确认按钮文本 |
| `defaultValue` | `List<AntPickerValue>` | 非受控初始值 |
| `itemHeight` | `double` | 单项高度 |
| `onCancel` | `VoidCallback?` | 取消回调 |
| `onClose` | `VoidCallback?` | 关闭回调 |
| `onConfirm` | `ValueChanged<List<AntPickerValue>>?` | 确认回调 |
| `onSelect` | `ValueChanged<List<AntPickerValue>>?` | 选中变化回调（滚轮滚动时触发） |
| `pickerHeight` | `double` | 滚轮区域高度 |
| `title` | `String?` | 面板标题 |
| `value` | `List<AntPickerValue>?` | 受控值 |
| `visible` | `bool?` | 受控可见性 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPicker>` | — |

