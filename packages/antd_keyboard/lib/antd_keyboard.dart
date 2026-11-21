/// antd_keyboard — antd-mobile 虚拟键盘族独立组件包（通用键盘引擎 + 三组件）
///
/// 从 antd_flutter_ui 拆分的独立组件包（参照 antd_picker 先例）：
/// - [AntKeyboard] — 通用键盘引擎（布局预设 + 自定义布局 + 长按变体 + 主题）
/// - [AntNumberKeyboard] — 数字键盘（numeric / decimal，对齐 antd-mobile API）
/// - [AntPasscodeInput] — 密码输入框（配合数字键盘的格子密码输入）
/// - [AntVirtualInput] — 虚拟输入框（自定义虚拟键盘文本输入）
///
/// 归属边界：引擎（ant_keyboard 三件 + keyboard_input_model / input_platform /
/// keyboard_overlay 共享文件，grep 核实仅键盘族使用）随包迁出 ui engines；
/// ui 包无其他消费方，AntInputField 仅注释提及、无代码引用。
///
/// 依赖方向约定：antd_keyboard → antd_theme / material_ui，不依赖 antd_flutter_ui
/// 及其他独立组件包（引擎零 ui 依赖）。
/// 浮层唤起类组件（Overlay 弹出键盘，非滚动场景），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容（零符号破坏）。
library;

export 'src/engines/ant_keyboard/ant_keyboard.dart';
export 'src/engines/ant_keyboard/ant_keyboard_layout.dart';
export 'src/engines/ant_keyboard/ant_keyboard_theme.dart';

export 'src/engines/keyboard_input_model.dart';
export 'src/engines/input_platform.dart';
export 'src/engines/keyboard_overlay.dart';

export 'src/number_keyboard/ant_number_keyboard.dart';
export 'src/number_keyboard/ant_number_keyboard_types.dart';

export 'src/passcode_input/ant_passcode_input.dart';
export 'src/passcode_input/ant_passcode_input_types.dart';

export 'src/virtual_input/ant_virtual_input.dart';
export 'src/virtual_input/ant_virtual_input_types.dart';
