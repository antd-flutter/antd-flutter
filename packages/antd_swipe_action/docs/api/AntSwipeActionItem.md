<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSwipeActionItem

> 种类：类

```dart
class AntSwipeActionItem
```

滑动操作按钮配置。

对齐 antd-mobile SwipeAction 的 action 项：
```ts
{ text, color, onClick, disabled }
```

## 构造函数

### `AntSwipeActionItem({required this.text, this.color, this.onPressed, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String` | 可选 | — |
| `color` | `Color?` | 可选 | — |
| `onPressed` | `VoidCallback?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `color` | `Color?` | 按钮背景色（默认主色 |
| `disabled` | `bool` | 是否禁用（禁用后点击不触发回调） |
| `onPressed` | `VoidCallback?` | 点击回调 |
| `text` | `String` | 按钮文案 |

