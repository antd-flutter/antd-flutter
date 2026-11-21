<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAnchor

> 种类：类

```dart
class AntAnchor
```

锚点 — 用于跳转到页面指定位置。

对齐 antd React Anchor 组件，支持垂直/水平方向、
受控激活状态、点击与变化回调。

```dart
AntAnchor(
  items: [
    AntAnchorItem(key: 'part-1', title: 'Part 1'),
    AntAnchorItem(key: 'part-2', title: 'Part 2'),
  ],
  onClick: (key) => print('clicked: $key'),
)
```

## 构造函数

### `AntAnchor({super.key, this.items = const [], this.direction = AntAnchorDirection.vertical, this.controller, this.onClick, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntAnchorItem>` | = const [] | — |
| `direction` | `AntAnchorDirection` | = AntAnchorDirection.vertical | — |
| `controller` | `AntAnchorController?` | 可选 | — |
| `onClick` | `ValueChanged<String>?` | 可选 | — |
| `onChange` | `ValueChanged<String?>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `controller` | `AntAnchorController?` | 受控控制器 |
| `direction` | `AntAnchorDirection` | 锚点方向 |
| `items` | `List<AntAnchorItem>` | 锚点链接项列表 |
| `onChange` | `ValueChanged<String?>?` | 激活项变化回调 |
| `onClick` | `ValueChanged<String>?` | 点击链接回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntAnchor>` | — |

