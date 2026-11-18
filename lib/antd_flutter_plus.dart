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

// L4 组件层 — 导航
export 'src/components/navigation/breadcrumb/ant_breadcrumb.dart';
export 'src/components/navigation/breadcrumb/ant_breadcrumb_types.dart';
export 'src/components/navigation/pagination/ant_pagination.dart';
export 'src/components/navigation/pagination/ant_pagination_types.dart';
export 'src/components/navigation/steps/ant_steps.dart';
export 'src/components/navigation/steps/ant_steps_types.dart';
export 'src/components/navigation/tabs/ant_tabs.dart';
export 'src/components/navigation/tabs/ant_tabs_types.dart';
export 'src/components/navigation/menu/ant_menu.dart';
export 'src/components/navigation/menu/ant_menu_types.dart';
export 'src/components/navigation/anchor/ant_anchor.dart';
export 'src/components/navigation/anchor/ant_anchor_types.dart';
export 'src/components/navigation/dropdown/ant_dropdown.dart';
export 'src/components/navigation/dropdown/ant_dropdown_types.dart';
export 'src/components/navigation/nav_bar/ant_nav_bar.dart';
export 'src/components/navigation/tab_bar/ant_tab_bar.dart';
export 'src/components/navigation/tab_bar/ant_tab_bar_types.dart';
export 'src/components/navigation/side_bar/ant_side_bar.dart';
export 'src/components/navigation/side_bar/ant_side_bar_types.dart';
export 'src/components/navigation/index_bar/ant_index_bar.dart';
export 'src/components/navigation/index_bar/ant_index_bar_types.dart';
export 'src/components/navigation/capsule_tabs/ant_capsule_tabs.dart';
export 'src/components/navigation/capsule_tabs/ant_capsule_tabs_types.dart';
export 'src/components/navigation/jumbo_tabs/ant_jumbo_tabs.dart';
export 'src/components/navigation/jumbo_tabs/ant_jumbo_tabs_types.dart';

// L4 组件层 — 通用
// Button 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/button/ant_button.dart';
export 'package:antd_flutter_ui/src/basic/button/ant_button_types.dart';
// Typography 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/typography/ant_typography.dart';
export 'package:antd_flutter_ui/src/basic/typography/ant_typography_types.dart';
export 'src/components/general/float_button/ant_float_button.dart';
export 'src/components/general/float_button/ant_float_button_types.dart';
// NoticeBar 通告栏已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/feedback/notice_bar/ant_notice_bar.dart';
export 'package:antd_flutter_ui/src/feedback/notice_bar/ant_notice_bar_types.dart';

// L4 组件层 — 布局
// AutoCenter 自动居中已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/auto_center/ant_auto_center.dart';
// Divider 分割线已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/divider/ant_divider.dart';
export 'package:antd_flutter_ui/src/basic/divider/ant_divider_types.dart';
// Flex 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/flex/ant_flex.dart';
export 'package:antd_flutter_ui/src/basic/flex/ant_flex_types.dart';
// Grid 栅格已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/grid/ant_grid.dart';
export 'package:antd_flutter_ui/src/basic/grid/ant_grid_types.dart';
// AntLayout 布局族已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/layout/ant_layout.dart';
export 'package:antd_flutter_ui/src/basic/layout/ant_layout_types.dart';
export 'src/components/layout/masonry/ant_masonry.dart';
export 'src/components/layout/masonry/ant_masonry_types.dart';
// SafeArea 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/safe_area/ant_safe_area.dart';
export 'package:antd_flutter_ui/src/basic/safe_area/ant_safe_area_types.dart';
// Space 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/space/ant_space.dart';
export 'package:antd_flutter_ui/src/basic/space/ant_space_types.dart';
export 'src/components/layout/splitter/ant_splitter.dart';
export 'src/components/layout/splitter/ant_splitter_types.dart';

