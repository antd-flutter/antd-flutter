# antd_keyboard

Ant Design（antd-mobile）虚拟键盘族独立组件包：通用键盘引擎 + 三组件，从 `antd_flutter_ui` 迁出（参照 `antd_picker` 拆分先例）。

## 组件

| 组件 | 说明 |
| --- | --- |
| `AntKeyboard` | 通用屏上键盘引擎：numeric / decimal / text / symbol / email 五布局预设 + 自定义布局（`AntKeyboardLayout`），长按变体气泡、长按连删、主题从 `AntTheme` 派生或 `AntKeyboardThemeData` 覆盖 |
| `AntNumberKeyboard` | 数字键盘（antd-mobile 兼容用法）：受控 value、maxLength、confirmText、randomOrder 乱序、customKey 槽位键、desktop 桌面形态 |
| `AntPasscodeInput` | 密码格子输入：length、plain 明文、separated 分隔、error、受控/非受控，keyboard: true 时唤起数字键盘 |
| `AntVirtualInput` | 虚拟输入框：placeholder、clearable、confirmText、keyboardLayout 自定义布局、keyboardDesktop 桌面键盘 |

## 引擎（随包迁出 ui engines）

- `lib/src/engines/ant_keyboard/`：`AntKeyboard` / `AntKeyboardLayout` / `AntKeyboardThemeData`
- `lib/src/engines/keyboard_input_model.dart` / `input_platform.dart` / `keyboard_overlay.dart`：键盘族共享文件（grep 核实仅键盘族使用，随包自持）

## 依赖方向

`antd_keyboard` → `antd_theme` / `material_ui`（引擎零 `antd_flutter_ui` 依赖），不依赖其他独立组件包。

## 移动端形态与 R36 安全区

- 移动端（iOS/Android）固定触控形态：键触控目标 ≥44（自定义过小 keyHeight 自动钳制）、无 hover 反馈（MouseRegion 仅桌面注入）、按压态反馈；桌面端未传主题时自动桌面密度（48 键高 + hover），显式 `desktop: false` 保持移动形态（API 兼容）。
- R36：引擎贴底时经 `MediaQuery` bottom inset 避让 home indicator/手势条；经 `AntKeyboardOverlayController` 弹出时外层 SafeArea 已消费 inset，不重复避让。

## R33 判定

键盘为**浮层唤起类**组件（Overlay 弹出键盘，非滚动场景），**不需要 sliver 支持**（R33）。

## 主包兼容

主包 `antd_flutter_plus` 对三组件 re-export `package:antd_keyboard/...`，对外零符号破坏；`antd_flutter_ui` 已移除对应目录与 barrel 导出。

## 运行 example

见 [example/README.md](example/README.md)。
