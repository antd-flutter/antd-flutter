<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntButtonType

> 种类：枚举

```dart
enum AntButtonType
```

按钮类型（antd `type` 属性）。

对应 antd v6 的 5 种 button type，每种映射到默认的 `AntButtonColor` +
`AntButtonVariant` 组合（详见 `AntButtonVariantResolver`）。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `normal` | 默认按钮 → color=default, variant=outlined |
| `primary` | 主按钮 → color=primary, variant=solid |
| `dashed` | 虚线按钮 → color=default, variant=dashed |
| `link` | 链接按钮 → color=link, variant=link |
| `text` | 文本按钮 → color=default, variant=text |

