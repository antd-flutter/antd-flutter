<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAffix

> 种类：类

```dart
class AntAffix
```

固钉 — 将元素钉在可视区域。

对齐 antd React Affix 组件（仅视口触发）：监听最近可滚动祖先的滚动位置，
元素越过阈值时把 child 移入根 `Overlay` 以 `Positioned` 固定在视口边缘
（脱离滚动容器的裁剪与页头遮挡，antd 的 fixed 定位语义），
原布局处保留等宽高等大占位，下方内容不跳动；滚回原位后解除。

## 构造函数

### `AntAffix({super.key, required this.child, this.offsetTop = kAntAffixDefaultOffsetTop, this.offsetBottom, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `offsetTop` | `double?` | = kAntAffixDefaultOffsetTop | — |
| `offsetBottom` | `double?` | 可选 | — |
| `onChange` | `ValueChanged<bool>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 需要钉住的内容 |
| `offsetBottom` | `double?` | 距视口底部的触发距离（像素） |
| `offsetTop` | `double?` | 距视口顶部的触发距离（像素），默认 0 |
| `onChange` | `ValueChanged<bool>?` | 钉住状态变化回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntAffix>` | — |

