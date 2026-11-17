/// antd_flutter_ui — Ant Design v6 Flutter 基础组件库
///
/// 全量组件库拆分的「基础库」：
/// - `src/engines/` 跨包共享引擎（滚轮选择引擎 + 列数据模型、虚拟键盘/格子输入模型）
/// - `src/basic/` 基础层组件（Button/Typography/布局系…，随迁移逐步落位）
/// - `src/display|entry|feedback|global/` 通用展示/录入/反馈/全局（后续迁移）
///
/// 依赖方向约定：独立组件包 → antd_flutter_ui → antd_theme/tokens/color/icons，
/// 独立包之间禁止互相依赖。主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

// ── 共享引擎 ────────────────────────────────────────────────
export 'src/engines/wheel_column_model.dart';
export 'src/engines/wheel_picker_engine.dart';
export 'src/engines/keyboard_input_model.dart';

// ── 基础层 ────────────────────────────────────────────────
export 'src/basic/button/ant_button.dart';
export 'src/basic/button/ant_button_types.dart';

// ── Typography 排版 ────────────────────────────────────────
export 'src/basic/typography/ant_typography.dart';
export 'src/basic/typography/ant_typography_types.dart';

export 'src/basic/tooltip/ant_tooltip.dart';
export 'src/basic/tooltip/ant_tooltip_types.dart';
