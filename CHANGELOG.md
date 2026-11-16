## 0.19.0-beta.1

新增 Table 表格、Descriptions 描述列表、Timeline 时间轴、Collapse 折叠面板、List 列表、Calendar 日历、Carousel 走马灯、Tree 树形控件与 Tour 漫游引导组件（Phase 6 数据展示组件第三批，数据展示分类 20/28）。

- AntTable：排序三态循环（升序→降序→取消）+ 表头图标着色、filters 筛选菜单（多选/确认/重置）、fixed 列横向吸边（阴影分隔）、scrollY 吸顶表头、行数>50 ListView.builder 虚拟滚动、简版分页、render 自定义列/ellipsis/align/size/bordered/loading/empty
- AntDescriptions：AntDescriptionsItem(label/child/span)、column 列数、bordered 灰底 label、size 三档、colon、layout(horizontal/vertical)
- AntTimeline：mode(left/right/alternate 左右交替)、节点色预设映射主题色板、customDot 自定义节点、pending 加载节点、reverse 倒序、label 时间标签列
- AntCollapse：accordion 手风琴、activeKey 受控/defaultActiveKey 多开、AnimatedSize 展开动画、箭头旋转、expandIconPosition/expandIcon 自定义、borderless、size
- AntList：ListView.builder 懒加载泛型列表、header/footer、size、bordered/split、AntList.Item(content/extra/actions)、空态复用 AntEmpty、loading、pageSize 内部分页
- AntCalendar：6×7 月视图（上下月补位灰显）、weekStartsOn(monday/sunday)、今天高亮/onSelect/受控、上月下月本月导航、disabledDate、fullscreen/card 双模式、dateCell 自定义单元格
- AntCarousel：PageView 手势滑动、autoplay(3s 可配)/pauseOnHover/loop、dots 四方位指示点、arrows 桌面箭头、受控 current/defaultCurrent/onChange、goTo、vertical
- AntTree：多级树展开动画、父子勾选联动（父勾子全选/子全选联动父/半选态）、checkStrictly 严格模式、selectedKeys/expandedKeys/checkedKeys 全受控、defaultExpandAll、showLine、disabled
- AntTour：分步漫游引导，GlobalKey 目标定位、CustomPainter 挖孔遮罩 + 圆角描边高亮、引导卡片跟随（placement 13 方位/箭头）、步骤指示、上一步/下一步/完成/跳过、onStepChange/onFinish/onClose、maskClosable
- Widget test：Table 27 + Tree 17 + Calendar 17 + Tour 16 + Carousel 15 + Descriptions 14 + Timeline 14 + Collapse 13 + List 12 个测试用例全量通过（累计 1306 个）
- Example demo 页：九组件各 6-8 个展示区块

## 0.18.0-beta.1

新增 Image 图片(含全屏预览)、Popover 气泡卡片、Tooltip 文字提示、Segmented 分段控制器与 QRCode 二维码组件（Phase 6 数据展示组件第二批）。

- AntImage：图片展示，网络图经 cached_network_image 缓存加载（加载占位/失败占位统一封装隔离 SDK）、fit 适配/radius 圆角/width/height、preview 点击全屏预览（自绘 Overlay：暗色遮罩 + InteractiveViewer 缩放 + 关闭按钮）、AntImage.PreviewGroup 组内左右切换 + 页码指示、fallback/errorWidget 加载失败自定义、previewSrc 预览图独立配置
- AntPopover：气泡卡片，title 标题/content 内容区、九方向 placement、arrow 箭头、color 自定义背景（文字自动反白）、overlayStyle、hover/点击触发、受控 open/defaultOpen/disabled
- AntTooltip：文字提示，12 方向 placement、arrow 箭头、color/overlayStyle、hover/点击/焦点触发（桌面 hover 延迟可配，移动端点击/长按）、受控 open/defaultOpen
- AntSegmented：分段控制器，String/AntSegmentedItem(label/icon/value/disabled) 选项、选中滑块动画（block AnimatedAlign / inline AnimatedContainer）、block 占满整行、size(large/middle/small)、shape(rounded/round)、受控 value/defaultValue/onChange、全局与单项 disabled
- AntQRCode：二维码（qr_flutter 经中间层封装，不泄漏 SDK 语义），size/errorLevel(L/M/Q/H)/color/bgColor 主题适配/bordered、status(active/expired/scanned) 覆盖层、expired 点击刷新 onRefresh、icon 中心图标模式
- Widget test：Tooltip 27 个 + Popover 19 个 + Segmented 16 个 + QRCode 15 个 + Image 17 个测试用例全量通过（累计 1161 个）
- Example demo 页：Tooltip/Popover/Segmented/QRCode/Image 各 7-8 个展示区块

