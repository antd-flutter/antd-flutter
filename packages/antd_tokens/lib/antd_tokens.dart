/// antd_tokens — Ant Design v6 Design Token 系统
///
/// 对应 antd 的 Seed → Map → Alias 三层令牌推导链：
/// - [AntSeedToken] — 种子令牌（colorPrimary、fontSize、borderRadius 等）
/// - [antGenFontSizes] / [antGenRadius] / … — 令牌生成算法
/// - [AntColorTokens] — 完整颜色令牌集（亮色/暗色工厂）
/// - [AntShadowTokens] — 阴影令牌
library;

export 'src/ant_seed_token.dart';
export 'src/ant_token_generators.dart';
export 'src/ant_color_tokens.dart';
export 'src/ant_shadow_tokens.dart';