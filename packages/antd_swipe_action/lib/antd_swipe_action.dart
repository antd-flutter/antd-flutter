/// antd_swipe_action — Ant Design SwipeAction（滑动操作）独立组件包
///
/// 从主包 antd_flutter_plus 拆分的独立组件包（零包内依赖）：
/// - [AntSwipeAction] — 滑动操作组件（对齐 antd-mobile v5 SwipeAction API）
/// - [AntSwipeActionItem] — 操作按钮配置
///
/// 依赖方向约定：antd_swipe_action → antd_theme（+ material_ui），
/// 不依赖其他独立组件包；滑动手势吸附状态为单包独享引擎，留在包内不上移。
/// 行内手势组件（child 为任意 Widget），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/swipe_action/ant_swipe_action.dart';
export 'src/swipe_action/ant_swipe_action_types.dart';