## 0.17.0-beta.2

修复 AntSpace 在松约束父级（如 AntAutoCenter/Center 内）不居中的问题。

- AntSpace：内部 Flex 由默认 MainAxisSize.max 改为 MainAxisSize.min，Space 语义应为紧贴子项的容器；此前 max 会撑满主轴剩余空间，导致外层 Center/AntAutoCenter 的主轴居中失效（内容顶在容器顶部）
- 新增回归测试：AntAutoCenter + AntSpace 组合在松约束容器内水平垂直均居中
- 全量 1067 个测试通过

## 0.17.0-beta.1

新增 Avatar 头像、Badge 徽标数、Tag 标签、Card 卡片、Empty 空状态与 Statistic 统计数值组件（Phase 6 数据展示组件首批）。

- AntAvatar：头像，支持 size(px/xs/sm/md/lg/xl)/shape(circle/square)/src 图片/icon 图标/children 文字 + AntAvatarGroup 组（maxCount 最大数量折叠/maxStyle 溢出样式/size 传递）
- AntBadge：徽标数，支持 count 计数/overflowCount 溢出上限/showZero 零值展示/dot 圆点/children 文本内容/status 状态点(success/processing/default/error/warning)/text 状态文案/badgeColor 自定义颜色/offset 偏移/size 尺寸
- AntTag：标签，支持 presetColor 预设色(success/processing/error/warning/default + 彩色色板)/checkable 可勾选/checked 受控/closable 可关闭/onClose/color 自定义颜色/borderless 无边框/icon 图标
- AntCard：卡片，支持 title 标题/extra 右上角操作区/cover 封面图/actions 底部操作组/size 尺寸/hoverable 悬停浮起/bordered 边框/onTap 点击回调 + AntCardMeta 组合(avatar/title/description)
- AntEmpty：空状态，支持 description 描述文字/image 自定义图片/children 自定义内容
- AntStatistic：统计数值，支持 value 数值/precision 精度/groupSeparator 千分位分隔符/title 标题/prefix/suffix 前后缀/valueStyle 数值样式/countdown 倒计时模式(format 格式/finishes 回调)/status 状态色
- Widget test：Avatar 14 个 + Badge 14 个 + Tag 12 个 + Card 12 个 + Empty 9 个 + Statistic 12 个测试用例全量通过（累计 1066 个）
- Example demo 页：Avatar/Badge/Tag/Card/Empty/Statistic 各 6-8 个展示区块

## 0.16.0-beta.1

新增 CheckList 复选列表、Selector 选择组、NumberKeyboard 数字键盘、PasscodeInput 密码格子输入、VirtualInput 虚拟输入与 ImageUploader 图片上传组件（Phase 5 数据录入组件第五批，数据录入分类 30/30 全部完成）。

