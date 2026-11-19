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
const kPendingVerify = <String>[
  'calendar',
  'calendar_picker',
];
const kMigratedVerified = <String>[
  'image',
  'page_indicator',
  'picker_view',
  'infinite_scroll',
  'pull_to_refresh',
  'qr_code',
  'swipe_action',
  'tooltip',
  'tour',
  'picker',
  'date_picker',
  'time_picker',
  'cascader',
  'cascader_view',
  'splitter',
  'upload',
  'button',
  'typography',
  'notice_bar',
  'auto_center',
  'divider',
  'flex',
  'grid',
  'layout',
  'safe_area',
  'space',
  'empty',
  'avatar',
  'badge',
  'card',
  'footer',
  'segmented',
  'statistic',
  'watermark',
  'tag',
  'ellipsis',
  'popover',
  'popconfirm',
  'dropdown',
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
