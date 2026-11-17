/// Ant Design 颜色令牌 — CSS 字符串层。
///
/// 保存 AntColorTokens 全部颜色字段的原始 CSS 表达（hex / rgba），
/// 与 antd Web 端输出逐字段对拍；Flutter Color 访问由
/// `tokens/` 层（ant_color_tokens.dart）的 AntColorTokens 提供。
///
/// @docImport '../ant_color_tokens.dart';
library;

import '../ant_seed_token.dart';

// ============================================================
// AntColorTokensCss — CSS 字符串形式的颜色令牌
// ============================================================

/// CSS 字符串形式的颜色令牌（原始值，调试与导出用）。
///
/// 保存 [AntColorTokens] 全部字段的 CSS 表达（hex / rgba），
/// 便于与 antd Web 端输出对拍和序列化；运行时请优先使用
/// [AntColorTokens] 的 [Color] getter。
class AntColorTokensCss {
  // 基色
  /// 背景基色（亮 `#fff` / 暗 `#000`，派生自种子）。
  final String colorBgBase;
  /// 文字基色（亮 `#000` / 暗 `#fff`，派生自种子）。
  final String colorTextBase;
  /// 纯白色常量 `#fff`。
  final String colorWhite;
  /// 阴影基色（派生自种子 [AntSeedToken.colorShadow]）。
  final String colorShadow;
  /// 遮罩背景色（黑色 45% 透明度）。
  final String colorBgMask;

  // 文字
  /// 默认文字色（文字基色 88%/暗色 85% alpha）。
  final String colorText;
  /// 次要文字色（基色 65% alpha）。
  final String colorTextSecondary;
  /// 三级文字色（基色 45% alpha）。
  final String colorTextTertiary;
  /// 四级文字色（基色 25% alpha）。
  final String colorTextQuaternary;
  /// 标题文字色（Alias：等于 colorText）。
  final String colorTextHeading;
  /// 表单标签文字色（Alias：等于 colorTextSecondary）。
  final String colorTextLabel;
  /// 描述文字色（Alias：等于 colorTextTertiary）。
  final String colorTextDescription;
  /// 深色底上的白色文字色（Alias：等于 colorWhite）。
  final String colorTextLightSolid;
  /// 占位符文字色（Alias：等于 colorTextQuaternary）。
  final String colorTextPlaceholder;
  /// 禁用态文字色（Alias：等于 colorTextQuaternary）。
  final String colorTextDisabled;
  /// 高亮色（Alias：等于 colorError）。
  final String colorHighlight;
  /// 图标默认色（Alias：等于 colorTextTertiary）。
  final String colorIcon;
  /// 图标 hover 色（Alias：等于 colorText）。
  final String colorIconHover;

  // 填充
  /// 默认填充色（文字基色 15%/暗色 18% alpha）。
  final String colorFill;
  /// 次级填充色（基色 6%/暗色 12% alpha）。
  final String colorFillSecondary;
  /// 三级填充色（基色 4%/暗色 8% alpha）。
  final String colorFillTertiary;
  /// 四级填充色（基色 2%/暗色 4% alpha）。
  final String colorFillQuaternary;
  /// 内容填充色（Alias：等于 colorFillSecondary）。
  final String colorFillContent;
  /// 内容填充 hover 色（Alias：等于 colorFill）。
  final String colorFillContentHover;
  /// 斑马纹/间隔填充色（Alias：等于 colorFillQuaternary）。
  final String colorFillAlter;

  // 背景
  /// 容器背景色（亮色等于基色，暗色 lighten 8%）。
  final String colorBgContainer;
  /// 浮层背景色（暗色 lighten 12%，亮色等于基色）。
  final String colorBgElevated;
  /// 布局背景色（亮色 darken 4%，暗色等于基色）。
  final String colorBgLayout;
  /// 聚光背景色（亮色为文字基色 85% alpha，暗色 lighten 26%）。
  final String colorBgSpotlight;
  /// 毛玻璃背景色（暗色为基色 4% alpha，亮色透明）。
  final String colorBgBlur;
  /// 禁用容器背景色（Alias：等于 colorFillTertiary）。
  final String colorBgContainerDisabled;
  /// 实底背景色（基色 100%/暗色 95% alpha）。
  final String colorBgSolid;
  /// 实底背景 hover 色（基色 75%/暗色 100% alpha）。
  final String colorBgSolidHover;
  /// 实底背景 active 色（基色 95%/暗色 90% alpha）。
  final String colorBgSolidActive;
  /// 文字背景 hover 色（Alias：等于 colorFillSecondary）。
  final String colorBgTextHover;
  /// 文字背景 active 色（Alias：等于 colorFill）。
  final String colorBgTextActive;

