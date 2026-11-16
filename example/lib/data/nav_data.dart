library;

/// antd 官网导航数据 — 组件分类与组件清单
/// 涵盖 antd v6 桌面版 + antd-mobile v5 移动端特有组件
/// 导航项（单个组件）
class NavItem {
  const NavItem(this.label, this.snakeName);

  /// 展示名（如 "Button 按钮"）
  final String label;

  /// 蛇形名（如 "button"），用于路由/占位
  final String snakeName;
}

/// 导航分组（如 "通用"、"布局"）
class NavGroup {
  const NavGroup(this.title, this.items);

  final String title;
  final List<NavItem> items;
}

/// antd 官网组件导航（七大分类，桌面 73 + 移动端 38 = 111 组件）
const List<NavGroup> navGroups = [
  NavGroup('通用', [
    NavItem('Button 按钮', 'button'),
    NavItem('Icon 图标', 'icon'),
    NavItem('NoticeBar 通告栏', 'notice_bar'),
    NavItem('Typography 排版', 'typography'),
  ]),
  NavGroup('布局', [
    NavItem('AutoCenter 自动居中', 'auto_center'),
    NavItem('Divider 分割线', 'divider'),
    NavItem('Flex 弹性布局', 'flex'),
    NavItem('Grid 栅格', 'grid'),
    NavItem('Layout 布局', 'layout'),
    NavItem('Masonry 瀑布流', 'masonry'),
    NavItem('SafeArea 安全区', 'safe_area'),
    NavItem('Space 间距', 'space'),
    NavItem('Splitter 分割面板', 'splitter'),
  ]),
  NavGroup('导航', [
    NavItem('Anchor 锚点', 'anchor'),
    NavItem('Breadcrumb 面包屑', 'breadcrumb'),
    NavItem('CapsuleTabs 胶囊选项卡', 'capsule_tabs'),
    NavItem('Dropdown 下拉菜单', 'dropdown'),
    NavItem('IndexBar 索引栏', 'index_bar'),
    NavItem('JumboTabs 大块选项卡', 'jumbo_tabs'),
    NavItem('Menu 导航菜单', 'menu'),
    NavItem('NavBar 导航栏', 'nav_bar'),
    NavItem('Pagination 分页', 'pagination'),
    NavItem('SideBar 侧边栏', 'side_bar'),
    NavItem('Steps 步骤条', 'steps'),
    NavItem('TabBar 标签栏', 'tab_bar'),
  ]),
  NavGroup('数据录入', [
    NavItem('AutoComplete 自动补全', 'auto_complete'),
    NavItem('CalendarPicker 日历选择器', 'calendar_picker'),
    NavItem('Cascader 级联选择', 'cascader'),
    NavItem('CascaderView 级联选择视图', 'cascader_view'),
    NavItem('CheckList 复选列表', 'check_list'),
    NavItem('Checkbox 多选框', 'checkbox'),
    NavItem('ColorPicker 颜色选择器', 'color_picker'),
    NavItem('DatePicker 日期选择框', 'date_picker'),
    NavItem('Form 表单', 'form'),
    NavItem('ImageUploader 图片上传', 'image_uploader'),
    NavItem('Input 输入框', 'input'),
    NavItem('InputNumber 数字输入框', 'input_number'),
    NavItem('Mentions 提及', 'mentions'),
    NavItem('NumberKeyboard 数字键盘', 'number_keyboard'),
    NavItem('PasscodeInput 密码输入', 'passcode_input'),
    NavItem('Picker 选择器', 'picker'),
    NavItem('PickerView 选择器视图', 'picker_view'),
    NavItem('Radio 单选框', 'radio'),
    NavItem('Rate 评分', 'rate'),
    NavItem('SearchBar 搜索栏', 'search_bar'),
    NavItem('Select 选择器', 'select'),
    NavItem('Selector 选择组', 'selector'),
    NavItem('Slider 滑动输入条', 'slider'),
    NavItem('Stepper 步进器', 'stepper'),
    NavItem('Switch 开关', 'switch'),
    NavItem('TimePicker 时间选择框', 'time_picker'),
    NavItem('Transfer 穿梭框', 'transfer'),
    NavItem('TreeSelect 树选择', 'tree_select'),
    NavItem('Upload 上传', 'upload'),
    NavItem('VirtualInput 虚拟输入', 'virtual_input'),
  ]),
  NavGroup('数据展示', [
    NavItem('Avatar 头像', 'avatar'),
    NavItem('Badge 徽标数', 'badge'),
    NavItem('Calendar 日历', 'calendar'),
    NavItem('Card 卡片', 'card'),
    NavItem('Carousel 走马灯', 'carousel'),
    NavItem('Collapse 折叠面板', 'collapse'),
    NavItem('Descriptions 描述列表', 'descriptions'),
    NavItem('Ellipsis 文本省略', 'ellipsis'),
    NavItem('Empty 空状态', 'empty'),
    NavItem('FloatingBubble 浮动气泡', 'floating_bubble'),
    NavItem('FloatingPanel 浮动面板', 'floating_panel'),
    NavItem('Footer 页脚', 'footer'),
    NavItem('Image 图片', 'image'),
    NavItem('ImageViewer 图片查看器', 'image_viewer'),
    NavItem('InfiniteScroll 无限滚动', 'infinite_scroll'),
    NavItem('List 列表', 'list'),
    NavItem('PageIndicator 页面指示器', 'page_indicator'),
    NavItem('Popover 气泡卡片', 'popover'),
    NavItem('QRCode 二维码', 'qr_code'),
    NavItem('Segmented 分段控制器', 'segmented'),
    NavItem('Statistic 统计数值', 'statistic'),
    NavItem('Table 表格', 'table'),
    NavItem('Tabs 标签页', 'tabs'),
    NavItem('Tag 标签', 'tag'),
    NavItem('Timeline 时间轴', 'timeline'),
    NavItem('Tooltip 文字提示', 'tooltip'),
    NavItem('Tour 漫游引导', 'tour'),
    NavItem('Tree 树形控件', 'tree'),
  ]),
  NavGroup('反馈', [
    NavItem('ActionSheet 动作面板', 'action_sheet'),
    NavItem('Alert 警告提示', 'alert'),
    NavItem('Dialog 对话框', 'dialog'),
    NavItem('Drawer 抽屉', 'drawer'),
    NavItem('ErrorBlock 错误块', 'error_block'),
    NavItem('Loading 加载', 'loading'),
    NavItem('Mask 遮罩层', 'mask'),
    NavItem('Message 全局提示', 'message'),
    NavItem('Modal 对话框', 'modal'),
    NavItem('Notification 通知提醒框', 'notification'),
    NavItem('Popconfirm 气泡确认框', 'popconfirm'),
    NavItem('Popup 弹出层', 'popup'),
    NavItem('Progress 进度条', 'progress'),
    NavItem('PullToRefresh 下拉刷新', 'pull_to_refresh'),
    NavItem('Result 结果', 'result'),
    NavItem('ResultPage 结果页', 'result_page'),
    NavItem('Skeleton 骨架屏', 'skeleton'),
    NavItem('Spin 加载中', 'spin'),
    NavItem('SwipeAction 滑动操作', 'swipe_action'),
    NavItem('Toast 轻提示', 'toast'),
  ]),
  NavGroup('其他', [
    NavItem('Affix 固钉', 'affix'),
    NavItem('App 应用', 'app'),
    NavItem('ConfigProvider 全局化配置', 'config_provider'),
    NavItem('FloatButton 浮动按钮', 'float_button'),
  ]),
];