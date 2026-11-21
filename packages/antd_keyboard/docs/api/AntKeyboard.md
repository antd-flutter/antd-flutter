<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboard

> 种类：类

```dart
class AntKeyboard
```

通用屏上键盘。

布局引擎吸收自 `flutter_onscreen_keyboard`：按「行 → 权重 flex」排布，
行支持 leading/trailing 附加组件，键分文本键 / 动作键两类；修饰态
（Shift/CapsLock）采用 XOR，文本通过可选的 `controller` 直接写入
`TextEditingController`（支持选区替换、inputFormatters、emoji 退格、
enter 提交/换行、tab 插入）。

双端形态（仓库 R38 规则）：
- 移动端：键高 48、1px 描边、4 圆角、无 hover，对齐 antd-mobile v5；
- 桌面端：`colorBgElevated` 浮层 + `colorFillSecondary` 键面 +
  `boxShadowSecondary` 阴影 + hover/pressed 反馈，对齐 antd v6。

## 构造函数

### `AntKeyboard({super.key, required this.layout, this.theme, this.controller, this.confirmText, this.onTextInput, this.onBackspace, this.onConfirm, this.onHide, this.onKey, this.showControlBar = false, this.onAlignTop, this.onAlignBottom, this.backspaceHoldDelay = const Duration(milliseconds: 700), this.backspaceRepeatInterval = const Duration(milliseconds: 150), this.handleHardwareKeys = false, this.showSurface = true, this.contentPadding})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `layout` | `AntKeyboardLayout` | 可选 | — |
| `theme` | `AntKeyboardThemeData?` | 可选 | — |
| `controller` | `AntKeyboardController?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `onTextInput` | `ValueChanged<String>?` | 可选 | — |
| `onBackspace` | `VoidCallback?` | 可选 | — |
| `onConfirm` | `VoidCallback?` | 可选 | — |
| `onHide` | `VoidCallback?` | 可选 | — |
| `onKey` | `ValueChanged<AntKeyboardKey>?` | 可选 | — |
| `showControlBar` | `bool` | = false | — |
| `onAlignTop` | `VoidCallback?` | 可选 | — |
| `onAlignBottom` | `VoidCallback?` | 可选 | — |
| `backspaceHoldDelay` | `Duration` | = const Duration(milliseconds: 700) | — |
| `backspaceRepeatInterval` | `Duration` | = const Duration(milliseconds: 150) | — |
| `handleHardwareKeys` | `bool` | = false | — |
| `showSurface` | `bool` | = true | — |
| `contentPadding` | `EdgeInsets?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `backspaceHoldDelay` | `Duration` | 退格长按后开始连续删除的延迟 |
| `backspaceRepeatInterval` | `Duration` | 退格连续删除间隔 |
| `confirmText` | `String?` | 确认键文案（动作键自身的 actionLabel 优先） |
| `contentPadding` | `EdgeInsets?` | 覆盖面板内边距 |
| `controller` | `AntKeyboardController?` | 可选控制器：绑定输入框、驱动修饰态与模式 |
| `handleHardwareKeys` | `bool` | 是否接管桌面物理键盘（无输入框聚焦时把按键回灌到键盘） |
| `layout` | `AntKeyboardLayout` | 键盘布局（单模式 rows 或多模式 modes） |
| `onAlignBottom` | `VoidCallback?` | 控制条「贴底」回调 |
| `onAlignTop` | `VoidCallback?` | 控制条「贴顶」回调 |
| `onBackspace` | `VoidCallback?` | 退格回调 |
| `onConfirm` | `VoidCallback?` | 确认 / 单行回车回调 |
| `onHide` | `VoidCallback?` | 收起键盘回调（hide 键 / Esc） |
| `onKey` | `ValueChanged<AntKeyboardKey>?` | 任意键点击回调（先于具体动作触发） |
| `onTextInput` | `ValueChanged<String>?` | 文本输入回调 |
| `showControlBar` | `bool` | 是否显示右上角的贴顶/贴底控制条 |
| `showSurface` | `bool` | 是否绘制键盘面板背景（嵌入自定义容器时可关闭） |
| `theme` | `AntKeyboardThemeData?` | 主题覆盖 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntKeyboard>` | — |