- AntCheckList：复选列表，支持 multiple 单选/多选模式、items 列表项（value/child/description/prefix/disabled/readOnly）、showCheckMark 选中图标、activeIcon 自定义选中图标、disabled/readOnly 全局禁用/只读、受控 value 与非受控 defaultValue、onChange 事件回调
- AntSelector：选择组，支持 options 选项列表（value/label/description/disabled）、multiple 单选/多选模式、columns 每行项数（null 时自适应换行）、disabled/readOnly、选中项主色边框与背景、受控 value 与非受控 defaultValue、onChange 事件回调
- AntNumberKeyboard：数字键盘，支持 4×3 数字网格、confirmText 确认按钮、customKey 自定义按键、randomOrder 数字乱序、maxLength 最大长度、title 标题、visible 可见性、受控 value 与非受控 defaultValue、onChange/onConfirm/onClose 事件回调
- AntPasscodeInput：密码格子输入，支持 length 格子数量、plain 明文/密文展示、error 错误状态、separated 格子分离、keyboard 内置数字键盘开关、autofocus 自动聚焦、受控 value 与非受控 defaultValue、onChange/onFill 事件回调
- AntVirtualInput：虚拟输入，支持 placeholder 占位文本、clearable 可清空、disabled 禁用、confirmText/onEnterPress 确认键、randomOrder/customKey 键盘配置、autoFocus 自动聚焦、onFocus/onBlur 事件回调、受控 value 与非受控 defaultValue、onChange 事件回调
- AntImageUploader：图片上传，支持 value/defaultValue 图片列表（AntImageUploadItem url/status）、maxCount 最大数量、columns 每行列数、deletable 可删除、showUpload 显示上传按钮、preview 点击预览（全屏可缩放）、imageFit 填充模式、onPickImage 选图回调、onDelete 删除拦截、onCountExceed 超出数量回调、受控与非受控模式
- Widget test：CheckList 16 个 + Selector 14 个 + NumberKeyboard 15 个 + PasscodeInput 15 个 + VirtualInput 13 个 + ImageUploader 15 个测试用例全量通过
- Example demo 页：CheckList 8 个 + Selector 8 个 + NumberKeyboard 7 个 + PasscodeInput 7 个 + VirtualInput 7 个 + ImageUploader 7 个展示区块

## 0.15.0-beta.1

新增 Stepper 步进器、SearchBar 搜索栏、Picker 选择器、PickerView 选择器视图、CascaderView 级联选择视图与 CalendarPicker 日历选择器组件（Phase 5 数据录入组件第四批）。

- AntStepper：步进器，支持 min/max 范围、step 步长、precision 精度、disabled 禁用、受控 value 与非受控 defaultValue、onChange 事件回调、边界按钮自动禁用
- AntSearchBar：搜索栏，支持 placeholder 占位文本、maxLength 最大长度、showCancelButton 取消按钮、cancelText 取消按钮文本、onSearch/onCancel/onFocus/onBlur 事件回调、搜索图标与清除按钮
- AntPicker：底部弹窗选择器，支持 columns 多列数据、title 标题、confirmText/cancelText 确认取消文本、closeOnMaskClick 遮罩关闭、受控 visible 与受控 value、onConfirm/onCancel/onSelect/onClose 事件回调
- AntPickerView：内嵌选择器视图，支持 columns 多列数据、itemHeight 行高、受控 value 与非受控 defaultValue、onChange 事件回调、滚轮联动
- AntCascaderView：内嵌级联选择视图，支持 options 树形选项、placeholder 占位文本、高度自定义、层级 Tab 切换、选中后自动跳转下一层级、受控 value 与非受控 defaultValue、onChange(value, items)/onTabsChange 事件回调、禁用选项
- AntCalendarPicker：日历选择器，支持 selectionMode（single/range）单选/范围选择、weekStartsOn（monday/sunday）周起始日、min/max 日期范围、allowClear 清除选择、月份导航、底部弹窗版与内嵌视图（AntCalendarPickerView）、受控 value 与非受控 defaultValue、onConfirm/onCancel/onClose/onChange 事件回调
- Widget test：Stepper 14 个 + SearchBar 12 个 + Picker 14 个 + PickerView 12 个 + CascaderView 16 个 + CalendarPicker 28 个测试用例全量通过
- Example demo 页：Stepper 8 个 + SearchBar 6 个 + Picker 7 个 + PickerView 5 个 + CascaderView 8 个 + CalendarPicker 8 个展示区块

## 0.14.0-beta.1

新增 Form 表单、AutoComplete 自动补全、Cascader 级联选择、TreeSelect 树选择、Mentions 提及、Transfer 穿梭框、Upload 上传与 ColorPicker 颜色选择器组件（Phase 5 数据录入组件第三批）。

