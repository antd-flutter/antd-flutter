/// antd_splitter — Ant Design v6 Splitter 独立组件包（固定布局类，无 sliver 依赖）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntSplitter] — 可拖拽分隔面板容器（对齐 antd React Splitter API）
/// - [AntSplitterPanel] — 面板（默认/受控尺寸、min/max 约束、折叠）
/// - [AntSplitterLayout] — 布局方向（horizontal / vertical）
/// - [AntSplitterCollapseCallback] — 折叠/展开回调
///
/// 依赖方向约定：antd_splitter → antd_theme / antd_icons_flutter（+ material_ui），
/// 不依赖其他独立组件包；拖拽分割引擎为单包独享，留在包内不上移。
/// 分割器为固定布局类组件（拖拽调整面板尺寸，非滚动场景），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/splitter/ant_splitter.dart';
export 'src/splitter/ant_splitter_types.dart';
