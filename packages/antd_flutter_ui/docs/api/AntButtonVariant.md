<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntButtonVariant

> 种类：枚举

```dart
enum AntButtonVariant
```

按钮变体（antd v6 `variant` 属性）。

决定按钮的填充方式（背景/边框/文字颜色的组合规则）。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `outlined` | 描边：背景=容器色，边框=色基，文字=色基 |
| `dashed` | 虚线描边：同 outlined 但边框为虚线 |
| `solid` | 实心：背景=色基，边框透明，文字=浅色 |
| `filled` | 填充：背景=色浅阶，边框透明，文字=色基 |
| `text` | 纯文本：背景透明，文字=色基 |
| `link` | 链接：背景透明，文字=链接色 |

