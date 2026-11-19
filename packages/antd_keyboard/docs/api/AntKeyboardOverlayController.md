<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardOverlayController

> 种类：类

```dart
class AntKeyboardOverlayController
```

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_alignTop` | `bool` | — |
| `_entry` | `OverlayEntry?` | — |
| `_lastDismiss` | `VoidCallback?` | — |
| `_lastKeyboard` | `Widget?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `showing` | `bool` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_handleKey` | `bool` | Esc 收起本地实现：弹出态监听硬件按键，hide 即注销（R37 语义） |
| `hide` | `void` | — |
| `realign` | `void` | 重新弹出（保持最近一次配置）并切换对齐（贴底/贴顶） |
| `show` | `void` | 在屏幕底部弹出键盘 |
| `isOverlayAvailable` | `bool` | 兼容无 Overlay 环境（如部分测试裸泵组件）：返回 false 表示未支持弹出 |

