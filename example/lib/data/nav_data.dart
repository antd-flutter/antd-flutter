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
    NavItem('Tooltip 文字提示', 'tooltip'),
    NavItem('Button 按钮', 'button'),
    NavItem('NoticeBar 通告栏', 'notice_bar'),
    NavItem('Typography 排版', 'typography'),
    NavItem('Affix 固定', 'affix'),
    NavItem('FloatButton 悬浮按钮', 'float_button'),
    NavItem('App 全局应用', 'app'),
    NavItem('ConfigProvider 全局化', 'config_provider'),
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
    NavItem('Calendar 日历', 'calendar'),
    NavItem('Badge 徽标数', 'badge'),
    NavItem('Card 卡片', 'card'),
    NavItem('Ellipsis 文本省略', 'ellipsis'),
    NavItem('InfiniteScroll 无限滚动', 'infinite_scroll'),
    NavItem('Empty 空状态', 'empty'),
    NavItem('Footer 页脚', 'footer'),
    NavItem('Image 图片', 'image'),
    NavItem('PageIndicator 页面指示器', 'page_indicator'),
    NavItem('Popover 气泡卡片', 'popover'),
    NavItem('Collapse 折叠面板', 'collapse'),
    NavItem('Descriptions 描述列表', 'descriptions'),
    NavItem('List 列表', 'list'),
    NavItem('Timeline 时间轴', 'timeline'),
    NavItem('Tree 树形控件', 'tree'),
    NavItem('Carousel 走马灯', 'carousel'),
    NavItem('Masonry 瀑布流', 'masonry'),
    NavItem('FloatingPanel 浮动面板', 'floating_panel'),
    NavItem('FloatingBubble 浮动气泡', 'floating_bubble'),
    NavItem('Splitter 分割容器', 'splitter'),
    NavItem('Upload 上传', 'upload'),
    NavItem('Segmented 分段控制器', 'segmented'),
    NavItem('Statistic 统计数值', 'statistic'),
    NavItem('Tour 引导弹览', 'tour'),
    NavItem('QRCode 二维码', 'qr_code'),
    NavItem('Watermark 水印', 'watermark'),
    NavItem('BorderBeam 边框光束', 'border_beam'),
    NavItem('CalendarPicker 日历选择器', 'calendar_picker'),
    NavItem('PickerView 选择器视图', 'picker_view'),
    NavItem('Tag 标签', 'tag'),
  ]),
  NavGroup('导航', [
    NavItem('Dropdown 下拉菜单', 'dropdown'),
    NavItem('Tabs 标签页', 'tabs'),
    NavItem('CapsuleTabs 胶囊标签', 'capsule_tabs'),
    NavItem('TabBar 标签栏', 'tab_bar'),
    NavItem('Steps 步骤条', 'steps'),
    NavItem('JumboTabs 大号标签', 'jumbo_tabs'),
    NavItem('SideBar 侧边导航', 'side_bar'),
    NavItem('Menu 菜单', 'menu'),
    NavItem('NavBar 导航栏', 'nav_bar'),
    NavItem('Pagination 分页', 'pagination'),
    NavItem('Anchor 锚点', 'anchor'),
    NavItem('Breadcrumb 面包屑', 'breadcrumb'),
    NavItem('IndexBar 索引栏', 'index_bar'),
  ]),
  NavGroup('反馈', [
    NavItem('PullToRefresh 下拉刷新', 'pull_to_refresh'),
    NavItem('SwipeAction 滑动操作', 'swipe_action'),
    NavItem('Popconfirm 气泡确认框', 'popconfirm'),
    NavItem('Alert 警告提示', 'alert'),
    NavItem('ErrorBlock 错误块', 'error_block'),
    NavItem('Loading 加载中', 'loading'),
    NavItem('Mask 背景蒙层', 'mask'),
    NavItem('Progress 进度条', 'progress'),
    NavItem('Result 操作结果', 'result'),
    NavItem('ResultPage 结果页', 'result_page'),
    NavItem('Skeleton 骨架屏', 'skeleton'),
    NavItem('Spin 加载', 'spin'),
    NavItem('Dialog 对话框', 'dialog'),
    NavItem('Drawer 抽屉', 'drawer'),
    NavItem('Modal 模态框', 'modal'),
    NavItem('Popup 气泡弹层', 'popup'),
    NavItem('ActionSheet 动作面板', 'action_sheet'),
    NavItem('Toast 轻提示', 'toast'),
    NavItem('Message 全局信息', 'message'),
    NavItem('Notification 通知提醒', 'notification'),
  ]),
  NavGroup('数据录入', [
    NavItem('TreeSelect 树选择', 'tree_select'),
    NavItem('Select 选择器', 'select'),
    NavItem('ColorPicker 颜色选择器', 'color_picker'),
    NavItem('AutoComplete 自动完成', 'auto_complete'),
    NavItem('Mentions 提及', 'mentions'),
    NavItem('Picker 选择器', 'picker'),
    NavItem('DatePicker 日期选择器', 'date_picker'),
    NavItem('TimePicker 时间选择器', 'time_picker'),
    NavItem('Cascader 级联选择', 'cascader'),
    NavItem('CascaderView 级联视图', 'cascader_view'),
    NavItem('Checkbox 复选框', 'checkbox'),
    NavItem('Radio 单选框', 'radio'),
    NavItem('Rate 评分', 'rate'),
    NavItem('Slider 滑动输入条', 'slider'),
    NavItem('Switch 开关', 'switch'),
    NavItem('Stepper 步进器', 'stepper'),
    NavItem('Input 输入框', 'input'),
    NavItem('InputNumber 数字输入框', 'input_number'),
    NavItem('SearchBar 搜索框', 'search_bar'),
    NavItem('CheckList 勾选列表', 'check_list'),
    NavItem('Selector 选择器', 'selector'),
    NavItem('NumberKeyboard 数字键盘', 'number_keyboard'),
    NavItem('PasscodeInput 密码输入框', 'passcode_input'),
    NavItem('VirtualInput 虚拟输入框', 'virtual_input'),
    NavItem('ImageUploader 图片上传', 'image_uploader'),
  ]),
];
