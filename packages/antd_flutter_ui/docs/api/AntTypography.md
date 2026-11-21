<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTypography

> 种类：类

```dart
class AntTypography
```

Ant Design Typography 基础组件。

所有排版组件（`AntTitle` / `AntParagraph` / `AntText` / `AntLink`）
共享此基类的通用能力。

## 构造函数

### `AntTypography({super.key, this.text, this.child, this.type, this.disabled = false, this.copyable = false, this.copyConfig, this.editable = false, this.editConfig, this.ellipsis, this.code = false, this.mark = false, this.underline = false, this.delete = false, this.strong = false, this.keyboard = false, this.italic = false, this.style, this.onTap, this.selectable = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `type` | `AntTypographyType?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `copyable` | `bool` | = false | — |
| `copyConfig` | `AntCopyConfig?` | 可选 | — |
| `editable` | `bool` | = false | — |
| `editConfig` | `AntEditConfig?` | 可选 | — |
| `ellipsis` | `AntEllipsisConfig?` | 可选 | — |
| `code` | `bool` | = false | — |
| `mark` | `bool` | = false | — |
| `underline` | `bool` | = false | — |
| `delete` | `bool` | = false | — |
| `strong` | `bool` | = false | — |
| `keyboard` | `bool` | = false | — |
| `italic` | `bool` | = false | — |
| `style` | `TextStyle?` | 可选 | — |
| `onTap` | `VoidCallback?` | 可选 | — |
| `selectable` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 自定义内容 Widget（显示时优先于 text） |
| `code` | `bool` | 代码样式（等宽字体 + 灰底 + 边框） |
| `copyConfig` | `AntCopyConfig?` | 可复制详细配置 |
| `copyable` | `bool` | 是否可复制（true 时使用默认配置） |
| `delete` | `bool` | 删除线 |
| `disabled` | `bool` | 禁用状态 |
| `editConfig` | `AntEditConfig?` | 可编辑详细配置 |
| `editable` | `bool` | 是否可编辑（true 时使用默认配置） |
| `ellipsis` | `AntEllipsisConfig?` | 省略配置 |
| `italic` | `bool` | 斜体 |
| `keyboard` | `bool` | 键盘按键样式（等宽字体 + 小号 + 灰底） |
| `mark` | `bool` | 高亮标记（黄色背景） |
| `onTap` | `VoidCallback?` | 点击回调 |
| `selectable` | `bool` | 文本是否可选择 |
| `strong` | `bool` | 加粗（fontWeightStrong） |
| `style` | `TextStyle?` | 自定义 TextStyle（叠加在解析样式之上） |
| `text` | `String?` | 纯文本内容（用于渲染及 copyable/editable 取文本源） |
| `type` | `AntTypographyType?` | 文本语义类型 |
| `underline` | `bool` | 下划线 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTypography>` | — |

