/// antd_tree — Ant Design v6 Tree / TreeSelect 独立组件包（数据展示类，无 sliver 依赖）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntTree] — 泛型树形控件（展开/收起、选中、复选父子联动/严格模式、连接线、缩进）
/// - [AntTreeKeyOf] / [AntTreeTitleBuilder] / [AntTreeChildrenOf] /
///   [AntTreeDisabledOf] / [AntTreeCheckableOf] — 泛型数据读取回调
/// - [AntTreeOnCheck] — 勾选回调（checkedKeys + halfCheckedKeys，元素为 keyOf 提取的 key）
/// - [AntTreeSelect] — 泛型树选择下拉组件（单选/多选、默认展开、尺寸、禁用项）
/// - [AntTreeSelectKeyOf] / [AntTreeSelectLabelOf] / [AntTreeSelectTitleBuilder] /
///   [AntTreeSelectChildrenOf] / [AntTreeSelectDisabledOf] — 泛型数据读取回调
/// - [AntTreeSelectSize] — 树选择尺寸
/// - [AntTreeNode] / [AntTreeSelectOption] / [AntTreeSelectFieldNames] — 旧模型，已废弃
///
/// 依赖方向约定：antd_tree → antd_theme（+ material_ui），
/// 不依赖主包 antd_flutter_plus；主包通过 export re-export 保持零符号破坏。
///
/// ```dart
/// import 'package:antd_tree/antd_tree.dart';
///
/// AntTree<Region>(
///   dataSource: regions,
///   keyOf: (region) => region.id,
///   titleBuilder: (context, region) => Text(region.name),
///   childrenOf: (region) => region.children,
///   checkable: true,
///   onCheck: (checkedKeys, halfCheckedKeys) {},
/// );
/// ```
library;

export 'src/tree/ant_tree.dart';
export 'src/tree_select/ant_tree_select.dart';
