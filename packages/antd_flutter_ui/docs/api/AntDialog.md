<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDialog

> 种类：类

```dart
class AntDialog
```

对话框 — 移动端模态弹窗，用于重要信息确认或内容展示。

对齐 antd-mobile v5 Dialog 组件：受控 `visible`、居中小卡片、
按钮横向均分居中排列、alert/confirm 双模式、actions 自定义按钮区、
遮罩点击关闭。

## 构造函数

### `AntDialog({super.key, this.visible = false, this.mode = AntDialogMode.alert, this.title, this.content, this.okText = kAntDialogDefaultOkText, this.cancelText = kAntDialogDefaultCancelText, this.actions = _defaultActions, this.closeOnMaskClick = true, this.onClick, this.widthFactor = kAntDialogDefaultWidthFactor})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `visible` | `bool` | = false | — |
| `mode` | `AntDialogMode` | = AntDialogMode.alert | — |
| `title` | `String?` | 可选 | — |
| `content` | `Widget?` | 可选 | — |
| `okText` | `String` | = kAntDialogDefaultOkText | — |
| `cancelText` | `String` | = kAntDialogDefaultCancelText | — |
| `actions` | `Object?` | = _defaultActions | — |
| `closeOnMaskClick` | `bool` | = true | — |
| `onClick` | `VoidCallback?` | 可选 | — |
| `widthFactor` | `double` | = kAntDialogDefaultWidthFactor | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actions` | `Object?` | 自定义按钮区 |
| `cancelText` | `String` | 取消按钮文案 |
| `closeOnMaskClick` | `bool` | 点击遮罩是否关闭（默认 true） |
| `content` | `Widget?` | 内容 |
| `mode` | `AntDialogMode` | 展示模式：alert 单按钮 / confirm 双按钮 |
| `okText` | `String` | 确认按钮文案 |
| `onClick` | `VoidCallback?` | 点击任意按钮回调（在关闭前触发） |
| `title` | `String?` | 标题 |
| `visible` | `bool` | 受控显示状态 |
| `widthFactor` | `double` | 卡片宽度占屏宽比例（默认 0.7） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actionsHidden` | `bool` | actions 是否为显式 null（隐藏按钮区） |
| `useDefaultActions` | `bool` | 是否使用默认按钮组 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntDialog>` | — |
| `alert` | `Future<bool>` | 弹出 alert 风格对话框（仅确认按钮），用户点击确认返回 true |
| `confirm` | `Future<bool>` | 弹出 confirm 风格对话框（确认 + 取消双按钮）， 确认返回 true，取消或遮罩关闭返回 false |