- AntForm：表单，支持 form 表单控制器（getFieldsValue/setFieldsValue/resetFields/submit）、name 表单名、layout（horizontal/vertical）、initialValues 初始值、onFinish 提交回调、onFinishFailed 提交失败回调、disabled 表单级禁用、AntFormField 表单项（name/rules/label/required）
- AntAutoComplete：自动补全，支持 options 选项列表（value/label）、filterOption 自定义过滤、size（large/middle/small）、placeholder、disabled、受控 value 与非受控 defaultValue、onChange/onSelect 事件回调
- AntCascader：级联选择，支持 options 树形选项（value/label/children/disabled）、changeOnSelect 允许选择父级、showSearch 搜索过滤、size、placeholder、disabled、受控 value 与非受控 defaultValue、onChange/onChangeComplete 事件回调
- AntTreeSelect：树选择，支持 treeData 树形数据（key/title/children/disabled）、treeDefaultExpandAll 默认展开全部、treeCheckable 复选模式、size、placeholder、disabled、受控 value 与非受控 defaultValue、onChange 事件回调
- AntMentions：提及，支持 options 选项列表（value/label）、split 分隔符、prefix 触发字符、size、placeholder、disabled、受控 value 与非受控 defaultValue、onChange/onSelect 事件回调
- AntTransfer：穿梭框，支持 dataSource 数据源（key/title/description/disabled）、targetKeys 目标项、selectedKeys 选中项、showSearch 搜索、titles 标题、operations 操作文案、disabled、onChange/onSelectChange 事件回调
- AntUpload：上传，支持 listType（text/picture/pictureCard）、accept 接受文件类型、multiple 多选、maxCount 最大数量、defaultFileList 默认文件列表、showUploadList 显示列表、disabled、onSelectFiles 选择回调、onChange/onRemove/onPreview 事件回调
- AntColorPicker：颜色选择器，支持 format（hex/rgb/hsl/hsb）颜色格式、showText 显示文本、presets 预设色板、disabledAlpha 禁用透明度、allowClear 允许清空、size（large/middle/small）、disabled、受控 value 与非受控 defaultValue、onChange/onChangeComplete 事件回调
- Widget test：Form 15 个 + AutoComplete 11 个 + Cascader 20 个 + TreeSelect 23 个 + Mentions 19 个 + Transfer 23 个 + Upload 24 个 + ColorPicker 19 个测试用例全量通过
- Example demo 页：Form 7 个 + AutoComplete 6 个 + Cascader 5 个 + TreeSelect 5 个 + Mentions 5 个 + Transfer 6 个 + Upload 8 个 + ColorPicker 11 个展示区块

## 0.13.0-beta.1

新增 Select 选择器、DatePicker 日期选择器、TimePicker 时间选择器、Slider 滑动输入条与 Rate 评分组件（Phase 5 数据录入组件第二批）。

- AntSelect：选择器，支持 mode（single/multiple）单选/多选、options 选项列表（value/label/disabled）、showSearch 搜索过滤、allowClear 清除按钮、loading 加载中、size（large/middle/small）、placeholder 占位文本、disabled 禁用、autofocus 自动聚焦、受控 value 与非受控 defaultValue、onChange 事件回调
- AntDatePicker：日期选择器，支持日历浮层面板（月份导航/今日高亮/范围外置灰）、format 日期格式化（yyyy-MM-dd）、allowClear 清除按钮、size（large/middle/small）、placeholder、disabled、autofocus、受控 value 与非受控 defaultValue、onChange 事件回调
- AntTimePicker：时间选择器，支持时分秒三列滚轮选择、hourStep/minuteStep/secondStep 步长、确认按钮提交、allowClear 清除按钮、size（large/middle/small）、placeholder、disabled、autofocus、受控 value 与非受控 defaultValue、onChange 事件回调
- AntSlider：滑动输入条，支持 min/max 范围、step 步长、marks 刻度标记、tooltipVisible 提示气泡控制、disabled 禁用、autofocus 自动聚焦、受控 value 与非受控 defaultValue、onChange/onChangeEnd 事件回调
- AntRate：评分组件，支持 count 星星数量、allowHalf 半星选择、allowClear 再次点击清除、character 自定义图标、disabled 禁用、autofocus 自动聚焦、受控 value 与非受控 defaultValue、onChange 事件回调
- Widget test：Select 10 个 + DatePicker 8 个 + TimePicker 8 个 + Slider 8 个 + Rate 9 个测试用例全量通过
- Example demo 页：Select 7 个 + DatePicker 5 个 + TimePicker 6 个 + Slider 5 个 + Rate 6 个展示区块

