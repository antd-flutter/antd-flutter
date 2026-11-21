/// antd_form — antd-mobile 表单组件独立包（Form / FormItem / FormController）
///
/// 从 ui 包（antd_flutter_ui）拆分的独立组件包（P08 批次 2）：
/// - [AntForm] — 表单容器（受控/非受控，initialValues / onFinish / onFinishFailed）
/// - [AntFormItem] — 表单字段（label / rules / 校验错误提示 / builder 绑定控件）
/// - [AntFormField] — builder 字段状态（value / errorText / didChange）
/// - [AntFormFieldRule] — 校验规则（required / pattern / 长度 / 数值范围 / 自定义 validator）
/// - [AntFormController] — 表单控制器（编程式读写值、校验、提交、重置）
///
/// 归属边界结论（读码评估）：
/// - AutoComplete / Mentions 为独立输入联想组件，**未被 Form 源码引用**
///   （ant_form.dart 仅 import antd_theme / material_ui / 自身 types），
///   留在 antd_flutter_ui（data_entry/auto_complete、data_entry/mentions）不迁。
/// - Form 与 Input 系组件的联动发生在业务层（builder 组合 AntInput 等），
///   本包经 ui barrel 引用 ui 组件，不重复持有。
///
/// 依赖方向约定：antd_form → antd_flutter_ui → antd_theme/tokens/color/icons，
/// 不依赖其他独立组件包。
/// 表单类组件为常规布局组件，非滚动场景，不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/form/ant_form.dart';
export 'src/form/ant_form_types.dart';
