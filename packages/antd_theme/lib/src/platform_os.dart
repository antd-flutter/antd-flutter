/// 当前运行平台的 operatingSystem 名称（条件导出）。
///
/// Web 下无 `dart:io`，返回 null；IO 平台返回 `Platform.operatingSystem`。
library;

export 'platform_os_stub.dart' if (dart.library.io) 'platform_os_io.dart';