  // 边框
  /// 默认边框色（背景基色 darken 15%/暗色 lighten 26%）。
  final String colorBorder;
  /// 次级边框色（背景基色 darken 6%/暗色 lighten 19%）。
  final String colorBorderSecondary;
  /// 禁用态边框色（与 colorBorder 同值）。
  final String colorBorderDisabled;
  /// 边框与背景交界色（Alias：等于 colorBgContainer）。
  final String colorBorderBg;
  /// 分割线色（Alias：colorBorderSecondary 在容器背景上的最小 alpha 等价色）。
  final String colorSplit;

  // Primary
  /// 主色色板第 6 阶主色值（色板第 6 阶）。
  final String colorPrimary;
  /// 主色色板第 1 阶（浅背景色）（色板第 1 阶）。
  final String colorPrimaryBg;
  /// 主色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  final String colorPrimaryBgHover;
  /// 主色色板第 3 阶（边框色）（色板第 3 阶）。
  final String colorPrimaryBorder;
  /// 主色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  final String colorPrimaryBorderHover;
  /// 主色hover 态色值（色板中间阶）。
  final String colorPrimaryHover;
  /// 主色色板第 7 阶（active 态色）（色板第 7 阶）。
  final String colorPrimaryActive;
  /// 主色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  final String colorPrimaryTextHover;
  /// 主色色板第 9 阶（文字色）（色板第 9 阶）。
  final String colorPrimaryText;
  /// 主色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  final String colorPrimaryTextActive;

  // Success
  /// 成功色色板第 6 阶主色值（色板第 6 阶）。
  final String colorSuccess;
  /// 成功色色板第 1 阶（浅背景色）（色板第 1 阶）。
  final String colorSuccessBg;
  /// 成功色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  final String colorSuccessBgHover;
  /// 成功色色板第 3 阶（边框色）（色板第 3 阶）。
  final String colorSuccessBorder;
  /// 成功色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  final String colorSuccessBorderHover;
  /// 成功色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  final String colorSuccessHover;
  /// 成功色色板第 7 阶（active 态色）（色板第 7 阶）。
  final String colorSuccessActive;
  /// 成功色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  final String colorSuccessTextHover;
  /// 成功色色板第 9 阶（文字色）（色板第 9 阶）。
  final String colorSuccessText;
  /// 成功色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  final String colorSuccessTextActive;

  // Error
  /// 错误色色板第 6 阶主色值（色板第 6 阶）。
  final String colorError;
  /// 错误色色板第 1 阶（浅背景色）（色板第 1 阶）。
  final String colorErrorBg;
  /// 错误色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  final String colorErrorBgHover;
  /// 错误色填充 hover 背景（色板第 2/4 阶 50% 混合）。
  final String colorErrorBgHoverFilled;
  final String colorErrorBgActive;
  /// 错误色色板第 3 阶（边框色）（色板第 3 阶）。
  final String colorErrorBorder;
  /// 错误色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  final String colorErrorBorderHover;
  /// 错误色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  final String colorErrorHover;
  /// 错误色色板第 7 阶（active 态色）（色板第 7 阶）。
  final String colorErrorActive;
  /// 错误色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  final String colorErrorTextHover;
  /// 错误色色板第 9 阶（文字色）（色板第 9 阶）。
  final String colorErrorText;
  /// 错误色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  final String colorErrorTextActive;
  /// 错误色焦点轮廓色（Alias：colorErrorBg 的最小 alpha 等价色）。
  final String colorErrorOutline;
  /// 错误色缀件色（Alias：等于 colorError）。
  final String colorErrorAffix;

  // Warning
  /// 警告色色板第 6 阶主色值（色板第 6 阶）。
  final String colorWarning;
  /// 警告色色板第 1 阶（浅背景色）（色板第 1 阶）。
  final String colorWarningBg;
  /// 警告色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  final String colorWarningBgHover;
  /// 警告色色板第 3 阶（边框色）（色板第 3 阶）。
  final String colorWarningBorder;
  /// 警告色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  final String colorWarningBorderHover;
  /// 警告色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  final String colorWarningHover;
  /// 警告色色板第 7 阶（active 态色）（色板第 7 阶）。
  final String colorWarningActive;
  /// 警告色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  final String colorWarningTextHover;
  /// 警告色色板第 9 阶（文字色）（色板第 9 阶）。
  final String colorWarningText;
  /// 警告色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  final String colorWarningTextActive;
  /// 警告色焦点轮廓色（Alias：colorWarningBg 的最小 alpha 等价色）。
  final String colorWarningOutline;
  /// 警告色缀件色（Alias：等于 colorWarning）。
  final String colorWarningAffix;

