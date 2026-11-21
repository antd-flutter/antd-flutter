<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopupMotion

> 种类：类

```dart
class AntPopupMotion
```

弹层单项出现动画 — fade + 方向滑入 / 缩放淡入。

供 `AntOverlayShell` 内部使用，也供轻提示族（Message / Notification）
堆叠项直接复用，统一各弹层的出现动画实现。

## 构造函数

### `AntPopupMotion({super.key, required this.animation, required this.child, this.slideBegin, this.scaleFrom})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `animation` | `Animation<double>` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `slideBegin` | `Offset?` | 可选 | — |
| `scaleFrom` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `animation` | `Animation<double>` | 动画进度（通常为 CurvedAnimation） |
| `child` | `Widget` | 内容 |
| `scaleFrom` | `double?` | 缩放淡入起始缩放 |
| `slideBegin` | `Offset?` | 方向滑入起始偏移 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

