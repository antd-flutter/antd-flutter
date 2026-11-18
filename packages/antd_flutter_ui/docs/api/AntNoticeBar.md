<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntNoticeBar

> 种类：类

```dart
class AntNoticeBar
```

通告栏 — 展示一组消息通知。

适用于当前页面内信息的通知，是一种较醒目的页面内通知方式。
超长内容自动横向滚动（`delay` 后开始，`speed` 控制速度）。

```dart
AntNoticeBar(content: '这是一条通告信息')
```

## 构造函数

### `AntNoticeBar({super.key, this.content = '', this.contentWidget, this.color = AntNoticeBarColor.normal, this.delay = 2000, this.speed = 50, this.closeable = false, this.closeIcon, this.onClose, this.onClick, this.extra, this.icon, this.wrap = false, this.shape = AntNoticeBarShape.rectangular, this.bordered = AntNoticeBarBorder.block})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `content` | `String` | = '' | — |
| `contentWidget` | `Widget?` | 可选 | — |
| `color` | `AntNoticeBarColor` | = AntNoticeBarColor.normal | — |
| `delay` | `int` | = 2000 | — |
| `speed` | `double` | = 50 | — |
| `closeable` | `bool` | = false | — |
| `closeIcon` | `Widget?` | 可选 | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `onClick` | `VoidCallback?` | 可选 | — |
| `extra` | `Widget?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `wrap` | `bool` | = false | — |
| `shape` | `AntNoticeBarShape` | = AntNoticeBarShape.rectangular | — |
| `bordered` | `AntNoticeBarBorder` | = AntNoticeBarBorder.block | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bordered` | `AntNoticeBarBorder` | 边框模式 |
| `closeIcon` | `Widget?` | 自定义关闭按钮图标 |
| `closeable` | `bool` | 是否可关闭 |
| `color` | `AntNoticeBarColor` | 语义颜色类型 |
| `content` | `String` | 公告文本内容 |
| `contentWidget` | `Widget?` | 自定义内容 Widget |
| `delay` | `int` | 开始滚动的延迟，单位毫秒 |
| `extra` | `Widget?` | 额外操作区域，显示在关闭按钮左侧 |
| `icon` | `Widget?` | 左侧图标，默认为喇叭图标 |
| `onClick` | `VoidCallback?` | 点击事件 |
| `onClose` | `VoidCallback?` | 关闭时的回调 |
| `shape` | `AntNoticeBarShape` | 形状 |
| `speed` | `double` | 滚动速度，单位 px/s |
| `wrap` | `bool` | 是否多行展示（关闭滚动） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntNoticeBar>` | — |

