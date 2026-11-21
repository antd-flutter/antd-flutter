<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntImageViewer

> 种类：类

```dart
class AntImageViewer
```

图片查看器 — 全屏浏览多张图片，支持缩放与左右切换。

对齐 antd-mobile MultiImageViewer 组件（组件本身支持多图）。

## 构造函数

### `AntImageViewer({super.key, required this.images, required this.open, this.defaultIndex = AntImageViewerDefaults.defaultIndex, this.onClose, this.afterClose, this.maxZoomRatio = AntImageViewerDefaults.maxZoomRatio, this.enableCompositeZoom = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `images` | `List<String>` | 可选 | — |
| `open` | `bool` | 可选 | — |
| `defaultIndex` | `int` | = AntImageViewerDefaults.defaultIndex | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `afterClose` | `VoidCallback?` | 可选 | — |
| `maxZoomRatio` | `double` | = AntImageViewerDefaults.maxZoomRatio | — |
| `enableCompositeZoom` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `afterClose` | `VoidCallback?` | 关闭动画结束后的回调 |
| `defaultIndex` | `int` | 初始展示下标 |
| `enableCompositeZoom` | `bool` | 是否开启双击缩放，默认开启 |
| `images` | `List<String>` | 图片地址列表 |
| `maxZoomRatio` | `double` | 最大缩放倍数（InteractiveViewer maxScale 边界），默认 3 |
| `onClose` | `VoidCallback?` | 关闭回调（遮罩轻点/关闭按钮/单图轻点触发，由外部控制 open 关闭） |
| `open` | `bool` | 受控显示开关 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntImageViewer>` | — |

