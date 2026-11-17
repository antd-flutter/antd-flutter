/// AntButton 颜色矩阵解析器
///
/// 精确移植 antd v6 `button/style/variant.ts` 的 CSS 变量体系：
/// - 6 种 variant × { default / primary / danger / link / 预设色 } 的颜色组合
/// - normal / hover / active / disabled 四态
/// - ghost 透明背景处理
/// - 预设色阴影使用 getAlphaColor 算法（与 antd `getAlphaColor.ts` 对齐）
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/widgets.dart';

import 'ant_button_preset_colors.dart';
import 'ant_button_types.dart';

/// 按钮某一交互状态下的视觉属性。
class AntButtonVisualState {
  const AntButtonVisualState({
    required this.background,
    required this.borderColor,
    required this.textColor,
    this.shadow,
  });

  /// 背景色。
  final Color background;

  /// 边框色。
  final Color borderColor;

  /// 文字/图标色。
  final Color textColor;

  /// 阴影（仅 solid / outlined / dashed 变体有值）。
  final List<BoxShadow>? shadow;
}

/// 按钮完整样式（四态 + 边框线型）。
class AntButtonStyle {
  const AntButtonStyle({
    required this.normal,
    required this.hover,
    required this.active,
    required this.disabled,
    this.borderStyle = BorderStyle.solid,
  });

  /// 默认态。
  final AntButtonVisualState normal;

  /// 悬浮态。
  final AntButtonVisualState hover;

  /// 按下态。
  final AntButtonVisualState active;

  /// 禁用态。
  final AntButtonVisualState disabled;

  /// 边框线型（dashed 变体为虚线）。
  final BorderStyle borderStyle;
}

// ============================================================
// 内部：色阶包（对应 antd CSS 变量 color-base/hover/active/light/…）
// ============================================================

class _ColorShades {
  const _ColorShades({
    required this.base,
    required this.hover,
    required this.active,
    required this.light,
    required this.lightHover,
    required this.lightActive,
    required this.solidText,
    required this.shadow,
  });

  /// color-base：实心背景 / 描边文字 / 描边边框的主色。
  final Color base;

  /// color-hover：hover 态主色。
  final Color hover;

  /// color-active：active 态主色。
  final Color active;

  /// color-light：filled/text 变体的浅色背景。
  final Color light;

  /// color-light-hover：filled/text 变体 hover 浅色背景。
  final Color lightHover;

  /// color-light-active：filled/text 变体 active 浅色背景。
  final Color lightActive;

  /// solid 变体文字色（colorTextLightSolid 或 solidTextColor）。
  final Color solidText;

  /// 变体阴影（仅 solid / outlined / dashed 使用）。
  final List<BoxShadow>? shadow;
}

