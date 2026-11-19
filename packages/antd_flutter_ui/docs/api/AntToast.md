<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntToast

> 种类：类

```dart
class AntToast
```

轻提示 — 在屏幕中央（或指定位置）展示深色半透明圆角卡片反馈。

对齐 antd-mobile Toast：静态方法 `show` 弹出提示，自动消失（默认
2000ms），loading 类型不自动消失，多条展示时替换当前提示。

## 构造函数

### `AntToast._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_active` | `_ActiveToast?` | — |
| `_overlayEntry` | `OverlayEntry?` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_remove` | `void` | — |
| `_resolveDuration` | `Duration?` | 各图标类型的默认消失策略 |
| `show` | `AntToastHandle` | 弹出一条轻提示，返回句柄可手动关闭 |

