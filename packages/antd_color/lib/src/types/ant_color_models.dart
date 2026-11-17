/// Ant Design 颜色模型纯数据类型。
///
/// 提供 HSV / HSL / RGB 三种颜色模型的不可变值对象，
/// 供 [AntFastColor]（`package:antd_color` 主体实现）解析与互转。
///
/// @docImport '../ant_fast_color.dart';
library;

/// HSV 颜色模型值。
///
/// ```dart
/// final hsv = AntHsv(h: 210, s: 0.9, v: 1.0);
/// final color = AntFastColor.of(hsv);
/// ```
class AntHsv {
  /// 色相（0-360）。
  final double h;

  /// HSV 饱和度（0-1）。
  final double s;

  /// 明度（0-1）。
  final double v;

  /// 透明度（0-1），默认 1。
  final double a;
  const AntHsv({required this.h, required this.s, required this.v, this.a = 1});
}

/// HSL 颜色模型值。
///
/// ```dart
/// final hsl = AntHsl(h: 210, s: 0.9, l: 0.5);
/// final color = AntFastColor.of(hsl);
/// ```
class AntHsl {
  /// 色相（0-360）。
  final double h;

  /// HSL 饱和度（0-1）。
  final double s;

  /// 亮度（0-1）。
  final double l;

  /// 透明度（0-1），默认 1。
  final double a;
  const AntHsl({required this.h, required this.s, required this.l, this.a = 1});
}

/// RGB 颜色模型值。
///
/// ```dart
/// final rgb = AntRgb(r: 22, g: 119, b: 255);
/// final color = AntFastColor.of(rgb);
/// ```
class AntRgb {
  /// 红色通道（0-255）。
  final int r;

  /// 绿色通道（0-255）。
  final int g;

  /// 蓝色通道（0-255）。
  final int b;

  /// 透明度（0-1），默认 1。
  final double a;
  const AntRgb({required this.r, required this.g, required this.b, this.a = 1});
}
