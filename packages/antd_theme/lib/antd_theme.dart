/// antd_theme — Ant Design v6 主题系统
///
/// - [AntThemeData] — 完整主题数据（light / dark / fromSeed 工厂）
/// - [AntTheme] — InheritedWidget 主题注入（自动桥接 Flutter `Theme`）
/// - [AntMaterialTheme] — AntThemeData → Flutter ThemeData 转换扩展
/// - [AntBreakpoint] — 响应式断点（xs ~ xxxl）
/// - `AntScale` — 统一缩放因子（替代已移除的 flutter_screenutil）
///
/// 文件按 R25/R26 细粒度分层：
/// - `src/enum/` — 枚举与形态定义（AntBreakpoint / AntDeviceType /
///   AntOrientation / AntFoldState / AntLayoutAspect）
/// - `src/types/` — 纯数据类型与回调签名（AntLayoutData / AntFoldStateProvider /
///   AntThemeData 子令牌数据类）
/// - 主体实现 — ant_theme_data / ant_theme / ant_material_bridge /
///   ant_responsive / ant_platform / ant_scale 等
library;

export 'src/ant_theme_data.dart';
export 'src/ant_theme.dart';
export 'src/ant_material_bridge.dart';
export 'src/ant_breakpoint.dart';
export 'src/ant_platform.dart';
export 'src/ant_responsive.dart';
export 'src/ant_scale.dart';
export 'src/ant_overlay_material.dart';
export 'src/ant_screen_util.dart';
export 'src/enum/ant_breakpoint_type.dart';
export 'src/enum/ant_responsive_type.dart';
export 'src/types/ant_layout_types.dart';
export 'src/types/ant_theme_sub_tokens.dart';
