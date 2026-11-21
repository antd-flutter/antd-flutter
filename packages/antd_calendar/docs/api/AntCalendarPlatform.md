<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarPlatform

> 种类：枚举

```dart
enum AntCalendarPlatform
```

日历平台渲染器选择（C1 引入；auto 按 `AntPlatform` 分派）。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `auto` | 自动：移动端 → mobile 渲染器，其余 → desktop 渲染器 |
| `desktop` | 强制桌面渲染器（antd v6 形态，C1 阶段兼容 fullscreen/card 两种布局） |
| `mobile` | 强制移动渲染器（antd-mobile v5 形态） |

