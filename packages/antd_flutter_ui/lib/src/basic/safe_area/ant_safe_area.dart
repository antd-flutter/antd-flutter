/// AntSafeArea — Flutter 标准库适配层
///
/// 适配层定位：本组件**继承 Flutter 原生 [SafeArea]**（material_ui/material.dart
/// 导出），类型可直接兼容任何接受 `SafeArea` 的位置。Flutter 原生参数
/// （`left` / `top` / `right` / `bottom` / `minimum` / `maintainBottomViewPadding`）
/// 经 `super` 构造级透传，语义与原生完全一致。
///
/// antd 增强（保持最小）：
/// - [position] — antd 风格的位置枚举（top / bottom / both），构造级映射为
///   原生 `top` / `bottom` 布尔参数；用户显式传入的枚举值永远优先。
/// - 占位模式 — [child] 为 null 时渲染安全区高度的 `SizedBox`（对齐 antd React
///   SafeArea 的占位用法），这是 Flutter 原生 `SafeArea` 不支持的能力。
///
/// 默认值策略：`minimum` 保持 Flutter 原生默认 `EdgeInsets.zero`；`minimum`
/// 为非可空参数，无法实现「null → antd token」的构造级注入，故保持原生默认。
library;

import 'package:material_ui/material_ui.dart';

import 'ant_safe_area_types.dart';

// ============================================================
// AntSafeArea
// ============================================================

/// 安全区 — 适配层实现，继承 Flutter [SafeArea]，兼容原生位置。
///
/// 对齐 antd React SafeArea 组件，在刘海屏、全面屏等设备上
/// 避免内容被状态栏或底部指示条遮挡。
///
/// ```dart
/// AntSafeArea(position: AntSafeAreaPosition.top) // 顶部安全区占位
/// AntSafeArea(position: AntSafeAreaPosition.bottom) // 底部安全区占位
/// AntSafeArea(child: myContent) // 包装子组件并添加安全区内边距
/// ```
class AntSafeArea extends SafeArea {
  /// 创建安全区组件。
  ///
  /// [position] 映射为原生 `top` / `bottom` 布尔参数（构造级解析）；
  /// 其余参数原样透传给 [SafeArea]，语义与 Flutter 原生一致。
  ///
  /// [child] 为 null 时进入占位模式；原生 [SafeArea.child] 不可为 null，
  /// 此处向父类传入 `SizedBox.shrink()` 占位（不会实际渲染该占位）。
  const AntSafeArea({
    super.key,
    this.position = AntSafeAreaPosition.both,
    Widget? child,
    super.maintainBottomViewPadding = false,
    super.minimum = EdgeInsets.zero,
    super.left = true,
    super.right = true,
  })  : _child = child,
        super(
          child: child ?? const SizedBox.shrink(),
          top: position == AntSafeAreaPosition.top ||
              position == AntSafeAreaPosition.both,
          bottom: position == AntSafeAreaPosition.bottom ||
              position == AntSafeAreaPosition.both,
        );

  /// 子组件。为 null 时渲染安全区高度的占位 SizedBox。
  ///
  /// 注意：父类 [SafeArea.child] 为非空字段，此处以私有字段承载可空语义；
  /// null 时向父类传入 `SizedBox.shrink()` 占位，不会实际渲染。
  final Widget? _child;

  /// 安全区位置。top 仅顶部，bottom 仅底部，both 顶部和底部。
  ///
  /// 构造级解析为原生 [SafeArea.top] / [SafeArea.bottom]；
  /// 用户显式传入的枚举值永远优先。
  final AntSafeAreaPosition position;

  @override
  Widget build(BuildContext context) {
    // 占位模式 — child 为 null 时渲染安全区高度的 SizedBox
    // （Flutter 原生 SafeArea 不支持 child 为 null，此处为 antd 增强能力）
    if (_child == null) {
      final mediaQuery = MediaQuery.of(context);
      var height = 0.0;
      if (top) {
        height += mediaQuery.padding.top;
      }
      if (bottom) {
        height += maintainBottomViewPadding
            ? mediaQuery.viewPadding.bottom
            : mediaQuery.padding.bottom;
      }
      return SizedBox(height: height);
    }

    // 包装模式 — 交由 Flutter 原生 SafeArea.build 处理
    return super.build(context);
  }
}
