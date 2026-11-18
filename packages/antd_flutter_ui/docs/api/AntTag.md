<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTag

> 种类：类

```dart
class AntTag
```

标签 — 进行标记和分类的小标签。

对齐 antd React Tag 组件。

## 构造函数

### `AntTag({super.key, required this.child, this.color, this.customColor, this.bordered = true, this.closable = false, this.onClose, this.icon, this.padding})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `String` | 可选 | — |
| `color` | `AntTagColor?` | 可选 | — |
| `customColor` | `Color?` | 可选 | — |
| `bordered` | `bool` | = true | — |
| `closable` | `bool` | = false | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `padding` | `EdgeInsets?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bordered` | `bool` | 是否有边框 |
| `child` | `String` | 标签内容 |
| `closable` | `bool` | 是否可关闭 |
| `color` | `AntTagColor?` | 预设颜色 |
| `customColor` | `Color?` | 自定义颜色值（十六进制或 Color） |
| `icon` | `Widget?` | 前置图标 |
| `onClose` | `VoidCallback?` | 关闭回调 |
| `padding` | `EdgeInsets?` | 内边距 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTag>` | — |

