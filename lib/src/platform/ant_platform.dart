import 'dart:io' show Platform;

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// AntPlatform — 平台检测工具类
///
/// 封装 `defaultTargetPlatform`，区分 desktop / mobile 两大交互类别，
/// 并提供 `isOhos` 单独标识用于鸿蒙差异化处理。
///
/// ## ohos 隔离（强制约定）
///
/// 标准 Flutter SDK 的 `Platform` 类无 `isOhos` 属性，
/// **严禁使用 `Platform.isOhos`**（会编译报错）。
/// 统一使用 `Platform.operatingSystem == 'ohos'` 字符串匹配
/// （`kIsWeb` 守卫下），标准 SDK 下该比较恒为 false，
/// 编译零错误、运行零异常。
class AntPlatform {
  AntPlatform._();

  /// 当前是否为 Web 环境
  static bool get isWeb => kIsWeb;

  /// 当前是否为桌面平台（web / windows / macos / linux）
  static bool get isDesktop {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux =>
        true,
      _ => false,
    };
  }

  /// 当前是否为移动平台（android / ios / ohos）
  static bool get isMobile => !isDesktop;

  /// 当前是否为 Android
  static bool get isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// 当前是否为 iOS
  static bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// 当前是否为 Windows
  static bool get isWindows => !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  /// 当前是否为 macOS
  static bool get isMacOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// 当前是否为 Linux
  static bool get isLinux => !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  /// 当前是否为鸿蒙（ohos）
  ///
  /// **隔离实现**：标准 Flutter SDK 的 `Platform` 类无 `isOhos` 属性，
  /// 严禁 `Platform.isOhos`。此处统一使用
  /// `Platform.operatingSystem == 'ohos'` 字符串匹配
  /// （`kIsWeb` 守卫下），标准 SDK 下恒为 false，零编译错误。
  static bool get isOhos {
    if (kIsWeb) return false;
    // ignore: avoid_dynamic_calls
    return Platform.operatingSystem == 'ohos';
  }

  // ---- 交互能力开关 ----

  /// 是否支持悬停（hover）反馈
  ///
  /// 桌面端启用 PointerRegion 悬停反馈，移动端跳过。
  static bool get supportsHover => isDesktop;

  /// 是否使用触摸涟漪（InkWell ripple）反馈
  ///
  /// 移动端启用 InkWell 涟漪，桌面端禁用涟漪改用 hover 高亮。
  static bool get useTouchRipple => isMobile;

  /// 是否显示滚动条
  ///
  /// 桌面端显示 ScrollbarTheme，移动端隐藏。
  static bool get showScrollbar => isDesktop;

  /// 是否支持键盘焦点遍历（Tab 遍历 + 快捷键）
  ///
  /// 桌面端支持 FocusNode/Shortcuts，移动端跳过。
  static bool get supportsKeyboard => isDesktop;

  /// 当前平台名称（用于日志/调试）
  static String get name {
    if (kIsWeb) return 'web';
    if (isOhos) return 'ohos';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.windows => 'windows',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'fuchsia',
    };
  }
}