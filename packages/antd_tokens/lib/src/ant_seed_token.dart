/// Ant Design 种子令牌。
///
/// @docImport 'ant_token_generators.dart';
/// @docImport 'ant_color_tokens.dart';
/// @docImport 'ant_shadow_tokens.dart';
library;

/// Ant Design 种子令牌配置。
///
/// 对应 antd v6 主题体系中的 `SeedToken`（`components/theme/themes/seed.ts`），
/// 是整个令牌派生链的最小输入集：
///
/// ```text
/// AntSeedToken（种子）
///   → antGenFontSizes / antGenRadius / antGenSizeMapToken …（生成器，Map Token 层）
///   → AntColorTokens.light / AntColorTokens.dark（颜色 Map + Alias 层）
///   → AntShadowTokens.generate（Alias 层阴影）
/// ```
///
/// 修改任意种子值（如 [colorPrimary]）都会逐层传播到生成的
/// 色板、字号阶梯、圆角阶梯与阴影，从而得到一套完整的自定义主题。
///
/// 示例：以品牌色派生完整主题种子：
///
/// ```dart
/// const seed = AntSeedToken(colorPrimary: '#6a3ce8');
/// final lightColors = AntColorTokens.light(seed);
/// final shadows = AntShadowTokens.generate(seed.colorShadow.isEmpty ? '#000' : seed.colorShadow);
/// ```
///
/// 与 antd 的对应关系：
/// - 类本身对应 `SeedTokenInterface`；
/// - [AntSeedToken.dark] 对应 antd `theme.darkAlgorithm` 使用的暗色种子预设。
/// 字段默认值与 antd v6 默认种子完全一致。
class AntSeedToken {
  // ==================== Color ====================

  /// 品牌主色种子值，对应 antd `colorPrimary`。
  ///
  /// 由色板算法派生出 `colorPrimaryBg` … `colorPrimaryTextActive` 共 10 阶；
  /// 暗色主题下 antd 会自动映射为更亮的色板（如 `#1677ff` → `#1668dc`）。
  final String colorPrimary;

  /// 成功色种子值，对应 antd `colorSuccess`，派生 10 阶成功色板。
  final String colorSuccess;

  /// 警告色种子值，对应 antd `colorWarning`，派生 10 阶警告色板。
  final String colorWarning;

  /// 错误色种子值，对应 antd `colorError`，派生 10 阶错误色板。
  final String colorError;

  /// 信息色种子值，对应 antd `colorInfo`，派生 10 阶信息色板。
  final String colorInfo;

  /// 链接色种子值，对应 antd `colorLink`。
  ///
  /// 空字符串表示回退使用 [colorInfo]，与 antd 行为一致。
  final String colorLink;

  /// 文字基色，对应 antd `colorTextBase`，所有文字/填充色由其按 alpha 派生。
  ///
  /// 空字符串表示亮色主题取 `#000`、暗色主题取 `#fff`。
  final String colorTextBase;

  /// 背景基色，对应 antd `colorBgBase`，容器/布局/边框色由其按亮度派生。
  ///
  /// 空字符串表示亮色主题取 `#fff`、暗色主题取 `#000`。
  final String colorBgBase;

  /// 阴影基色，对应 antd `colorShadow`，供 [AntShadowTokens.generate] 使用。
  ///
  /// 空字符串表示亮色主题取 `#000`、暗色主题取 `rgba(255, 255, 255, 0.2)`。
  final String colorShadow;

  // ==================== Font ====================

  /// 正文字体族 CSS 栈，对应 antd `fontFamily`。
  final String fontFamily;

  /// 代码字体族 CSS 栈，对应 antd `fontFamilyCode`。
  final String fontFamilyCode;

  /// 基准字号（逻辑像素），对应 antd `fontSize`，默认 14。
  ///
  /// 作为 [antGenFontSizes] 的输入派生整个字号阶梯。
  final double fontSize;

  // ==================== Line ====================

  /// 线宽（逻辑像素），对应 antd `lineWidth`，默认 1。
  final double lineWidth;

  /// 线型 CSS 值，对应 antd `lineType`，默认 `solid`。
  final String lineType;

  // ==================== Motion ====================

  /// 动效时长单位（秒），对应 antd `motionUnit`，默认 0.1。
  ///
  /// 由 [antGenMotionDuration] 派生 fast/mid/slow 三档时长。
  final double motionUnit;