/// 解析某颜色语义的全部色阶。
_ColorShades _resolveShades(AntButtonColor color, AntThemeData theme) {
  final t = theme;

  switch (color) {
    // ---- default（中性色体系）----
    case AntButtonColor.normal:
      return _ColorShades(
        // color-base = defaultBorderColor = colorBorder
        base: t.colorBorder,
        // color-hover = defaultHoverBorderColor = colorPrimaryHover
        hover: t.colorPrimaryHover,
        // color-active = defaultActiveBorderColor = colorPrimaryActive
        active: t.colorPrimaryActive,
        // color-light = colorFillTertiary
        light: t.colorFillTertiary,
        // color-light-hover = colorFillSecondary
        lightHover: t.colorFillSecondary,
        // color-light-active = colorFill
        lightActive: t.colorFill,
        // solidTextColor = isBright(colorBgSolid) ? '#000' : '#fff'
        solidText: _solidTextColor(t),
        // defaultShadow = 0 {controlOutlineWidth}px 0 {controlTmpOutline}
        shadow: _boxShadow(t.controlOutlineWidth, t.controlTmpOutline),
      );

    // ---- primary ----
    case AntButtonColor.primary:
      return _ColorShades(
        base: t.colorPrimary,
        hover: t.colorPrimaryHover,
        active: t.colorPrimaryActive,
        // color-light = colorPrimaryBg
        light: t.colorPrimaryBg,
        // color-light-hover = colorPrimaryBgHover
        lightHover: t.colorPrimaryBgHover,
        // color-light-active = colorPrimaryBorder（注意：非 colorPrimaryBgActive）
        lightActive: t.colorPrimaryBorder,
        // primaryColor = colorTextLightSolid
        solidText: t.colorTextLightSolid,
        // primaryShadow = 0 {controlOutlineWidth}px 0 {controlOutline}
        shadow: _boxShadow(t.controlOutlineWidth, t.controlOutline),
      );

    // ---- danger ----
    case AntButtonColor.danger:
      return _ColorShades(
        base: t.colorError,
        hover: t.colorErrorHover,
        active: t.colorErrorActive,
        // color-light = colorErrorBg
        light: t.colorErrorBg,
        // color-light-hover = colorErrorBgFilledHover（专用于 filled hover）
        lightHover: t.colors.colorErrorBgHoverFilled,
        // color-light-active = colorErrorBgActive
        lightActive: t.colorErrorBgActive,
        // dangerColor = colorTextLightSolid
        solidText: t.colorTextLightSolid,
        // dangerShadow = 0 {controlOutlineWidth}px 0 {colorErrorOutline}
        shadow: _boxShadow(t.controlOutlineWidth, t.colorErrorOutline),
      );

    // ---- link（colorLink 体系）----
    case AntButtonColor.link:
      return _ColorShades(
        base: t.colorLink,
        hover: t.colorLinkHover,
        active: t.colorLinkActive,
        // link 变体背景恒透明，浅色阶不使用
        light: const Color(0x00000000),
        lightHover: const Color(0x00000000),
        lightActive: const Color(0x00000000),
        solidText: t.colorTextLightSolid,
        shadow: null,
      );

    // ---- 预设色 ----
    default:
      final isDark = t.isDark;
      return _ColorShades(
        // color-base = {colorKey}6
        base: presetColorAt(color, 6, isDark: isDark),
        // color-hover = {colorKey}Hover = {colorKey}5
        hover: presetColorAt(color, 5, isDark: isDark),
        // color-active = {colorKey}Active = {colorKey}7
        active: presetColorAt(color, 7, isDark: isDark),
        // color-light = {colorKey}1
        light: presetColorAt(color, 1, isDark: isDark),
        // color-light-hover = {colorKey}2
        lightHover: presetColorAt(color, 2, isDark: isDark),
        // color-light-active = {colorKey}3
        lightActive: presetColorAt(color, 3, isDark: isDark),
        solidText: t.colorTextLightSolid,
        // {colorKey}ShadowColor = 0 {controlOutlineWidth}px 0
        //   getAlphaColor({colorKey}1, colorBgContainer)
        shadow: _boxShadow(
          t.controlOutlineWidth,
          _getAlphaColor(
            presetColorAt(color, 1, isDark: isDark),
            t.colorBgContainer,
          ),
        ),
      );
  }
}

// ============================================================
// 内部：variant × color 组合解析
// ============================================================

