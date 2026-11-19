# antd_carousel

Ant Design v6 Carousel（走马灯）组件的 Flutter 实现 — 基于 PageView 的轮播组件，支持自动播放、循环模式、指示点（四种位置）、切换箭头、垂直轮播、受控/非受控模式与程序化控制器（goTo），API 对齐 antd React Carousel。

> 当前为预览版本。

> R33 判定：轮播为固定布局展示类组件（固定高度容器内的页面切换，非滚动列表场景），不需要 sliver 支持。

> R30.1 轮子参考：对照评估 [carousel_slider](https://pub.dev/packages/carousel_slider)（MIT）— 现有实现已覆盖其核心能力（自动播放 / 无限循环 / 指示器 / 手势切换 / 箭头 / 垂直方向）；吸收其**无限循环实现细节**（PageView.builder + 页码取模模拟无限页，循环时向任意方向连续滑动不回弹），自绘实现落地，不引入三方依赖（R30.3）。视差/页面变换效果（transform / parallax）属增强能力，antd React Carousel 本体不提供，暂不吸收（可经自定义 item 自行实现，见 example「自定义 item」页）。

## 安装

```yaml
dependencies:
  antd_carousel: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_carousel/antd_carousel.dart';

// ── 基础轮播 ────────────────────────────────────────────
AntCarousel(children: [Text('1'), Text('2'), Text('3')]);

// ── 自动播放 + 无限循环 ─────────────────────────────────
AntCarousel(children: [...], autoplay: true, loop: true);

// ── 指示点位置 + 箭头 + 垂直 ────────────────────────────
AntCarousel(
  children: [...],
  dotPosition: AntCarouselDotPosition.left,
  arrows: true,
  vertical: true,
  height: 200,
);

// ── 受控 Controller ─────────────────────────────────────
final controller = AntCarouselController();
AntCarousel(children: [...], controller: controller);
controller.goTo(2);
```

## 组件

| 组件/类型 | 说明 |
| --- | --- |
| `AntCarousel` | 走马灯组件 |
| `AntCarouselController` | 外部控制器（goTo 跳转） |
| `AntCarouselDotPosition` | 指示点位置枚举（top / bottom / left / right） |

## Example

```bash
cd example
flutter pub get
flutter run -d macos   # 或 -d chrome / 其他已连接设备
```

demo 覆盖：基础轮播 / 自动播放 / 无限循环 / 指示点样式与位置 / 箭头 / 垂直轮播 / 手势切换 / 受控 Controller / 自定义 item / 视差与页面变换（自定义 item 演示）。
