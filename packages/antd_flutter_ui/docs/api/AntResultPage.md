<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntResultPage

> 种类：类

```dart
class AntResultPage
```

页面级结果页 — 用于反馈一整套操作流程的最终处理结果。

对齐 antd-mobile v5 ResultPage 组件；整体内容在可用空间内垂直居中。

## 构造函数

### `AntResultPage({super.key, this.status = AntResultPageStatus.info, this.title, this.subTitle, this.description, this.buttons, this.children, this.icon})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `status` | `AntResultPageStatus` | = AntResultPageStatus.info | — |
| `title` | `String?` | 可选 | — |
| `subTitle` | `String?` | 可选 | — |
| `description` | `List<Widget>?` | 可选 | — |
| `buttons` | `List<Widget>?` | 可选 | — |
| `children` | `Widget?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `buttons` | `List<Widget>?` | 操作按钮区（按钮列表，水平居中排列） |
| `children` | `Widget?` | 自定义内容区（展示在按钮区下方） |
| `description` | `List<Widget>?` | 明细描述（多行文字列表，展示在副标题下方） |
| `icon` | `Widget?` | 自定义图标（覆盖状态默认图标） |
| `status` | `AntResultPageStatus` | 结果状态（决定默认图标与颜色） |
| `subTitle` | `String?` | 副标题 |
| `title` | `String?` | 主标题 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildButtons` | `Widget` | 构建按钮操作区 |
| `_buildDescription` | `List<Widget>` | 构建多行明细列表 |
| `_statusColor` | `Color` | 语义状态映射主题色 |
| `build` | `Widget` | — |

