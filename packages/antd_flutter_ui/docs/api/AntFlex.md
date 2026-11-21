<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFlex

> 种类：类

```dart
class AntFlex
```

弹性布局 — 高效的对齐、间隔和分布子元素容器。

对齐 antd React Flex 组件，提供简洁的 flex 布局能力。

```dart
AntFlex(children: [Text('A'), Text('B')]) // 水平排列
AntFlex(vertical: true, gap: AntFlexGap.middle(), children: [...]) // 垂直排列带间距
AntFlex(justify: AntFlexJustify.center, align: AntFlexAlign.center, children: [...]) // 居中
AntFlex(wrap: true, gap: AntFlexGap.all(8), children: [...]) // 换行
```

## 构造函数

### `AntFlex({super.key, this.vertical = false, this.wrap = false, this.justify = AntFlexJustify.start, this.align = AntFlexAlign.start, this.gap, this.mainAxisSize = MainAxisSize.max, this.children = const []})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `vertical` | `bool` | = false | — |
| `wrap` | `bool` | = false | — |
| `justify` | `AntFlexJustify` | = AntFlexJustify.start | — |
| `align` | `AntFlexAlign` | = AntFlexAlign.start | — |
| `gap` | `AntFlexGap?` | 可选 | — |
| `mainAxisSize` | `MainAxisSize` | = MainAxisSize.max | — |
| `children` | `List<Widget>` | = const [] | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `align` | `AntFlexAlign` | 交叉轴对齐方式 |
| `children` | `List<Widget>` | 子元素列表 |
| `gap` | `AntFlexGap?` | 间距配置 |
| `justify` | `AntFlexJustify` | 主轴对齐方式 |
| `mainAxisSize` | `MainAxisSize` | 主轴尺寸 |
| `vertical` | `bool` | 是否垂直排列 |
| `wrap` | `bool` | 是否换行 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_insertGap` | `List<Widget>` | 在子元素间插入间距（非换行模式） |
| `_resolveGap` | `(double?, double?)` | 解析 gap 配置为实际像素值（含 screenutil 缩放） |
| `build` | `Widget` | — |
| `_mapCrossAxisAlignment` | `CrossAxisAlignment` | 映射交叉轴对齐方式 |
| `_mapMainAxisAlignment` | `MainAxisAlignment` | 映射主轴对齐方式 |
| `_mapWrapAlignment` | `WrapAlignment` | 映射 Wrap 主轴对齐方式 |
| `_mapWrapCrossAlignment` | `WrapCrossAlignment` | 映射 Wrap 交叉轴对齐方式 |

