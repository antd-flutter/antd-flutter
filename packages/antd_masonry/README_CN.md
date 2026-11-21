# antd_masonry - 贪心列瀑布流布局与 sliver 变体

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_masonry/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_masonry/README_CN.md)

`antd_masonry` 把高度不一的 widget 布局到均衡的多列中，API 对齐 antd React Masonry。用 `AntMasonryItem` 声明的子项可指定高度与跨列数；布局引擎把每个子项放入当前最矮的列，sliver 变体则可与 `CustomScrollView` 组合。

本包是纯布局容器：不持有滚动状态，也不提供 controller —— 滚动属于承载它的滚动视图，内容变化意味着用新的 `children` 列表重建。

## 定位与设计

| 方面 | 决策 |
| --- | --- |
| 模型 | 无状态布局容器，完全由 `children` 列表驱动 |
| 高度来源 | `AntMasonryItem.height`；既是放置输入，也是渲染盒高度 |
| 放置 | 任一子项声明高度时按最短列贪心；全部没有时按轮询交错 |
| 跨列 | `AntMasonryItem.span` 占多列；整行项以最高列作为基线 |
| 响应式 | `AntMasonryResponsive` 按 antd 栅格断点从容器宽度解析列数 |
| Sliver | `AntSliverMasonry` 用 `SliverToBoxAdapter` 承载同一引擎；设计上非懒加载 |
| 间距 | `gutter` / `verticalGutter` 按主题 `s()` 缩放；子项高度是精确逻辑像素 |

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_masonry: ^1.0.0
```

在本 monorepo 内：

```yaml
dependencies:
  antd_masonry:
    path: ../packages/antd_masonry
```

## 快速开始

```dart
import 'package:antd_masonry/antd_masonry.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MasonryApp());

class MasonryApp extends StatelessWidget {
  const MasonryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AntMasonry(
              columns: 3,
              gutter: 12,
              children: const [
                AntMasonryItem(
                  height: 120,
                  child: ColoredBox(color: Color(0xFF1677FF)),
                ),
                AntMasonryItem(
                  height: 180,
                  child: ColoredBox(color: Color(0xFF52C41A)),
                ),
                AntMasonryItem(
                  height: 90,
                  child: ColoredBox(color: Color(0xFFFAAD14)),
                ),
                AntMasonryItem(
                  height: 220,
                  child: ColoredBox(color: Color(0xFFFF4D4F)),
                ),
                AntMasonryItem(
                  height: 140,
                  child: ColoredBox(color: Color(0xFF722ED1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_masonry/docs/api-index.md)

按容器宽度解析列数：

```dart
AntMasonry(
  responsiveColumns: const AntMasonryResponsive(xs: 1, sm: 2, lg: 3, xl: 4),
  gutter: 16,
  children: const [
    AntMasonryItem(height: 120, child: Card(child: Text('A'))),
    AntMasonryItem(height: 180, child: Card(child: Text('B'))),
  ],
)
```

让子项跨列，包括整行：

```dart
AntMasonry(
  columns: 3,
  gutter: 16,
  children: const [
    AntMasonryItem(height: 120, child: Card(child: Text('A'))),
    AntMasonryItem(height: 160, span: 2, child: Card(child: Text('Wide'))),
    AntMasonryItem(height: 100, span: 3, child: Card(child: Text('Full row'))),
  ],
)
```

在 `CustomScrollView` 中使用 sliver 变体：

```dart
CustomScrollView(
  slivers: [
    const SliverAppBar(title: Text('Masonry')),
    AntSliverMasonry(
      columns: 3,
      gutter: 16,
      fallbackItemHeight: 120,
      children: const [
        AntMasonryItem(height: 100, child: Card(child: Text('A'))),
        AntMasonryItem(height: 160, span: 2, child: Card(child: Text('B'))),
      ],
    ),
  ],
)
```

## 项目结构

```text
antd_masonry/
├── lib/
│   ├── antd_masonry.dart                  # 公开 barrel
│   └── src/masonry/
│       ├── ant_masonry.dart               # 瀑布流组件 + AntMasonryItem
│       ├── ant_masonry_layout.dart        # 共用放置引擎
│       ├── ant_masonry_types.dart         # AntMasonryResponsive
│       └── ant_sliver_masonry.dart        # sliver 变体
├── example/lib/main.dart                  # 演示画廊
├── test/
│   ├── masonry/ant_masonry_test.dart
│   └── masonry/ant_sliver_masonry_test.dart
├── docs/api-index.md
├── README.md
├── README_CN.md
├── CHANGELOG.md
└── pubspec.yaml
```

## 许可证

MIT。见仓库根目录 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
