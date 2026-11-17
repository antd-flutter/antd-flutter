import 'package:flutter/foundation.dart' show ValueNotifier, ValueListenable;
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart' hide ScreenUtilInit;

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
/// ## 桌面超宽等比放大
///
/// 超宽屏（4K / 带鱼屏）下桌面模式因子恒为 1，布局元素会显得偏小。
/// 可通过以下参数开启**等比放大**：
///
/// - [allowScaleUp]：是否允许超宽等比放大，默认 `false` 完全保持现状（因子恒 1）；
/// - [maxWidth]：桌面基准宽度上限（逻辑像素）。窗口宽度 ≤ [maxWidth] 时行为
///   不变（因子 1）；超过 [maxWidth] 后 designSize 固定基于 [maxWidth] 计算，
///   缩放因子 = 窗口宽度 / [maxWidth] > 1，全 UI 等比放大；
/// - [maxScaleFactor]：放大倍率封顶保护，超过后不再放大，
///   防止极端窗口下元素过大。
///
/// 组合语义示例：`allowScaleUp: true, maxWidth: 1920, maxScaleFactor: 1.5`
/// 时，窗口宽度 2400 → 因子 = 2400 / 1920 = 1.25（全 UI 等比放大 1.25 倍）；
/// 窗口宽度 3600 → 因子本应为 1.875，被 [maxScaleFactor] 封顶为 1.5。
///
/// 放大生效时 [AntScreenUtilInit.scaleFactorListenable] 会同步暴露当前因子，
/// `AntResponsive` 的 [AntLayoutData.scaleFactor] 字段也随之上报，
/// 方便业务感知当前缩放状态。
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

  /// 桌面默认放大倍率封顶值。
  static const double defaultMaxScaleFactor = 1.5;

  /// 桌面基准宽度上限（逻辑像素）。
  ///
  /// 仅在 [allowScaleUp] 为 true 时生效：
  /// - 窗口逻辑宽度 ≤ [maxWidth]：行为不变，缩放因子恒为 1；
  /// - 窗口逻辑宽度 > [maxWidth]：designSize 固定基于 [maxWidth] 计算，
  ///   缩放因子 = 窗口宽度 / [maxWidth] > 1，全 UI 等比放大
  ///   （受 [maxScaleFactor] 封顶）。
  ///
  /// 例：`maxWidth: 1920`，窗口 2400 → 因子 1.25。
  /// 为 null 时即使 [allowScaleUp] 为 true 也无法放大（无基准上限）。
  final double? maxWidth;

  /// 是否允许桌面超宽等比放大。
  ///
  /// 默认 `false`，完全保持现状（缩放因子恒为 1，永不放大）。
  /// 设为 `true` 且 [maxWidth] 非空时，窗口宽度超过 [maxWidth] 后
  /// 按 窗口宽度 / [maxWidth] 等比放大，倍率受 [maxScaleFactor] 封顶。
  final bool allowScaleUp;

  /// 放大倍率封顶保护。
  ///
  /// 窗口宽度 / [maxWidth] 超过此值后不再继续放大，防止极端窗口下
  /// 元素过大。默认 1.5。
  final double maxScaleFactor;

  /// 当前桌面缩放因子的全局通知器（非放大时恒为 1.0）。
  ///
  /// [AntResponsiveInit] 读取此值填充 [AntLayoutData.scaleFactor]，
  /// 业务也可直接监听感知缩放变化。
  static final ValueNotifier<double> scaleFactorNotifier =
      ValueNotifier<double>(1.0);

  /// 当前桌面缩放因子（只读视图，见 [scaleFactorNotifier]）。
  static ValueListenable<double> get scaleFactorListenable =>
      scaleFactorNotifier;

  /// 计算桌面模式下生效的 designSize 与缩放因子（纯函数，便于测试）。
  ///
  /// ## 语义
  ///
  /// - 非桌面模式（[desktopBreakpoint] 为 null 或 [windowSize].width <
  ///   desktopBreakpoint）：designSize = [designSize]，因子恒为 1.0
  ///   （手机端仍按手机设计稿缩放，与"放大"无关）。
  /// - 桌面模式且不放大（[allowScaleUp] 为 false，或 [maxWidth] 为 null，
  ///   或窗口宽度 ≤ [maxWidth]）：designSize = [windowSize]，因子恒为 1.0
  ///   （现状行为，`.w/.sp/.r` 不缩放）。
  /// - 桌面模式且放大（[allowScaleUp] 为 true 且 [maxWidth] 非空且窗口
  ///   宽度 > [maxWidth]）：
  ///   `factor = min(窗口宽度 / maxWidth, [maxScaleFactor])`，
  ///   `designSize = windowSize / factor` —— designSize 的宽度固定基于
  ///   maxWidth 语义（窗口越宽 factor 越大），使 `.w` 因子 = factor，
  ///   高度按同一 factor 等比换算保持不变形。
  ///
  /// ## 组合示例
  ///
  /// `allowScaleUp: true, maxWidth: 1920, maxScaleFactor: 1.5`：
  /// - 窗口 2400 → factor = 2400 / 1920 = **1.25**；
  /// - 窗口 3600 → 本应 1.875，被 maxScaleFactor 封顶为 **1.5**。
  static ({Size designSize, double scaleFactor}) resolveDesktopScale({
    required Size designSize,
    required Size windowSize,
    double? desktopBreakpoint = 768,
    double? maxWidth,
    bool allowScaleUp = false,
    double maxScaleFactor = defaultMaxScaleFactor,
  }) {
    final breakpoint = desktopBreakpoint;
    if (breakpoint == null ||
        windowSize == Size.zero ||
        windowSize.width < breakpoint) {
      // 非桌面模式：按手机设计稿缩放，桌面放大因子恒为 1。
      return (designSize: designSize, scaleFactor: 1.0);
    }
    // 桌面模式：默认因子恒为 1（designSize = 窗口实际尺寸）。
    if (!allowScaleUp || maxWidth == null || windowSize.width <= maxWidth) {
      return (designSize: windowSize, scaleFactor: 1.0);
    }
    // 超宽放大：封顶保护 + designSize 固定基于 maxWidth 语义。
    final factor = (windowSize.width / maxWidth).clamp(1.0, maxScaleFactor);
    return (
      designSize: Size(windowSize.width / factor, windowSize.height / factor),
      scaleFactor: factor,
    );
  }

  const AntScreenUtilInit({
    super.key,
    this.designSize = const Size(375, 812),
    required this.builder,
    this.child,
    this.minTextAdapt = true,
    this.splitScreenMode = true,
    this.desktopBreakpoint = 768,
    this.maxWidth,
    this.allowScaleUp = false,
    this.maxScaleFactor = defaultMaxScaleFactor,
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
  /// `.w/.sp/.r` 值不缩放，组件保持原始逻辑像素尺寸；
  /// 开启超宽放大（[AntScreenUtilInit.allowScaleUp]）后按
  /// 窗口宽度 / maxWidth 等比放大，详见
  /// [AntScreenUtilInit.resolveDesktopScale]。
  Size _effectiveDesignSize() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalSize = view.physicalSize / view.devicePixelRatio;
    final result = AntScreenUtilInit.resolveDesktopScale(
      designSize: widget.designSize,
      windowSize: logicalSize,
      desktopBreakpoint: widget.desktopBreakpoint,
      maxWidth: widget.maxWidth,
      allowScaleUp: widget.allowScaleUp,
      maxScaleFactor: widget.maxScaleFactor,
    );
    // 同步暴露当前因子（值不变不通知），供 AntResponsive / 业务感知。
    if (AntScreenUtilInit.scaleFactorNotifier.value != result.scaleFactor) {
      AntScreenUtilInit.scaleFactorNotifier.value = result.scaleFactor;
    }
    return result.designSize;
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
