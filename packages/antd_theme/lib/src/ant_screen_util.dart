import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier;
import 'package:flutter/widgets.dart';

/// 兼容入口：历史上用于初始化 `flutter_screenutil`。
///
/// 自 2026-11-21 起仓库改为 **AntScale 因子**（见 `AntScale` / `AntThemeData.s`），
/// 不再依赖 `flutter_screenutil`；本组件仅保留为直通包装，按原样构建 [builder]，
/// 不再进行任何屏幕缩放，也不再要求外层初始化。
///
/// 新代码请直接使用 `AntTheme` + `theme.s(...)` / 尺寸 token，
/// 需要整体缩放时给 `AntThemeData` 传 `scale: AntScale(...)` 或 `AntScale.auto(context)`。
@Deprecated('使用 AntThemeData(scale: ...) 与 theme.s(...)；ScreenUtil 已移除')
class AntScreenUtilInit extends StatelessWidget {
  const AntScreenUtilInit({
    super.key,
    required this.builder,
    this.designSize,
    this.desktopBreakpoint,
    this.allowScaleUp = false,
    this.maxWidth,
    this.maxScaleFactor,
  });

  final Widget Function(BuildContext context, Widget? child) builder;

  /// 已废弃，保留仅用于兼容旧调用签名。
  final Size? designSize;

  /// 已废弃，保留仅用于兼容旧调用签名。
  final double? desktopBreakpoint;

  /// 已废弃，保留仅用于兼容旧调用签名。
  final bool allowScaleUp;

  /// 已废弃，保留仅用于兼容旧调用签名。
  final double? maxWidth;

  /// 已废弃，保留仅用于兼容旧调用签名。
  final double? maxScaleFactor;

  /// 兼容旧字段：缩放因子恒为 1.0。
  static final ValueNotifier<double> scaleFactorNotifier =
      ValueNotifier<double>(1.0);

  /// 兼容旧字段。
  static ValueListenable<double> get scaleFactorListenable =>
      scaleFactorNotifier;

  @override
  Widget build(BuildContext context) => builder(context, null);
}
