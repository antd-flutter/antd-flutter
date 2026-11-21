/// antd_floating — Ant Design v6 Floating 独立组件包（overlay 悬浮类）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntFloatingPanel] — 可拖拽的底部浮动面板，锚点间平滑移动并动画吸附
/// - [AntFloatingPanelController] — 面板程序化控制（吸附到锚点/展开/收起/重置）
/// - [AntFloatingBubble] — 可拖拽悬浮气泡，支持菜单展开与边缘磁吸
/// - [AntFloatingBubbleController] — 气泡程序化控制（显示/隐藏/吸附边缘/重置位置）
///
/// 依赖方向约定：antd_floating → antd_theme（+ material_ui），
/// 不依赖主包 antd_flutter_plus；主包通过 export re-export 保持零符号破坏。
///
/// R33 判定：浮动面板/气泡为 overlay 悬浮类组件（Stack/Overlay 内悬浮定位），
/// 不参与 CustomScrollView 滚动组合，**不需要 sliver 变体**。
///
/// ```dart
/// import 'package:antd_floating/antd_floating.dart';
///
/// AntFloatingPanel(
///   anchors: [0.3, 0.6, 1],
///   child: ListView(children: [Text('内容')]),
/// );
///
/// AntFloatingBubble(
///   initialPos: Offset(300, 500),
///   child: Icon(AntIcons.editOutlined),
/// );
/// ```
library;

export 'src/floating_panel/ant_floating_panel.dart';
export 'src/floating_panel/ant_floating_panel_types.dart';
export 'src/floating_bubble/ant_floating_bubble.dart';
export 'src/floating_bubble/ant_floating_bubble_types.dart';
