<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTabsItem

> 种类：类

```dart
class AntTabsItem
```

选项卡项。

## 构造函数

### `AntTabsItem({required this.key, this.label, this.labelWidget, this.child, this.icon, this.disabled = false, this.closable})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String` | 可选 | — |
| `label` | `String?` | 可选 | — |
| `labelWidget` | `Widget?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `closable` | `bool?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 内容区域 |
| `closable` | `bool?` | 是否可关闭 |
| `disabled` | `bool` | 是否禁用 |
| `icon` | `Widget?` | 自定义图标 |
| `key` | `String` | 选项卡唯一标识 |
| `label` | `String?` | 标题文字 |
| `labelWidget` | `Widget?` | 自定义标题组件 |

