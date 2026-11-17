/// Ant Design 颜色令牌。
///
/// 从种子令牌生成完整的颜色令牌集（亮色 / 暗色），
/// 对应 antd `genColorMapToken` + `generateNeutralColorPalettes` + `alias.ts` 颜色部分。
///
/// CSS 字符串形式的令牌数据类（AntColorTokensCss）拆分至
/// `css/ant_color_tokens_css.dart`。
///
/// @docImport 'css/ant_color_tokens_css.dart';
library;

import 'dart:ui';

import 'package:antd_color/antd_color.dart';
import 'ant_seed_token.dart';
import 'css/ant_color_tokens_css.dart';

// ============================================================
// 颜色算法（亮/暗主题）
// ============================================================

/// 设置透明度并输出 rgba 字符串。
String _getAlphaColor(String baseColor, double alpha) {
  return AntFastColor.of(baseColor).setA(alpha).toRgbString();
}

/// 实色调整：亮色主题 darken，暗色主题 lighten。
String _getSolidColorLight(String baseColor, double brightness) {
  return AntFastColor.of(baseColor).darken(brightness).toHexString();
}

String _getSolidColorDark(String baseColor, double brightness) {
  return AntFastColor.of(baseColor).lighten(brightness).toHexString();
}

/// 在背景色上寻找最小 alpha 使前景色呈现效果（antd util/getAlphaColor）。
String _getAlphaColorOnBg(String frontColor, String backgroundColor) {
  final front = AntFastColor.of(frontColor);
  final fRgb = front.toRgb();
  if (front.a < 1) return frontColor;

  final bRgb = AntFastColor.of(backgroundColor).toRgb();

  for (var fA = 0.01; fA <= 1; fA += 0.01) {
    final r = ((fRgb.r - bRgb.r * (1 - fA)) / fA).round();
    final g = ((fRgb.g - bRgb.g * (1 - fA)) / fA).round();
    final b = ((fRgb.b - bRgb.b * (1 - fA)) / fA).round();
    if (r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255) {
      return AntFastColor.fromRgb(r, g, b, (fA * 100).round() / 100)
          .toRgbString();
    }
  }

  // fallback
  return AntFastColor.fromRgb(fRgb.r, fRgb.g, fRgb.b, 1).toRgbString();
}

// ============================================================
// 色板映射（antd ColorMap 1-10）
// ============================================================

/// 亮色主题色板映射: {1..7}=colors[0..6], {8,9,10}=colors[4,5,6]。
List<String> _mapLight(List<String> colors) => [
      colors[0], colors[1], colors[2], colors[3], colors[4],
      colors[5], colors[6], colors[4], colors[5], colors[6],
    ];

/// 暗色主题色板映射: {1..4}=colors[0..3], {5}=colors[6], {6}=colors[5],
/// {7}=colors[4], {8,9,10}=colors[6,5,4]。
List<String> _mapDark(List<String> colors) => [
      colors[0], colors[1], colors[2], colors[3],
      colors[6], colors[5], colors[4],
      colors[6], colors[5], colors[4],
    ];

// ============================================================
// AntColorTokens — 完整颜色令牌集
// ============================================================

/// Ant Design 颜色令牌集。
///
/// 包含 antd MapToken + AliasToken 中的全部颜色字段，
/// 以 Flutter [Color] 形式提供，同时保留 CSS 字符串（[css]）用于调试与导出。
///
/// 在 antd v6 令牌派生链中，本类同时覆盖两层：
///
/// ```text
/// AntSeedToken（种子）
///   └─ AntColorTokens.light / AntColorTokens.dark
///        ├─ Map Token 层：色板派生（colorPrimaryBg…TextActive 等 10 阶）
///        └─ Alias Token 层：语义别名（colorSplit、controlItemBgHover 等）
/// ```
///
/// 亮/暗主题的差异体现在：
/// - 色板使用 `dark` 主题算法生成，且 `colorPrimaryBg` 映射为 `colorPrimaryBorder`；
/// - 中性色（文字/填充/背景/边框）采用不同的 alpha / 亮度系数；
/// - 实色调整在亮色为 darken、暗色为 lighten，以在暗背景上保持层次感；
/// - `colorBgBlur` 亮色为透明（与 antd 一致，亮色主题不提供毛玻璃背景色）。
///
/// 使用场景：
/// - 通过 `antd_theme` 装配亮色 / 暗色主题（本类是主题颜色的唯一来源）；
/// - Widget 层按语义取色，如 `colorBgContainer`、`colorTextSecondary`；
/// - 定制品牌色后借助 [css] 与 antd Web 端令牌值对拍。
///
/// 性能提示：getter 每次调用都会解析 `css` 字符串为 `Color`；热点路径
/// （如 build 方法高频执行）请先取出 `Color` 缓存为局部变量，或由
/// `antd_theme` 层统一缓存。业务代码应优先通过 `antd_theme` 获取当前
/// `AntColorTokens`，而非自行调用工厂。
///
/// ```dart
/// const seed = AntSeedToken(colorPrimary: '#6a3ce8');
/// final light = AntColorTokens.light(seed);
/// final dark = AntColorTokens.dark(seed);
/// light.colorPrimary; // #6a3ce8
/// dark.colorPrimary;  // 暗色色板第 6 阶（比亮色更亮）
/// ```
class AntColorTokens {
  AntColorTokens._({
    required this.css,
    required this.isDark,
  });