// L4 组件层 — 数据录入
export 'src/components/data_entry/input/ant_input.dart';
export 'src/components/data_entry/input/ant_input_types.dart';
export 'src/components/data_entry/input_number/ant_input_number.dart';
export 'src/components/data_entry/input_number/ant_input_number_types.dart';
export 'src/components/data_entry/checkbox/ant_checkbox.dart';
export 'src/components/data_entry/checkbox/ant_checkbox_types.dart';
export 'src/components/data_entry/check_list/ant_check_list.dart';
export 'src/components/data_entry/check_list/ant_check_list_types.dart';
export 'src/components/data_entry/radio/ant_radio.dart';
export 'src/components/data_entry/radio/ant_radio_types.dart';
export 'src/components/data_entry/switch/ant_switch.dart';
export 'src/components/data_entry/switch/ant_switch_types.dart';
export 'src/components/data_entry/select/ant_select.dart';
export 'src/components/data_entry/select/ant_select_types.dart';
export 'src/components/data_entry/selector/ant_selector.dart';
export 'src/components/data_entry/selector/ant_selector_types.dart';
export 'src/components/data_entry/date_picker/ant_date_picker.dart';
export 'src/components/data_entry/date_picker/ant_date_picker_types.dart';
export 'src/components/data_entry/time_picker/ant_time_picker.dart';
export 'src/components/data_entry/time_picker/ant_time_picker_types.dart';
export 'src/components/data_entry/slider/ant_slider.dart';
export 'src/components/data_entry/slider/ant_slider_types.dart';
export 'src/components/data_entry/rate/ant_rate.dart';
export 'src/components/data_entry/rate/ant_rate_types.dart';
export 'src/components/data_entry/form/ant_form.dart';
export 'src/components/data_entry/form/ant_form_types.dart';
export 'src/components/data_entry/auto_complete/ant_auto_complete.dart';
export 'src/components/data_entry/auto_complete/ant_auto_complete_types.dart';
export 'src/components/data_entry/cascader/ant_cascader.dart';
export 'src/components/data_entry/cascader/ant_cascader_types.dart';
export 'src/components/data_entry/cascader/ant_cascader_view.dart';
export 'src/components/data_entry/color_picker/ant_color_picker.dart';
export 'src/components/data_entry/image_uploader/ant_image_uploader.dart';
export 'src/components/data_entry/image_uploader/ant_image_uploader_types.dart';
export 'src/components/data_entry/tree_select/ant_tree_select.dart';
export 'src/components/data_entry/tree_select/ant_tree_select_types.dart';
export 'src/components/data_entry/mentions/ant_mentions.dart';
export 'src/components/data_entry/mentions/ant_mentions_types.dart';
export 'src/components/data_entry/number_keyboard/ant_number_keyboard.dart';
export 'src/components/data_entry/number_keyboard/ant_number_keyboard_types.dart';
export 'src/components/data_entry/passcode_input/ant_passcode_input.dart';
export 'src/components/data_entry/passcode_input/ant_passcode_input_types.dart';
export 'src/components/data_entry/virtual_input/ant_virtual_input.dart';
export 'src/components/data_entry/virtual_input/ant_virtual_input_types.dart';
export 'src/components/data_entry/transfer/ant_transfer.dart';
export 'src/components/data_entry/upload/ant_upload.dart';
export 'src/components/data_entry/stepper/ant_stepper.dart';
export 'src/components/data_entry/stepper/ant_stepper_types.dart';
export 'src/components/data_entry/search_bar/ant_search_bar.dart';
export 'src/components/data_entry/search_bar/ant_search_bar_types.dart';
export 'src/components/data_entry/picker/ant_picker.dart';
export 'src/components/data_entry/picker/ant_picker_types.dart';
export 'src/components/data_entry/picker/ant_picker_view.dart';
export 'src/components/data_entry/calendar_picker/ant_calendar_picker.dart';
export 'src/components/data_entry/calendar_picker/ant_calendar_picker_types.dart';

