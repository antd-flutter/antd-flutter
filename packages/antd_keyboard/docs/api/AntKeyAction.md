<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyAction

> 种类：枚举

```dart
enum AntKeyAction
```

按键动作类型

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `text` | 文本输入键 |
| `backspace` | 退格（支持长按连续删除） |
| `space` | 空格 |
| `confirm` | 确认 |
| `hide` | 收起键盘 |
| `shift` | Shift（一次性大写/副字符，输入后自动复位） |
| `capslock` | CapsLock（持久大写/副字符锁定） |
| `modeSwitch` | 布局模式切换（循环 modes） |
| `enter` | 回车/换行 |
| `tab` | Tab（仅触发 onKey，由调用方决定语义） |
| `none` | 占位（不渲染交互内容） |

