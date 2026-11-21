<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardOverlayController

> 种类：类

```dart
class AntKeyboardOverlayController
```

通用键盘浮层控制器：把任意键盘组件停靠到根 `Overlay` 上。

吸收参考库的 overlay 承载方式，并补上原实现缺失的能力：
- `alignTop` 真正生效（旧实现字段恒为 false，参数被吞）；
- 入场/退场滑动动画，退场动画结束后才移除 OverlayEntry；
- 可选的遮罩与点击遮罩关闭；
- 桌面端浮层留边 + 圆角/阴影（键盘自身主题负责），移动端贴底；
- Esc 关闭（桌面物理键盘），再次打开后重新注册监听。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_alignTop` | `bool` | — |
| `_animationDuration` | `Duration` | — |
| `_barrierColor` | `Color?` | — |
| `_dismissOnTapOutside` | `bool` | — |
| `_disposed` | `bool` | — |
| `_entry` | `OverlayEntry?` | — |
| `_lastDismiss` | `VoidCallback?` | — |
| `_lastKeyboard` | `Widget?` | — |
| `_visible` | `ValueNotifier<bool>?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `alignTop` | `bool` | 当前是否贴顶 |
| `showing` | `bool` | 当前是否显示（退场动画期间即为 false） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_handleKey` | `bool` | — |
| `_removeEntry` | `void` | 立即移除（不播动画） |
| `dispose` | `void` | 释放：移除浮层与 Esc 监听 |
| `hide` | `void` | 收起键盘（触发 dismiss，并播放退场动画） |
| `realign` | `void` | 切换贴顶/贴底，保持键盘与 dismiss 绑定不变 |
| `show` | `void` | 显示键盘 |
| `isOverlayAvailable` | `bool` | 当前环境是否可插入 Overlay |