  // Info
  /// 信息色色板第 6 阶主色值（色板第 6 阶）。
  final String colorInfo;
  /// 信息色色板第 1 阶（浅背景色）（色板第 1 阶）。
  final String colorInfoBg;
  /// 信息色色板第 2 阶（背景 hover 色）（色板第 2 阶）。
  final String colorInfoBgHover;
  /// 信息色色板第 3 阶（边框色）（色板第 3 阶）。
  final String colorInfoBorder;
  /// 信息色色板第 4 阶（边框 hover 色）（色板第 4 阶）。
  final String colorInfoBorderHover;
  /// 信息色 hover 态色值（色板第 4 阶，与 BorderHover 同阶）。
  final String colorInfoHover;
  /// 信息色色板第 7 阶（active 态色）（色板第 7 阶）。
  final String colorInfoActive;
  /// 信息色色板第 8 阶（hover 态文字色）（色板第 8 阶）。
  final String colorInfoTextHover;
  /// 信息色色板第 9 阶（文字色）（色板第 9 阶）。
  final String colorInfoText;
  /// 信息色色板第 10 阶（active 态文字色）（色板第 10 阶）。
  final String colorInfoTextActive;

  // Link
  /// 链接色（种子 colorLink/colorInfo 色板第 6 阶）。
  final String colorLink;
  /// 链接 hover 色（链接色板第 4 阶）。
  final String colorLinkHover;
  /// 链接 active 色（链接色板第 7 阶）。
  final String colorLinkActive;

  // Control
  /// 控件焦点轮廓色（Alias：colorPrimaryBg 在容器背景上的最小 alpha 等价色）。
  final String controlOutline;
  /// 控件临时轮廓色（Alias：等于 colorFillQuaternary）。
  final String controlTmpOutline;
  /// 控件条目 hover 背景（Alias：等于 colorFillTertiary）。
  final String controlItemBgHover;
  /// 控件条目选中背景（Alias：等于 colorPrimaryBg）。
  final String controlItemBgActive;
  /// 控件条目选中 hover 背景（Alias：等于 colorPrimaryBgHover）。
  final String controlItemBgActiveHover;
  /// 控件条目选中禁用背景（Alias：等于 colorFill）。
  final String controlItemBgActiveDisabled;

  const AntColorTokensCss({
    required this.colorBgBase,
    required this.colorTextBase,
    required this.colorWhite,
    required this.colorShadow,
    required this.colorBgMask,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextTertiary,
    required this.colorTextQuaternary,
    this.colorTextHeading = '',
    this.colorTextLabel = '',
    this.colorTextDescription = '',
    this.colorTextLightSolid = '',
    this.colorTextPlaceholder = '',
    this.colorTextDisabled = '',
    this.colorHighlight = '',
    this.colorIcon = '',
    this.colorIconHover = '',
    required this.colorFill,
    required this.colorFillSecondary,
    required this.colorFillTertiary,
    required this.colorFillQuaternary,
    this.colorFillContent = '',
    this.colorFillContentHover = '',
    this.colorFillAlter = '',
    required this.colorBgContainer,
    required this.colorBgElevated,
    required this.colorBgLayout,
    required this.colorBgSpotlight,
    required this.colorBgBlur,
    this.colorBgContainerDisabled = '',
    required this.colorBgSolid,
    required this.colorBgSolidHover,
    required this.colorBgSolidActive,
    this.colorBgTextHover = '',
    this.colorBgTextActive = '',
    required this.colorBorder,
    required this.colorBorderSecondary,
    required this.colorBorderDisabled,
    this.colorBorderBg = '',
    this.colorSplit = '',
    required this.colorPrimary,
    required this.colorPrimaryBg,
    required this.colorPrimaryBgHover,
    required this.colorPrimaryBorder,
    required this.colorPrimaryBorderHover,
    required this.colorPrimaryHover,
    required this.colorPrimaryActive,
    required this.colorPrimaryTextHover,
    required this.colorPrimaryText,
    required this.colorPrimaryTextActive,
    required this.colorSuccess,
    required this.colorSuccessBg,
    required this.colorSuccessBgHover,
    required this.colorSuccessBorder,
    required this.colorSuccessBorderHover,
    required this.colorSuccessHover,
    required this.colorSuccessActive,
    required this.colorSuccessTextHover,
    required this.colorSuccessText,
    required this.colorSuccessTextActive,
    required this.colorError,
    required this.colorErrorBg,
    required this.colorErrorBgHover,
    required this.colorErrorBgHoverFilled,
    required this.colorErrorBgActive,
    required this.colorErrorBorder,
    required this.colorErrorBorderHover,
    required this.colorErrorHover,
    required this.colorErrorActive,
    required this.colorErrorTextHover,
    required this.colorErrorText,
    required this.colorErrorTextActive,
    this.colorErrorOutline = '',
    this.colorErrorAffix = '',
    required this.colorWarning,
    required this.colorWarningBg,
    required this.colorWarningBgHover,
    required this.colorWarningBorder,
    required this.colorWarningBorderHover,
    required this.colorWarningHover,
    required this.colorWarningActive,
    required this.colorWarningTextHover,
    required this.colorWarningText,
    required this.colorWarningTextActive,
    this.colorWarningOutline = '',
    this.colorWarningAffix = '',
    required this.colorInfo,
    required this.colorInfoBg,
    required this.colorInfoBgHover,
    required this.colorInfoBorder,
    required this.colorInfoBorderHover,
    required this.colorInfoHover,
    required this.colorInfoActive,
    required this.colorInfoTextHover,
    required this.colorInfoText,
    required this.colorInfoTextActive,
    required this.colorLink,
    required this.colorLinkHover,
    required this.colorLinkActive,
    this.controlOutline = '',
    this.controlTmpOutline = '',
    this.controlItemBgHover = '',
    this.controlItemBgActive = '',
    this.controlItemBgActiveHover = '',
    this.controlItemBgActiveDisabled = '',
  });