  /// CSS 字符串形式的原始令牌值（调试与导出用），见 [AntColorTokensCss]。
  final AntColorTokensCss css;

  /// Whether this token set was generated for the dark theme.
  final bool isDark;

  // ==================== 基色 ====================

  /// 背景基色（亮 `#fff` / 暗 `#000`，派生自种子）。
  Color get colorBgBase => antParseColor(css.colorBgBase);
  /// 文字基色（亮 `#000` / 暗 `#fff`，派生自种子）。
  Color get colorTextBase => antParseColor(css.colorTextBase);
  /// 纯白色常量 `#fff`。
  Color get colorWhite => antParseColor(css.colorWhite);
  /// 阴影基色（派生自种子 [AntSeedToken.colorShadow]）。
  Color get colorShadow => antParseColor(css.colorShadow);
  /// 遮罩背景色（黑色 45% 透明度）。
  Color get colorBgMask => antParseColor(css.colorBgMask);

  // ==================== 文字 ====================

  /// 默认文字色（文字基色 88%/暗色 85% alpha）。
  Color get colorText => antParseColor(css.colorText);
  /// 次要文字色（基色 65% alpha）。
  Color get colorTextSecondary => antParseColor(css.colorTextSecondary);
  /// 三级文字色（基色 45% alpha）。
  Color get colorTextTertiary => antParseColor(css.colorTextTertiary);
  /// 四级文字色（基色 25% alpha）。
  Color get colorTextQuaternary => antParseColor(css.colorTextQuaternary);

  /// 标题文字色（Alias：等于 colorText）。
  Color get colorTextHeading => antParseColor(css.colorTextHeading);
  /// 表单标签文字色（Alias：等于 colorTextSecondary）。
  Color get colorTextLabel => antParseColor(css.colorTextLabel);
  /// 描述文字色（Alias：等于 colorTextTertiary）。
  Color get colorTextDescription => antParseColor(css.colorTextDescription);
  /// 深色底上的白色文字色（Alias：等于 colorWhite）。
  Color get colorTextLightSolid => antParseColor(css.colorTextLightSolid);
  /// 占位符文字色（Alias：等于 colorTextQuaternary）。
  Color get colorTextPlaceholder => antParseColor(css.colorTextPlaceholder);
  /// 禁用态文字色（Alias：等于 colorTextQuaternary）。
  Color get colorTextDisabled => antParseColor(css.colorTextDisabled);
  /// 高亮色（Alias：等于 colorError）。
  Color get colorHighlight => antParseColor(css.colorHighlight);
  /// 图标默认色（Alias：等于 colorTextTertiary）。
  Color get colorIcon => antParseColor(css.colorIcon);
  /// 图标 hover 色（Alias：等于 colorText）。
  Color get colorIconHover => antParseColor(css.colorIconHover);

  // ==================== 填充 ====================

