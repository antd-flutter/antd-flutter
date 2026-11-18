<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntWatermark

> 种类：类

```dart
class AntWatermark
```

水印 — 给页面指定区域添加水印。

对齐 antd React Watermark 组件：文字平铺、可旋转、
可配置字号颜色与间距，水印层不拦截手势。

`child` 可空：
- 传入 child：水印层自动测量 child 尺寸并等尺寸叠放；
- 传 null：填充满父级模式，要求父级约束有界。

## 构造函数

### `AntWatermark({super.key, required this.content, this.child, this.fontSize, this.fontColor, this.rotate = kAntWatermarkRotate, this.gapX = kAntWatermarkGapX, this.gapY = kAntWatermarkGapY, this.zIndex = 0, this.opacity = kAntWatermarkOpacity})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `content` | `Object` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `fontSize` | `double?` | 可选 | — |
| `fontColor` | `Color?` | 可选 | — |
| `rotate` | `double` | = kAntWatermarkRotate | — |
| `gapX` | `double` | = kAntWatermarkGapX | — |
| `gapY` | `double` | = kAntWatermarkGapY | — |
| `zIndex` | `int` | = 0 | — |
| `opacity` | `double` | = kAntWatermarkOpacity | — |

### `AntWatermark.text(String text, {Key? key, Widget? child, double? fontSize, Color? fontColor, double rotate = kAntWatermarkRotate, double gapX = kAntWatermarkGapX, double gapY = kAntWatermarkGapY, int zIndex = 0, double opacity = kAntWatermarkOpacity})`

便捷构造：单条字符串水印。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String` | 可选 | — |
| `key` | `Key?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `fontSize` | `double?` | 可选 | — |
| `fontColor` | `Color?` | 可选 | — |
| `rotate` | `double` | = kAntWatermarkRotate | — |
| `gapX` | `double` | = kAntWatermarkGapX | — |
| `gapY` | `double` | = kAntWatermarkGapY | — |
| `zIndex` | `int` | = 0 | — |
| `opacity` | `double` | = kAntWatermarkOpacity | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 被水印覆盖的内容 |
| `content` | `Object` | 水印文字（String 或 List<String> 多行展示） |
| `fontColor` | `Color?` | 字体颜色 |
| `fontSize` | `double?` | 字体大小 |
| `gapX` | `double` | 水平间距 |
| `gapY` | `double` | 垂直间距 |
| `opacity` | `double` | 整体透明度 |
| `rotate` | `double` | 旋转角度（度，默认 -22） |
| `zIndex` | `int` | 水印层级（相对覆盖层） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `lines` | `List<String>` | 归一化为多行文字列表 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntWatermark>` | — |

