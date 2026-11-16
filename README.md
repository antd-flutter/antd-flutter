# antd-flutter

[![pub package](https://img.shields.io/pub/v/antd_flutter_plus.svg)](https://pub.dev/packages/antd_flutter_plus)

> [!WARNING]
> **Beta 软件包 — 请勿用于生产环境。** antd_flutter_plus 目前处于公测阶段 (0.x.0-beta.x)。在达到 1.0.0 版本之前，API 可能会在没有通知的情况下发生变更。仅将其用于评估、演示或开发试用。

> [!WARNING]
> **Beta 阶段 — 暂不建议在生产环境使用。** antd_flutter_plus 当前处于 beta 阶段（0.x.0-beta.x），API 在 1.0.0 正式发布前可能随时变动，请仅用于评估、演示或开发体验。
Ant Design v6 Flutter 组件库。基于 Ant Design 设计规范与 Design Token 体系，融合 antd v6（桌面端）与 antd-mobile v5（移动端）组件体系，在 Flutter 上实现的高质量跨平台组件库。

## 特性

- **Design Token 体系** — 与 antd v6 源码逐一断言对齐的令牌层，支持亮/暗色主题与 Token 覆写
- **桌面 + 移动端融合** — 共性组件统一一套按平台响应式适配，移动端特有组件（NavBar/TabBar/Picker/Toast 等）独立提供
- **跨平台** — 支持 Web / Windows / macOS / Linux / Android / iOS（鸿蒙 ohos 规划中待 Flutter 3.50 支持）
- **响应式适配** — flutter_screenutil 集成（`.w`/`.sp`/`.r`），AntBreakpoint 断点与 antd 栅格一致
- **API 对齐 antd React 版** — PascalCase Widget + camelCase 参数，降低迁移成本

## 安装

```yaml
dependencies:
  antd_flutter_plus: ^0.1.0-beta.1
```

## 快速上手

```dart
import 'package:antd_flutter_plus/antd_flutter_plus.dart';

void main() {
  runApp(AntScreenUtilInit(
    builder: (context, child) => AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: AntButton(
              onPressed: () {},
              child: Text('Hello antd-flutter'),
            ),
          ),
        ),
      ),
    ),
  ));
}
```

## 包结构

| 包 | 层级 | 说明 |
|---|---|---|
| [antd_color](https://pub.dev/packages/antd_color) | L2 颜色 | AntFastColor / 色板生成 / 颜色解析（零三方依赖） |
| [antd_tokens](https://pub.dev/packages/antd_tokens) | L2 令牌 | SeedToken / 令牌生成器 / 亮暗色色值 / 阴影令牌 |
| [antd_theme](https://pub.dev/packages/antd_theme) | L3 主题 | AntThemeData / AntTheme / 断点 / ScreenUtil 封装 |
| [antd_icons_flutter](https://pub.dev/packages/antd_icons_flutter) | 图标 | 698 TTF 图标（outlined/filled）+ 150 twotone SVG |
| **antd_flutter_plus** | L1+L4 | 平台工具 + 全部组件（聚合导出以上四包） |

## 组件实现进度

> 图例：✅ 已实现 ｜ 📋 计划中（📱 为移动端特有组件）

**总体：57 / 111**

### 通用 — 5/5 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Button | ✅ | primary/default/dashed/text/link + danger + loading + icon + block |
| Icon | ✅ | [antd_icons_flutter](https://pub.dev/packages/antd_icons_flutter) — 698 TTF（outlined/filled）+ 150 twotone SVG |
| Typography | ✅ | Title(h1-h5) / Paragraph / Text / Link + copyable / editable / ellipsis / mark / delete |
| FloatButton | ✅ | 悬浮按钮 + FloatButtonGroup(trigger/placement) + FloatButtonBackTop + badge 角标 |
| NoticeBar 📱 | ✅ | 通告栏，滚动/多行/可关闭/5种语义颜色/3种形状/边框模式 |

### 布局 — 9/9 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Divider | ✅ | 水平/垂直/solid/dashed/dotted/带文字/orientation/orientationMargin/plain |
| Flex | ✅ | vertical/wrap/justify/align/gap(small/middle/large/all/only)/mainAxisSize |
| Grid | ✅ | Row/Col 24 栅格 + span/offset/gutter/align/justify/wrap/flex |
| Layout | ✅ | Sider(折叠/断点/深浅主题) + Header/Content/Footer 组合 |
| Space | ✅ | direction/size(small/middle/large/all/only)/align/wrap/split |
| Splitter | ✅ | 拖拽调整/折叠/受控/双击重置/lazy/min/max |
| Masonry | ✅ | columns/responsiveColumns(断点)/gutter/贪心+轮询分配 |
| SafeArea 📱 | ✅ | top/bottom/both + 占位模式/包装模式/键盘适配 |
| AutoCenter 📱 | ✅ | 自动居中 + expanded 弹性布局占满剩余空间 |

### 导航 — 13/13 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Breadcrumb | ✅ | items/separator/separatorWidget/title/titleWidget/icon/onClick |
| Steps | ✅ | horizontal/vertical/normal/small/wait/process/finish/error/onChange |
| Pagination | ✅ | 受控/非受控/showSizeChanger/showQuickJumper/showTotal/simple/small |
| Tabs | ✅ | line/card 样式 + top/left/right/bottom 位置 + closable 关闭 + 受控/非受控 |
| Menu | ✅ | vertical/horizontal + SubMenu 展开 + light/dark 主题 + 折叠 + 分组/分割线 |
| Anchor | ✅ | vertical/horizontal + 嵌套子链接 + controller 受控 + 边框激活指示 |
| Dropdown | ✅ | hover/click 触发 + 四方向弹出 + 分割线/禁用/危险项 + arrow 箭头 + 受控 |
| NavBar 📱 | ✅ | 标题居中 + 返回箭头 + 左侧附加 + 右侧操作 + 底部分割线 |
| TabBar 📱 | ✅ | 底部 Tab 切换 + Badge 角标（圆点/文字）+ 激活图标 + safeArea |
| SideBar 📱 | ✅ | 左侧高亮条动画 + 激活白底 + 角标 + 禁用项 |
| IndexBar 📱 | ✅ | 字母索引 + 中央气泡提示 + 精确命中检测 + 点击/拖动 |
| CapsuleTabs 📱 | ✅ | 胶囊选项卡 + 灰色容器白底激活 + 阴影 + 禁用项 |
| JumboTabs 📱 | ✅ | 大选项卡 + 主标题/描述 + 底部指示条 |

### 数据录入 — 30/30 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Input | ✅ | TextArea/Password/Search/Group + 前后缀/addon/清除/字数统计/状态/尺寸 |
| InputNumber | ✅ | 数字输入框 + 上下限/步长/精度/controls 模式/addon |
| Checkbox | ✅ | 多选框 + 半选/受控/组(options/children)/纵向/组禁用 |
| Radio | ✅ | 单选框 + 按钮风格(outline/solid)/组/纵向/组禁用 |
| Switch | ✅ | 开关 + 尺寸/文案/加载中/禁用/受控 |
| Select | ✅ | 单选/多选 + 搜索过滤/清除/加载中/尺寸/禁用 |
| DatePicker | ✅ | 日历浮层面板 + 月份导航/format 格式化/清除/尺寸 |
| TimePicker | ✅ | 时分秒三列滚轮 + 步长/确认按钮/清除/尺寸 |
| Slider | ✅ | 滑动输入条 + 范围/步长/刻度标记/提示气泡 |
| Rate | ✅ | 评分 + 半星/清除/自定义图标/数量/禁用 |
| Form | ✅ | 表单 + form 控制器(getFieldsValue/setFieldsValue/resetFields/submit) + rules 校验 + layout |
| AutoComplete | ✅ | 自动补全 + options/filterOption/受控/onSelect |
| Cascader | ✅ | 级联选择 + 树形选项/changeOnSelect/showSearch/受控 |
| TreeSelect | ✅ | 树选择 + treeData/默认展开/复选模式/受控 |
| Mentions | ✅ | 提及 + options/prefix/split/受控/onSelect |
| Transfer | ✅ | 穿梭框 + dataSource/targetKeys/selectedKeys/showSearch |
| Upload | ✅ | 上传 + listType(text/picture/pictureCard)/maxCount/showUploadList |
| ColorPicker | ✅ | 颜色选择器 + format(hex/rgb/hsl/hsb)/presets/disabledAlpha/allowClear |
| Stepper 📱 | ✅ | 步进器 + min/max/step/precision + 边界按钮禁用 + 受控 |
| SearchBar 📱 | ✅ | 搜索栏 + placeholder/maxLength/取消按钮/onSearch/onCancel |
| Picker 📱 | ✅ | 底部弹窗选择器 + 多列滚轮/确认取消/遮罩关闭/受控 visible |
| PickerView 📱 | ✅ | 内嵌滚轮选择器视图 + 多列联动/受控 value/onChange |
| CascaderView 📱 | ✅ | 级联选择视图 + 层级 Tab/自动跳转/onTabsChange/禁用选项 |
| CalendarPicker 📱 | ✅ | 日历选择器 + single/range 模式/周起始日/min/max/月份导航 + 弹窗版与内嵌视图 |
| CheckList 📱 | ✅ | 复选列表 + multiple 单选/多选/items/showCheckMark/activeIcon/受控 |
| Selector 📱 | ✅ | 选择组 + options/multiple/columns/选中主色边框/受控 |
| NumberKeyboard 📱 | ✅ | 数字键盘 + confirmText/customKey/randomOrder/maxLength/受控 |
| PasscodeInput 📱 | ✅ | 密码格子输入 + length/plain/error/separated/onFill/内置键盘 |
| VirtualInput 📱 | ✅ | 虚拟输入 + placeholder/clearable/confirmText/onEnterPress/内置键盘 |
| ImageUploader 📱 | ✅ | 图片上传 + maxCount/columns/preview/deletable/onPickImage/状态展示 |

### 数据展示 — 27/28 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Avatar | ✅ | 尺寸/形状(shape/circle/square)/图标/图片/文字 + Group 最大数量折叠 + 状态色 |
| Badge | ✅ | count/overflowCount/圆点/文字 + 状态色 + status-dot + offset 偏移 + size |
| Tag | ✅ | 预设色/checkable 可勾选/closable 可关闭/borderless + 图标 |
| Card | ✅ | title/extra/cover/actions + size + hoverable/bordered + 内嵌模式 |
| Empty | ✅ | image 自定义图片/描述文字/children 自定义内容 |
| Image | ✅ | cached_network_image 缓存加载 + 全屏预览(缩放/组切换) + fit/radius/fallback/previewSrc |
| Statistic | ✅ | value 精度/千分位分隔/前后缀/title + 倒计时模式 + 状态色 |
| Table | ✅ | 排序三态/筛选菜单/固定列吸边/吸顶表头/虚拟滚动/分页/size/loading/empty |
| Descriptions | ✅ | label/值列表 + column/span 跨列/bordered/size/colon/横纵布局 |
| Timeline | ✅ | mode 左右交替 + 节点色预设/自定义节点/pending/reverse/label 标签列 |
| Collapse | ✅ | 手风琴/受控多开 + 展开动画/箭头位置/自定义图标/borderless/size |
| List | ✅ | 泛型懒加载列表 + header/footer/size/bordered/split/actions/extra/空态/loading/分页 |
| Calendar | ✅ | 月视图 6×7 + 周起始日/今天高亮/disabledDate/fullscreen+card 双模式/dateCell 自定义 |
| Carousel | ✅ | PageView 手势 + autoplay/loop/指示点四方位/箭头/垂直/受控/goTo |
| Popover | ✅ | 气泡卡片 + title/content + 九方向 + 箭头/自定义背景 + hover/点击触发 + 受控 |
| Tooltip | ✅ | 文字提示 + 12 方向 + 箭头/自定义颜色 + hover/点击/焦点触发 + 受控/延迟 |
| Segmented | ✅ | 分段控制器 + 滑块动画 + String/Item 选项 + block/size/shape + 受控/禁用 |
| QRCode | ✅ | 二维码 + 纠错等级 L/M/Q/H + 自定义颜色/尺寸 + expired/scanned 状态 + icon 模式 |
| Tree | ✅ | 多级树 + 展开动画/父子勾选联动/半选/checkStrictly/选中/showLine/受控 |
| Tour | ✅ | 分步引导 + GlobalKey 目标定位/挖孔遮罩高亮/卡片跟随/步骤指示/跳过完成 |
| Ellipsis 📱 | ✅ | 多行截断(start/end/middle) + rows/expandText/collapseText 展开收起 |
| Footer 📱 | ✅ | 默认回顶部文案 + onClick/child 自定义 |
| PageIndicator 📱 | ✅ | 指示点 + 受控 current/激活动画/横纵方向/自定义颜色尺寸 |
| ImageViewer 📱 | ✅ | 全屏查看 + 缩放/双击/左右切换/页码/关闭动画 |
| InfiniteScroll 📱 | ✅ | 滚动触底加载 + threshold/loading/失败重试/没有更多 + 自定义文案 |
| FloatingPanel 📱 | ✅ | 锚点拖拽面板 + 把手自定义/吸附动画/onHeightChange/内容滚动 |
| FloatingBubble 📱 | ✅ | 可拖拽悬浮球 + axis 方向约束/边界钳制/点击展开菜单/自定义图标 |

### 反馈 — 21/21 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Message | ✅ | 顶部全局提示 + 四类型/loading/队列叠加/自动消失/手动关闭 |
| Modal | ✅ | 居中对话框 + 受控/confirmLoading/footer/遮罩配置 + showAntModal 函数式 |
| Alert | ✅ | 四类型语义色 + description/closable/showIcon/action/banner |
| Progress | ✅ | 线性+Circle 自绘圆弧 + 状态色/自定义颜色/format/动画过渡 |
| Skeleton | ✅ | avatar/title/paragraph 组合 + rows/active 闪烁/自定义骨架 |
| Notification | ✅ | 四角堆叠通知 + title/description/类型图标/时长/可关闭/滑入动画 |
| Drawer | ✅ | 四方向侧滑 + 动画/title/closable/footer/遮罩配置 |
| Spin | ✅ | 转圈 + 三档尺寸/tip/child 包裹遮罩/自定义指示器 |
| Result | ✅ | 语义状态图标 + 404/403/500 数字 + title/subTitle/extra |
| Popconfirm | ✅ | 确认气泡 + 十二方向/自定义按钮文案/回调/受控/禁用 |
| Watermark | ✅ | CustomPainter 平铺水印 + 多行/字号颜色角度/间距/点击穿透 |
| Toast 📱 | ✅ | 中央深色卡片 + icon 类型/loading 手动关闭/位置三档/穿透配置 |
| ActionSheet 📱 | ✅ | 底部动作面板 + danger/disabled/description/取消区/closeOnAction |
| PullToRefresh 📱 | ✅ | 手势下拉 + 阈值触发/状态机/回弹动画/自定义头部与文案 |
| Dialog 📱 | ✅ | 移动端小卡片 + alert/confirm 函数式/自定义 actions/遮罩配置 |
| Popup 📱 | ✅ | 四方向滑入弹层 + 关闭图标/遮罩配置/内容滚动 |
| Mask 📱 | ✅ | 全屏遮罩 + 透明度/颜色/点击回调/上层内容/淡入淡出 |
| SwipeAction 📱 | ✅ | 左右滑动手势 + 跟随位移/松手吸附/超半宽展开/回调收起/danger/disabled |
| Loading 📱 | ✅ | 轻量转圈 + size/color/速度/child 组合/方向 |
| ErrorBlock 📱 | ✅ | 自绘插画四种状态 + 默认文案/自定义 children 操作区 |
| ResultPage 📱 | ✅ | 页面级结果 + 五状态图标/description 明细列表/buttons 操作区 |

### 其他 — 4/4 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Affix | ✅ | 页面固定 + offsetTop/offsetBottom/change 回调/占位不跳动 |
| App | ✅ | 根部上下文 + message/notification/modal 无 context 调用 |
| ConfigProvider | 📋 | 国际化 + 主题入口 |
| BorderBeam | 📋 | 边框光效 |

## 链接

- [官网](https://antd-flutter.github.io/antd-flutter/)
- [图标 Gallery](https://antd-flutter.github.io/antd-flutter/icons/)
- [GitHub](https://github.com/antd-flutter/antd-flutter)
- [问题反馈](https://github.com/antd-flutter/antd-flutter/issues)

## License

MIT