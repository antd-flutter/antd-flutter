/// AntResponsive 布局形态定义（枚举族）。
///
/// 设备类型 / 屏幕方向 / 折叠屏状态 / 细粒度 aspect 四个语义族，
/// 供响应式布局层（ant_responsive.dart）与布局数据快照使用。
///
/// @docImport '../ant_responsive.dart';
/// @docImport '../types/ant_layout_types.dart';
library;

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

  /// 桌面超宽等比缩放因子（scaleFactor）
  scaleFactor,
}
