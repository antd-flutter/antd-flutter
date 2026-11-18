<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntImageDefaults

> 种类：类

```dart
class AntImageDefaults
```

AntImage 默认配置与公共构建器。

## 构造函数

### `AntImageDefaults._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `errorText` | `String` | 默认加载失败提示文字 |
| `networkPrefix` | `String` | 图片地址的网络前缀判断关键字 |
| `previewBarrierAlpha` | `double` | 默认预览遮罩背景透明度 |
| `previewMaxScale` | `double` | 预览图片最大缩放倍数 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `defaultError` | `Widget` | 默认加载失败占位：断裂图片 icon + 提示文字 |
| `defaultPlaceholder` | `Widget` | 默认加载中占位：居中圆形进度指示器 |
| `isNetworkSrc` | `bool` | 判断图片地址是否为网络图片（http/https 开头） |

