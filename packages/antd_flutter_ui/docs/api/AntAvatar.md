<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAvatar

> 种类：类

```dart
class AntAvatar
```

头像 — 用于用户头像或品牌标识，支持图片、图标和文字。

对齐 antd React Avatar 组件。

## 构造函数

### `AntAvatar({super.key, this.src, this.icon, this.child, this.shape = AntAvatarShape.circle, this.size, this.presetSize, this.gap = 4, this.draggable = false, this.onError, this.backgroundColor, this.fit, this.cacheManager})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `src` | `String?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `child` | `String?` | 可选 | — |
| `shape` | `AntAvatarShape` | = AntAvatarShape.circle | — |
| `size` | `double?` | 可选 | — |
| `presetSize` | `AntAvatarSize?` | 可选 | — |
| `gap` | `double` | = 4 | — |
| `draggable` | `bool` | = false | — |
| `onError` | `VoidCallback?` | 可选 | — |
| `backgroundColor` | `Color?` | 可选 | — |
| `fit` | `BoxFit?` | 可选 | — |
| `cacheManager` | `BaseCacheManager?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `backgroundColor` | `Color?` | 背景色，默认取主题色 |
| `cacheManager` | `BaseCacheManager?` | 网络图缓存管理器，默认使用 cachednetworkimage 内置缓存 |
| `child` | `String?` | 文字内容，src 和 icon 均为空时生效 |
| `draggable` | `bool` | 图片是否可拖拽 |
| `fit` | `BoxFit?` | 图片填充模式 |
| `gap` | `double` | 文字与边框间距 |
| `icon` | `Widget?` | 自定义图标，src 为空时生效 |
| `onError` | `VoidCallback?` | 图片加载失败回调 |
| `presetSize` | `AntAvatarSize?` | 预设尺寸 |
| `shape` | `AntAvatarShape` | 形状，默认圆形 |
| `size` | `double?` | 自定义像素尺寸 |
| `src` | `String?` | 图片地址，优先级最高 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildFallback` | `Widget` | 加载失败 fallback：与头像尺寸/形状一致的自绘占位 （主题色浅底 + 居中 person 图标），不出现破… |
| `_buildLoadingPlaceholder` | `Widget` | 加载中占位：主题色淡入的圆形进度指示器，尺寸随头像大小缩放 |
| `_buildSrcImage` | `Widget` | 图片地址分发：网络图走 cachednetworkimage 中间件封装， 本地资源走 Image.asset，与… |
| `_resolveBorderRadius` | `BorderRadius` | — |
| `_resolveSize` | `double` | 解析实际尺寸 |
| `build` | `Widget` | — |

