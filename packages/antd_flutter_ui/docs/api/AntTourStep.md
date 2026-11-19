<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTourStep

> 种类：类

```dart
class AntTourStep
```

漫游式引导的单个步骤。

对齐 antd React Tour 的 TourStep：`target` 为空时卡片全屏居中，
`title` / `description` 为卡片文字内容，
`placement` / `mask` / `arrow` 可覆盖 `AntTour` 的同名配置。

## 构造函数

### `AntTourStep({this.target, this.title, this.description, this.cover, this.placement, this.mask, this.arrow})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `target` | `GlobalKey?` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `description` | `String?` | 可选 | — |
| `cover` | `Widget?` | 可选 | — |
| `placement` | `AntTourPlacement?` | 可选 | — |
| `mask` | `bool?` | 可选 | — |
| `arrow` | `bool?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `arrow` | `bool?` | 是否显示箭头（覆盖 Tour 级配置） |
| `cover` | `Widget?` | 步骤顶部展示的封面（图片或自定义 Widget） |
| `description` | `String?` | 步骤描述内容 |
| `mask` | `bool?` | 是否显示遮罩（覆盖 Tour 级配置） |
| `placement` | `AntTourPlacement?` | 引导卡片位置（覆盖 Tour 级配置） |
| `target` | `GlobalKey?` | 引导卡片指向的目标元素（为空时卡片全屏居中） |
| `title` | `String?` | 步骤标题 |

