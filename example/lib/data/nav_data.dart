library;

/// antd 官网导航数据 — 组件分类与组件清单
/// 涵盖 antd v6 桌面版 + antd-mobile v5 移动端特有组件
/// 导航项（单个组件）
class NavItem {
  const NavItem(this.label, this.snakeName, {this.verified = false});

  /// 展示名（如 "Button 按钮"）
  final String label;

  /// 蛇形名（如 "button"），用于路由/占位
  final String snakeName;

  /// 是否已通过用户验收（P08 拆包迁移进度标记）。
  /// false 表示已迁移到 antd_flutter_ui 但尚未验收（标「待验证」）。
  /// 未迁移组件不在本清单中，侧栏不显示（功能仍在主包可用）。
  final bool verified;
}

/// 导航分组（如 "通用"、"布局"）
class NavGroup {
  const NavGroup(this.title, this.items);

  final String title;
  final List<NavItem> items;
}

/// antd 官网组件导航（七大分类，桌面 73 + 移动端 38 = 111 组件）
///
/// 三态进度模型：
/// - 已验收：[NavItem.verified] 为 true，侧栏标 ✅
/// - 待验证：已迁移未验收（如 Ellipsis），侧栏标「待验证」
/// - 未迁移：不入清单（ui17 隐藏方案，P08 迁移完成后逐步恢复）
const List<NavGroup> navGroups = [
  NavGroup('通用', [
    NavItem('Button 按钮', 'button', verified: true),
    NavItem('NoticeBar 通告栏', 'notice_bar', verified: true),
    NavItem('Typography 排版', 'typography', verified: true),
  ]),
  NavGroup('布局', [
    NavItem('AutoCenter 自动居中', 'auto_center', verified: true),
    NavItem('Divider 分割线', 'divider', verified: true),
    NavItem('Flex 弹性布局', 'flex', verified: true),
    NavItem('Grid 栅格', 'grid', verified: true),
    NavItem('Layout 布局', 'layout', verified: true),
    NavItem('SafeArea 安全区', 'safe_area', verified: true),
    NavItem('Space 间距', 'space', verified: true),
  ]),
  NavGroup('数据展示', [
    NavItem('Avatar 头像', 'avatar', verified: true),
    NavItem('Badge 徽标数', 'badge', verified: true),
    NavItem('Card 卡片', 'card', verified: true),
    NavItem('Ellipsis 文本省略', 'ellipsis'),
    NavItem('Empty 空状态', 'empty', verified: true),
    NavItem('Footer 页脚', 'footer', verified: true),
    NavItem('Segmented 分段控制器', 'segmented', verified: true),
    NavItem('Statistic 统计数值', 'statistic', verified: true),
    NavItem('Watermark 水印', 'watermark', verified: true),
    NavItem('Tag 标签', 'tag', verified: true),
  ]),
];