/// 解析按钮完整样式。
///
/// 参数对应 antd Button 的 color / variant / ghost 属性。
/// 返回四态（normal / hover / active / disabled）的完整颜色矩阵。
AntButtonStyle resolveButtonStyle({
  required AntButtonColor color,
  required AntButtonVariant variant,
  bool ghost = false,
  required AntThemeData theme,
}) {
  final shades = _resolveShades(color, theme);
  final t = theme;

  // ---- 1. 按 variant 生成基础三态 ----
  late Color bg;
  late Color bgHover;
  late Color bgActive;
  late Color border;
  late Color borderHover;
  late Color borderActive;
  late Color text;
  late Color textHover;
  late Color textActive;
  List<BoxShadow>? shadow;

  switch (variant) {
    case AntButtonVariant.solid:
      // solid：bg=color-base→hover→active，border 透明，text=solidText
      bg = shades.base;
      bgHover = shades.hover;
      bgActive = shades.active;
      border = const Color(0x00000000);
      borderHover = const Color(0x00000000);
      borderActive = const Color(0x00000000);
      text = shades.solidText;
      textHover = shades.solidText;
      textActive = shades.solidText;
      shadow = shades.shadow;

      // default 色的 solid 使用 colorBgSolid 系列（非 color-base）
      if (color == AntButtonColor.normal) {
        bg = t.colorBgSolid;
        bgHover = t.colorBgSolidHover;
        bgActive = t.colorBgSolidActive;
        // text 已由 solidText = solidTextColor 处理
      }

    case AntButtonVariant.outlined:
    case AntButtonVariant.dashed:
      // outlined/dashed：border=color-base→hover→active，bg=容器色，text=color-base→hover→active
      border = shades.base;
      borderHover = shades.hover;
      borderActive = shades.active;
      bg = t.colorBgContainer;
      bgHover = t.colorBgContainer;
      bgActive = t.colorBgContainer;
      text = shades.base;
      textHover = shades.hover;
      textActive = shades.active;
      shadow = shades.shadow;

      // default 色的 outlined/dashed：text 用 defaultColor 系列，bg 恒 colorBgContainer
      if (color == AntButtonColor.normal) {
        text = t.colorText; // defaultColor
        textHover = t.colorPrimaryHover; // defaultHoverColor
        textActive = t.colorPrimaryActive; // defaultActiveColor
        // bg 已是 colorBgContainer = defaultBg = defaultHoverBg = defaultActiveBg
      }

      // link 色的 outlined/dashed：text 用 colorLink 系列
      if (color == AntButtonColor.link) {
        text = t.colorLink;
        textHover = t.colorLinkHover;
        textActive = t.colorLinkActive;
      }

    case AntButtonVariant.filled:
      // filled：bg=color-light→light-hover→light-active，border 透明，text=color-base
      border = const Color(0x00000000);
      borderHover = const Color(0x00000000);
      borderActive = const Color(0x00000000);
      bg = shades.light;
      bgHover = shades.lightHover;
      bgActive = shades.lightActive;
      text = shades.base;
      textHover = shades.hover;
      textActive = shades.active;
      shadow = null; // filled 无阴影

      // default 色的 filled：text 恒 colorText（hover/active 不变色）
      if (color == AntButtonColor.normal) {
        text = t.colorText;
        textHover = t.colorText;
        textActive = t.colorText;
      }

    case AntButtonVariant.text:
      // text：bg=transparent→hover color-light→active color-light-active，
      // border 透明，text=color-base→hover→active
      border = const Color(0x00000000);
      borderHover = const Color(0x00000000);
      borderActive = const Color(0x00000000);
      bg = const Color(0x00000000);
      bgHover = shades.light;
      bgActive = shades.lightActive;
      text = shades.base;
      textHover = shades.hover;
      textActive = shades.active;
      shadow = null; // text 无阴影

      // default 色的 text：text 恒 colorText，bg-hover = textHoverBg = colorFillTertiary
      if (color == AntButtonColor.normal) {
        text = t.colorText; // textTextColor
        textHover = t.colorText; // textTextHoverColor
        textActive = t.colorText; // textTextActiveColor
        bgHover = t.colorFillTertiary; // textHoverBg
      }

    case AntButtonVariant.link:
      // link：bg 恒透明，border 透明，text=color-base→hover→active
      border = const Color(0x00000000);
      borderHover = const Color(0x00000000);
      borderActive = const Color(0x00000000);
      bg = const Color(0x00000000);
      bgHover = const Color(0x00000000); // linkHoverBg = transparent
      bgActive = const Color(0x00000000);
      text = shades.base;
      textHover = shades.hover;
      textActive = shades.active;
      shadow = null; // link 无阴影

      // default 色的 link 变体：使用 colorLink 系列（By Default 覆盖）
      if (color == AntButtonColor.normal) {
        text = t.colorLink;
        textHover = t.colorLinkHover;
        textActive = t.colorLinkActive;
      }
  }

  // ---- 2. ghost 覆盖 ----
  if (ghost) {
    // ghost：bg 恒透明，shadow 清除
    bg = const Color(0x00000000);
    bgHover = const Color(0x00000000);
    bgActive = const Color(0x00000000);
    shadow = null;

    // default 色 ghost + outlined/dashed：text/border = colorBgContainer
    if (color == AntButtonColor.normal &&
        (variant == AntButtonVariant.outlined ||
            variant == AntButtonVariant.dashed)) {
      text = t.colorBgContainer; // defaultGhostColor
      border = t.colorBgContainer; // defaultGhostBorderColor
      borderHover = t.colorBgContainer;
      borderActive = t.colorBgContainer;
    }
  }

  // ---- 3. disabled 态 ----
  final Color disabledBg;
  final Color disabledBorder;
  if (variant == AntButtonVariant.text || variant == AntButtonVariant.link) {
    // text/link 禁用：bg/border 透明
    disabledBg = const Color(0x00000000);
    disabledBorder = const Color(0x00000000);
  } else {
    disabledBg = t.colorBgContainerDisabled;
    disabledBorder = t.colorBorderDisabled;
  }

  return AntButtonStyle(
    normal: AntButtonVisualState(
      background: bg,
      borderColor: border,
      textColor: text,
      shadow: shadow,
    ),
    hover: AntButtonVisualState(
      background: bgHover,
      borderColor: borderHover,
      textColor: textHover,
      shadow: shadow,
    ),
    active: AntButtonVisualState(
      background: bgActive,
      borderColor: borderActive,
      textColor: textActive,
      shadow: shadow,
    ),
    disabled: AntButtonVisualState(
      background: disabledBg,
      borderColor: disabledBorder,
      textColor: t.colorTextDisabled,
      shadow: null,
    ),
    borderStyle: variant == AntButtonVariant.dashed
        ? BorderStyle.solid // Flutter 用 dashPattern 处理虚线
        : BorderStyle.solid,
  );
}

