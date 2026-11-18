/// antd_pull_to_refresh — Ant Design PullToRefresh（下拉刷新）独立组件包
///
/// 从主包 antd_flutter_plus 拆分的独立组件包（零包内依赖）：
/// - [AntPullToRefresh] — 下拉刷新组件（对齐 antd-mobile v5 PullToRefresh API）
/// - [AntPullToRefreshStatus] / [AntPullToRefreshPointer] — 类型定义
///
/// 依赖方向约定：antd_pull_to_refresh → antd_theme（+ material_ui），
/// 不依赖其他独立组件包；刷新手势状态机为单包独享引擎，留在包内不上移。
/// 包裹类组件（child 需自行提供可滚动组件），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/pull_to_refresh/ant_pull_to_refresh.dart';
export 'src/pull_to_refresh/ant_pull_to_refresh_types.dart';