// ============================================================
// 数据展示 Data Display
// ============================================================
// AntAvatar 头像已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/avatar/ant_avatar.dart';
export 'package:antd_flutter_ui/src/display/avatar/ant_avatar_types.dart';
// AntBadge 徽标已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/badge/ant_badge.dart';
export 'package:antd_flutter_ui/src/display/badge/ant_badge_types.dart';
// AntTag 标签已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/tag/ant_tag.dart';
export 'package:antd_flutter_ui/src/display/tag/ant_tag_types.dart';
// AntCard 卡片已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/card/ant_card.dart';
export 'package:antd_flutter_ui/src/display/card/ant_card_types.dart';
// Empty 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/empty/ant_empty.dart';
export 'package:antd_flutter_ui/src/display/empty/ant_empty_types.dart';
// AntStatistic 统计数值已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/statistic/ant_statistic.dart';
export 'package:antd_flutter_ui/src/display/statistic/ant_statistic_types.dart';

// ============================================================
// 数据展示 Data Display — 批次B
// ============================================================
export 'src/components/data_display/tooltip/ant_tooltip.dart';
export 'src/components/data_display/tooltip/ant_tooltip_types.dart';
export 'src/components/data_display/popover/ant_popover.dart';
export 'src/components/data_display/popover/ant_popover_types.dart';
// Segmented 分段控制器已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/segmented/ant_segmented.dart';
export 'package:antd_flutter_ui/src/display/segmented/ant_segmented_types.dart';
// QRCode 二维码已迁移至 antd_qrcode（P08），此处 re-export 保持符号兼容
export 'package:antd_qrcode/src/qr_code/ant_qr_code.dart';
export 'package:antd_qrcode/src/qr_code/ant_qr_code_types.dart';
// AntImage 图片已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/image/ant_image.dart';
export 'package:antd_flutter_ui/src/display/image/ant_image_types.dart';

// ============================================================
// 数据展示 Data Display — 批次C
// ============================================================
export 'src/components/data_display/table/ant_table.dart';
export 'src/components/data_display/table/ant_table_types.dart';
export 'src/components/data_display/tree/ant_tree.dart';
export 'src/components/data_display/tree/ant_tree_types.dart';
export 'src/components/data_display/calendar/ant_calendar.dart';
export 'src/components/data_display/calendar/ant_calendar_types.dart';
export 'src/components/data_display/tour/ant_tour.dart';
export 'src/components/data_display/tour/ant_tour_types.dart';
export 'src/components/data_display/carousel/ant_carousel.dart';
export 'src/components/data_display/carousel/ant_carousel_types.dart';
export 'src/components/data_display/descriptions/ant_descriptions.dart';
export 'src/components/data_display/descriptions/ant_descriptions_types.dart';
export 'src/components/data_display/timeline/ant_timeline.dart';
export 'src/components/data_display/timeline/ant_timeline_types.dart';
export 'src/components/data_display/collapse/ant_collapse.dart';
export 'src/components/data_display/collapse/ant_collapse_types.dart';
export 'src/components/data_display/list/ant_list.dart';
export 'src/components/data_display/list/ant_list_types.dart';

// ============================================================
// 数据展示 Data Display — 批次D
// ============================================================
// Ellipsis 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/display/ellipsis/ant_ellipsis.dart';
export 'package:antd_flutter_ui/src/display/ellipsis/ant_ellipsis_types.dart';
// Footer 已迁移至 antd_flutter_ui（P08），此处 re-export 保持符号兼容
export 'package:antd_flutter_ui/src/basic/footer/ant_footer.dart';
export 'package:antd_flutter_ui/src/basic/footer/ant_footer_types.dart';
export 'src/components/data_display/page_indicator/ant_page_indicator.dart';
export 'src/components/data_display/page_indicator/ant_page_indicator_types.dart';
export 'src/components/data_display/floating_bubble/ant_floating_bubble.dart';
export 'src/components/data_display/floating_bubble/ant_floating_bubble_types.dart';
// InfiniteScroll / PullToRefresh 已迁移至 antd_refresh（P08），此处 re-export 保持符号兼容
export 'package:antd_refresh/src/infinite_scroll/ant_infinite_scroll.dart';
export 'package:antd_refresh/src/infinite_scroll/ant_infinite_scroll_types.dart';
export 'src/components/data_display/image_viewer/ant_image_viewer.dart';
export 'src/components/data_display/image_viewer/ant_image_viewer_types.dart';
export 'src/components/data_display/floating_panel/ant_floating_panel.dart';
export 'src/components/data_display/floating_panel/ant_floating_panel_types.dart';

