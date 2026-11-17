/// 色板生成选项配置。
///
/// 用于控制 [antGeneratePalette] 的主题模式与暗色背景色。
///
/// @docImport '../ant_color_palette.dart';
library;

/// 色板生成选项。
///
/// 用于控制 [antGeneratePalette] 的主题模式与暗色背景色。
///
/// ```dart
/// final opts = AntPaletteOptions(theme: 'dark', backgroundColor: '#000000');
/// final palette = antGeneratePalette('#1677FF', opts);
/// ```
class AntPaletteOptions {
  /// 主题模式：`dark` 为暗色主题，其他值（默认 `default`）为亮色主题。
  final String theme;

  /// 暗色主题背景色（hex 字符串）；`null` 时使用 antd 默认值 `#141414`。
  /// 仅在 [theme] 为 `dark` 时生效。
  final String? backgroundColor;

  const AntPaletteOptions({this.theme = 'default', this.backgroundColor});
}