## 0.12.0-beta.1

新增 Input 输入框、InputNumber 数字输入框、Checkbox 复选框、Radio 单选框与 Switch 开关组件（Phase 5 数据录入组件首批）。

- AntInput：输入框，支持 size（large/middle/small）、status（normal/error/warning）、prefix/suffix 前后缀、addonBefore/addonAfter 外部前后置、allowClear 清除按钮、maxLength/showCount 字数统计、bordered 边框开关、disabled 禁用、受控 value 与非受控 defaultValue、onChange/onSubmit 事件回调
- AntInputTextArea：多行文本，支持 autoSize 自适应高度（boolean/对象 minRows/maxRows）、maxLength/showCount 字数统计
- AntInputPassword：密码框，支持 visibilityToggle 密码可见切换
- AntInputSearch：搜索框，支持 onSearch 搜索回调、enterButton 自定义搜索按钮
- AntInputGroup：输入框组，支持 compact 紧凑模式（合并相邻边框）
- AntInputNumber：数字输入框，支持 min/max 上下限、step 步长、precision 精度、controls（upDown/none）步进按钮模式、addonBefore/addonAfter、size、disabled、受控 value 与非受控 defaultValue、onChange/onStep 事件回调
- AntCheckbox：复选框，支持受控 checked 与非受控 defaultChecked、indeterminate 半选、disabled 禁用、value 组内联动、onChange 事件回调
- AntCheckboxGroup：复选框组，支持 options 列表与 children 两种模式、受控 value 与非受控 defaultValue、direction（horizontal/vertical）、组级 disabled、onChange 事件回调
- AntRadio：单选框，支持受控 checked 与非受控 defaultChecked、disabled 禁用、value 组内联动、onChange 事件回调
- AntRadioGroup：单选框组，支持 options 列表与 children 两种模式、optionType（normal/button）选项风格、buttonStyle（outline/solid）按钮风格、direction（horizontal/vertical）、组级 disabled、onChange 事件回调
- AntRadioButton：按钮风格单选，搭配 AntRadioGroup 使用
- AntSwitch：开关，支持受控 checked 与非受控 defaultChecked、size（middle/small）、checkedChildren/unCheckedChildren 文案、loading 加载中、disabled 禁用、onChange 事件回调
- Widget test：Input 25 个 + InputNumber 15 个 + Checkbox 19 个 + Radio 18 个 + Switch 14 个测试用例全量通过
- Example demo 页：Input 11 个 + InputNumber 8 个 + Checkbox 8 个 + Radio 9 个 + Switch 6 个展示区块

## 0.11.0-beta.1

新增 NavBar 导航栏、TabBar 标签栏、SideBar 侧边栏、IndexBar 索引栏、CapsuleTabs 胶囊选项卡与 JumboTabs 大块选项卡组件（Phase 4 导航组件第三批，导航分类全部完成）。

