<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntQRCode

> 种类：类

```dart
class AntQRCode
```

二维码 — 展示二维码的组件。

对齐 antd React QRCode 组件。

## 构造函数

### `AntQRCode({super.key, required this.value, this.size = _kDefaultSize, this.errorLevel = AntQRCodeErrorLevel.m, this.color, this.bgColor, this.icon = false, this.iconSize = _kDefaultIconSize, this.status = AntQRCodeStatus.active, this.onRefresh, this.bordered = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String` | 可选 | — |
| `size` | `double` | = _kDefaultSize | — |
| `errorLevel` | `AntQRCodeErrorLevel` | = AntQRCodeErrorLevel.m | — |
| `color` | `Color?` | 可选 | — |
| `bgColor` | `Color?` | 可选 | — |
| `icon` | `bool` | = false | — |
| `iconSize` | `double` | = _kDefaultIconSize | — |
| `status` | `AntQRCodeStatus` | = AntQRCodeStatus.active | — |
| `onRefresh` | `VoidCallback?` | 可选 | — |
| `bordered` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bgColor` | `Color?` | 背景色，默认取主题容器背景色 |
| `bordered` | `bool` | 是否显示边框 |
| `color` | `Color?` | 前景色（二维码点色），默认取主题文字色 |
| `errorLevel` | `AntQRCodeErrorLevel` | 纠错等级 |
| `icon` | `bool` | 是否在二维码中心显示图标 |
| `iconSize` | `double` | 中间图标尺寸 |
| `onRefresh` | `VoidCallback?` | 过期后点击刷新回调 |
| `size` | `double` | 尺寸（逻辑像素，内部按 .w 缩放） |
| `status` | `AntQRCodeStatus` | 二维码状态 |
| `value` | `String` | 二维码内容 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildCenterIcon` | `Widget` | 中间图标：白底圆形遮罩 + 图标 |
| `_buildQRView` | `Widget` | 渲染二维码（SDK 语义经本中间层映射，外部不感知） |
| `_buildStatusOverlay` | `Widget` | 状态覆盖层（expired / scanned） |
| `_mapErrorLevel` | `int` | 纠错等级映射（中间层隔离 SDK 枚举语义） |
| `build` | `Widget` | — |

