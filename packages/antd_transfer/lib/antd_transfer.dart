/// antd_transfer — antd-mobile 穿梭框独立组件包（Transfer / TreeTransfer）
///
/// 从主包 antd_flutter_plus（此前在 ui）拆分的独立组件包：
/// - [AntTransfer] — 双栏穿梭框（多选 / 受控 / 搜索过滤 / 禁用项 / oneWay 单向）
/// - [AntTransferItem] — 数据项（携带 children 即为树形 TreeTransfer 模式）
///
/// 多级树形穿梭（TreeTransfer 增强）随迁：父子勾选联动、半选（indeterminate）、
/// 禁用子树联动、树形展示与树模式搜索过滤，均为数据驱动无需显式开关。
///
/// 归属边界：AntCheckbox（含 indeterminate 半选）为 ui 共享基础组件，留
/// antd_flutter_ui 不迁；本包经 ui barrel 引用。
///
/// 依赖方向约定：antd_transfer → antd_flutter_ui → antd_theme/tokens/color/icons，
/// 不依赖其他独立组件包。
/// 穿梭框为固定布局类组件（双栏列表，非滚动场景），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/transfer/ant_transfer.dart';
export 'src/transfer/ant_transfer_types.dart';
