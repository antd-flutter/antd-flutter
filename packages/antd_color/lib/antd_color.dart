/// antd_color — Ant Design v6 颜色系统
///
/// 精确移植 `@ant-design/fast-color` v3，提供：
/// - [AntFastColor] — 颜色操作（明暗、混合、透明度等）
/// - [antGeneratePalette] — antd 10 阶色板生成算法
/// - [AntColor] — 色板包装，同时提供 hex 与 Flutter [Color] 访问
/// - [antParseColor] — CSS 颜色字符串 → Flutter Color
///
/// 文件按 R25/R26 细粒度分层：
/// - `src/types/` — 纯数据类型（AntHsv / AntHsl / AntRgb）
/// - `src/config/` — 配置类（AntPaletteOptions）
/// - 主体实现 — ant_fast_color / ant_color_palette / ant_color 等
library;

export 'src/ant_color.dart';
export 'src/ant_color_palette.dart';
export 'src/ant_color_presets.dart';
export 'src/ant_fast_color.dart';
export 'src/ant_parse_color.dart';
export 'src/config/ant_palette_options.dart';
export 'src/types/ant_color_models.dart';
