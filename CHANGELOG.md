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