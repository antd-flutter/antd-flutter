<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCopyConfig

> 种类：类

```dart
class AntCopyConfig
```

可复制配置 — 对应 antd `CopyConfig`。

## 构造函数

### `AntCopyConfig({this.text, this.onCopy, this.icon, this.tooltips, this.tooltip = true, this.position = AntCopyIconPosition.after})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String?` | 可选 | — |
| `onCopy` | `VoidCallback?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `tooltips` | `List<String>?` | 可选 | — |
| `tooltip` | `bool` | = true | — |
| `position` | `AntCopyIconPosition` | = AntCopyIconPosition.after | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `icon` | `Widget?` | 自定义复制图标 |
| `onCopy` | `VoidCallback?` | 复制成功后的回调 |
| `position` | `AntCopyIconPosition` | 复制图标显示位置（前/后，默认后） |
| `text` | `String?` | 自定义复制文本（默认取子节点纯文本） |
| `tooltip` | `bool` | 是否显示 tooltip 提示（对齐 antd tooltips=false 能力，默认开启） |
| `tooltips` | `List<String>?` | 复制按钮的 tooltip 文本（默认 "复制", "已复制"） |

