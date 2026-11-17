/// AntResponsive — 响应式布局信息通知（断点 / 设备类型 / 方向 / 折叠屏 / 平台）。
///
/// 类似 `MediaQuery` / `Theme` 的外侧包裹：
///
/// ```dart
/// AntResponsiveInit(
///   builder: (context, data) => MaterialApp(...),
/// )
/// ```
///
/// 读取方式（多粒度）：
/// - `AntResponsive.of(context)` — 整体依赖，任一字段变化触发 rebuild
/// - `AntResponsive.breakpointOf(context)` 等细粒度方法 — 仅对应 aspect
///   变化才触发 rebuild（仿 MediaQuery aspect 机制）
/// - `AntResponsive.layoutListenableOf(context)` — 非 Widget 场景的
///   `ValueListenable<AntLayoutData>` / `addListener` 订阅
///
/// 通知去重：[AntLayoutData] 实现 `==`，值不变不通知；
/// 细粒度方法只比较对应 aspect。
library;

import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/foundation.dart'
    show ValueListenable, defaultTargetPlatform;
import 'package:flutter/widgets.dart';

import 'ant_breakpoint.dart';
import 'ant_platform.dart';

/// 设备类型。
enum AntDeviceType {
  /// 手机（宽度 < 768 的移动端）
  phone,

  /// 平板（宽度 >= 768 的移动端）
  tablet,

  /// 桌面（windows / macos / linux）
  desktop,

  /// Web
  web,
}

/// 屏幕方向。
enum AntOrientation { portrait, landscape }

/// 折叠屏状态。
enum AntFoldState {
  /// 未知（平台无法获取折叠信息时的默认值）
  unknown,

  /// 完全展开（大屏单屏）
  flat,

  /// 半折叠（悬停态，铰链姿势 half-opened）
  halfOpened,

  /// 折叠（合上）
  folded,
}

/// 布局信息 aspect，用于细粒度依赖拆分。
enum AntLayoutAspect {
  /// 宽度（任意像素变化）
  width,

  /// 断点
  breakpoint,

  /// 设备类型
  deviceType,

  /// 方向
  orientation,

  /// 折叠态
  foldState,

  /// 平台信息（targetPlatform / isOhos / isDesktop）
  platform,
}

/// 布局信息不可变快照。
class AntLayoutData {
  /// 窗口逻辑宽度。
  final double width;

  /// 当前命中的最大断点；宽度小于 480 时为 null。
  final AntBreakpoint? breakpoint;

  /// 设备类型（宽度 + 平台综合判定）。
  final AntDeviceType deviceType;

  /// 屏幕方向。
  final AntOrientation orientation;

  /// 折叠屏状态。
  final AntFoldState foldState;

  /// 目标平台。
  final TargetPlatform targetPlatform;

  /// 是否为鸿蒙平台。
  final bool isOhos;

  /// 是否为桌面类平台（web / windows / macos / linux）。
  final bool isDesktop;

  const AntLayoutData({
    required this.width,
    required this.breakpoint,
    required this.deviceType,
    required this.orientation,
    required this.foldState,
    required this.targetPlatform,
    required this.isOhos,
    required this.isDesktop,
  });

  /// 从 [MediaQueryData] 构建布局快照。
  ///
  /// [foldState] 显式传入（如 OHOS 经 channel 返回）时优先生效；
  /// 否则从 `MediaQueryData.displayFeatures` 推导（见
  /// [foldStateFromDisplayFeatures]）。
  factory AntLayoutData.fromMediaQuery(
    MediaQueryData mq, {
    AntFoldState? foldState,
  }) {
    final platform =
        AntPlatform.isWeb ? TargetPlatform.android : defaultTargetPlatform;
    return AntLayoutData(
      width: mq.size.width,
      breakpoint: AntBreakpoint.fromWidth(mq.size.width),
      deviceType: defaultDeviceTypeOf(mq),
      orientation: mq.size.width >= mq.size.height
          ? AntOrientation.landscape
          : AntOrientation.portrait,
      foldState: foldState ?? foldStateFromDisplayFeatures(mq.displayFeatures),
      targetPlatform: platform,
      isOhos: AntPlatform.isOhos,
      isDesktop: AntPlatform.isDesktop,
    );
  }

  /// 设备类型判定（宽度 + 平台综合）。
  ///
  /// - Web → [AntDeviceType.web]
  /// - 桌面平台（windows/macos/linux）→ [AntDeviceType.desktop]
  /// - 移动端：宽度 >= 768 → [AntDeviceType.tablet]，否则 [AntDeviceType.phone]
  static AntDeviceType defaultDeviceTypeOf(MediaQueryData mq) {
    if (AntPlatform.isWeb) return AntDeviceType.web;
    if (AntPlatform.isDesktop) return AntDeviceType.desktop;
    return mq.size.width >= 768 ? AntDeviceType.tablet : AntDeviceType.phone;
  }