- AntNavBar：移动端导航栏，支持 child 标题居中、back 返回箭头、backArrow 自定义箭头、left 左侧附加、right 右侧操作、onBack 回调、border 底部分割线
- AntTabBar：底部标签栏，支持 items 列表（key/title/icon/activeIcon/badgeDot/badgeText/disabled）、activeKey 受控与 defaultActiveKey 非受控、onChange 切换回调、border 顶部边框、safeArea 底部安全区
- AntSideBar：侧边栏，支持 items 列表（key/title/badge/disabled）、activeKey 受控与 defaultActiveKey 非受控、onChange 回调、左侧高亮条动画、激活项白色背景
- AntIndexBar：字母索引栏，支持 items 列表（key/title）、onChange 回调、中央气泡提示（800ms 自动隐藏）、GlobalKey + RenderBox 精确命中检测、点击与垂直拖动选择
- AntCapsuleTabs：胶囊选项卡，支持 items 列表（key/title/disabled）、activeKey 受控与 defaultActiveKey 非受控、onChange 回调、灰色容器 + 白色激活胶囊 + 阴影
- AntJumboTabs：大块选项卡，支持 items 列表（key/title/description/disabled）、activeKey 受控与 defaultActiveKey 非受控、onChange 回调、主标题 + 描述 + 底部指示条
- Widget test：NavBar 10 个 + TabBar 15 个 + SideBar 12 个 + IndexBar 8 个 + CapsuleTabs 9 个 + JumboTabs 10 个测试用例全量通过
- Example demo 页：NavBar 6 个 + TabBar 7 个 + SideBar 4 个 + IndexBar 2 个 + CapsuleTabs 4 个 + JumboTabs 4 个展示区块
- Example 首页窄屏 AppBar 已替换为 AntNavBar

## 0.10.0-beta.1

新增 Tabs 标签页、Menu 导航菜单、Anchor 锚点与 Dropdown 下拉菜单组件（Phase 4 导航组件第二批）。

- AntTabs：标签页，支持 items 列表（key/label/child/disabled/closable）、activeKey 受控与 defaultActiveKey 非受控、type（line/card）、position（top/left/right/bottom）、closable 全局可关闭、onChange/onTabClick/onTabClose 事件回调、AnimatedSize 内容切换动画、指示条滑动动画
- AntMenu：导航菜单，支持 mode（vertical/horizontal）、items 列表（key/label/labelWidget/icon/disabled/children/type item/group/divider）、theme（light/dark）、selectedKey 受控与 defaultSelectedKey 非受控、inlineCollapsed 折叠、openKeys/subMenuOpenKeys 展开子菜单、onClick/onOpenChange 事件回调、水平模式 SubMenu 下拉弹出
- AntAnchor：锚点，支持 direction（vertical/horizontal）、items 列表（key/title/titleWidget/children 嵌套子链接）、controller 受控（setActive/activeKey）、onClick 事件回调、垂直左侧边框激活指示、水平底部边框激活指示
- AntDropdown：下拉菜单，支持 trigger（hover/click）、placement（bottomLeft/bottomRight/topLeft/topRight）、items 列表（key/label/labelWidget/icon/disabled/danger/type item/divider）、open 受控与 onOpenChange、onClick 事件回调、arrow 箭头、disabled 禁用、Overlay 浮层实现
- Widget test：Tabs 19 个 + Menu 29 个 + Anchor 15 个 + Dropdown 15 个测试用例全量通过
- Example demo 页：Tabs 6 个 + Menu 5 个 + Anchor 4 个 + Dropdown 6 个展示区块

## 0.9.0-beta.1

新增 Breadcrumb 面包屑、Steps 步骤条与 Pagination 分页组件（Phase 4 导航组件首批）。

- AntBreadcrumb：面包屑，支持 items 列表、separator 自定义分隔符（默认 '/'）、separatorWidget 自定义分隔符组件、title/titleWidget 标题、icon 图标、onClick 点击回调，最后一项为当前页面不可点击
- AntSteps：步骤条，支持 direction（horizontal/vertical）、status（wait/process/finish/error）、size（normal/small）、current 当前步骤、items 步骤配置（title/description/icon/status/disabled）、onChange 点击切换，finish 显 ✓、error 显 ✗、process 显数字白字蓝底、wait 显数字灰字，连接线颜色随状态变化
- AntPagination：分页，支持受控 current/pageSize 与非受控 defaultCurrent/defaultPageSize、showSizeChanger 每页条数切换、showQuickJumper 快速跳转、showTotal 显示总条数、simple 简单模式、disabled 禁用、size（normal/small）、pageSizeOptions 可选每页条数、onChange/onPageSizeChange 事件回调，页码生成算法支持首尾固定+当前±2+省略号跳转
- Widget test：Breadcrumb 11 个 + Steps 14 个 + Pagination 26 个测试用例全量通过
- Example demo 页：Breadcrumb 5 个 + Steps 7 个 + Pagination 7 个展示区块

