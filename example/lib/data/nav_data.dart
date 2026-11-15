/// antd 官网导航数据 — 组件分类与组件清单
library;

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

/// antd 官网组件导航（六大分类）
const List<NavGroup> navGroups = [
  NavGroup('通用', [
    NavItem('Button 按钮', 'button'),
    NavItem('Icon 图标', 'icon'),
    NavItem('Typography 排版', 'typography'),
  ]),
  NavGroup('布局', [
    NavItem('Divider 分割线', 'divider'),
    NavItem('Flex 弹性布局', 'flex'),
    NavItem('Grid 栅格', 'grid'),
    NavItem('Layout 布局', 'layout'),
    NavItem('Space 间距', 'space'),
  ]),
  NavGroup('导航', [
    NavItem('Anchor 锚点', 'anchor'),
    NavItem('Breadcrumb 面包屑', 'breadcrumb'),
    NavItem('Dropdown 下拉菜单', 'dropdown'),
    NavItem('Menu 导航菜单', 'menu'),
    NavItem('Pagination 分页', 'pagination'),
    NavItem('Steps 步骤条', 'steps'),
  ]),
  NavGroup('数据录入', [
    NavItem('AutoComplete 自动补全', 'auto_complete'),
    NavItem('Cascader 级联选择', 'cascader'),
    NavItem('Checkbox 多选框', 'checkbox'),
    NavItem('ColorPicker 颜色选择器', 'color_picker'),
    NavItem('DatePicker 日期选择框', 'date_picker'),
    NavItem('Form 表单', 'form'),
    NavItem('Input 输入框', 'input'),
    NavItem('InputNumber 数字输入框', 'input_number'),
    NavItem('Mentions 提及', 'mentions'),
    NavItem('Radio 单选框', 'radio'),
    NavItem('Rate 评分', 'rate'),
    NavItem('Select 选择器', 'select'),
    NavItem('Slider 滑动输入条', 'slider'),
    NavItem('Switch 开关', 'switch'),
    NavItem('TimePicker 时间选择框', 'time_picker'),
    NavItem('Transfer 穿梭框', 'transfer'),
    NavItem('TreeSelect 树选择', 'tree_select'),
    NavItem('Upload 上传', 'upload'),
  ]),
  NavGroup('数据展示', [
    NavItem('Avatar 头像', 'avatar'),
    NavItem('Badge 徽标数', 'badge'),
    NavItem('Calendar 日历', 'calendar'),
    NavItem('Card 卡片', 'card'),
    NavItem('Carousel 走马灯', 'carousel'),
    NavItem('Collapse 折叠面板', 'collapse'),
    NavItem('Descriptions 描述列表', 'descriptions'),
    NavItem('Empty 空状态', 'empty'),
    NavItem('Image 图片', 'image'),
    NavItem('List 列表', 'list'),
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
    NavItem('Alert 警告提示', 'alert'),
    NavItem('Drawer 抽屉', 'drawer'),
    NavItem('Message 全局提示', 'message'),
    NavItem('Modal 对话框', 'modal'),
    NavItem('Notification 通知提醒框', 'notification'),
    NavItem('Popconfirm 气泡确认框', 'popconfirm'),
    NavItem('Progress 进度条', 'progress'),
    NavItem('Result 结果', 'result'),
    NavItem('Skeleton 骨架屏', 'skeleton'),
    NavItem('Spin 加载中', 'spin'),
  ]),
  NavGroup('其他', [
    NavItem('Affix 固钉', 'affix'),
    NavItem('App 应用', 'app'),
    NavItem('ConfigProvider 全局化配置', 'config_provider'),
    NavItem('FloatButton 浮动按钮', 'float_button'),
  ]),
];