// ============================================================
// 反馈 Feedback — 批次A
// ============================================================
export 'src/components/feedback/alert/ant_alert.dart';
export 'src/components/feedback/alert/ant_alert_types.dart';
export 'src/components/feedback/progress/ant_progress.dart';
export 'src/components/feedback/progress/ant_progress_types.dart';
export 'src/components/feedback/skeleton/ant_skeleton.dart';
export 'src/components/feedback/skeleton/ant_skeleton_types.dart';
export 'src/components/feedback/spin/ant_spin.dart';
export 'src/components/feedback/spin/ant_spin_types.dart';
export 'src/components/feedback/result/ant_result.dart';
export 'src/components/feedback/result/ant_result_types.dart';
export 'src/components/feedback/drawer/ant_drawer.dart';
export 'src/components/feedback/drawer/ant_drawer_types.dart';
export 'src/components/feedback/popconfirm/ant_popconfirm.dart';
export 'src/components/feedback/popconfirm/ant_popconfirm_types.dart';
export 'src/components/feedback/message/ant_message.dart';
export 'src/components/feedback/message/ant_message_types.dart';
export 'src/components/feedback/modal/ant_modal.dart';
export 'src/components/feedback/modal/ant_modal_types.dart';
export 'src/components/feedback/notification/ant_notification.dart';
export 'src/components/feedback/notification/ant_notification_types.dart';
export 'package:antd_flutter_ui/src/feedback/watermark/ant_watermark.dart';
export 'package:antd_flutter_ui/src/feedback/watermark/ant_watermark_types.dart';

// ============================================================
// 反馈 Feedback — 批次B
// ============================================================
export 'src/components/feedback/toast/ant_toast.dart';
export 'src/components/feedback/toast/ant_toast_types.dart';
export 'src/components/feedback/mask/ant_mask.dart';
export 'src/components/feedback/mask/ant_mask_types.dart';
export 'src/components/feedback/dialog/ant_dialog.dart';
export 'src/components/feedback/dialog/ant_dialog_types.dart';
export 'src/components/feedback/popup/ant_popup.dart';
export 'src/components/feedback/popup/ant_popup_types.dart';
// PullToRefresh / InfiniteScroll 已迁移至 antd_refresh（P08），此处 re-export 保持符号兼容
export 'package:antd_refresh/src/pull_to_refresh/ant_pull_to_refresh.dart';
export 'package:antd_refresh/src/pull_to_refresh/ant_pull_to_refresh_types.dart';
export 'src/components/feedback/action_sheet/ant_action_sheet.dart';
export 'src/components/feedback/action_sheet/ant_action_sheet_types.dart';

// ============================================================
// 反馈 Feedback — 批次C
// ============================================================
// SwipeAction 滑动操作已迁移至 antd_swipe_action（P08），此处 re-export 保持符号兼容
export 'package:antd_swipe_action/src/swipe_action/ant_swipe_action.dart';
export 'package:antd_swipe_action/src/swipe_action/ant_swipe_action_types.dart';
export 'src/components/feedback/loading/ant_loading.dart';
export 'src/components/feedback/loading/ant_loading_types.dart';
export 'src/components/feedback/error_block/ant_error_block.dart';
export 'src/components/feedback/result_page/ant_result_page.dart';

// ============================================================
// 其他 Misc — App / ConfigProvider（Phase 8 最后一批）
// ============================================================
export 'src/components/misc/app/ant_app.dart';
export 'src/components/misc/app/ant_app_types.dart';
export 'src/components/misc/config_provider/ant_config_provider.dart';
export 'src/components/misc/config_provider/ant_config_provider_types.dart';
export 'src/components/misc/affix/ant_affix.dart';
export 'src/components/misc/affix/ant_affix_types.dart';
export 'src/components/misc/border_beam/ant_border_beam.dart';
export 'src/components/misc/border_beam/ant_border_beam_types.dart';
