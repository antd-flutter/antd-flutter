/// antd_tree — Ant Design v6 Tree / TreeSelect 独立组件包（数据展示类，无 sliver 依赖）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntTree] — 树形控件（展开/收起、选中、复选父子联动/严格模式、连接线、缩进）
/// - [AntTreeNode] — 树节点数据
/// - [AntTreeOnCheck] — 勾选回调（checkedKeys + halfCheckedKeys）
/// - [AntTreeSelect] — 树选择下拉组件（单选/多选、默认展开、尺寸、禁用项）
/// - [AntTreeSelectOption] — 树选择选项
/// - [AntTreeSelectSize] — 树选择尺寸
/// - [AntTreeSelectFieldNames] — 自定义字段名
///
/// 依赖方向约定：antd_tree → antd_theme（+ material_ui），
/// 不依赖主包 antd_flutter_plus；主包通过 export re-export 保持零符号破坏。
///
/// ```dart
/// import 'package:antd_tree/antd_tree.dart';
///
/// AntTree(
///   treeData: [
///     AntTreeNode(key: 'zj', title: '浙江', children: [
///       AntTreeNode(key: 'hz', title: '杭州'),
///     ]),
///   ],
///   checkable: true,
///   onCheck: (checkedKeys, halfCheckedKeys) {},
/// );
/// ```
library;

export 'src/tree/ant_tree.dart';
export 'src/tree_select/ant_tree_select.dart';
