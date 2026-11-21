<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopconfirm

> 种类：类

```dart
class AntPopconfirm
```

气泡确认框 — 点击元素时弹出的确认气泡，包含确认/取消按钮。

对齐 antd React Popconfirm 组件：支持标题/描述、九/十二方向弹出位置、
自定义按钮文案与图标、受控 open、disabled 禁用。
点击确认或取消后气泡自动关闭。

## 构造函数

### `AntPopconfirm({super.key, required this.child, this.title, this.description, this.okText, this.cancelText, this.onConfirm, this.onCancel, this.okButtonProps, this.cancelButtonProps, this.placement = AntPopconfirmPlacement.bottomLeft, this.icon, this.open, this.onOpenChange, this.controller, this.disabled = false, this.overlayStyle})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `description` | `String?` | 可选 | — |
| `okText` | `String?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `onConfirm` | `VoidCallback?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |
| `okButtonProps` | `AntPopconfirmButtonProps?` | 可选 | — |
| `cancelButtonProps` | `AntPopconfirmButtonProps?` | 可选 | — |
| `placement` | `AntPopconfirmPlacement` | = AntPopconfirmPlacement.bottomLeft | — |
| `icon` | `Widget?` | 可选 | — |
| `open` | `bool?` | 可选 | — |
| `onOpenChange` | `AntPopconfirmOpenChange?` | 可选 | — |
| `controller` | `AntPopconfirmController?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `overlayStyle` | `AntPopconfirmOverlayStyle?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `cancelButtonProps` | `AntPopconfirmButtonProps?` | 取消按钮附加属性 |
| `cancelText` | `String?` | 取消按钮文案（默认「取消」） |
| `child` | `Widget` | 触发元素 |
| `controller` | `AntPopconfirmController?` | 程序化控制器（可选） |
| `description` | `String?` | 补充描述 |
| `disabled` | `bool` | 是否禁用弹出 |
| `icon` | `Widget?` | 自定义图标（默认问号图标，主色） |
| `okButtonProps` | `AntPopconfirmButtonProps?` | 确认按钮附加属性（简化：仅支持 onTap 覆盖前的额外回调语义由 onConfirm 承担） |
| `okText` | `String?` | 确认按钮文案（默认「确定」） |
| `onCancel` | `VoidCallback?` | 取消回调（点击后自动关闭） |
| `onConfirm` | `VoidCallback?` | 确认回调（点击后自动关闭） |
| `onOpenChange` | `AntPopconfirmOpenChange?` | 显示状态变化回调 |
| `open` | `bool?` | 受控显示状态（非空时进入受控模式） |
| `overlayStyle` | `AntPopconfirmOverlayStyle?` | 浮层自定义样式 |
| `placement` | `AntPopconfirmPlacement` | 弹出位置 |
| `title` | `String?` | 确认框标题（为空时使用默认文案「确定吗？」） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPopconfirm>` | — |

