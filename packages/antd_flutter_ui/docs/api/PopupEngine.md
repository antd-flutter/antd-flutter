<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# PopupEngine

> 种类：类

```dart
class PopupEngine
```

统一弹层位置计算引擎。

算法来源：minikin/popover（MIT）的 PopoverRenderShiftedBox 方向决策 /
边界翻转 / 滑动夹回逻辑的 Dart 移植与简化。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `defaultMargin` | `double` | 视口内边距默认值（气泡与视口边缘的最小距离） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_decompose` | `(AntPopupDirection, AntPopupAlign)` | 把 placement 拆成（主方向，沿边对齐） |
| `_flip` | `AntPopupDirection` | 翻到对侧 |
| `solve` | `AntPopupLayout` | 解析弹层位置 |