## 0.8.0-beta.1

新增 SafeArea 安全区与 AutoCenter 自动居中组件（Phase 3 布局组件第四批，布局分类全部完成）。

- AntSafeArea：安全区，支持 position（top/bottom/both）、占位模式（child 为 null 时渲染安全区高度 SizedBox，对齐 antd React）与包装模式（child 不为 null 时包装子组件并添加安全区内边距，对齐 Flutter SafeArea）、maintainBottomViewPadding 键盘弹出保持底部内边距、minimum 最小内边距、left/right 左右安全区开关
- AntAutoCenter：自动居中，让内容在剩余空间中自动居中，支持 expanded 在 Flex 父级中占据剩余空间（对齐 antd React AutoCenter 行为）
- Widget test：SafeArea 14 个 + AutoCenter 7 个测试用例全量通过
- Example demo 页：SafeArea 4 个 + AutoCenter 3 个展示区块

## 0.7.0-beta.1

新增 Splitter 分割面板与 Masonry 瀑布流组件（Phase 3 布局组件第三批）。

- AntSplitter：分割面板，支持 layout（horizontal/vertical）、拖拽调整面板大小、collapsible 折叠按钮、size 受控模式、defaultSize 双击重置、min/max 尺寸约束、lazy 拖拽模式、resizable 可调整开关、onResizeStart/onResize/onResizeEnd/onCollapse/onDraggerDoubleClick 事件回调
- AntSplitterPanel：面板配置，支持 size/defaultSize/min/max/resizable/collapsible/child
- AntMasonry：瀑布流布局，支持 columns 列数（默认 3）、responsiveColumns 响应式列数（xs/sm/md/lg/xl/xxl 断点与 antd 栅格对齐）、gutter 列间距、verticalGutter 行间距、贪心分配（有 height 时放入最矮列）与轮询分配（无 height 时）
- AntMasonryItem：瀑布流项，支持 height 参与贪心分配
- Widget test：Splitter 20 个 + Masonry 12 个测试用例全量通过
- Example demo 页：Splitter 6 个 + Masonry 4 个展示区块

## 0.6.0-beta.1

新增 Grid 栅格与 Layout 布局组件（Phase 3 布局组件第二批）。

- AntRow/AntCol：24 栅格系统，支持 span 栅格占位、offset 偏移、gutter 间距、align 垂直对齐（top/middle/bottom）、justify 水平分布（start/center/end/spaceAround/spaceBetween）、wrap 换行、flex 弹性比例（覆盖 span）
- AntLayout：布局容器，支持 sider/header/content/footer 命名插槽组合，有 sider 时水平结构，无 sider 时纯垂直结构
- AntLayoutSider：侧边栏，支持 width/collapsedWidth 自定义宽度、collapsible 可折叠、defaultCollapsed 初始折叠、collapsed 受控折叠状态、theme 深色/浅色主题（dark #001529 / light colorBgContainer）、breakpoint 响应式断点自动折叠、trigger 自定义触发器、onCollapse/onBreakpoint 事件回调、AnimatedContainer 宽度动画
- AntLayoutHeader：顶部区域，高度 64，背景 colorBgContainer，支持自定义高度
- AntLayoutContent：内容区域，flex 自动填充，背景 colorBgLayout
- AntLayoutFooter：底部区域，padding 24×50，文字 colorTextSecondary
- Widget test：Grid 32 个 + Layout 32 个测试用例全量通过
- Example demo 页：Grid 9 个 + Layout 8 个展示区块
- Example 首页已用 AntLayout/AntLayoutSider/AntLayoutHeader/AntLayoutContent 替换系统布局组件

## 0.5.0-beta.1

新增 Divider 分割线、Flex 弹性布局与 Space 间距组件（Phase 3 布局组件首批）。

