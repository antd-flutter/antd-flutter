<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarLayout

> 种类：枚举

```dart
enum AntCalendarLayout
```

日历布局形态（双实现切换）。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `auto` | 自动：经 AntResponsive 自适应（desktop/web → fullscreen，phone/tab… |
| `fullscreen` | 强制桌面形态（fullscreen 大格子 + dateCell 内容插槽 + 头部年月下拉） |
| `card` | 强制移动形态（紧凑面板 + 滑动手势） |

