<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntControlHeightToken

> 种类：类

```dart
class AntControlHeightToken
```

控件高度令牌，对应 antd Map Token 的控件高度部分（`genControlHeight`）。

由 `antGenControlHeight` 从基准高度按比例派生。

## 构造函数

### `AntControlHeightToken({required this.controlHeightSM, required this.controlHeightXS, required this.controlHeightLG})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `controlHeightSM` | `double` | 可选 | — |
| `controlHeightXS` | `double` | 可选 | — |
| `controlHeightLG` | `double` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `controlHeightLG` | `double` | 大号控件高度（基准 × 1.25） |
| `controlHeightSM` | `double` | 小号控件高度（基准 × 0.75） |
| `controlHeightXS` | `double` | 特小号控件高度（基准 × 0.5） |

