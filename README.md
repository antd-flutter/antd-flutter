# antd-flutter

[![pub package](https://img.shields.io/pub/v/antd_flutter_plus.svg)](https://pub.dev/packages/antd_flutter_plus)

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

**总体：32 / 111**

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

### 数据录入 — 5/30 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Input | ✅ | TextArea/Password/Search/Group + 前后缀/addon/清除/字数统计/状态/尺寸 |
| InputNumber | ✅ | 数字输入框 + 上下限/步长/精度/controls 模式/addon |
| Checkbox | ✅ | 多选框 + 半选/受控/组(options/children)/纵向/组禁用 |
| Radio | ✅ | 单选框 + 按钮风格(outline/solid)/组/纵向/组禁用 |
| Switch | ✅ | 开关 + 尺寸/文案/加载中/禁用/受控 |
| Select | 📋 | 单选/多选/搜索 |
| DatePicker | 📋 | 日期选择框 |
| TimePicker | 📋 | 时间选择框 |
| Slider | 📋 | 滑动输入条 |
| Rate | 📋 | 评分 |
| Form | 📋 | 表单校验引擎 |
| AutoComplete | 📋 | 自动补全 |
| Cascader | 📋 | 级联选择 |
| TreeSelect | 📋 | 树选择 |
| Mentions | 📋 | 提及 |
| Transfer | 📋 | 穿梭框 |
| Upload | 📋 | 上传 |
| ColorPicker | 📋 | 颜色选择器 |
| Stepper 📱 | 📋 | 步进器，+/- 长按连增 |
| SearchBar 📱 | 📋 | 搜索栏 |
| Picker 📱 | 📋 | 底部弹出滚轮选择器 |
| PickerView 📱 | 📋 | 内嵌滚轮选择器视图 |
| CascaderView 📱 | 📋 | 级联选择视图 |
| CalendarPicker 📱 | 📋 | 日历选择器 |
| CheckList 📱 | 📋 | 复选列表 |
| Selector 📱 | 📋 | 选择组 |
| NumberKeyboard 📱 | 📋 | 数字键盘 |
| PasscodeInput 📱 | 📋 | 密码格子输入框 |
| VirtualInput 📱 | 📋 | 虚拟输入 |
| ImageUploader 📱 | 📋 | 图片上传 |

### 数据展示 — 0/28 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Avatar | 📋 | 头像 |
| Badge | 📋 | 徽标数 |
| Tag | 📋 | 标签 |
| Card | 📋 | 卡片 |
| Empty | 📋 | 空状态 |
| Image | 📋 | 图片 + 预览 |
| Statistic | 📋 | 统计数值 |
| Table | 📋 | 排序/筛选/固定列/虚拟滚动 |
| Descriptions | 📋 | 描述列表 |
| Timeline | 📋 | 时间轴 |
| Collapse | 📋 | 折叠面板 |
| List | 📋 | 列表 |
| Calendar | 📋 | 日历 |
| Carousel | 📋 | 走马灯 + 移动端手势滑动 |
| Popover | 📋 | 气泡卡片 |
| Tooltip | 📋 | 文字提示 |
| Segmented | 📋 | 分段控制器 |
| QRCode | 📋 | 二维码 |
| Tree | 📋 | 树形控件 |
| Tour | 📋 | 漫游引导 |
| Ellipsis 📱 | 📋 | 文本省略 |
| Footer 📱 | 📋 | 页脚 |
| PageIndicator 📱 | 📋 | 页面指示器 |
| ImageViewer 📱 | 📋 | 全屏图片查看器 |
| InfiniteScroll 📱 | 📋 | 无限滚动 |
| FloatingPanel 📱 | 📋 | 浮动面板 |
| FloatingBubble 📱 | 📋 | 浮动气泡 |

### 反馈 — 0/21 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Message | 📋 | 全局提示 |
| Modal | 📋 | 对话框 + 移动端底部弹出 |
| Alert | 📋 | 警告提示 |
| Progress | 📋 | 进度条 + Circle 环形变体 |
| Skeleton | 📋 | 骨架屏 |
| Notification | 📋 | 通知提醒框 |
| Drawer | 📋 | 抽屉 |
| Spin | 📋 | 加载中 |
| Result | 📋 | 结果 |
| Popconfirm | 📋 | 气泡确认框 |
| Watermark | 📋 | 水印 |
| Toast 📱 | 📋 | 轻提示 |
| ActionSheet 📱 | 📋 | 动作面板 |
| PullToRefresh 📱 | 📋 | 下拉刷新 |
| Dialog 📱 | 📋 | 移动端对话框 |
| Popup 📱 | 📋 | 弹出层 |
| Mask 📱 | 📋 | 遮罩层 |
| SwipeAction 📱 | 📋 | 滑动操作 |
| Loading 📱 | 📋 | 加载 |
| ErrorBlock 📱 | 📋 | 错误块 |
| ResultPage 📱 | 📋 | 结果页 |

### 其他 — 0/4 完成

| 组件 | 状态 | 说明 |
|---|---|---|
| Affix | 📋 | 固钉 |
| App | 📋 | 全局上下文 |
| ConfigProvider | 📋 | 国际化 + 主题入口 |
| BorderBeam | 📋 | 边框光效 |

## 链接

- [官网](https://antd-flutter.github.io/antd-flutter/)
- [图标 Gallery](https://antd-flutter.github.io/antd-flutter/icons/)
- [GitHub](https://github.com/antd-flutter/antd-flutter)
- [问题反馈](https://github.com/antd-flutter/antd-flutter/issues)

## License

MIT