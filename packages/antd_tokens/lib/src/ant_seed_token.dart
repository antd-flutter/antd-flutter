/// Ant Design 种子令牌。
///
/// 对应 antd `SeedToken`，是主题配置的最小输入集，
/// 所有 Map Token / Alias Token 均由种子令牌推导生成。
library;

/// Ant Design 种子令牌配置。
///
/// 与 antd `components/theme/themes/seed.ts` 的默认值完全一致。
class AntSeedToken {
  // ==================== Color ====================

  /// 主色种子值。
  final String colorPrimary;

  /// 成功色种子值。
  final String colorSuccess;

  /// 警告色种子值。
  final String colorWarning;

  /// 错误色种子值。
  final String colorError;

  /// 信息色种子值。
  final String colorInfo;

  /// 链接色种子值（空字符串表示使用 colorInfo）。
  final String colorLink;

  /// 文字基色（空字符串表示亮色 #000 / 暗色 #fff）。
  final String colorTextBase;

  /// 背景基色（空字符串表示亮色 #fff / 暗色 #000）。
  final String colorBgBase;

  /// 阴影色（亮色 #000 / 暗色 rgba(255,255,255,0.2)）。
  final String colorShadow;

  // ==================== Font ====================

  /// 字体族 CSS 栈。
  final String fontFamily;

  /// 代码字体族。
  final String fontFamilyCode;

  /// 基准字号。
  final double fontSize;

  // ==================== Line ====================

  /// 线宽。
  final double lineWidth;

  /// 线型。
  final String lineType;

  // ==================== Motion ====================

  /// 动效时长单位（秒）。
  final double motionUnit;

  /// 动效时长基数（秒）。
  final double motionBase;

  /// 是否启用动效。
  final bool motion;

  /// 动效缓动 — OutCirc。
  final String motionEaseOutCirc;

  /// 动效缓动 — InOutCirc。
  final String motionEaseInOutCirc;

  /// 动效缓动 — Out。
  final String motionEaseOut;

  /// 动效缓动 — InOut。
  final String motionEaseInOut;

  /// 动效缓动 — OutBack。
  final String motionEaseOutBack;

  /// 动效缓动 — InBack。
  final String motionEaseInBack;

  /// 动效缓动 — InQuint。
  final String motionEaseInQuint;

  /// 动效缓动 — OutQuint。
  final String motionEaseOutQuint;

  // ==================== Radius ====================

  /// 圆角基数。
  final double borderRadius;

  // ==================== Size ====================

  /// 尺寸单位。
  final double sizeUnit;

  /// 尺寸步长。
  final double sizeStep;

  /// 弹出层箭头尺寸。
  final double sizePopupArrow;

  // ==================== Control ====================

  /// 控件基准高度。
  final double controlHeight;

  // ==================== Z-Index ====================

  /// Z-Index 基数。
  final int zIndexBase;

  /// 弹出层 Z-Index 基数。
  final int zIndexPopupBase;

  // ==================== Misc ====================

  /// 图片透明度。
  final double opacityImage;

  /// 是否线框模式。
  final bool wireframe;

  /// 是否显示焦点轮廓。
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

  /// 复制并覆盖部分值。
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

  /// 暗色主题种子。
  ///
  /// 与 antd 一致：colorPrimary 保持不变（'#1677ff'），
  /// 暗色主色 '#1668dc' 由暗色色板算法自动生成。
  /// 仅显式设置中性色（文字/背景/阴影），便于调试和自定义。
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