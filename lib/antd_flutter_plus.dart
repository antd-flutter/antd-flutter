/// antd-flutter — Ant Design v6 Flutter 组件库
///
/// 基于 Ant Design 设计规范与 Design Token 体系，
/// 在 Flutter 上实现的高质量组件库。
///
/// 全量导出。如需按层独立引入，可使用：
/// - `package:antd_color/antd_color.dart` — L2 颜色层
/// - `package:antd_tokens/antd_tokens.dart` — L2 令牌层
/// - `package:antd_theme/antd_theme.dart` — L3 主题层
library;

// L1 基础层 — 平台工具（本包）
export 'src/platform/ant_platform.dart';
export 'src/platform/ant_ohos_channel.dart';

// L2 颜色层
export 'package:antd_color/antd_color.dart';

// L2 令牌层
export 'package:antd_tokens/antd_tokens.dart';

// L3 主题层
export 'package:antd_theme/antd_theme.dart';

// 图标资源层
export 'package:antd_icons_flutter/antd_icons_flutter.dart';

// L4 组件层 — 通用
export 'src/components/general/button/ant_button.dart';
export 'src/components/general/button/ant_button_types.dart';
export 'src/components/general/typography/ant_typography.dart';
export 'src/components/general/typography/ant_typography_types.dart';
export 'src/components/general/float_button/ant_float_button.dart';
export 'src/components/general/float_button/ant_float_button_types.dart';