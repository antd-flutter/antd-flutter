import 'dart:io' show Platform;

/// IO 平台：返回 `Platform.operatingSystem`（如 `ohos` / `android`）。
String? get operatingSystemName => Platform.operatingSystem;
