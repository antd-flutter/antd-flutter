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
///
/// 枚举族拆分至 `enum/ant_responsive_type.dart`，
/// 布局数据类型拆分至 `types/ant_layout_types.dart`。
///
/// @docImport 'enum/ant_responsive_type.dart';
/// @docImport 'types/ant_layout_types.dart';
library;

import 'package:flutter/foundation.dart'
    show ValueListenable;
import 'package:flutter/widgets.dart';

import 'enum/ant_breakpoint_type.dart';
import 'enum/ant_responsive_type.dart';
import 'types/ant_layout_types.dart';

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
