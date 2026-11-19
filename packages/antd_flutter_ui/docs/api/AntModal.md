<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntModal

> 种类：类

```dart
class AntModal
```

对话框 — 模态弹窗，用于重要信息确认或内容展示。

对齐 antd React Modal 组件：受控 `open`、遮罩点击关闭、右上角关闭、
确认/取消双按钮（主按钮主色）、confirmLoading 加载态、
footer 自定义或 null 隐藏、width 宽度与 centered 垂直居中。

## 构造函数

### `AntModal({super.key, this.open = false, this.title, this.content, this.okText = kAntModalDefaultOkText, this.cancelText = kAntModalDefaultCancelText, this.onOk, this.onCancel, this.confirmLoading = false, this.footer = _defaultFooter, this.width = kAntModalDefaultWidth, this.maskClosable = true, this.closable = true, this.centered = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `open` | `bool` | = false | — |
| `title` | `String?` | 可选 | — |
| `content` | `Widget?` | 可选 | — |
| `okText` | `String` | = kAntModalDefaultOkText | — |
| `cancelText` | `String` | = kAntModalDefaultCancelText | — |
| `onOk` | `VoidCallback?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |
| `confirmLoading` | `bool` | = false | — |
| `footer` | `Object?` | = _defaultFooter | — |
| `width` | `double?` | = kAntModalDefaultWidth | — |
| `maskClosable` | `bool` | = true | — |
| `closable` | `bool` | = true | — |
| `centered` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `cancelText` | `String` | 取消按钮文案 |
| `centered` | `bool` | 是否垂直居中（默认偏上展示） |
| `closable` | `bool` | 是否显示右上角关闭图标 |
| `confirmLoading` | `bool` | 确认按钮加载态（加载中不可点击） |
| `content` | `Widget?` | 内容 |
| `footer` | `Object?` | 自定义底部 |
| `maskClosable` | `bool` | 点击遮罩是否关闭 |
| `okText` | `String` | 确认按钮文案 |
| `onCancel` | `VoidCallback?` | 点击取消 / 遮罩 / 关闭图标回调 |
| `onOk` | `VoidCallback?` | 点击确认回调 |
| `open` | `bool` | 受控打开状态 |
| `title` | `String?` | 标题 |
| `width` | `double?` | 对话框宽度（逻辑像素） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `footerHidden` | `bool` | footer 是否为显式 null（隐藏底部） |
| `useDefaultFooter` | `bool` | footer 是否使用默认按钮组 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntModal>` | — |

