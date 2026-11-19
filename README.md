# antd_flutter_plus

[![pub package](https://img.shields.io/pub/v/antd_flutter_plus.svg)](https://pub.dev/packages/antd_flutter_plus)

Ant Design v6 Flutter 组件库的**全量伞包** — 106 个组件经 re-export 一站式接入，一次依赖获得完整组件能力（含主题 / Design Token / 颜色 / 图标基础能力）。

> 拆分后的组件库以「基础库 + 独立单组件包」形式维护，本伞包经 re-export 聚合全部组件，对外 API 符号保持兼容（零符号破坏）。

## 安装

```yaml
dependencies:
  antd_flutter_plus: ^1.0.0-beta.2
```

## 用法

### 方式一：伞包接入（推荐快速试用 / 完整体验）

一次引入，全部组件直接可用：

```dart
import 'package:antd_flutter_plus/antd_flutter_plus.dart';

AntButton(
  child: const Text('按钮'),
  onPressed: () {},
)

AntPicker(
  columns: [
    ['周一', '周二', '周三'],
  ],
  onConfirm: (values) {},
)

AntImageViewer(
  images: ['https://example.com/a.png'],
  open: visible,
  onClose: () => setState(() => visible = false),
)
```

### 方式二：单组件包接入（对包体积与依赖面敏感的生产项目）

只引入所需组件对应的包，依赖面最小化：

```yaml
dependencies:
  antd_flutter_ui: ^0.1.0-beta.1 # 基础库（必引，含主题/令牌与通用组件）
  antd_picker: ^0.1.0-beta.1     # 按需组件包
```

```dart
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_picker/antd_picker.dart';

AntButton(
  child: const Text('按钮'),
  onPressed: () {},
)
```

## 包清单

### 基础设施

| 包 | 版本 | 说明 |
| --- | --- | --- |
| [antd_flutter_ui](packages/antd_flutter_ui/README.md) | 0.1.0-beta.1 | 基础库：共享引擎 + 通用组件层 |
| [antd_tokens](packages/antd_tokens/README.md) | 1.0.0 | Design Token 系统（seed token / 令牌生成算法） |
| [antd_theme](packages/antd_theme/README.md) | 1.0.0 | 主题系统（主题数据 / 阴影 / 断点 / 屏幕适配） |
| [antd_color](packages/antd_color/README.md) | 1.0.0 | 颜色系统（FastColor / 色板生成 / 颜色解析） |
| [antd_icons_flutter](packages/antd_icons_flutter/README.md) | 1.0.1 | 图标库（850+ 图标：outlined / filled / twotone） |

### 独立组件包

| 包 | 版本 | 说明 |
| --- | --- | --- |
| [antd_calendar](packages/antd_calendar/README.md) | 0.1.0-beta.1 | Calendar 日历（月面板，桌面/移动双形态） |
| [antd_carousel](packages/antd_carousel/README.md) | 0.1.0-beta.1 | Carousel 走马灯（自动播放 / 循环 / 指示点） |
| [antd_floating](packages/antd_floating/README.md) | 0.1.0-beta.1 | Floating 浮动面板（拖拽 / 锚点吸附） |
| [antd_form](packages/antd_form/README.md) | 0.1.0-beta.1 | Form 表单（受控/非受控 + 校验规则） |
| [antd_image_viewer](packages/antd_image_viewer/README.md) | 0.1.0-beta.1 | ImageViewer 图片预览（双指缩放 / 平移 / 多图切换） |
| [antd_keyboard](packages/antd_keyboard/README.md) | 0.1.0-beta.1 | 虚拟键盘族（通用键盘引擎 / NumberKeyboard 等） |
| [antd_masonry](packages/antd_masonry/README.md) | 0.1.0-beta.1 | Masonry 瀑布流（最短列贪心分布） |
| [antd_picker](packages/antd_picker/README.md) | 0.1.0-beta.1 | Picker 选择器族（Picker / DatePicker / TimePicker / Cascader） |
| [antd_qrcode](packages/antd_qrcode/README.md) | 0.1.0-beta.1 | QRCode 二维码（纠错级别 / 状态遮罩） |
| [antd_refresh](packages/antd_refresh/README.md) | 0.1.0-beta.1 | PullToRefresh 下拉刷新（手势状态机） |
| [antd_splitter](packages/antd_splitter/README.md) | 0.1.0-beta.1 | Splitter 分隔面板（拖拽分割 / 最小尺寸约束） |
| [antd_swipe_action](packages/antd_swipe_action/README.md) | 0.1.0-beta.1 | SwipeAction 滑动操作（左滑/右滑操作按钮） |
| [antd_table](packages/antd_table/README.md) | 0.1.0-beta.1 | Table 表格（排序 / 筛选 / 固定列头 / 行选择） |
| [antd_transfer](packages/antd_transfer/README.md) | 0.1.0-beta.1 | Transfer 穿梭框（双面板多选） |
| [antd_tree](packages/antd_tree/README.md) | 0.1.0-beta.1 | Tree / TreeSelect（展开折叠 / 选择 / 复选） |
| [antd_upload](packages/antd_upload/README.md) | 0.1.0-beta.1 | Upload 上传（文件列表 / 进度） |

## 文档

- [官网](https://antd-flutter.github.io/antd-flutter/)
- [图标 Gallery](https://antd-flutter.github.io/antd-flutter/icons/)
- [GitHub](https://github.com/antd-flutter/antd-flutter)
- [GitCode](https://gitcode.com/antd-flutter/antd-flutter)
- [问题反馈](https://github.com/antd-flutter/antd-flutter/issues)

## License

MIT
