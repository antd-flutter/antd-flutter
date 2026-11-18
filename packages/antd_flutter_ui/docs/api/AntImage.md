<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntImage

> 种类：类

```dart
class AntImage
```

图片 — 可预览的图片容器，支持网络/资源图、加载占位与失败回退。

对齐 antd React Image 组件。网络图片经
`_buildNetworkImage` 统一接入 cached_network_image 缓存加载。

## 构造函数

### `AntImage({super.key, required this.src, this.previewSrc, this.width, this.height, this.fit, this.radius, this.preview = true, this.placeholder, this.fallback, this.errorWidget, this.onError, this.previewFit = BoxFit.contain})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `src` | `String` | 可选 | — |
| `previewSrc` | `String?` | 可选 | — |
| `width` | `double?` | 可选 | — |
| `height` | `double?` | 可选 | — |
| `fit` | `BoxFit?` | 可选 | — |
| `radius` | `double?` | 可选 | — |
| `preview` | `bool` | = true | — |
| `placeholder` | `Widget?` | 可选 | — |
| `fallback` | `String?` | 可选 | — |
| `errorWidget` | `Widget?` | 可选 | — |
| `onError` | `VoidCallback?` | 可选 | — |
| `previewFit` | `BoxFit` | = BoxFit.contain | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `errorWidget` | `Widget?` | 加载失败自定义占位，优先级高于 fallback |
| `fallback` | `String?` | 加载失败占位图地址（antd fallback 语义） |
| `fit` | `BoxFit?` | 图片填充模式 |
| `height` | `double?` | 显示高度（.w 缩放） |
| `onError` | `VoidCallback?` | 图片加载失败回调 |
| `placeholder` | `Widget?` | 加载中自定义占位，为空时显示进度指示器 |
| `preview` | `bool` | 是否点击弹出全屏预览，默认 true |
| `previewFit` | `BoxFit` | 预览大图填充模式，默认 contain |
| `previewSrc` | `String?` | 预览大图地址，为空时使用 src |
| `radius` | `double?` | 圆角半径（.r 缩放），为空时取主题大圆角 |
| `src` | `String` | 图片地址，http/https 开头走网络加载，其余按资源图处理 |
| `width` | `double?` | 显示宽度（.w 缩放） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_resolvedPreviewSrc` | `String` | 实际生效的预览地址 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntImage>` | — |