  /// 从 `MediaQueryData.displayFeatures` 推导折叠态。
  ///
  /// 调研结论（Flutter Display API / displayFeatures）：
  /// - `DisplayFeatureType.hinge`（物理铰链）：`state == halfOpened`
  ///   表示半折叠姿势，`state == flat` 表示完全展开；
  /// - `DisplayFeatureType.fold`（软折叠/屏内折痕）：视作折叠态；
  /// - 无 hinge/fold 特征（普通设备/桌面/Web，多数平台不透出折叠信息）
  ///   → 返回 [AntFoldState.flat]（非折叠设备即平铺）；
  /// - 完全合上（folded）时系统通常切回单屏/息屏，displayFeatures
  ///   无法表达，如需精确 folded 态需平台通道（OHOS 经 AntOhosChannel）。
  static AntFoldState foldStateFromDisplayFeatures(
    List<DisplayFeature> displayFeatures,
  ) {
    var result = AntFoldState.flat;
    for (final feature in displayFeatures) {
      switch (feature.type) {
        case DisplayFeatureType.hinge:
          if (feature.state == DisplayFeatureState.postureHalfOpened) {
            return AntFoldState.halfOpened;
          }
          result = AntFoldState.flat;
        case DisplayFeatureType.fold:
          return AntFoldState.folded;
        case DisplayFeatureType.cutout:
        case DisplayFeatureType.unknown:
          break;
      }
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntLayoutData &&
        other.width == width &&
        other.breakpoint == breakpoint &&
        other.deviceType == deviceType &&
        other.orientation == orientation &&
        other.foldState == foldState &&
        other.targetPlatform == targetPlatform &&
        other.isOhos == isOhos &&
        other.isDesktop == isDesktop;
  }

  @override
  int get hashCode => Object.hash(
        width,
        breakpoint,
        deviceType,
        orientation,
        foldState,
        targetPlatform,
        isOhos,
        isDesktop,
      );

  @override
  String toString() => 'AntLayoutData(width: $width, breakpoint: $breakpoint, '
      'deviceType: $deviceType, orientation: $orientation, '
      'foldState: $foldState, platform: $targetPlatform, '
      'isOhos: $isOhos)';
}

/// 布局信息订阅源（非 Widget 场景）。
///
/// 持有 [ValueNotifier]<[AntLayoutData]>，值不变时（`==` 相等）不通知。
class AntResponsiveScope extends InheritedWidget {
  /// 布局数据通知器。
  final ValueNotifier<AntLayoutData> notifier;

  const AntResponsiveScope({
    super.key,
    required this.notifier,
    required super.child,
  });

  /// 获取最近的订阅源；无包裹时返回 null。
  static AntResponsiveScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AntResponsiveScope>();

  /// 获取布局数据 [ValueListenable]（依赖整体数据变化）。
  ///
  /// ```dart
  /// final listenable = AntResponsiveScope.layoutListenableOf(context);
  /// listenable.addListener(() { ... });
  /// ```
  static ValueListenable<AntLayoutData> layoutListenableOf(
    BuildContext context,
  ) {
    final scope = maybeOf(context);
    assert(() {
      if (scope == null) {
        throw FlutterError(
          'AntResponsiveScope.layoutListenableOf() 在 AntResponsiveScope '
          '（AntResponsiveInit 包裹）之外调用。',
        );
      }
      return true;
    }());
    return scope!.notifier;
  }

  @override
  bool updateShouldNotify(AntResponsiveScope oldWidget) =>
      notifier != oldWidget.notifier;
}

/// 响应式布局信息 InheritedModel（按 aspect 细粒度依赖）。
///
/// 由 [AntResponsiveInit] 在树中注入：
///
/// ```dart
/// AntResponsiveInit(
///   // child 保持稳定实例，builder 重建时嵌入同一 child 实现局部刷新
///   child: const MyPage(),
///   builder: (context, data, child) => MaterialApp(home: child!),
/// )
/// ```
class AntResponsive extends InheritedModel<AntLayoutAspect> {
  /// 当前布局数据快照。
  final AntLayoutData data;

  const AntResponsive({
    super.key,
    required this.data,
    required super.child,
  });

  /// 依赖整体布局数据（任一字段变化即 rebuild）。
  ///
  /// 无 [AntResponsive] 包裹时返回 null。
  static AntLayoutData? maybeOf(
    BuildContext context, {
    AntLayoutAspect? aspect,
  }) {
    final model = context.dependOnInheritedWidgetOfExactType<AntResponsive>(
      aspect: aspect,
    );
    return model?.data;
  }

  /// 依赖整体布局数据；无包裹时断言报错。
  static AntLayoutData of(BuildContext context, {AntLayoutAspect? aspect}) {
    final data = maybeOf(context, aspect: aspect);
    assert(() {
      if (data == null) {
        throw FlutterError(
          'AntResponsive.of() 在 AntResponsiveInit 包裹之外调用。',
        );
      }
      return true;
    }());
    return data!;
  }

  /// 仅依赖断点 aspect。
  static AntBreakpoint? breakpointOf(BuildContext context) =>
      of(context, aspect: AntLayoutAspect.breakpoint).breakpoint;

  /// 仅依赖设备类型 aspect。
  static AntDeviceType deviceTypeOf(BuildContext context) =>
      of(context, aspect: AntLayoutAspect.deviceType).deviceType;

