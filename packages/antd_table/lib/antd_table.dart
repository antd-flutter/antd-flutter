/// antd_table — Ant Design v6 Table 表格组件独立包。
///
/// 从 antd_flutter_ui（display/table）拆分的独立组件包：
/// - [AntTable] — 表格（含全部高级用法：排序/筛选/固定列/固定表头/
///   行选择/合并单元格/展开行/树形数据/分页/汇总行/分组表头）
/// - [AntColumnType] 等类型定义（ant_table_types.dart）
///
/// 归属边界：Table 为自包含数据展示组件，仅依赖 antd_theme 与
/// material_ui，不引用 ui 包组件，无共享引擎留存 ui。
///
/// 依赖方向约定：antd_table → antd_theme，不依赖 antd_flutter_ui
/// 及其他独立组件包。
/// Table 表格横向滚动场景判定不需要 sliver 支持（R33）：
/// 现有实现为固定布局 + 表体内部滚动（固定列经位置计算实现），
/// 不依赖外层滚动位置；横向滚动经 SingleChildScrollView 在组件内部完成。
///
/// 后续增强项（随包迁移，不阻塞本次拆分）：
/// - 虚拟滚动（antd React Table virtual 能力）
/// - 列宽拖拽调整
/// - 可编辑单元格
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/table/ant_table.dart';
export 'src/table/ant_table_types.dart';
