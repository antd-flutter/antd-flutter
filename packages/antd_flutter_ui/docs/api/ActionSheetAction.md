<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# ActionSheetAction

> 种类：类

```dart
class ActionSheetAction
```

动作面板选项。

对齐 antd-mobile ActionSheet 的 action 配置。

## 构造函数

### `ActionSheetAction({required this.text, this.key, this.description, this.disabled = false, this.danger = false, this.onClick})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String` | 可选 | — |
| `key` | `Key?` | 可选 | — |
| `description` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `danger` | `bool` | = false | — |
| `onClick` | `ValueChanged<ActionSheetAction>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `danger` | `bool` | 是否为危险操作（红色文字） |
| `description` | `String?` | 二级描述文案（显示在标题下方） |
| `disabled` | `bool` | 是否禁用（灰显且不可点击） |
| `key` | `Key?` | 选项唯一标识 |
| `onClick` | `ValueChanged<ActionSheetAction>?` | 点击回调 |
| `text` | `String` | 标题文案 |

