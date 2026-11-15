/// AntButton 尺寸 + 形状解析器
///
/// 精确移植 antd v6 `button/style/index.ts` 的 genButtonStyle /
/// genSizeBaseButtonStyle / genSizeSmallButtonStyle / genSizeLargeButtonStyle /
/// genCircleButtonStyle / genBlockButtonStyle 逻辑。
///
/// 缩放规范：flutter_screenutil 仅使用 `.w`（尺寸/间距）/ `.sp`（字号）/ `.r`（圆角），
/// 禁止 `.h`。
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_button_types.dart';

/// 按钮尺寸解析结果（已含 screenutil 缩放）。
class AntButtonSizeStyle {
  const AntButtonSizeStyle({
    required this.height,
    required this.fontSize,
    required this.borderRadius,
    required this.paddingInline,
    required this.iconGap,
    this.width,
  });

  /// 控件高度（circle/icon-only 时同时作为宽度）。
  final double height;

  /// 内容字号。
  final double fontSize;

  /// 圆角半径。
  final double borderRadius;

  /// 横向内边距（circle/icon-only 时为 0）。
  final double paddingInline;

  /// 图标与文字间距（= marginXS）。
  final double iconGap;

  /// 固定宽度（icon-only/circle = height；block = infinity；其余 null）。
  final double? width;
}

/// 解析按钮尺寸 + 形状。
///
/// [iconOnly] 为 true 时（无文字仅有图标）：宽度 = 高度，paddingInline = 0。
/// [block] 为 true 时：宽度 = 撑满父容器。
AntButtonSizeStyle resolveButtonSize({
  required AntButtonSize size,
  required AntButtonShape shape,
  bool iconOnly = false,
  bool block = false,
  required AntThemeData theme,
}) {
  final t = theme;

  // ---- 1. 按尺寸取基础值（与 antd genSizeXxxButtonStyle 对齐）----
  late double rawHeight;
  late double rawFontSize;
  late double rawBorderRadius;
  late double rawPaddingInline;

  switch (size) {
    case AntButtonSize.middle:
      // base: controlHeight / contentFontSize / borderRadius / paddingInline
      rawHeight = t.controlHeight;
      rawFontSize = t.fontSize; // contentFontSize 默认 = fontSize
      rawBorderRadius = t.borderRadius;
      // paddingInline = paddingContentHorizontal - lineWidth
      rawPaddingInline = t.paddingContentHorizontal - t.lineWidth;
    case AntButtonSize.small:
      // SM: controlHeightSM / contentFontSizeSM / borderRadiusSM / paddingInlineSM
      rawHeight = t.controlHeightSM;
      rawFontSize = t.fontSize; // contentFontSizeSM 默认 = fontSize
      rawBorderRadius = t.borderRadiusSM;
      // paddingInlineSM = 8 - lineWidth
      rawPaddingInline = 8 - t.lineWidth;
    case AntButtonSize.large:
      // LG: controlHeightLG / contentFontSizeLG / borderRadiusLG / paddingInlineLG
      rawHeight = t.controlHeightLG;
      rawFontSize = t.fontSizeLG; // contentFontSizeLG 默认 = fontSizeLG
      rawBorderRadius = t.borderRadiusLG;
      // paddingInlineLG = paddingContentHorizontal - lineWidth
      rawPaddingInline = t.paddingContentHorizontal - t.lineWidth;
  }

  // ---- 2. screenutil 缩放（.w 尺寸 / .sp 字号 / .r 圆角）----
  final height = rawHeight.w;
  final fontSize = rawFontSize.sp;
  var borderRadius = rawBorderRadius.r;
  var paddingInline = rawPaddingInline.w;
  final iconGap = t.marginXS.w;

  // ---- 3. 形状覆盖 ----
  double? width;

  switch (shape) {
    case AntButtonShape.circle:
      // genCircleButtonStyle: minWidth=controlHeight, paddingInline=0, borderRadius=50%
      width = height;
      paddingInline = 0;
      borderRadius = height / 2; // 50% → 高度的一半（高度已缩放，不再单独 .r）
    case AntButtonShape.round:
      // round: borderRadius = controlHeight（全圆角）
      borderRadius = height; // 已缩放的高度值
    case AntButtonShape.square:
      // 方角：无圆角
      borderRadius = 0;
    case AntButtonShape.normal:
      // 默认形状，保持基础圆角
      break;
  }

  // ---- 4. icon-only 覆盖 ----
  if (iconOnly) {
    // &-icon-only: width=controlHeight, paddingInline=0
    width = height;
    paddingInline = 0;
  }

  // ---- 5. block 覆盖 ----
  if (block) {
    // &-block: width=100%
    width = double.infinity;
  }

  return AntButtonSizeStyle(
    height: height,
    fontSize: fontSize,
    borderRadius: borderRadius,
    paddingInline: paddingInline,
    iconGap: iconGap,
    width: width,
  );
}