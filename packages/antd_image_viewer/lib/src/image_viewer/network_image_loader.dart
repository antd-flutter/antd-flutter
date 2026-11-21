/// 网络图加载中间件（跨平台条件导出）。
///
/// IO 平台使用 `cached_network_image`（磁盘缓存），Web 平台使用
/// `Image.network`，因为 `cached_network_image` 依赖的缓存管理器使用
/// `dart:io`，无法在 Web 编译。
library;

export 'network_image_loader_io.dart'
    if (dart.library.js_interop) 'network_image_loader_web.dart';
