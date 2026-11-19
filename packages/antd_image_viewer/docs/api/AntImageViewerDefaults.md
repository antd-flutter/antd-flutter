<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntImageViewerDefaults

> 种类：类

```dart
class AntImageViewerDefaults
```

AntImageViewer 默认配置与公共构建器。

## 构造函数

### `AntImageViewerDefaults._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `animationDuration` | `Duration` | 开关动画时长 |
| `barrierAlpha` | `double` | 遮罩背景不透明度 |
| `defaultIndex` | `int` | 默认初始展示下标 |
| `maxZoomRatio` | `double` | 默认最大缩放倍数 |
| `networkPrefix` | `String` | 图片地址的网络前缀判断关键字 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `buildImage` | `Widget` | 构建单张大图：网络图走缓存加载，其余按资源图处理， 加载中/失败均给出占位 |
| `defaultError` | `Widget` | 默认加载失败占位：断裂图片 icon + 提示文字 |
| `defaultPlaceholder` | `Widget` | 默认加载中占位：居中圆形进度指示器 |
| `isNetworkSrc` | `bool` | 判断图片地址是否为网络图片（http/https 开头） |

