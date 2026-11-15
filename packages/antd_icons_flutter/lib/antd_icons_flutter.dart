/// antd_icons_flutter — Ant Design 图标库
///
/// 850+ 图标，三种风格全覆盖：
/// - **Outlined**（线框）447 个 + **Filled**（实心）251 个 — TTF 字体模式
/// - **TwoTone**（双色）150 个 — SVG 资产 + flutter_svg 渲染
///
/// 用法：
/// ```dart
/// // 方式一：统一 AntdIcon 组件（推荐）
/// AntdIcon(AntIcons.checkOutlined)
/// AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red)
///
/// // 方式二：TTF 图标直接用 Flutter Icon
/// Icon(AntIcons.searchOutlined, size: 24, color: Colors.blue)
/// ```
library;

export 'src/ant_icons.dart';
export 'src/ant_icons_twotone.dart';
export 'src/antd_icon.dart';