// ============================================================
// 内部工具
// ============================================================

/// 构造 antd 风格的按钮阴影：`0 {offset}px 0 {color}`。
List<BoxShadow>? _boxShadow(double offsetY, Color color) {
  return [
    BoxShadow(
      offset: Offset(0, offsetY),
      blurRadius: 0,
      spreadRadius: 0,
      color: color,
    ),
  ];
}

/// 与 antd `isBright` 对齐（opaque 色分支）：
/// `r * 0.299 + g * 0.587 + b * 0.114 > 192`。
///
/// solidTextColor = isBright(colorBgSolid) ? '#000' : '#fff'
Color _solidTextColor(AntThemeData t) {
  final c = t.colorBgSolid;
  final brightness = c.r * 255 * 0.299 + c.g * 255 * 0.587 + c.b * 255 * 0.114;
  return brightness > 192 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
}

/// 与 antd `getAlphaColor.ts` 对齐：
/// 将不透明前景色转换为在背景上呈现相同视觉效果的最小透明度色。
///
/// 算法：从 fA=0.01 递增到 1.0，寻找使 r/g/b 均在 [0,255] 范围内的
/// 最小 alpha，使 `front = bg*(1-fA) + front*fA` 成立。
Color _getAlphaColor(Color front, Color background) {
  // 若前景已有透明度，直接返回
  if (front.a < 1.0) return front;

  final fR = (front.r * 255).round();
  final fG = (front.g * 255).round();
  final fB = (front.b * 255).round();
  final bR = (background.r * 255).round();
  final bG = (background.g * 255).round();
  final bB = (background.b * 255).round();

  for (int i = 1; i <= 100; i++) {
    final fA = i / 100.0;
    final r = ((fR - bR * (1 - fA)) / fA).round();
    final g = ((fG - bG * (1 - fA)) / fA).round();
    final b = ((fB - bB * (1 - fA)) / fA).round();
    if (r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255) {
      return Color.fromARGB((fA * 255).round(), r, g, b);
    }
  }

  // fallback：返回不透明前景色
  return front;
}