- AntDivider：分割线，支持 type（horizontal/vertical）、orientation（left/center/right）、orientationMargin 标题边距、plain 普通文本样式、variant（solid/dashed/dotted）、dashed 虚线便捷属性、child 标题内容、color/thickness/indent/endIndent/spacing 样式覆盖
- AntFlex：弹性布局，支持 vertical 垂直排列、wrap 换行、justify 主轴对齐（start/end/center/spaceBetween/spaceAround/spaceEvenly）、align 交叉轴对齐（start/end/center/baseline/stretch）、gap 间距（small/middle/large 预设 + all 单值 + only 行列分别）、mainAxisSize 主轴尺寸
- AntSpace：间距，支持 direction（horizontal/vertical）、size（small/middle/large 预设 + all 单值 + only 水平垂直分别）、align 交叉轴对齐（start/end/center/baseline）、wrap 换行、split 分隔符（间距均分到分隔符两侧）
- Widget test：Divider 21 个 + Flex 34 个 + Space 36 个测试用例全量通过
- Example demo 页：Divider 10 个 + Flex 8 个 + Space 8 个展示区块
- Example 首页系统 Divider/VerticalDivider/Row/Column/SizedBox 间距已替换为 AntDivider/AntFlex/AntSpace

## 0.4.0-beta.1

新增 NoticeBar 通告栏组件。

- AntNoticeBar：通告栏，支持 content 超长自动横向滚动（delay/speed）、color 语义颜色（normal/alert/error/info/success）、closeable 可关闭、icon 自定义左侧图标、extra 右侧操作区、wrap 多行展示、shape 形状（rectangular/neutral/rounded）、bordered 边框模式（block/full/none）、onClick/onClose 事件
- Widget test：25 个测试用例全量通过
- Example demo 页：10 个展示区块

## 0.3.0-beta.1

新增 FloatButton 悬浮按钮组件。

- AntFloatButton：悬浮按钮，支持 type(normal/primary)、shape(circle/square)、icon、content、href、disabled、badge(角标 count/dot)、tooltip、onClick
- AntFloatButtonGroup：悬浮按钮组，支持 trigger(click/hover) 展开/收起、placement(top/bottom/left/right) 方位、shape(circle/square)、closeIcon、AnimatedSize 展开动画
- AntFloatButtonBackTop：回到顶部，支持 visibilityHeight 显示阈值、duration 滚动时长、onClick、scrollController、AnimatedOpacity 显隐动画
- Widget test：21 个测试用例全量通过
- Example demo 页：11 个展示区块

## 0.2.0-beta.1

新增 Typography 排版组件。

- AntTypography 排版基类：支持 ellipsis 省略（tooltip/expandable）、copyable 可复制、editable 可编辑、mark 标记、delete 删除线、underline 下划线、disabled 禁用、type（secondary/success/warning/danger）
- AntTitle（h1-h5）：五级标题，字号/行高与 Ant Design token 对齐
- AntParagraph：段落，支持 ellipsis 省略与 expandable 展开/收起
- AntText：文本，支持 secondary/success/warning/danger 类型
- AntLink：链接，支持 href 与 hover 下划线
- Widget test：37 个测试用例全量通过
- Example demo 页：10 个展示区块

## 0.1.0-beta.1

首个 beta 版本。

- L1 基础层：AntPlatform 平台工具（desktop/mobile 判定 + ohos 隔离）、AntOhosChannel 抽象接口
- L2 颜色层：[antd_color](https://pub.dev/packages/antd_color) — AntFastColor / antGeneratePalette / AntColor / antParseColor
- L2 令牌层：[antd_tokens](https://pub.dev/packages/antd_tokens) — AntSeedToken / AntTokenGenerators / AntColorTokens / AntShadowTokens
- L3 主题层：[antd_theme](https://pub.dev/packages/antd_theme) — AntThemeData / AntTheme / AntBreakpoint / AntScreenUtilInit
- 图标资源层：[antd_icons_flutter](https://pub.dev/packages/antd_icons_flutter) — 698 TTF 图标（outlined 447 + filled 251）+ 150 twotone SVG 图标
- L4 组件层：AntButton（primary/default/dashed/text/link + danger + loading + icon + block）
- 响应式适配：flutter_screenutil 集成（.w/.sp/.r，禁 .h）