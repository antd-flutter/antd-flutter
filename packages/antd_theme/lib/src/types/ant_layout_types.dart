/// AntResponsive 布局数据类型与回调签名。
///
/// 纯数据快照 [AntLayoutData] 与折叠态外部提供器签名 [AntFoldStateProvider]。
///
/// @docImport '../ant_responsive.dart';
/// @docImport '../enum/ant_responsive_type.dart';
library;

import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform;
import 'package:flutter/widgets.dart';

import '../ant_platform.dart';
import '../enum/ant_breakpoint_type.dart';
import '../enum/ant_responsive_type.dart';

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

/// 折叠态外部提供器签名（如 OHOS 经 AntOhosChannel 同步返回）。
typedef AntFoldStateProvider = AntFoldState? Function();
