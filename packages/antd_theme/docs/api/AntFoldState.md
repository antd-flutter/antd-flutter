<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFoldState

> 种类：枚举

```dart
enum AntFoldState
```

折叠屏状态。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `unknown` | 未知（平台无法获取折叠信息时的默认值） |
| `flat` | 完全展开（大屏单屏） |
| `halfOpened` | 半折叠（悬停态，铰链姿势 half-opened） |
| `folded` | 折叠（合上） |

