/// AntColorPicker 类型定义
library;

/// 颜色格式
enum AntColorFormat {
  /// 十六进制
  hex,

  /// RGB
  rgb,

  /// HSL
  hsl,

  /// HSB
  hsb,
}

/// 预设颜色组
class AntColorPreset {
  const AntColorPreset({
    required this.label,
    required this.colors,
  });

  /// 分组标题
  final String label;

  /// 颜色列表（hex 格式，如 '#1677ff'）
  final List<String> colors;
}

/// 颜色选择器尺寸
enum AntColorPickerSize {
  /// 小
  small,

  /// 中
  middle,

  /// 大
  large,
}