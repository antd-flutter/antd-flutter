library;

/// P08 迁移状态驱动（按迁移顺序维护）
///
/// 维护方式（以后流程）：
/// 1. 组件迁移合并后（packages/antd_flutter_ui 已含该组件）→ 把 snakeName
///    加入 [kPendingVerify]，Nav 页面显示「⏱ 待验证」，用户可打开验收；
/// 2. 用户验收通过 → 把 snakeName 从 [kPendingVerify] 移入
///    [kMigratedVerified]，Nav 页面 label 后标 ✅；
/// 3. 两个清单都不在 → 未迁移，侧栏不显示（ui17 隐藏逻辑）。
///
/// NavItem 的 verified/pendingVerify/visible 均由本清单驱动，
/// 无需手工逐个修改 NavItem。
/// pendingVerify: 已迁移待用户验收（NavItem 显示 ⏱ 待验证）
/// verified: 用户验收通过（NavItem 显示 label ✅）
///
/// 2026-11-21 归位：以 docs/plan/tasks/P08-验收状态表.md 为准，修正历史漂移
/// （14 项已验收仍挂待验证 / 16 项未验收被标已验收 / 6 项重复），并去重。
const kPendingVerify = <String>[
  // 日历族（独立包 antd_calendar，双端一致性打磨中）
  'calendar',
  'calendar_picker',
  // 键盘族（独立包 antd_keyboard）
  'number_keyboard',
  'passcode_input',
  'virtual_input',
  // 批次 0-4 select-like 族（弹层统一 popup_engine 基座）
  'auto_complete',
  // 批次 0-5 数据展示残余
  'collapse',
  'descriptions',
  'timeline',
  // 批次 0-6 导航族
  'tabs',
  'tab_bar',
  'steps',
  'jumbo_tabs',
  'side_bar',
  'menu',
  'anchor',
  'breadcrumb',
  'index_bar',
  // 批次 0-7 misc/general 族
  'config_provider',
  // 批次 0-8 / 独立包压轴（transfer/table 已从 ui 拆出为独立包）
  'transfer',
  'table',
];

const kMigratedVerified = <String>[
  'mentions',
  'affix',
  'app',
  'capsule_tabs',
  // 基础层
  'button',
  'typography',
  'flex',
  'space',
  'grid',
  'layout',
  'divider',
  'safe_area',
  'auto_center',
  'footer',
  // 通用展示 + 反馈
  'empty',
  'avatar',
  'badge',
  'tag',
  'card',
  'statistic',
  'notice_bar',
  'segmented',
  'watermark',
  'ellipsis',
  'image',
  'tooltip',
  'popover',
  'popconfirm',
  'dropdown',
  // 批次 0-1 反馈非弹层族
  'alert',
  'error_block',
  'loading',
  'mask',
  'progress',
  'result',
  'result_page',
  'skeleton',
  'spin',
  // 批次 0-2 反馈弹层族
  'dialog',
  'drawer',
  'modal',
  'popup',
  'action_sheet',
  'toast',
  'message',
  'notification',
  // 批次 0-3 录入简单族（已验收部分）
  'radio',
  'rate',
  'slider',
  'switch',
  'stepper',
  'input',
  'input_number',
  'search_bar',
  'check_list',
  'selector',
  'image_uploader',
  // 批次 0-4 select-like 族（已验收部分）
  'select',
  'color_picker',
  // 批次 0-7 misc/general 族（已验收部分）
  'border_beam',
  'float_button',
  // 剩余通用展示
  'page_indicator',
  'picker_view',
  // 独立包
  'infinite_scroll',
  'pull_to_refresh',
  'qr_code',
  'swipe_action',
  'tour',
  'floating_panel',
  'floating_bubble',
  'picker',
  'date_picker',
  'time_picker',
  'cascader',
  'cascader_view',
  'splitter',
  'tree',
  'tree_select',
  'carousel',
  'masonry',
  'upload',
  // antd_form 独立包（ui 本体 Form 已验收；包级 example 验收另记状态表）
  'form',
  // 已验收（2026-11-21 用户验收）
  'checkbox',
  // 已验收（2026-11-21 用户验收，含 AntAppBar 别名）
  'nav_bar',
  // 已验收（2026-11-21 用户验收）
  'pagination',
  // 已验收（2026-11-21 用户验收）
  'list',
];

/// 迁移状态
enum MigrationStatus {
  /// 已迁移待用户验收（显示 ⏱ 待验证）
  pendingVerify,

  /// 用户验收通过（label ✅）
  verified,

  /// 未迁移（侧栏不显示）
  hidden,
}

/// 按 snakeName 查询迁移状态
MigrationStatus migrationStatusOf(String snakeName) {
  if (kMigratedVerified.contains(snakeName)) return MigrationStatus.verified;
  if (kPendingVerify.contains(snakeName)) {
    return MigrationStatus.pendingVerify;
  }
  return MigrationStatus.hidden;
}