  /// 仅依赖折叠态 aspect。
  static AntFoldState foldStateOf(BuildContext context) =>
      of(context, aspect: AntLayoutAspect.foldState).foldState;

  /// 仅依赖平台 aspect。
  static TargetPlatform platformOf(BuildContext context) =>
      of(context, aspect: AntLayoutAspect.platform).targetPlatform;

  /// 仅依赖宽度 aspect。
  static double widthOf(BuildContext context) =>
      of(context, aspect: AntLayoutAspect.width).width;

  @override
  bool updateShouldNotify(AntResponsive oldWidget) => data != oldWidget.data;

  @override
  bool updateShouldNotifyDependent(
    AntResponsive oldWidget,
    Set<AntLayoutAspect> dependencies,
  ) {
    final old = oldWidget.data;
    final current = data;
    for (final aspect in dependencies) {
      final changed = switch (aspect) {
        AntLayoutAspect.width => current.width != old.width,
        AntLayoutAspect.breakpoint => current.breakpoint != old.breakpoint,
        AntLayoutAspect.deviceType => current.deviceType != old.deviceType,
        AntLayoutAspect.orientation => current.orientation != old.orientation,
        AntLayoutAspect.foldState => current.foldState != old.foldState,
        AntLayoutAspect.platform =>
          current.targetPlatform != old.targetPlatform ||
              current.isOhos != old.isOhos ||
              current.isDesktop != old.isDesktop,
      };
      if (changed) return true;
    }
    return false;
  }
}

/// 折叠态外部提供器签名（如 OHOS 经 AntOhosChannel 同步返回）。
typedef AntFoldStateProvider = AntFoldState? Function();

/// AntResponsive 初始化 Widget。
///
/// - 监听 [MediaQuery] 变化，快照值真正变化（`==` 不等）才通知；
/// - 同时注入 [AntResponsive]（Widget 依赖）与 [AntResponsiveScope]
///   （非 Widget 的 [ValueListenable] / addListener 订阅入口）；
/// - [foldStateProvider] 用于接入平台折叠态（OHOS 经 AntOhosChannel），
///   返回 null 时回落到 displayFeatures 推导。
///
/// ```dart
/// AntResponsiveInit(
///   foldStateProvider: () => isOhos
///       ? AntOhosChannelRegistry.channel.getFoldStateSync()
///       : null,
///   builder: (context, data) => MaterialApp(...),
/// )
/// ```
class AntResponsiveInit extends StatefulWidget {
  /// 构建回调，携带当前布局快照。
  ///
  /// [child] 为原样透传的子树：builder 重建时应嵌入同一 [child] 实例，
  /// 保持子树 Element 不重建，使细粒度 aspect 订阅生效
  /// （与 `MediaQuery(data:, child:)` 同理）。
  final Widget Function(
    BuildContext context,
    AntLayoutData data,
    Widget? child,
  ) builder;

  /// 透传子树（稳定实例，配合 [builder] 实现局部刷新）。
  final Widget? child;

  /// 折叠态外部提供器（OHOS channel 等），null 时自动推导。
  final AntFoldStateProvider? foldStateProvider;

  const AntResponsiveInit({
    super.key,
    required this.builder,
    this.child,
    this.foldStateProvider,
  });

  @override
  State<AntResponsiveInit> createState() => _AntResponsiveInitState();
}

class _AntResponsiveInitState extends State<AntResponsiveInit>
    with WidgetsBindingObserver {
  final ValueNotifier<AntLayoutData> _notifier = ValueNotifier<AntLayoutData>(
    const AntLayoutData(
      width: 0,
      breakpoint: null,
      deviceType: AntDeviceType.phone,
      orientation: AntOrientation.portrait,
      foldState: AntFoldState.unknown,
      targetPlatform: TargetPlatform.android,
      isOhos: false,
      isDesktop: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 窗口尺寸/折叠姿势变化（如桌面 resize、折叠展开）。
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  void _sync() {
    if (!mounted) return;
    final mq = MediaQuery.maybeOf(context);
    if (mq == null) return;
    final data = AntLayoutData.fromMediaQuery(
      mq,
      foldState: widget.foldStateProvider?.call(),
    );
    // 通知去重：值相等不发通知。
    if (_notifier.value != data) {
      _notifier.value = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 依赖 MediaQuery：任一 MediaQuery 变化触发本 Widget rebuild，
    // 由 InheritedModel 的 updateShouldNotify / notifier 去重下游通知。
    final mq = MediaQuery.of(context);
    final data = AntLayoutData.fromMediaQuery(
      mq,
      foldState: widget.foldStateProvider?.call(),
    );
    if (_notifier.value != data) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
    }
    // child 由外部持有（稳定实例）；builder 每次数据变化重建外壳时
    // 嵌入同一 child 实例，子树 Element 不重建，aspect 隔离生效。
    return AntResponsiveScope(
      notifier: _notifier,
      child: AntResponsive(
        data: data,
        child: Builder(
          builder: (context) => widget.builder(context, data, widget.child),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notifier.dispose();
    super.dispose();
  }
}