  /// 默认填充色（文字基色 15%/暗色 18% alpha）。
  Color get colorFill => antParseColor(css.colorFill);
  /// 次级填充色（基色 6%/暗色 12% alpha）。
  Color get colorFillSecondary => antParseColor(css.colorFillSecondary);
  /// 三级填充色（基色 4%/暗色 8% alpha）。
  Color get colorFillTertiary => antParseColor(css.colorFillTertiary);
  /// 四级填充色（基色 2%/暗色 4% alpha）。
  Color get colorFillQuaternary => antParseColor(css.colorFillQuaternary);
  /// 内容填充色（Alias：等于 colorFillSecondary）。
  Color get colorFillContent => antParseColor(css.colorFillContent);
  /// 内容填充 hover 色（Alias：等于 colorFill）。
  Color get colorFillContentHover => antParseColor(css.colorFillContentHover);
  /// 斑马纹/间隔填充色（Alias：等于 colorFillQuaternary）。
  Color get colorFillAlter => antParseColor(css.colorFillAlter);

  // ==================== 背景 ====================

  /// 容器背景色（亮色等于基色，暗色 lighten 8%）。
  Color get colorBgContainer => antParseColor(css.colorBgContainer);
  /// 浮层背景色（暗色 lighten 12%，亮色等于基色）。
  Color get colorBgElevated => antParseColor(css.colorBgElevated);
  /// 布局背景色（亮色 darken 4%，暗色等于基色）。
  Color get colorBgLayout => antParseColor(css.colorBgLayout);
  /// 聚光背景色（亮色为文字基色 85% alpha，暗色 lighten 26%）。
  Color get colorBgSpotlight => antParseColor(css.colorBgSpotlight);
  /// 毛玻璃背景色（暗色为基色 4% alpha，亮色透明）。
  Color get colorBgBlur => antParseColor(css.colorBgBlur);
  /// 禁用容器背景色（Alias：等于 colorFillTertiary）。
  Color get colorBgContainerDisabled => antParseColor(css.colorBgContainerDisabled);
  /// 实底背景色（基色 100%/暗色 95% alpha）。
  Color get colorBgSolid => antParseColor(css.colorBgSolid);
  /// 实底背景 hover 色（基色 75%/暗色 100% alpha）。
  Color get colorBgSolidHover => antParseColor(css.colorBgSolidHover);
  /// 实底背景 active 色（基色 95%/暗色 90% alpha）。
  Color get colorBgSolidActive => antParseColor(css.colorBgSolidActive);
  /// 文字背景 hover 色（Alias：等于 colorFillSecondary）。
  Color get colorBgTextHover => antParseColor(css.colorBgTextHover);
  /// 文字背景 active 色（Alias：等于 colorFill）。
  Color get colorBgTextActive => antParseColor(css.colorBgTextActive);

  // ==================== 边框 ====================

  /// 默认边框色（背景基色 darken 15%/暗色 lighten 26%）。
  Color get colorBorder => antParseColor(css.colorBorder);
  /// 次级边框色（背景基色 darken 6%/暗色 lighten 19%）。
  Color get colorBorderSecondary => antParseColor(css.colorBorderSecondary);
  /// 禁用态边框色（与 colorBorder 同值）。
  Color get colorBorderDisabled => antParseColor(css.colorBorderDisabled);
  /// 边框与背景交界色（Alias：等于 colorBgContainer）。
  Color get colorBorderBg => antParseColor(css.colorBorderBg);
  /// 分割线色（Alias：colorBorderSecondary 在容器背景上的最小 alpha 等价色）。
  Color get colorSplit => antParseColor(css.colorSplit);

  // ==================== Primary ====================

  /// 主色色板第 6 阶主色值（色板第 6 阶）。
  Color get colorPrimary => antParseColor(css.colorPrimary);
  /// 主色色板第 1 阶（浅背景色）（色板第 1 阶）。
  Color get colorPrimaryBg => antParseColor(css.colorPrimaryBg);
  /// 主色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  Color get colorPrimaryBgHover => antParseColor(css.colorPrimaryBgHover);
  /// 主色色板第 3 阶（边框色）（色板第 3 阶）。
  Color get colorPrimaryBorder => antParseColor(css.colorPrimaryBorder);
  /// 主色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  Color get colorPrimaryBorderHover => antParseColor(css.colorPrimaryBorderHover);
  /// 主色hover 态色值（色板中间阶）。
  Color get colorPrimaryHover => antParseColor(css.colorPrimaryHover);
  /// 主色色板第 7 阶（active 态色）（色板第 7 阶）。
  Color get colorPrimaryActive => antParseColor(css.colorPrimaryActive);
  /// 主色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  Color get colorPrimaryTextHover => antParseColor(css.colorPrimaryTextHover);
  /// 主色色板第 9 阶（文字色）（色板第 9 阶）。
  Color get colorPrimaryText => antParseColor(css.colorPrimaryText);
  /// 主色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  Color get colorPrimaryTextActive => antParseColor(css.colorPrimaryTextActive);

