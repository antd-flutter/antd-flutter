<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_keyboard API 文档总览

> 自动生成时间：2026-11-21T23:54:44.464194；共 22 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（14）

| 名称 | 说明 |
| --- | --- |
| [`AntKeyboard`](api/AntKeyboard.md) | 通用屏上键盘 |
| [`AntKeyboardController`](api/AntKeyboardController.md) | 通用键盘控制器 — 修饰键 / 模式 / 文本绑定 / 物理键盘协作 |
| [`AntKeyboardFieldBinding`](api/AntKeyboardFieldBinding.md) | 键盘文本绑定：把 AntKeyboardController 连接到真实的 TextEditingControll… |
| [`AntKeyboardKey`](api/AntKeyboardKey.md) | 键盘按键统一模型 |
| [`AntKeyboardKeyView`](api/AntKeyboardKeyView.md) | 单个键的基础容器（引擎与数字键盘共用） |
| [`AntKeyboardLayout`](api/AntKeyboardLayout.md) | 键盘布局 |
| [`AntKeyboardLayouts`](api/AntKeyboardLayouts.md) | 预设注册表（AntKeyboardLayouts.of(preset) → 布局实例） |
| [`AntKeyboardOverlayController`](api/AntKeyboardOverlayController.md) | 通用键盘浮层控制器：把任意键盘组件停靠到根 Overlay 上 |
| [`AntKeyboardRow`](api/AntKeyboardRow.md) | 键盘行 leading / trailing 对齐参考库 KeyboardRow：在按键序列两端插入固定 宽度的附… |
| [`AntKeyboardThemeData`](api/AntKeyboardThemeData.md) | AntKeyboard 主题数据 |
| [`AntNumberKeyboard`](api/AntNumberKeyboard.md) | 数字键盘 — 移动端完全对齐 antd-mobile v5 NumberKeyboard，桌面端取 antd v6… |
| [`AntPasscodeInput`](api/AntPasscodeInput.md) | 密码格子输入 — 用于验证码/密码场景的格子输入组件 |
| [`AntVirtualInput`](api/AntVirtualInput.md) | 虚拟输入 — 通过内置键盘输入的只读输入框 |
| [`KeyboardInputBuffer`](api/KeyboardInputBuffer.md) | 键盘输入缓冲 — 受控/非受控两种模式下的按键追加与退格 |

## 枚举（3）

| 名称 | 说明 |
| --- | --- |
| [`AntKeyAction`](api/AntKeyAction.md) | 按键动作类型 |
| [`AntKeyboardOverlayAlignment`](api/AntKeyboardOverlayAlignment.md) | 键盘浮层停靠位置 |
| [`AntKeyboardPreset`](api/AntKeyboardPreset.md) | 键盘预设类型（便捷参数 |

## 函数（2）

| 名称 | 说明 |
| --- | --- |
| [`buildNumberKeyOrder`](api/buildNumberKeyOrder.md) | 数字键盘按键序（1-9），支持乱序 |
| [`isDesktopInputPlatform`](api/isDesktopInputPlatform.md) | 当前是否为桌面平台（桌面端不使用自定义虚拟键盘，直接走系统输入） |

## 常量（3）

| 名称 | 说明 |
| --- | --- |
| [`antKeyboardTapRegionGroup`](api/antKeyboardTapRegionGroup.md) | 输入框与键盘浮层共享的点击区域分组：落在键盘上的点击不算「点外部」， 输入框的 TapRegion 因此不会误收起键盘 |
| [`kAntKeyboardMinTouchTarget`](api/kAntKeyboardMinTouchTarget.md) | 触控目标最小尺寸（移动端可点击区域不得小于 44×44） |
| [`kAntNumberKeyboardKeyHeight`](api/kAntNumberKeyboardKeyHeight.md) | 数字键盘默认键高（antd-mobile 48 / antd v6 56），与主题解析保持一致 |

