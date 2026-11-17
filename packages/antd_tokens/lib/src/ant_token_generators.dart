/// Ant Design Token 派生算法（聚合出口）。
///
/// 原 ant_token_generators.dart 已按 R25/R26 拆分至 `generators/` 目录：
/// - `generators/ant_font_generator.dart` — genFontSizes / genFontMapToken
/// - `generators/ant_radius_generator.dart` — genRadius
/// - `generators/ant_size_generator.dart` — genSizeMapToken
/// - `generators/ant_control_height_generator.dart` — genControlHeight
/// - `generators/ant_motion_generator.dart` — genCommonMapToken 动效部分
///
/// 本文件保留为聚合出口，维持既有相对引用与文档引用路径不变。
library;

export 'generators/ant_font_generator.dart';
export 'generators/ant_radius_generator.dart';
export 'generators/ant_size_generator.dart';
export 'generators/ant_control_height_generator.dart';
export 'generators/ant_motion_generator.dart';