  /// 动效时长基数（秒），对应 antd `motionBase`，默认 0。
  final double motionBase;

  /// Whether to enable motion durations；对应 antd `motion`。
  ///
  /// 为 `false` 时所有动效时长归零。
  final bool motion;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseOutCirc`。
  final String motionEaseOutCirc;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseInOutCirc`。
  final String motionEaseInOutCirc;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseOut`。
  final String motionEaseOut;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseInOut`。
  final String motionEaseInOut;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseOutBack`。
  final String motionEaseOutBack;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseInBack`。
  final String motionEaseInBack;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseInQuint`。
  final String motionEaseInQuint;

  /// 动效缓动曲线（CSS cubic-bezier），对应 antd `motionEaseOutQuint`。
  final String motionEaseOutQuint;

  // ==================== Radius ====================

  /// 圆角基数（逻辑像素），对应 antd `borderRadius`，默认 6。
  ///
  /// 由 [antGenRadius] 派生 XS/SM/LG/Outer 圆角阶梯。
  final double borderRadius;

  // ==================== Size ====================

  /// 尺寸单位（逻辑像素），对应 antd `sizeUnit`，默认 4。
  final double sizeUnit;

  /// 尺寸步长（逻辑像素），对应 antd `sizeStep`，默认 4。
  ///
  /// 由 [antGenSizeMapToken] 派生 XXS…XXL 尺寸阶梯。
  final double sizeStep;

  /// 弹出层箭头尺寸（逻辑像素），对应 antd `sizePopupArrow`，默认 16。
  final double sizePopupArrow;

  // ==================== Control ====================

  /// 控件基准高度（逻辑像素），对应 antd `controlHeight`，默认 32。
  ///
  /// 由 [antGenControlHeight] 派生 XS/SM/LG 三档高度。
  final double controlHeight;

  // ==================== Z-Index ====================

  /// Z-Index 基数，对应 antd `zIndexBase`，默认 0。
  final int zIndexBase;

  /// 弹出层 Z-Index 基数，对应 antd `zIndexPopupBase`，默认 1000。
  final int zIndexPopupBase;

  // ==================== Misc ====================

  /// 图片透明度，对应 antd `opacityImage`，默认 1。
  final double opacityImage;

  /// Whether to use wireframe style；对应 antd `wireframe`，默认 `false`。
  final bool wireframe;

  /// Whether to show focus outline；对应 antd `focus`，默认 `true`。
  final bool focusOutline;

  const AntSeedToken({
    this.colorPrimary = '#1677ff',
    this.colorSuccess = '#52c41a',
    this.colorWarning = '#faad14',
    this.colorError = '#ff4d4f',
    this.colorInfo = '#1677ff',
    this.colorLink = '',
    this.colorTextBase = '',
    this.colorBgBase = '',
    this.colorShadow = '',
    this.fontFamily =
        "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'",
    this.fontFamilyCode =
        "'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace",
    this.fontSize = 14,
    this.lineWidth = 1,
    this.lineType = 'solid',
    this.motionUnit = 0.1,
    this.motionBase = 0,
    this.motion = true,
    this.motionEaseOutCirc = 'cubic-bezier(0.08, 0.82, 0.17, 1)',
    this.motionEaseInOutCirc = 'cubic-bezier(0.78, 0.14, 0.15, 0.86)',
    this.motionEaseOut = 'cubic-bezier(0.215, 0.61, 0.355, 1)',
    this.motionEaseInOut = 'cubic-bezier(0.645, 0.045, 0.355, 1)',
    this.motionEaseOutBack = 'cubic-bezier(0.12, 0.4, 0.29, 1.46)',
    this.motionEaseInBack = 'cubic-bezier(0.71, -0.46, 0.88, 0.6)',
    this.motionEaseInQuint = 'cubic-bezier(0.755, 0.05, 0.855, 0.06)',
    this.motionEaseOutQuint = 'cubic-bezier(0.23, 1, 0.32, 1)',
    this.borderRadius = 6,
    this.sizeUnit = 4,
    this.sizeStep = 4,
    this.sizePopupArrow = 16,
    this.controlHeight = 32,
    this.zIndexBase = 0,
    this.zIndexPopupBase = 1000,
    this.opacityImage = 1,
    this.wireframe = false,
    this.focusOutline = true,
  });

  /// Copies this seed with the given fields overridden.
  ///
  /// 未传入的字段保持原值。常用于在默认种子上做少量定制：
  ///
  /// ```dart
  /// final seed = const AntSeedToken().copyWith(colorPrimary: '#6a3ce8');
  /// ```
  AntSeedToken copyWith({
    String? colorPrimary,
    String? colorSuccess,
    String? colorWarning,
    String? colorError,
    String? colorInfo,
    String? colorLink,
    String? colorTextBase,
    String? colorBgBase,
    String? colorShadow,
    String? fontFamily,
    String? fontFamilyCode,
    double? fontSize,
    double? lineWidth,
    String? lineType,
    double? motionUnit,
    double? motionBase,
    bool? motion,
    String? motionEaseOutCirc,
    String? motionEaseInOutCirc,
    String? motionEaseOut,
    String? motionEaseInOut,
    String? motionEaseOutBack,
    String? motionEaseInBack,
    String? motionEaseInQuint,
    String? motionEaseOutQuint,
    double? borderRadius,
    double? sizeUnit,
    double? sizeStep,
    double? sizePopupArrow,
    double? controlHeight,
    int? zIndexBase,
    int? zIndexPopupBase,
    double? opacityImage,
    bool? wireframe,
    bool? focusOutline,
  }) {
    return AntSeedToken(
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorSuccess: colorSuccess ?? this.colorSuccess,
      colorWarning: colorWarning ?? this.colorWarning,
      colorError: colorError ?? this.colorError,
      colorInfo: colorInfo ?? this.colorInfo,
      colorLink: colorLink ?? this.colorLink,
      colorTextBase: colorTextBase ?? this.colorTextBase,
      colorBgBase: colorBgBase ?? this.colorBgBase,
      colorShadow: colorShadow ?? this.colorShadow,
      fontFamily: fontFamily ?? this.fontFamily,
      fontFamilyCode: fontFamilyCode ?? this.fontFamilyCode,
      fontSize: fontSize ?? this.fontSize,
      lineWidth: lineWidth ?? this.lineWidth,
      lineType: lineType ?? this.lineType,
      motionUnit: motionUnit ?? this.motionUnit,
      motionBase: motionBase ?? this.motionBase,
      motion: motion ?? this.motion,
      motionEaseOutCirc: motionEaseOutCirc ?? this.motionEaseOutCirc,
      motionEaseInOutCirc: motionEaseInOutCirc ?? this.motionEaseInOutCirc,
      motionEaseOut: motionEaseOut ?? this.motionEaseOut,
      motionEaseInOut: motionEaseInOut ?? this.motionEaseInOut,
      motionEaseOutBack: motionEaseOutBack ?? this.motionEaseOutBack,
      motionEaseInBack: motionEaseInBack ?? this.motionEaseInBack,
      motionEaseInQuint: motionEaseInQuint ?? this.motionEaseInQuint,
      motionEaseOutQuint: motionEaseOutQuint ?? this.motionEaseOutQuint,
      borderRadius: borderRadius ?? this.borderRadius,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      sizeStep: sizeStep ?? this.sizeStep,
      sizePopupArrow: sizePopupArrow ?? this.sizePopupArrow,
      controlHeight: controlHeight ?? this.controlHeight,
      zIndexBase: zIndexBase ?? this.zIndexBase,
      zIndexPopupBase: zIndexPopupBase ?? this.zIndexPopupBase,
      opacityImage: opacityImage ?? this.opacityImage,
      wireframe: wireframe ?? this.wireframe,
      focusOutline: focusOutline ?? this.focusOutline,
    );
  }

  /// Creates a dark-theme seed，对应 antd `theme.darkAlgorithm` 的暗色种子预设。
  ///
  /// 与 antd 一致：[colorPrimary] 保持不变（`#1677ff`），
  /// 暗色主色 `#1668dc` 由暗色色板算法自动生成；
  /// 仅显式设置中性色（文字/背景/阴影），便于调试和自定义。
  ///
  /// ```dart
  /// final colors = AntColorTokens.dark(AntSeedToken.dark());
  /// ```
  factory AntSeedToken.dark({
    String colorTextBase = '#fff',
    String colorBgBase = '#000',
    String colorShadow = 'rgba(255, 255, 255, 0.2)',
  }) {
    return const AntSeedToken().copyWith(
      colorTextBase: colorTextBase,
      colorBgBase: colorBgBase,
      colorShadow: colorShadow,
    );
  }
}