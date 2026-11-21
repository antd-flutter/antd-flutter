/// antd_transfer — antd-mobile 穿梭框独立组件包（Transfer / TreeTransfer）
///
/// 从主包 antd_flutter_plus（此前在 ui）拆分的独立组件包：
/// - [AntTransfer] — 泛型双栏穿梭框（多选 / 受控 / 搜索过滤 / 禁用项 / oneWay 单向）
/// - [AntTransferKeyOf] / [AntTransferTitleBuilder] / [AntTransferDescriptionOf] /
///   [AntTransferChildrenOf] / [AntTransferDisabledOf] / [AntTransferOnChange] —
///   泛型数据读取与回调类型
/// - [AntTransferItem] — 旧数据项，已废弃；组件不再要求使用
///
/// 多级树形穿梭（TreeTransfer 增强）随迁：父子勾选联动、半选（indeterminate）、
/// 禁用子树联动、树形展示与树模式搜索过滤，均为数据驱动：
/// 提供 `childrenOf` 即进入树形模式，无需显式开关。
///
/// 归属边界：AntCheckbox（含 indeterminate 半选）为 ui 共享基础组件，留
/// antd_flutter_ui 不迁；本包经 ui barrel 引用。
///
/// 依赖方向约定：antd_transfer → antd_flutter_ui → antd_theme/tokens/color/icons，
/// 不依赖其他独立组件包。
/// 穿梭框为固定布局类组件（双栏列表，非滚动场景），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
///
/// ```dart
/// AntTransfer<Attachment>(
///   dataSource: attachments,
///   keyOf: (item) => item.id,
///   titleBuilder: (context, item) => Text(item.name),
///   descriptionOf: (item) => item.sizeLabel,
///   onChange: (targetKeys, direction, moveKeys) {},
/// );
/// ```
library;

export 'src/transfer/ant_transfer.dart';
export 'src/transfer/ant_transfer_types.dart';
