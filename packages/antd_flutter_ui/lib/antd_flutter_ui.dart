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
export 'src/display/popover/ant_popover.dart';
export 'src/display/popover/ant_popover_types.dart';
export 'src/display/popover/ant_popconfirm.dart';
export 'src/display/popover/ant_popconfirm_types.dart';
export 'src/display/popover/ant_dropdown.dart';
export 'src/display/popover/ant_dropdown_types.dart';
export 'src/engines/popup_engine.dart';
export 'src/engines/popup_overlay.dart';
export 'src/engines/wheel_column_model.dart';
export 'src/engines/wheel_picker_engine.dart';
export 'src/engines/keyboard_input_model.dart';
export 'src/engines/calendar_grid_engine.dart';

// ── 基础层 ────────────────────────────────────────────────
export 'src/basic/button/ant_button.dart';
export 'src/basic/button/ant_button_types.dart';

// ── AutoCenter 自动居中 ────────────────────────────────────
export 'src/basic/auto_center/ant_auto_center.dart';

// ── Flex 弹性布局 ──────────────────────────────────────────
export 'src/basic/flex/ant_flex.dart';
export 'src/basic/flex/ant_flex_types.dart';

// ── Grid 栅格 ──────────────────────────────────────────────
export 'src/basic/grid/ant_grid.dart';
export 'src/basic/grid/ant_grid_types.dart';

// ── Layout 布局 ────────────────────────────────────────────
export 'src/basic/layout/ant_layout.dart';
export 'src/basic/layout/ant_layout_types.dart';

// ── SafeArea 安全区 ────────────────────────────────────────
export 'src/basic/safe_area/ant_safe_area.dart';
export 'src/basic/safe_area/ant_safe_area_types.dart';

// ── Divider 分割线 ─────────────────────────────────────────
export 'src/basic/divider/ant_divider.dart';
export 'src/basic/divider/ant_divider_types.dart';

// ── Space 间距 ─────────────────────────────────────────────
export 'src/basic/space/ant_space.dart';
export 'src/basic/space/ant_space_types.dart';

// ── Typography 排版 ────────────────────────────────────────
export 'src/basic/typography/ant_typography.dart';
export 'src/basic/typography/ant_typography_types.dart';

export 'src/basic/tooltip/ant_tooltip.dart';
export 'src/basic/tooltip/ant_tooltip_types.dart';

// ── Empty 空状态 ───────────────────────────────────────────
export 'src/display/empty/ant_empty.dart';
export 'src/display/empty/ant_empty_types.dart';

// ── PageIndicator 页面指示器 ────────────────────────────────
export 'src/display/page_indicator/ant_page_indicator.dart';
export 'src/display/page_indicator/ant_page_indicator_types.dart';

// ── Tour 漫游式引导 ────────────────────────────────────────
export 'src/display/tour/ant_tour.dart';
export 'src/display/tour/ant_tour_types.dart';

// ── Avatar 头像 ────────────────────────────────────────────
export 'src/display/avatar/ant_avatar.dart';
export 'src/display/avatar/ant_avatar_types.dart';

// ── Badge 徽标 ─────────────────────────────────────────────
export 'src/display/badge/ant_badge.dart';
export 'src/display/badge/ant_badge_types.dart';

// ── Tag 标签 ────────────────────────────────────────────────
export 'src/display/tag/ant_tag.dart';
export 'src/display/tag/ant_tag_types.dart';

// ── Card 卡片 ───────────────────────────────────────────────
export 'src/display/card/ant_card.dart';
export 'src/display/card/ant_card_types.dart';

// ── Statistic 统计数值 ──────────────────────────────────────
export 'src/display/statistic/ant_statistic.dart';
export 'src/display/statistic/ant_statistic_types.dart';

// ── Ellipsis 文本省略 ───────────────────────────────────────
export 'src/display/ellipsis/ant_ellipsis.dart';
export 'src/display/ellipsis/ant_ellipsis_types.dart';

// ── Footer 页脚 ────────────────────────────────────────────
export 'src/basic/footer/ant_footer.dart';
export 'src/basic/footer/ant_footer_types.dart';

// ── NoticeBar 通告栏 ────────────────────────────────────────
export 'src/feedback/notice_bar/ant_notice_bar.dart';
export 'src/feedback/watermark/ant_watermark.dart';
export 'src/feedback/watermark/ant_watermark_types.dart';
export 'src/feedback/notice_bar/ant_notice_bar_types.dart';

// ── Segmented 分段控制器 ────────────────────────────────────
export 'src/display/segmented/ant_segmented.dart';
export 'src/display/segmented/ant_segmented_types.dart';

// ── Image 图片 ─────────────────────────────────────────────
export 'src/display/image/ant_image.dart';
export 'src/display/image/ant_image_types.dart';

// ── PickerView 内嵌滚轮选择器（通用滚轮视图，供 Picker/CalendarPicker 等） ──
export 'src/display/picker_view/ant_picker_view.dart';
