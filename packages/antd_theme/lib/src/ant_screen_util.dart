import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart'
    hide ScreenUtilInit;

/// AntScreenUtil 初始化 Widget。
///
/// 封装 [ScreenUtilInit]，设置 antd 设计稿尺寸，并内置**桌面自适应**。
///
/// 默认设计稿尺寸为 375×812（iPhone X 基准），可通过 [designSize] 自定义。
///
/// ## 桌面自适应
///
/// 当窗口逻辑宽度 >= [desktopBreakpoint]（默认 768）时，视为桌面环境：
/// designSize 自动替换为窗口实际逻辑尺寸，使缩放因子恒为 1，
/// `.w/.sp/.r` 值不缩放，组件保持原始逻辑像素尺寸。
/// 窗口 resize 时自动重新计算，缩放因子始终为 1。
///
/// 这样桌面端 / 桌面 Web 端组件不会被放大，而手机端 / 手机 Web 端
/// 仍按手机设计稿正常缩放。
///
/// 设 [desktopBreakpoint] 为 null 可禁用桌面自适应（始终按 [designSize] 缩放）。
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
class AntScreenUtilInit extends StatefulWidget {
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

  /// 桌面模式宽度阈值（逻辑像素）。
  ///
  /// 当窗口逻辑宽度 >= 此值时，视为桌面环境，缩放因子恒为 1
  /// （designSize = 窗口实际尺寸，`.w/.sp/.r` 不缩放）。
  ///
  /// 默认 768。设为 null 可禁用桌面自适应。
  final double? desktopBreakpoint;

  const AntScreenUtilInit({
    super.key,
    this.designSize = const Size(375, 812),
    required this.builder,
    this.child,
    this.minTextAdapt = true,
    this.splitScreenMode = true,
    this.desktopBreakpoint = 768,
  });

  @override
  State<AntScreenUtilInit> createState() => _AntScreenUtilInitState();
}

class _AntScreenUtilInitState extends State<AntScreenUtilInit>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    // 窗口尺寸变化时重建（重新计算桌面模式 designSize）
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 计算生效的 designSize。
  ///
  /// 桌面模式（窗口宽度 >= desktopBreakpoint）下，
  /// designSize = 窗口实际逻辑尺寸 → 缩放因子恒为 1，
  /// `.w/.sp/.r` 值不缩放，组件保持原始逻辑像素尺寸。
  Size _effectiveDesignSize() {
    final breakpoint = widget.desktopBreakpoint;
    if (breakpoint != null) {
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      final logicalSize = view.physicalSize / view.devicePixelRatio;
      if (logicalSize != Size.zero && logicalSize.width >= breakpoint) {
        return logicalSize;
      }
    }
    return widget.designSize;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: _effectiveDesignSize(),
      minTextAdapt: widget.minTextAdapt,
      splitScreenMode: widget.splitScreenMode,
      builder: widget.builder,
      child: widget.child,
    );
  }
}