# antd_carousel - 基于 PageView 的 Ant Design 走马灯

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_carousel/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_carousel/README_CN.md)

## 定位与设计

`antd_carousel` 将 Ant Design 的走马灯带到 Flutter：一个固定高度的页面切换器，支持自动播放、无限循环、四个位置的指示点、箭头、垂直模式、受控或非受控索引，以及用于编程式跳转的控制器。API 对齐 antd React Carousel，概念一一对应。

- **基于 `PageView`。** 本包是 `PageView` / `PageView.builder` 的布局与状态封装，不是自定义渲染对象。
- **循环但不复制页面。** 无限循环使用 `PageView.builder`、较大的页偏移与取模映射，两个方向连续滑动都不会在两端回弹，页面列表也不会被克隆。
- **页面保持普通组件。** 走马灯不会用自己的变换包裹页面；自定义转场与视差效果应放在页面组件内部。
- **固定高度覆盖层。** 页面铺满容器，指示点与箭头通过 `Stack` 叠在上层，因此组件必须有确定高度——传入 `height` 或放在固定高度的父容器中。
- **全平台同一套实现。** 移动端、桌面端与 Web 共用代码；只有 `pauseOnHover` 与箭头透明度与指针相关。
- **跟随主题。** 颜色与尺寸来自最近的 `AntThemeData`；没有 `AntTheme` 时回退到亮色主题。

## 安装

需要 Dart `>=3.0.0 <4.0.0` 与 Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_carousel: ^1.0.0
```

## 快速开始

以下应用完整且可直接运行：

```dart
import 'package:antd_carousel/antd_carousel.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const CarouselApp());

class CarouselApp extends StatelessWidget {
  const CarouselApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 480,
              height: 200,
              child: AntCarousel(
                autoplay: true,
                loop: true,
                children: const [
                  ColoredBox(
                    color: Color(0xFF1677FF),
                    child: Center(child: Text('1')),
                  ),
                  ColoredBox(
                    color: Color(0xFF52C41A),
                    child: Center(child: Text('2')),
                  ),
                  ColoredBox(
                    color: Color(0xFFFAAD14),
                    child: Center(child: Text('3')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_carousel/docs/api-index.md)

通过 `import 'package:antd_carousel/antd_carousel.dart';` 引入 `AntCarousel`、`AntCarouselController` 与 `AntCarouselDotPosition`。

### 页面与固定高度

`children` 与 `items` 等价，二者必须且只能传一个。

```dart
final pages = <Widget>[
  const ColoredBox(color: Color(0xFF1677FF)),
  const ColoredBox(color: Color(0xFF52C41A)),
  const ColoredBox(color: Color(0xFFFAAD14)),
];

AntCarousel(
  height: 200,
  children: pages,
);
```

### 自动播放、循环与箭头

```dart
AntCarousel(
  autoplay: true,
  autoplayInterval: const Duration(seconds: 3),
  loop: true,
  arrows: true,
  height: 220,
  children: pages,
);
```

### 控制器与页面切换

```dart
final controller = AntCarouselController();

AntCarousel(
  controller: controller,
  onChange: (index) {},
  height: 200,
  children: pages,
);

// 在按钮或快捷键回调中：
controller.goTo(2);
controller.goTo(0, animate: false);
```

## 项目结构

```text
packages/antd_carousel/
├── lib/
│   ├── antd_carousel.dart               # 公共出口
│   └── src/carousel/
│       ├── ant_carousel.dart            # 基于 PageView 的走马灯组件
│       └── ant_carousel_types.dart      # 指示点位置枚举与控制器
├── example/lib/main.dart                # 示例应用
├── docs/api-index.md                    # 生成的 API 索引
├── test/carousel/ant_carousel_test.dart # 组件测试
├── CHANGELOG.md
├── README.md
├── README_CN.md
└── pubspec.yaml
```

## 许可证

MIT。详见仓库根目录的 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
