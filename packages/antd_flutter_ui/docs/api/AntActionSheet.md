<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntActionSheet

> 种类：类

```dart
class AntActionSheet
```

动作面板 — 从底部弹出的一组操作选项。

对齐 antd-mobile ActionSheet 组件：actions 列表 + 可选取消按钮，
支持 danger 红色、disabled 灰显、extraDescription 附加说明、
closeOnAction 点击后关闭、遮罩点击关闭、底部安全区适配。

## 构造函数

### `AntActionSheet({super.key, required this.visible, required this.actions, this.extraDescription, this.onClose, this.cancelText, this.closeOnAction = false, this.safeArea = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `visible` | `bool` | 可选 | — |
| `actions` | `List<ActionSheetAction>` | 可选 | — |
| `extraDescription` | `String?` | 可选 | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `closeOnAction` | `bool` | = false | — |
| `safeArea` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actions` | `List<ActionSheetAction>` | 动作选项列表 |
| `cancelText` | `String?` | 取消按钮文案（传入即显示独立灰色取消区域） |
| `closeOnAction` | `bool` | 点击选项后是否关闭面板（默认 false） |
| `extraDescription` | `String?` | 顶部附加说明 |
| `onClose` | `VoidCallback?` | 关闭回调（遮罩 / 取消按钮 / closeOnAction 触发，外部应将 visible 置为 false） |
| `safeArea` | `bool` | 是否适配底部安全区（默认 true） |
| `visible` | `bool` | 受控显示状态 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntActionSheet>` | — |

