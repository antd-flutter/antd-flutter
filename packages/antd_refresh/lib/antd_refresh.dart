/// antd_refresh — Ant Design 滚动刷新独立组件包（零包内依赖）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包，职责分离为两个可组合控件：
/// - [AntPullToRefresh] — 下拉刷新（对齐 antd-mobile v5 PullToRefresh API），
///   只做下拉刷新，不负责上拉加载；
/// - [AntInfiniteScroll] — 无限滚动 / 上拉加载更多（对齐 InfiniteScroll API），
///   只做滚动到底自动加载，不负责下拉刷新。
///
/// 两者相互独立、互不依赖，可自由组合：
/// 下拉刷新组件包裹无限滚动列表即得完整「下拉刷新 + 上拉加载」体验。
///
/// 依赖方向约定：antd_refresh → antd_theme（+ material_ui），
/// 不依赖其他独立组件包；刷新手势状态机为单包独享引擎，留在包内不上移。
/// 包裹类组件（child 需自行提供可滚动组件），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/infinite_scroll/ant_infinite_scroll.dart';
export 'src/pull_to_refresh/ant_pull_to_refresh.dart';
export 'src/pull_to_refresh/ant_pull_to_refresh_header.dart';
export 'src/pull_to_refresh/ant_pull_to_refresh_types.dart';
