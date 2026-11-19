<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardOverlayController

> 种类：类

```dart
class AntKeyboardOverlayController
```

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_entry` | `OverlayEntry?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `showing` | `bool` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hide` | `void` | — |
| `show` | `void` | 在屏幕底部弹出键盘 |
| `isOverlayAvailable` | `bool` | 兼容无 Overlay 环境（如部分测试裸泵组件）：返回 false 表示未支持弹出 |

