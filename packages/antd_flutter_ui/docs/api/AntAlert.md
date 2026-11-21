<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAlert

> 种类：类

```dart
class AntAlert
```

警告提示 — 展示需要用户关注的信息。

对齐 antd React Alert 组件。

## 构造函数

### `AntAlert({super.key, this.type = AntAlertType.info, required this.message, this.description, this.closable = false, this.onClose, this.showIcon = false, this.icon, this.action, this.banner = false, this.bordered = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `type` | `AntAlertType` | = AntAlertType.info | — |
| `message` | `String` | 可选 | — |
| `description` | `String?` | 可选 | — |
| `closable` | `bool` | = false | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `showIcon` | `bool` | = false | — |
| `icon` | `Widget?` | 可选 | — |
| `action` | `Widget?` | 可选 | — |
| `banner` | `bool` | = false | — |
| `bordered` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `action` | `Widget?` | 操作区（右侧补充操作） |
| `banner` | `bool` | 是否用作顶部公告（横幅变体：无边框/圆角，默认显示图标） |
| `bordered` | `bool` | 是否显示边框 |
| `closable` | `bool` | 是否可关闭 |
| `description` | `String?` | 警告描述内容 |
| `icon` | `Widget?` | 自定义图标（覆盖默认图标，仅在 showIcon 时生效） |
| `message` | `String` | 警告提示内容（主体） |
| `onClose` | `VoidCallback?` | 关闭回调 |
| `showIcon` | `bool` | 是否显示辅助图标 |
| `type` | `AntAlertType` | 语义类型 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntAlert>` | — |

