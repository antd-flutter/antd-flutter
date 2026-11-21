<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCarousel

> 种类：类

```dart
class AntCarousel
```

走马灯 — 常用于一组图片或卡片轮播。

对齐 antd React Carousel 组件。

## 构造函数

### `AntCarousel({super.key, this.children, this.items, this.autoplay = false, this.autoplayInterval = const Duration(seconds: 3), this.pauseOnHover = false, this.loop = false, this.dots = true, this.dotPosition = AntCarouselDotPosition.bottom, this.arrows = false, this.vertical = false, this.defaultCurrent = 0, this.current, this.onChange, this.controller, this.height})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `children` | `List<Widget>?` | 可选 | — |
| `items` | `List<Widget>?` | 可选 | — |
| `autoplay` | `bool` | = false | — |
| `autoplayInterval` | `Duration` | = const Duration(seconds: 3) | — |
| `pauseOnHover` | `bool` | = false | — |
| `loop` | `bool` | = false | — |
| `dots` | `bool` | = true | — |
| `dotPosition` | `AntCarouselDotPosition` | = AntCarouselDotPosition.bottom | — |
| `arrows` | `bool` | = false | — |
| `vertical` | `bool` | = false | — |
| `defaultCurrent` | `int` | = 0 | — |
| `current` | `int?` | 可选 | — |
| `onChange` | `ValueChanged<int>?` | 可选 | — |
| `controller` | `AntCarouselController?` | 可选 | — |
| `height` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `arrows` | `bool` | 是否显示切换箭头（桌面端，hover 时完全不透明） |
| `autoplay` | `bool` | 是否自动切换 |
| `autoplayInterval` | `Duration` | 自动切换间隔，默认 3 秒（对齐 antd autoplaySpeed 3000） |
| `children` | `List<Widget>?` | 轮播内容（Widget 列表） |
| `controller` | `AntCarouselController?` | 外部控制器 |
| `current` | `int?` | 受控当前页索引 |
| `defaultCurrent` | `int` | 初始页索引（非受控） |
| `dotPosition` | `AntCarouselDotPosition` | 指示点位置，默认底部 |
| `dots` | `bool` | 是否显示指示点 |
| `height` | `double?` | 轮播区高度（垂直轮播或作为页面容器时建议指定） |
| `items` | `List<Widget>?` | 轮播内容（与 children 二选一） |
| `loop` | `bool` | 是否循环（无限循环：PageView.builder + 取模模拟无限页，任意方向连续滑动不回弹） |
| `onChange` | `ValueChanged<int>?` | 页面切换回调 |
| `pauseOnHover` | `bool` | 悬停时暂停自动切换（桌面端） |
| `vertical` | `bool` | 是否垂直轮播 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_pages` | `List<Widget>` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCarousel>` | — |