  // ==================== Success ====================

  /// 成功色色板第 6 阶主色值（色板第 6 阶）。
  Color get colorSuccess => antParseColor(css.colorSuccess);
  /// 成功色色板第 1 阶（浅背景色）（色板第 1 阶）。
  Color get colorSuccessBg => antParseColor(css.colorSuccessBg);
  /// 成功色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  Color get colorSuccessBgHover => antParseColor(css.colorSuccessBgHover);
  /// 成功色色板第 3 阶（边框色）（色板第 3 阶）。
  Color get colorSuccessBorder => antParseColor(css.colorSuccessBorder);
  /// 成功色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  Color get colorSuccessBorderHover => antParseColor(css.colorSuccessBorderHover);
  /// 成功色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  Color get colorSuccessHover => antParseColor(css.colorSuccessHover);
  /// 成功色色板第 7 阶（active 态色）（色板第 7 阶）。
  Color get colorSuccessActive => antParseColor(css.colorSuccessActive);
  /// 成功色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  Color get colorSuccessTextHover => antParseColor(css.colorSuccessTextHover);
  /// 成功色色板第 9 阶（文字色）（色板第 9 阶）。
  Color get colorSuccessText => antParseColor(css.colorSuccessText);
  /// 成功色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  Color get colorSuccessTextActive => antParseColor(css.colorSuccessTextActive);

  // ==================== Warning ====================

  /// 警告色色板第 6 阶主色值（色板第 6 阶）。
  Color get colorWarning => antParseColor(css.colorWarning);
  /// 警告色色板第 1 阶（浅背景色）（色板第 1 阶）。
  Color get colorWarningBg => antParseColor(css.colorWarningBg);
  /// 警告色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  Color get colorWarningBgHover => antParseColor(css.colorWarningBgHover);
  /// 警告色色板第 3 阶（边框色）（色板第 3 阶）。
  Color get colorWarningBorder => antParseColor(css.colorWarningBorder);
  /// 警告色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  Color get colorWarningBorderHover => antParseColor(css.colorWarningBorderHover);
  /// 警告色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  Color get colorWarningHover => antParseColor(css.colorWarningHover);
  /// 警告色色板第 7 阶（active 态色）（色板第 7 阶）。
  Color get colorWarningActive => antParseColor(css.colorWarningActive);
  /// 警告色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  Color get colorWarningTextHover => antParseColor(css.colorWarningTextHover);
  /// 警告色色板第 9 阶（文字色）（色板第 9 阶）。
  Color get colorWarningText => antParseColor(css.colorWarningText);
  /// 警告色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  Color get colorWarningTextActive => antParseColor(css.colorWarningTextActive);

  // ==================== Error ====================

  /// 错误色色板第 6 阶主色值（色板第 6 阶）。
  Color get colorError => antParseColor(css.colorError);
  /// 错误色色板第 1 阶（浅背景色）（色板第 1 阶）。
  Color get colorErrorBg => antParseColor(css.colorErrorBg);
  /// 错误色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  Color get colorErrorBgHover => antParseColor(css.colorErrorBgHover);
  /// 错误色填充 hover 背景（色板第 2/4 阶 50% 混合）。
  Color get colorErrorBgHoverFilled => antParseColor(css.colorErrorBgHoverFilled);
  Color get colorErrorBgActive => antParseColor(css.colorErrorBgActive);
  /// 错误色色板第 3 阶（边框色）（色板第 3 阶）。
  Color get colorErrorBorder => antParseColor(css.colorErrorBorder);
  /// 错误色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  Color get colorErrorBorderHover => antParseColor(css.colorErrorBorderHover);
  /// 错误色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  Color get colorErrorHover => antParseColor(css.colorErrorHover);
  /// 错误色色板第 7 阶（active 态色）（色板第 7 阶）。
  Color get colorErrorActive => antParseColor(css.colorErrorActive);
  /// 错误色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  Color get colorErrorTextHover => antParseColor(css.colorErrorTextHover);
  /// 错误色色板第 9 阶（文字色）（色板第 9 阶）。
  Color get colorErrorText => antParseColor(css.colorErrorText);
  /// 错误色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  Color get colorErrorTextActive => antParseColor(css.colorErrorTextActive);
  /// 错误色焦点轮廓色（Alias：colorErrorBg 的最小 alpha 等价色）。
  Color get colorErrorOutline => antParseColor(css.colorErrorOutline);
  /// 错误色缀件色（Alias：等于 colorError）。
  Color get colorErrorAffix => antParseColor(css.colorErrorAffix);

