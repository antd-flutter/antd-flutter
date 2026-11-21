<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntResult

> 种类：类

```dart
class AntResult
```

结果页 — 用于反馈一系列操作任务的处理结果。

对齐 antd React Result 组件。

## 构造函数

### `AntResult({super.key, this.status = AntResultStatus.info, this.title, this.subTitle, this.extra, this.children, this.icon})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `status` | `AntResultStatus` | = AntResultStatus.info | — |
| `title` | `String?` | 可选 | — |
| `subTitle` | `String?` | 可选 | — |
| `extra` | `Widget?` | 可选 | — |
| `children` | `Widget?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `Widget?` | 自定义内容区（展示在操作区下方） |
| `extra` | `Widget?` | 操作区（如按钮组） |
| `icon` | `Widget?` | 自定义图标（覆盖状态默认图标 |
| `status` | `AntResultStatus` | 结果状态（决定默认图标/数字大字与颜色） |
| `subTitle` | `String?` | 副标题 |
| `title` | `String?` | 主标题 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildImage` | `Widget` | 构建状态图/数字大字区域 |
| `_statusColor` | `Color` | 语义状态映射主题色 |
| `build` | `Widget` | — |

