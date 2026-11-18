<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSpace

> 种类：类

```dart
class AntSpace
```

间距 — 组件间设置间距，支持排列方向、间距大小和分隔符。

对齐 antd React Space 组件，提供简洁的间距布局能力。

```dart
AntSpace(children: [Text('A'), Text('B')]) // 水平间距
AntSpace(direction: AntSpaceDirection.vertical, children: [...]) // 垂直间距
AntSpace(size: AntSpaceSize.large(), children: [...]) // 大间距
AntSpace(split: AntDivider(type: AntDividerType.vertical), children: [...]) // 带分隔符
```

## 构造函数

### `AntSpace({super.key, this.direction = AntSpaceDirection.horizontal, this.size, this.align, this.wrap = false, this.split, this.children = const []})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `direction` | `AntSpaceDirection` | = AntSpaceDirection.horizontal | — |
| `size` | `AntSpaceSize?` | 可选 | — |
| `align` | `AntSpaceAlign?` | 可选 | — |
| `wrap` | `bool` | = false | — |
| `split` | `Widget?` | 可选 | — |
| `children` | `List<Widget>` | = const [] | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `align` | `AntSpaceAlign?` | 交叉轴对齐方式 |
| `children` | `List<Widget>` | 子元素列表 |
| `direction` | `AntSpaceDirection` | 排列方向 |
| `size` | `AntSpaceSize?` | 间距配置 |
| `split` | `Widget?` | 子元素之间的分隔符 |
| `wrap` | `bool` | 是否换行 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_insertGap` | `List<Widget>` | 在子元素间插入间距（无分隔符模式） |
| `_insertGapAndSplit` | `List<Widget>` | 在子元素间插入间距和分隔符 |
| `_resolveSize` | `(double?, double?)` | 解析 size 配置为实际像素值（含 screenutil 缩放） |
| `build` | `Widget` | — |
| `_mapCrossAxisAlignment` | `CrossAxisAlignment` | 映射交叉轴对齐方式 |
| `_mapWrapCrossAlignment` | `WrapCrossAlignment` | 映射 Wrap 交叉轴对齐方式 |

