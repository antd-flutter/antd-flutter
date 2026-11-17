/// CSS 颜色字符串解析工具。
///
/// 提供独立于色板包装类（AntColor）的颜色字符串 → Flutter Color 解析。
///
/// @docImport 'ant_color.dart';
library;

import 'dart:ui';

/// 解析 CSS 颜色字符串为 Flutter [Color]。
///
/// 支持 `#rgb`、`#rrggbb`、`#rrggbbaa`（可带前导 `#`）、
/// `rgb(r,g,b)` 与 `rgba(r,g,b,a)` 格式；数值两侧允许空白。
///
/// [cssColor] 为待解析的 CSS 颜色字符串，前导/尾随空白会被忽略。
///
/// 返回对应的 [Color]；带 `#rrggbbaa` 时第 1 个字节作为 alpha（00 为全透明）。
/// 若格式无法识别或通道缺失，返回不透明黑色（`#000000`）作为兜底值，
/// 不抛出异常。
///
/// 注意：静默兜底便于容错但可能掩盖格式错误，解析外部输入
/// （如后端下发的颜色）时建议先做格式校验或对比解析结果。
///
/// ```dart
/// final primary = antParseColor('#1677FF'); // Color(0xFF1677FF)
/// final semi = antParseColor('rgba(22, 119, 255, 0.5)');
/// ```
Color antParseColor(String cssColor) {
  final trimmed = cssColor.trim();

  if (trimmed.startsWith('#')) {
    final hex = trimmed.substring(1);
    if (hex.length == 3) {
      final r = int.parse(hex[0] * 2, radix: 16);
      final g = int.parse(hex[1] * 2, radix: 16);
      final b = int.parse(hex[2] * 2, radix: 16);
      return Color.fromARGB(255, r, g, b);
    }
    if (hex.length == 6) {
      final value = int.parse(hex, radix: 16);
      return Color.fromARGB(255, (value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF);
    }
    if (hex.length == 8) {
      final value = int.parse(hex, radix: 16);
      return Color.fromARGB(
        (value >> 24) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 8) & 0xFF,
        value & 0xFF,
      );
    }
  }

  if (trimmed.startsWith('rgb')) {
    final inner = trimmed
        .replaceAll(RegExp(r'^[^(]*\('), '')
        .replaceAll(RegExp(r'\).*$'), '');
    final parts = inner.split(',').map((s) => s.trim()).toList();
    if (parts.length >= 3) {
      final r = double.tryParse(parts[0])?.round() ?? 0;
      final g = double.tryParse(parts[1])?.round() ?? 0;
      final b = double.tryParse(parts[2])?.round() ?? 0;
      var a = 255;
      if (parts.length >= 4) {
        final aVal = double.tryParse(parts[3]) ?? 1;
        a = (aVal * 255).round().clamp(0, 255);
      }
      return Color.fromARGB(a, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
    }
  }

  // Fallback: 黑色
  return const Color.fromARGB(255, 0, 0, 0);
}
