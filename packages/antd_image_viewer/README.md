# antd_image_viewer - Fullscreen image viewer with zoom and paging

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_image_viewer/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_image_viewer/README_CN.md)

`antd_image_viewer` is a Flutter port of antd-mobile's ImageViewer / MultiImageViewer: a fullscreen dark overlay with pinch zoom, pan, double-tap zoom, horizontal paging between images, a page counter, a close button and a controlled open state.

It is a display component, not a camera or a gallery grid. You give it a list of image sources and an `open` flag; it inserts itself into the root overlay, and the host keeps ownership of the flag through `onClose`. Network images are loaded through `cached_network_image`; anything whose source does not start with `http` is treated as an asset.

## Positioning & design

| Aspect | Decision |
| --- | --- |
| Presentation | Root `OverlayEntry`, full-screen `Material` barrier at 85% black, 200 ms fade in/out |
| Host contract | `open` is fully controlled; the viewer never flips it itself and calls `onClose` instead |
| Paging | `PageView.builder`, one image per page, counter `n / total` |
| Zoom | `InteractiveViewer` bounded by `maxZoomRatio`; double tap toggles between 1× and `maxZoomRatio` |
| Image loading | `cached_network_image` for `http…` sources, `Image.asset` otherwise, shared placeholder/error widgets |
| Dismissal | Close button, single tap at 1×, and the Escape key |

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`. Network images require platform network permission as usual; local images must be declared in your app's `pubspec.yaml` assets.

```yaml
dependencies:
  antd_image_viewer: ^1.0.0
```

Inside this monorepo:

```yaml
dependencies:
  antd_image_viewer:
    path: ../packages/antd_image_viewer
```

## Quick start

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

The widget itself occupies no space (`SizedBox.shrink`); the visible UI lives in the root overlay.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_image_viewer/docs/api-index.md)

Open the viewer at a specific image:

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

Limit the zoom range and disable double-tap zoom:

```dart
AntImageViewer(
  images: const ['https://picsum.photos/id/1015/1200/800'],
  open: true,
  maxZoomRatio: 5,
  enableCompositeZoom: false,
  onClose: () {},
)
```

Run cleanup work after the closing animation has finished:

```dart
AntImageViewer(
  images: const ['https://picsum.photos/id/1015/1200/800'],
  open: true,
  onClose: () {},
  afterClose: () => debugPrint('overlay removed'),
)
```

## Project structure

```text
antd_image_viewer/
├── lib/
│   ├── antd_image_viewer.dart                  # Public barrel
│   └── src/image_viewer/
│       ├── ant_image_viewer.dart               # Overlay viewer + zoomable page
│       └── ant_image_viewer_types.dart         # Defaults and shared builders
├── example/lib/main.dart                       # Demo gallery
├── test/ant_image_viewer_test.dart             # Widget tests
├── docs/api-index.md
├── README.md
├── README_CN.md
├── CHANGELOG.md
└── pubspec.yaml
```

## License

MIT. See the repository root [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
