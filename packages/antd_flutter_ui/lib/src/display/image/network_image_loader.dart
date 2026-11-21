/// 网络图加载中间件（跨平台条件导出）。
///
/// - IO 平台：使用 `cached_network_image`，带磁盘缓存与占位/错误回调；
/// - Web 平台：使用 `Image.network`（`cached_network_image` 依赖的
///   `flutter_cache_manager` 使用 `dart:io`，无法在 Web 编译）。
///
/// 组件代码只依赖本文件导出的 [buildAntNetworkImage]，不直接引用具体实现。
library;

export 'network_image_loader_io.dart'
    if (dart.library.js_interop) 'network_image_loader_web.dart';
