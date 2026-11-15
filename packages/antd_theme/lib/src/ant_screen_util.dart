import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart'
    hide ScreenUtilInit;

/// AntScreenUtil 初始化 Widget。
///
/// 封装 [ScreenUtilInit]，设置 antd 设计稿尺寸。
///
/// 默认设计稿尺寸为 375×812（iPhone X 基准），可通过 [designSize] 自定义。
///
/// ## 缩放规范
///
/// 使用 `flutter_screenutil` 时**只允许以下三个扩展**：
/// - `.w` — 按宽度比例适配（用于宽高、间距、边框等）
/// - `.sp` — 按宽度和系统字体缩放适配（用于字号）
/// - `.r` — 按宽高较小值适配（用于圆角）
///
/// **禁止使用 `.h`**：高度在不同设备上差异过大，会导致布局异常。
/// 所有高度需求请使用 `.w` 配合 Flex 布局（Expanded / Flexible）解决。
///
/// ```dart
/// AntScreenUtilInit(
///   builder: (context, child) => MaterialApp(...),
/// )
/// ```
class AntScreenUtilInit extends StatelessWidget {
  /// 设计稿尺寸，默认 375×812
  final Size designSize;

  /// 构建回调
  final Widget Function(BuildContext, Widget?) builder;

  /// 传入的 child，避免重建
  final Widget? child;

  /// 是否根据系统字体大小缩放文字
  final bool minTextAdapt;

  /// 是否支持分屏模式
  final bool splitScreenMode;

  const AntScreenUtilInit({
    super.key,
    this.designSize = const Size(375, 812),
    required this.builder,
    this.child,
    this.minTextAdapt = true,
    this.splitScreenMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: minTextAdapt,
      splitScreenMode: splitScreenMode,
      builder: builder,
      child: child,
    );
  }
}