  // ==================== Info ====================

  /// 信息色色板第 6 阶主色值（色板第 6 阶）。
  Color get colorInfo => antParseColor(css.colorInfo);
  /// 信息色色板第 1 阶（浅背景色）（色板第 1 阶）。
  Color get colorInfoBg => antParseColor(css.colorInfoBg);
  /// 信息色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  Color get colorInfoBgHover => antParseColor(css.colorInfoBgHover);
  /// 信息色色板第 3 阶（边框色）（色板第 3 阶）。
  Color get colorInfoBorder => antParseColor(css.colorInfoBorder);
  /// 信息色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  Color get colorInfoBorderHover => antParseColor(css.colorInfoBorderHover);
  /// 信息色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  Color get colorInfoHover => antParseColor(css.colorInfoHover);
  /// 信息色色板第 7 阶（active 态色）（色板第 7 阶）。
  Color get colorInfoActive => antParseColor(css.colorInfoActive);
  /// 信息色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  Color get colorInfoTextHover => antParseColor(css.colorInfoTextHover);
  /// 信息色色板第 9 阶（文字色）（色板第 9 阶）。
  Color get colorInfoText => antParseColor(css.colorInfoText);
  /// 信息色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  Color get colorInfoTextActive => antParseColor(css.colorInfoTextActive);

  // ==================== Link ====================

  /// 链接色（种子 colorLink/colorInfo 色板第 6 阶）。
  Color get colorLink => antParseColor(css.colorLink);
  /// 链接 hover 色（链接色板第 4 阶）。
  Color get colorLinkHover => antParseColor(css.colorLinkHover);
  /// 链接 active 色（链接色板第 7 阶）。
  Color get colorLinkActive => antParseColor(css.colorLinkActive);

  // ==================== Control ====================

  /// 控件焦点轮廓色（Alias：colorPrimaryBg 在容器背景上的最小 alpha 等价色）。
  Color get controlOutline => antParseColor(css.controlOutline);
  /// 控件临时轮廓色（Alias：等于 colorFillQuaternary）。
  Color get controlTmpOutline => antParseColor(css.controlTmpOutline);
  /// 控件条目 hover 背景（Alias：等于 colorFillTertiary）。
  Color get controlItemBgHover => antParseColor(css.controlItemBgHover);
  /// 控件条目选中背景（Alias：等于 colorPrimaryBg）。
  Color get controlItemBgActive => antParseColor(css.controlItemBgActive);
  /// 控件条目选中 hover 背景（Alias：等于 colorPrimaryBgHover）。
  Color get controlItemBgActiveHover => antParseColor(css.controlItemBgActiveHover);
  /// 控件条目选中禁用背景（Alias：等于 colorFill）。
  Color get controlItemBgActiveDisabled => antParseColor(css.controlItemBgActiveDisabled);
  /// 警告色焦点轮廓色（Alias：colorWarningBg 的最小 alpha 等价色）。
  Color get colorWarningOutline => antParseColor(css.colorWarningOutline);
  /// 警告色缀件色（Alias：等于 colorWarning）。
  Color get colorWarningAffix => antParseColor(css.colorWarningAffix);

  // ==================== Factory ====================

  /// Generates the light-theme color tokens from a seed.
  ///
  /// 对应 antd `theme.defaultAlgorithm` 的颜色部分：
  /// 色板按 `default` 主题生成，中性色基于 `#fff` 背景、`#000` 文字。
  factory AntColorTokens.light(AntSeedToken seed) {
    return AntColorTokens._generate(seed, isDark: false);
  }

