<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntImagePreviewGroup

> 种类：类

```dart
class AntImagePreviewGroup
```

图片预览组 — 包裹一组 `AntImage`，点击任意一张
可在全屏预览内左右切换组内图片。

对齐 antd React Image.PreviewGroup 组件。

## 构造函数

### `AntImagePreviewGroup({super.key, required this.children})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `children` | `List<AntImage>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntImage>` | 组内图片列表 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_sources` | `List<String>` | 收集组内所有可预览地址（去重保序） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

