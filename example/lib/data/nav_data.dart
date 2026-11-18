library;

import 'migration_status.dart';

/// antd 官网导航数据 — 组件分类与组件清单
/// 涵盖 antd v6 桌面版 + antd-mobile v5 移动端特有组件
/// 导航项（单个组件）
class NavItem {
  const NavItem(this.label, this.snakeName);

  /// 展示名（如 "Button 按钮"）
  final String label;

  /// 蛇形名（如 "button"），用于路由/占位
  final String snakeName;

  /// 是否已通过用户验收（✅），由 kMigratedVerified 清单驱动
  bool get verified => migrationStatusOf(snakeName) == MigrationStatus.verified;

  /// 是否已迁移待验收（⏱ 待验证），由 kPendingVerify 清单驱动
  bool get pendingVerify =>
      migrationStatusOf(snakeName) == MigrationStatus.pendingVerify;

  /// 是否可见：两个迁移清单都不在 → 未迁移，侧栏不显示（ui17 隐藏逻辑）
  bool get visible => verified || pendingVerify;
}

/// 导航分组（如 "通用"、"布局"）
class NavGroup {
  const NavGroup(this.title, this.items);

  final String title;
  final List<NavItem> items;
}

/// antd 官网组件导航（七大分类，桌面 73 + 移动端 38 = 111 组件）
///
/// 三态进度模型（由 migration_status.dart 清单驱动，勿手工改 NavItem）：
/// - 已验收：snakeName 在 kMigratedVerified，侧栏标 ✅
/// - 待验证：已迁移未验收，snakeName 在 kPendingVerify，侧栏标「待验证」
/// - 未迁移：两个清单都不在，侧栏不显示（ui17 隐藏方案）
/// 清单外的组件先不入清单；迁移合并后再按文件头流程维护。
const List<NavGroup> navGroups = [
  NavGroup('通用', [
    NavItem('Button 按钮', 'button'),
    NavItem('NoticeBar 通告栏', 'notice_bar'),
    NavItem('Typography 排版', 'typography'),
  ]),
  NavGroup('布局', [
    NavItem('AutoCenter 自动居中', 'auto_center'),
    NavItem('Divider 分割线', 'divider'),
    NavItem('Flex 弹性布局', 'flex'),
    NavItem('Grid 栅格', 'grid'),
    NavItem('Layout 布局', 'layout'),
    NavItem('SafeArea 安全区', 'safe_area'),
    NavItem('Space 间距', 'space'),
  ]),
  NavGroup('数据展示', [
    NavItem('Avatar 头像', 'avatar'),
    NavItem('Badge 徽标数', 'badge'),
    NavItem('Card 卡片', 'card'),
    NavItem('Ellipsis 文本省略', 'ellipsis'),
    NavItem('Empty 空状态', 'empty'),
    NavItem('Footer 页脚', 'footer'),
    NavItem('Image 图片', 'image'),
    NavItem('Segmented 分段控制器', 'segmented'),
    NavItem('Statistic 统计数值', 'statistic'),
    NavItem('Watermark 水印', 'watermark'),
    NavItem('Tag 标签', 'tag'),
  ]),
];
