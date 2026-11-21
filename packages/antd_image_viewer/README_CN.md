# antd_image_viewer - 支持缩放与翻页的全屏图片查看器

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_image_viewer/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_image_viewer/README_CN.md)

`antd_image_viewer` 是 antd-mobile ImageViewer / MultiImageViewer 的 Flutter 实现：全屏暗色浮层，支持双指缩放、平移、双击缩放、左右翻页、页码指示、关闭按钮，以及受控的打开状态。

它是展示组件，不是相机或宫格相册。你提供一组图片地址与 `open` 开关，它把自己插入根 Overlay，并通过 `onClose` 把关闭意图交回宿主。网络图经 `cached_network_image` 加载；不以 `http` 开头的地址按资源图（asset）处理。

## 定位与设计

| 方面 | 决策 |
| --- | --- |
| 呈现 | 根 `OverlayEntry`、85% 黑色全屏 `Material` 遮罩、200ms 淡入淡出 |
| 宿主契约 | `open` 完全受控；查看器从不自行关闭，只调用 `onClose` |
| 翻页 | `PageView.builder`，一页一张图，计数文案 `n / total` |
| 缩放 | `InteractiveViewer`，上限为 `maxZoomRatio`；双击在 1× 与 `maxZoomRatio` 间切换 |
| 图片加载 | `http…` 走 `cached_network_image`，其余走 `Image.asset`，共用占位与错误组件 |
| 关闭方式 | 关闭按钮、1× 时单击、Escape 键 |

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。网络图按常规需要平台网络权限；本地图需在应用的 `pubspec.yaml` 中声明资源。

```yaml
dependencies:
  antd_image_viewer: ^1.0.0
```

在本 monorepo 内：

```yaml
dependencies:
  antd_image_viewer:
    path: ../packages/antd_image_viewer
```

## 快速开始

```dart
import 'package:antd_image_viewer/antd_image_viewer.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const ViewerApp());

class ViewerApp extends StatefulWidget {
  const ViewerApp({super.key});

  @override
  State<ViewerApp> createState() => _ViewerAppState();
}

class _ViewerAppState extends State<ViewerApp> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: AntImageViewer(
              images: const [
                'https://picsum.photos/id/1015/1200/800',
                'https://picsum.photos/id/1016/1200/800',
                'https://picsum.photos/id/1018/1200/800',
              ],
              open: _open,
              onClose: () => setState(() => _open = false),
              afterClose: () => debugPrint('viewer closed'),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => setState(() => _open = true),
            child: const Icon(Icons.image_outlined),
          ),
        ),
      ),
    );
  }
}
```

组件本身不占据空间（`SizedBox.shrink`）；可见 UI 位于根 Overlay 中。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_image_viewer/docs/api-index.md)

从指定图片开始打开查看器：

```dart
AntImageViewer(
  images: const [
    'https://picsum.photos/id/1015/1200/800',
    'https://picsum.photos/id/1016/1200/800',
  ],
  defaultIndex: 1,
  open: true,
  onClose: () {},
)
```

限制缩放范围并关闭双击缩放：

```dart
AntImageViewer(
  images: const ['https://picsum.photos/id/1015/1200/800'],
  open: true,
  maxZoomRatio: 5,
  enableCompositeZoom: false,
  onClose: () {},
)
```

在关闭动画结束后执行清理：

```dart
AntImageViewer(
  images: const ['https://picsum.photos/id/1015/1200/800'],
  open: true,
  onClose: () {},
  afterClose: () => debugPrint('overlay removed'),
)
```

## 项目结构

```text
antd_image_viewer/
├── lib/
│   ├── antd_image_viewer.dart                  # 公开 barrel
│   └── src/image_viewer/
│       ├── ant_image_viewer.dart               # 浮层查看器 + 可缩放页
│       └── ant_image_viewer_types.dart         # 默认值与共用构建器
├── example/lib/main.dart                       # 演示画廊
├── test/ant_image_viewer_test.dart             # Widget 测试
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
