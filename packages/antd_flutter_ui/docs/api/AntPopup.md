<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopup

> 种类：类

```dart
class AntPopup
```

弹出层 — 从四方向滑出的浮层面板，常用于半屏内容展示。

对齐 antd-mobile v5 Popup 组件：受控 `visible`、四方向滑入
（SlideTransition + 遮罩淡入）、关闭图标、遮罩点击关闭。

## 构造函数

### `AntPopup({super.key, this.visible = false, this.position = AntPopupPosition.bottom, this.body, this.showCloseIcon = false, this.onClose, this.destroyOnClose = false, this.maskClosable = true, this.handle = false, this.borderRadius, this.backgroundColor})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `visible` | `bool` | = false | — |
| `position` | `AntPopupPosition` | = AntPopupPosition.bottom | — |
| `body` | `Widget?` | 可选 | — |
| `showCloseIcon` | `bool` | = false | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `destroyOnClose` | `bool` | = false | — |
| `maskClosable` | `bool` | = true | — |
| `handle` | `bool` | = false | — |
| `borderRadius` | `double?` | 可选 | — |
| `backgroundColor` | `Color?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `backgroundColor` | `Color?` | 自定义面板背景色（默认 colorBgContainer） |
| `body` | `Widget?` | 面板内容 |
| `borderRadius` | `double?` | 自定义面板圆角（覆盖方向默认圆角） |
| `destroyOnClose` | `bool` | 关闭后是否销毁内容（简化实现：隐藏时不保留内容） |
| `handle` | `bool` | 是否显示拖拽把手（占位属性，当前简化实现不渲染把手） |
| `maskClosable` | `bool` | 点击遮罩是否关闭（默认 true） |
| `onClose` | `VoidCallback?` | 关闭回调（点击关闭图标或遮罩时触发） |
| `position` | `AntPopupPosition` | 弹出方向（默认底部弹出） |
| `showCloseIcon` | `bool` | 是否显示关闭图标 |
| `visible` | `bool` | 受控显示状态 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntPopup>` | — |
| `show` | `void` | 函数式弹出一个临时弹出层（关闭动画结束后自动移除） |