  /// Generates the dark-theme color tokens from a seed.
  ///
  /// 对应 antd `theme.darkAlgorithm` 的颜色部分：色板按 `dark` 主题生成，
  /// 且暗色下 `colorPrimaryBg`/`colorPrimaryBgHover` 取边框色（与 antd 一致）。
  factory AntColorTokens.dark(AntSeedToken seed) {
    return AntColorTokens._generate(seed, isDark: true);
  }

  factory AntColorTokens._generate(AntSeedToken seed, {required bool isDark}) {
    // ---- 基色 ----
    final colorBgBase = seed.colorBgBase.isNotEmpty
        ? seed.colorBgBase
        : (isDark ? '#000' : '#fff');
    final colorTextBase = seed.colorTextBase.isNotEmpty
        ? seed.colorTextBase
        : (isDark ? '#fff' : '#000');
    final colorShadow = seed.colorShadow.isNotEmpty
        ? seed.colorShadow
        : (isDark ? 'rgba(255, 255, 255, 0.2)' : '#000');

    // ---- 色板 ----
    List<String> genPalette(String baseColor) {
      final raw = antGeneratePalette(
        baseColor,
        AntPaletteOptions(theme: isDark ? 'dark' : 'default'),
      );
      return isDark ? _mapDark(raw) : _mapLight(raw);
    }

    final primary = genPalette(seed.colorPrimary);
    final success = genPalette(seed.colorSuccess);
    final warning = genPalette(seed.colorWarning);
    final error = genPalette(seed.colorError);
    final info = genPalette(seed.colorInfo);
    final linkSeed = seed.colorLink.isNotEmpty ? seed.colorLink : seed.colorInfo;
    final link = genPalette(linkSeed);

    // ---- 中性色算法 ----
    String alpha(String base, double a) => _getAlphaColor(base, a);
    String solid(String base, double b) =>
        isDark ? _getSolidColorDark(base, b) : _getSolidColorLight(base, b);

    // ---- 错误色特殊 ----
    final errorBgHoverFilled = AntFastColor.of(error[1])
        .mix(AntFastColor.of(error[3]), 50)
        .toHexString();

    // ---- 构建 CSS 令牌 ----
    final css = AntColorTokensCss(
      // 基色
      colorBgBase: colorBgBase,
      colorTextBase: colorTextBase,
      colorWhite: '#fff',
      colorShadow: colorShadow,
      colorBgMask: AntFastColor.of('#000').setA(0.45).toRgbString(),

      // 文字
      colorText: alpha(colorTextBase, isDark ? 0.85 : 0.88),
      colorTextSecondary: alpha(colorTextBase, 0.65),
      colorTextTertiary: alpha(colorTextBase, 0.45),
      colorTextQuaternary: alpha(colorTextBase, 0.25),

      // 填充
      colorFill: alpha(colorTextBase, isDark ? 0.18 : 0.15),
      colorFillSecondary: alpha(colorTextBase, isDark ? 0.12 : 0.06),
      colorFillTertiary: alpha(colorTextBase, isDark ? 0.08 : 0.04),
      colorFillQuaternary: alpha(colorTextBase, isDark ? 0.04 : 0.02),

      // 实底背景
      colorBgSolid: alpha(colorTextBase, isDark ? 0.95 : 1),
      colorBgSolidHover: alpha(colorTextBase, isDark ? 1 : 0.75),
      colorBgSolidActive: alpha(colorTextBase, isDark ? 0.9 : 0.95),

      // 背景
      colorBgLayout: solid(colorBgBase, isDark ? 0 : 4),
      colorBgContainer: solid(colorBgBase, isDark ? 8 : 0),
      colorBgElevated: solid(colorBgBase, isDark ? 12 : 0),
      colorBgSpotlight: isDark
          ? solid(colorBgBase, 26)
          : alpha(colorTextBase, 0.85),
      colorBgBlur: isDark ? alpha(colorTextBase, 0.04) : 'transparent',

      // 边框
      colorBorder: solid(colorBgBase, isDark ? 26 : 15),
      colorBorderDisabled: solid(colorBgBase, isDark ? 26 : 15),
      colorBorderSecondary: solid(colorBgBase, isDark ? 19 : 6),

      // Primary
      colorPrimaryBg: primary[0],
      colorPrimaryBgHover: primary[1],
      colorPrimaryBorder: primary[2],
      colorPrimaryBorderHover: primary[3],
      colorPrimaryHover: primary[4],
      colorPrimary: primary[5],
      colorPrimaryActive: primary[6],
      colorPrimaryTextHover: primary[7],
      colorPrimaryText: primary[8],
      colorPrimaryTextActive: primary[9],

      // Success
      colorSuccessBg: success[0],
      colorSuccessBgHover: success[1],
      colorSuccessBorder: success[2],
      colorSuccessBorderHover: success[3],
      colorSuccessHover: success[3],
      colorSuccess: success[5],
      colorSuccessActive: success[6],
      colorSuccessTextHover: success[7],
      colorSuccessText: success[8],
      colorSuccessTextActive: success[9],

      // Error
      colorErrorBg: error[0],
      colorErrorBgHover: error[1],
      colorErrorBgHoverFilled: errorBgHoverFilled,
      colorErrorBgActive: error[2],
      colorErrorBorder: error[2],
      colorErrorBorderHover: error[3],
      colorErrorHover: error[4],
      colorError: error[5],
      colorErrorActive: error[6],
      colorErrorTextHover: error[7],
      colorErrorText: error[8],
      colorErrorTextActive: error[9],

      // Warning
      colorWarningBg: warning[0],
      colorWarningBgHover: warning[1],
      colorWarningBorder: warning[2],
      colorWarningBorderHover: warning[3],
      colorWarningHover: warning[3],
      colorWarning: warning[5],
      colorWarningActive: warning[6],
      colorWarningTextHover: warning[7],
      colorWarningText: warning[8],
      colorWarningTextActive: warning[9],

      // Info
      colorInfoBg: info[0],
      colorInfoBgHover: info[1],
      colorInfoBorder: info[2],
      colorInfoBorderHover: info[3],
      colorInfoHover: info[3],
      colorInfo: info[5],
      colorInfoActive: info[6],
      colorInfoTextHover: info[7],
      colorInfoText: info[8],
      colorInfoTextActive: info[9],

      // Link
      colorLinkHover: link[3],
      colorLink: link[5],
      colorLinkActive: link[6],
    );

    // ---- 暗色主题覆盖 ----
    // colorPrimaryBg = colorPrimaryBorder, colorPrimaryBgHover = colorPrimaryBorderHover
    final mergedCss = isDark
        ? css.copyWith(
            colorPrimaryBg: css.colorPrimaryBorder,
            colorPrimaryBgHover: css.colorPrimaryBorderHover,
          )
        : css;

    // ---- 别名令牌 ----
    final aliasCss = _generateAlias(mergedCss);

    return AntColorTokens._(css: aliasCss, isDark: isDark);
  }

