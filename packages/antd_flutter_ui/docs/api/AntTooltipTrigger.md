<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTooltipTrigger

> 种类：枚举

```dart
enum AntTooltipTrigger
```

气泡触发方式。

未显式指定时按平台自动选择：桌面端 hover，移动端 click。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `hover` | 悬停触发（桌面端） |
| `click` | 点击 / 长按触发（移动端） |
| `focus` | 焦点触发 |

