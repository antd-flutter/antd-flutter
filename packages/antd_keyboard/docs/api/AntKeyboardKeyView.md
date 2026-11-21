<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardKeyView

> 种类：类

```dart
class AntKeyboardKeyView
```

单个键的基础容器（引擎与数字键盘共用）。

只负责：尺寸/圆角/描边/按下反馈/hover（桌面）/点击与长按手势，
内容由调用方传入。这样通用键盘与 antd-mobile 数字键盘可以共享同一套
交互语义，同时各自保留自己的布局与配色。

## 构造函数

### `AntKeyboardKeyView({super.key, required this.child, required this.theme, this.background, this.pressedBackground, this.hoverBackground, this.activeBackground, this.active = false, this.borderRadius, this.height, this.padding = EdgeInsets.zero, this.onTap, this.onTapDown, this.onTapUp, this.onTapCancel, this.onLongPress, this.onLongPressStart, this.semanticLabel, this.enabled = true, this.showBorder, this.showHover, this.boxShadow})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `theme` | `AntKeyboardThemeData` | 可选 | — |
| `background` | `Color?` | 可选 | — |
| `pressedBackground` | `Color?` | 可选 | — |
| `hoverBackground` | `Color?` | 可选 | — |
| `activeBackground` | `Color?` | 可选 | — |
| `active` | `bool` | = false | — |
| `borderRadius` | `double?` | 可选 | — |
| `height` | `double?` | 可选 | — |
| `padding` | `EdgeInsets` | = EdgeInsets.zero | — |
| `onTap` | `VoidCallback?` | 可选 | — |
| `onTapDown` | `VoidCallback?` | 可选 | — |
| `onTapUp` | `VoidCallback?` | 可选 | — |
| `onTapCancel` | `VoidCallback?` | 可选 | — |
| `onLongPress` | `VoidCallback?` | 可选 | — |
| `onLongPressStart` | `ValueChanged<Offset>?` | 可选 | — |
| `semanticLabel` | `String?` | 可选 | — |
| `enabled` | `bool` | = true | — |
| `showBorder` | `bool?` | 可选 | — |
| `showHover` | `bool?` | 可选 | — |
| `boxShadow` | `List<BoxShadow>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `active` | `bool` | — |
| `activeBackground` | `Color?` | — |
| `background` | `Color?` | — |
| `borderRadius` | `double?` | — |
| `boxShadow` | `List<BoxShadow>?` | — |
| `child` | `Widget` | — |
| `enabled` | `bool` | — |
| `height` | `double?` | — |
| `hoverBackground` | `Color?` | — |
| `onLongPress` | `VoidCallback?` | — |
| `onLongPressStart` | `ValueChanged<Offset>?` | — |
| `onTap` | `VoidCallback?` | — |
| `onTapCancel` | `VoidCallback?` | — |
| `onTapDown` | `VoidCallback?` | — |
| `onTapUp` | `VoidCallback?` | — |
| `padding` | `EdgeInsets` | — |
| `pressedBackground` | `Color?` | — |
| `semanticLabel` | `String?` | — |
| `showBorder` | `bool?` | — |
| `showHover` | `bool?` | — |
| `theme` | `AntKeyboardThemeData` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntKeyboardKeyView>` | — |