  static AntColorTokensCss _generateAlias(AntColorTokensCss map) {
    return map.copyWith(
      // Background
      colorFillContent: map.colorFillSecondary,
      colorFillContentHover: map.colorFill,
      colorFillAlter: map.colorFillQuaternary,
      colorBgContainerDisabled: map.colorFillTertiary,

      // Split
      colorBorderBg: map.colorBgContainer,
      colorSplit: _getAlphaColorOnBg(map.colorBorderSecondary, map.colorBgContainer),

      // Text
      colorTextPlaceholder: map.colorTextQuaternary,
      colorTextDisabled: map.colorTextQuaternary,
      colorTextHeading: map.colorText,
      colorTextLabel: map.colorTextSecondary,
      colorTextDescription: map.colorTextTertiary,
      colorTextLightSolid: map.colorWhite,
      colorHighlight: map.colorError,
      colorBgTextHover: map.colorFillSecondary,
      colorBgTextActive: map.colorFill,

      colorIcon: map.colorTextTertiary,
      colorIconHover: map.colorText,

      colorErrorOutline: _getAlphaColorOnBg(map.colorErrorBg, map.colorBgContainer),
      colorWarningOutline: _getAlphaColorOnBg(map.colorWarningBg, map.colorBgContainer),
      colorErrorAffix: map.colorError,
      colorWarningAffix: map.colorWarning,

      // Control
      controlItemBgHover: map.colorFillTertiary,
      controlItemBgActive: map.colorPrimaryBg,
      controlItemBgActiveHover: map.colorPrimaryBgHover,
      controlItemBgActiveDisabled: map.colorFill,
      controlTmpOutline: map.colorFillQuaternary,
      controlOutline: _getAlphaColorOnBg(map.colorPrimaryBg, map.colorBgContainer),
    );
  }
}
