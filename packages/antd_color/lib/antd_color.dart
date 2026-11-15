/// antd_color — Ant Design v6 颜色系统
///
/// 精确移植 `@ant-design/fast-color` v3，提供：
/// - [AntFastColor] — 颜色操作（明暗、混合、透明度等）
/// - [antGeneratePalette] — antd 10 阶色板生成算法
/// - [AntColor] — 色板包装，同时提供 hex 与 Flutter [Color] 访问
/// - [antParseColor] — CSS 颜色字符串 → Flutter Color
library;

export 'src/ant_fast_color.dart';
export 'src/ant_color_palette.dart';
export 'src/ant_color.dart';