library;

/// AntDevicePreview — device_preview 中间件隔离封装（规则 R16）。
///
/// demo 业务代码不直接触碰 device_preview API，统一经本封装接入：
///
/// ```dart
/// void main() {
///   AntDevicePreview.bootstrap();
///   runApp(const AntdFlutterExampleApp());
/// }
/// ```
///
/// 平台策略：
/// - 仅 desktop（windows/macos/linux）与 web 端启用；
/// - 移动端（android/ios/ohos）不启用，应用原样运行，零影响；
/// - 启用时不区分 debug/release（`enabled: true` 全模式开启）。
///
/// 版本调研（2026-11-17）：device_preview 3.0.0 已发布（绑定层新架构，
/// 支持 folds/hinges 折叠模拟），但其 `PreviewPlatformDispatcher` 未实现
/// Flutter 3.50 新增的 `PlatformDispatcher.resetInternalState`，
/// 在当前 SDK（3.50.0）下无法编译，且上游 master（截至本日）尚无修复
/// → 按任务约定退回 1.3.1 三行包装实现；折叠屏 hinges 模拟为 3.0 专属
/// 能力，1.x 不支持，待上游适配 Flutter 3.50 后可升级恢复。
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// demo 预置的 device_preview 模拟设备封装。
class AntDevicePreview {
  AntDevicePreview._();

  /// 是否在当前平台启用设备模拟。
  ///
  /// desktop/web 启用；移动端（android/ios/ohos）恒为 false。
  static bool get shouldEnable => AntPlatform.isDesktop || kIsWeb;

  /// 1.x 架构无需初始化绑定（模拟经 [wrap] 的 widget 包装完成）。
  /// 保留调用形态与 3.0 接入方式对齐，便于将来升级。
  static WidgetsBinding bootstrap() => WidgetsBinding.instance;

  /// 一行接入包装。
  ///
  /// 启用平台返回 device_preview 包装（应用内工具栏 + 设备模拟），
  /// `enabled: true` 不区分 debug/release；未启用平台原样返回 [app]。
  static Widget wrap(BuildContext context, Widget app) {
    if (!shouldEnable) return app;
    return DevicePreview(
      enabled: true,
      devices: presetDevices,
      builder: (_) => app,
    );
  }

  /// MaterialApp 的 locale 透传（仅启用平台生效）。
  static Locale? localeOf(BuildContext context) =>
      shouldEnable ? DevicePreview.locale(context) : null;

  /// MaterialApp 的 builder 透传（仅启用平台生效）。
  static TransitionBuilder? get appBuilder =>
      shouldEnable ? DevicePreview.appBuilder : null;

  /// 预置模拟设备清单：手机 / 平板 / 桌面窗口。
  ///
  /// 1.x 无 folds/hinges 折叠模拟（3.0 专属能力，见类注释版本调研），
  /// 折叠屏形态布局验证经 AntResponsive 半折模拟尺寸（681×841）覆盖。
  static List<DeviceInfo> get presetDevices => <DeviceInfo>[
    // 手机
    Devices.ios.iPhone16,
    Devices.ios.iPhoneSE,
    Devices.android.googlePixel9,
    Devices.android.samsungGalaxyS25,
    // 平板
    Devices.ios.iPadPro13InchesM4,
    Devices.ios.iPadAir4,
    // 桌面窗口（1440 / 1920，macOS/windows 共享 wideMonitor 规格，留一）
    desktopWindow1440,
    Devices.macOS.wideMonitor,
  ];

  /// 1440×900 桌面窗口（内置清单无 1440 规格，自建补齐）。
  static final DeviceInfo desktopWindow1440 = DeviceInfo.genericTablet(
    id: 'desktop-1440',
    name: 'Desktop Window 1440',
    platform: TargetPlatform.macOS,
    screenSize: const Size(1440, 900),
  );
}
