# antd_keyboard example

Ant Design（antd-mobile）虚拟键盘族演示画廊：通用键盘引擎 [AntKeyboard] + AntNumberKeyboard / AntPasscodeInput / AntVirtualInput 三组件。

## 运行

```bash
cd packages/antd_keyboard/example
flutter pub get
flutter run -d macos   # 或 chrome / 其他设备
flutter test           # example widget test
```

## 覆盖形态（五个分区 Tab）

| 分区 | 内容 |
| --- | --- |
| AntKeyboard 引擎 | numeric / decimal / text / symbol / email 五布局预设 + custom 自定义布局；text 布局长按字母键可呼出变体气泡；退格键支持长按连删 |
| NumberKeyboard | 基础数字键盘、confirmText 确认键、randomOrder 乱序、customKey 自定义槽位键（AntNumberKeyboard 兼容用法） |
| PasscodeInput | 密码格子输入（keyboard: true 唤起数字键盘）、明文 + 分隔样式（plain / separated） |
| VirtualInput | 虚拟输入框（默认数字键盘 / 自定义 QWERTY 布局 + confirmText） |
| 桌面形态 | desktop / keyboardDesktop 桌面密度与 hover 形态 |

## 平台适配

- **R35.4**：AntResponsiveInit + AntLayoutData 断点布局——desktop 宽屏（≥768 / lg+）双栏 Wrap、phone 窄屏单栏，窗口缩放无溢出；AntScreenUtilInit（375×812 设计稿）提供 .w / .sp 缩放。
- **暗色切换**：AppBar 右上角按钮联动 AntTheme + themeMode，键盘主题（AntKeyboardThemeData）从 AntTheme 派生自动跟随。
- **R32.2**：图标与应用名（AntdKeyboard）经 `scripts/setup_example_identity.sh --pkg antd_keyboard --example packages/antd_keyboard/example --name AntdKeyboard` 统一注入，全平台覆盖。
- **R33 判定**：键盘为浮层唤起类组件（Overlay 弹出，非滚动场景），不需要 sliver 支持。