  AntColorTokensCss copyWith({
    String? colorPrimaryBg,
    String? colorPrimaryBgHover,
    String? colorFillContent,
    String? colorFillContentHover,
    String? colorFillAlter,
    String? colorBgContainerDisabled,
    String? colorBorderBg,
    String? colorSplit,
    String? colorTextPlaceholder,
    String? colorTextDisabled,
    String? colorTextHeading,
    String? colorTextLabel,
    String? colorTextDescription,
    String? colorTextLightSolid,
    String? colorHighlight,
    String? colorBgTextHover,
    String? colorBgTextActive,
    String? colorIcon,
    String? colorIconHover,
    String? colorErrorOutline,
    String? colorWarningOutline,
    String? colorErrorAffix,
    String? colorWarningAffix,
    String? controlItemBgHover,
    String? controlItemBgActive,
    String? controlItemBgActiveHover,
    String? controlItemBgActiveDisabled,
    String? controlTmpOutline,
    String? controlOutline,
  }) {
    return AntColorTokensCss(
      colorBgBase: colorBgBase,
      colorTextBase: colorTextBase,
      colorWhite: colorWhite,
      colorShadow: colorShadow,
      colorBgMask: colorBgMask,
      colorText: colorText,
      colorTextSecondary: colorTextSecondary,
      colorTextTertiary: colorTextTertiary,
      colorTextQuaternary: colorTextQuaternary,
      colorTextHeading: colorTextHeading ?? this.colorTextHeading,
      colorTextLabel: colorTextLabel ?? this.colorTextLabel,
      colorTextDescription: colorTextDescription ?? this.colorTextDescription,
      colorTextLightSolid: colorTextLightSolid ?? this.colorTextLightSolid,
      colorTextPlaceholder: colorTextPlaceholder ?? this.colorTextPlaceholder,
      colorTextDisabled: colorTextDisabled ?? this.colorTextDisabled,
      colorHighlight: colorHighlight ?? this.colorHighlight,
      colorIcon: colorIcon ?? this.colorIcon,
      colorIconHover: colorIconHover ?? this.colorIconHover,
      colorFill: colorFill,
      colorFillSecondary: colorFillSecondary,
      colorFillTertiary: colorFillTertiary,
      colorFillQuaternary: colorFillQuaternary,
      colorFillContent: colorFillContent ?? this.colorFillContent,
      colorFillContentHover: colorFillContentHover ?? this.colorFillContentHover,
      colorFillAlter: colorFillAlter ?? this.colorFillAlter,
      colorBgContainer: colorBgContainer,
      colorBgElevated: colorBgElevated,
      colorBgLayout: colorBgLayout,
      colorBgSpotlight: colorBgSpotlight,
      colorBgBlur: colorBgBlur,
      colorBgContainerDisabled: colorBgContainerDisabled ?? this.colorBgContainerDisabled,
      colorBgSolid: colorBgSolid,
      colorBgSolidHover: colorBgSolidHover,
      colorBgSolidActive: colorBgSolidActive,
      colorBgTextHover: colorBgTextHover ?? this.colorBgTextHover,
      colorBgTextActive: colorBgTextActive ?? this.colorBgTextActive,
      colorBorder: colorBorder,
      colorBorderSecondary: colorBorderSecondary,
      colorBorderDisabled: colorBorderDisabled,
      colorBorderBg: colorBorderBg ?? this.colorBorderBg,
      colorSplit: colorSplit ?? this.colorSplit,
      colorPrimary: colorPrimary,
      colorPrimaryBg: colorPrimaryBg ?? this.colorPrimaryBg,
      colorPrimaryBgHover: colorPrimaryBgHover ?? this.colorPrimaryBgHover,
      colorPrimaryBorder: colorPrimaryBorder,
      colorPrimaryBorderHover: colorPrimaryBorderHover,
      colorPrimaryHover: colorPrimaryHover,
      colorPrimaryActive: colorPrimaryActive,
      colorPrimaryTextHover: colorPrimaryTextHover,
      colorPrimaryText: colorPrimaryText,
      colorPrimaryTextActive: colorPrimaryTextActive,
      colorSuccess: colorSuccess,
      colorSuccessBg: colorSuccessBg,
      colorSuccessBgHover: colorSuccessBgHover,
      colorSuccessBorder: colorSuccessBorder,
      colorSuccessBorderHover: colorSuccessBorderHover,
      colorSuccessHover: colorSuccessHover,
      colorSuccessActive: colorSuccessActive,
      colorSuccessTextHover: colorSuccessTextHover,
      colorSuccessText: colorSuccessText,
      colorSuccessTextActive: colorSuccessTextActive,
      colorError: colorError,
      colorErrorBg: colorErrorBg,
      colorErrorBgHover: colorErrorBgHover,
      colorErrorBgHoverFilled: colorErrorBgHoverFilled,
      colorErrorBgActive: colorErrorBgActive,
      colorErrorBorder: colorErrorBorder,
      colorErrorBorderHover: colorErrorBorderHover,
      colorErrorHover: colorErrorHover,
      colorErrorActive: colorErrorActive,
      colorErrorTextHover: colorErrorTextHover,
      colorErrorText: colorErrorText,
      colorErrorTextActive: colorErrorTextActive,
      colorErrorOutline: colorErrorOutline ?? this.colorErrorOutline,
      colorErrorAffix: colorErrorAffix ?? this.colorErrorAffix,
      colorWarning: colorWarning,
      colorWarningBg: colorWarningBg,
      colorWarningBgHover: colorWarningBgHover,
      colorWarningBorder: colorWarningBorder,
      colorWarningBorderHover: colorWarningBorderHover,
      colorWarningHover: colorWarningHover,
      colorWarningActive: colorWarningActive,
      colorWarningTextHover: colorWarningTextHover,
      colorWarningText: colorWarningText,
      colorWarningTextActive: colorWarningTextActive,
      colorWarningOutline: colorWarningOutline ?? this.colorWarningOutline,
      colorWarningAffix: colorWarningAffix ?? this.colorWarningAffix,
      colorInfo: colorInfo,
      colorInfoBg: colorInfoBg,
      colorInfoBgHover: colorInfoBgHover,
      colorInfoBorder: colorInfoBorder,
      colorInfoBorderHover: colorInfoBorderHover,
      colorInfoHover: colorInfoHover,
      colorInfoActive: colorInfoActive,
      colorInfoTextHover: colorInfoTextHover,
      colorInfoText: colorInfoText,
      colorInfoTextActive: colorInfoTextActive,
      colorLink: colorLink,
      colorLinkHover: colorLinkHover,
      colorLinkActive: colorLinkActive,
      controlOutline: controlOutline ?? this.controlOutline,
      controlTmpOutline: controlTmpOutline ?? this.controlTmpOutline,
      controlItemBgHover: controlItemBgHover ?? this.controlItemBgHover,
      controlItemBgActive: controlItemBgActive ?? this.controlItemBgActive,
      controlItemBgActiveHover: controlItemBgActiveHover ?? this.controlItemBgActiveHover,
      controlItemBgActiveDisabled: controlItemBgActiveDisabled ?? this.controlItemBgActiveDisabled,
    );
  }
}