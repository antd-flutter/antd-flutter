/// antd_tokens — Ant Design v6 Design Token 系统
///
/// 对应 antd 的 Seed → Map → Alias 三层令牌推导链：
/// - [AntSeedToken] — 种子令牌（colorPrimary、fontSize、borderRadius 等）
/// - [antGenFontSizes] / [antGenRadius] / … — 令牌生成算法
/// - [AntColorTokens] — 完整颜色令牌集（亮色/暗色工厂）
/// - [AntShadowTokens] — 阴影令牌
///
/// 文件按 R25/R26 细粒度分层：
/// - `src/generators/` — 令牌派生算法（font / radius / size / control_height / motion）
/// - `src/css/` — CSS 字符串令牌数据层（AntColorTokensCss）
/// - `ant_token_generators.dart` — generators 聚合出口（兼容既有引用）
library;

export 'src/ant_seed_token.dart';
export 'src/ant_token_generators.dart';
export 'src/ant_color_tokens.dart';
export 'src/ant_shadow_tokens.dart';
export 'src/generators/ant_font_generator.dart';
export 'src/generators/ant_radius_generator.dart';
export 'src/generators/ant_size_generator.dart';
export 'src/generators/ant_control_height_generator.dart';
export 'src/generators/ant_motion_generator.dart';
export 'src/css/ant_color_tokens_css.dart';
