<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSizeMapToken

> 种类：类

```dart
class AntSizeMapToken
```

尺寸映射令牌，对应 antd Map Token 的尺寸部分（`genSizeMapToken`）。

由 `antGenSizeMapToken` 从 `sizeUnit × sizeStep` 派生 XXS…XXL 间距阶梯。

## 构造函数

### `AntSizeMapToken({required this.sizeXXL, required this.sizeXL, required this.sizeLG, required this.sizeMD, required this.sizeMS, required this.size, required this.sizeSM, required this.sizeXS, required this.sizeXXS})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `sizeXXL` | `double` | 可选 | — |
| `sizeXL` | `double` | 可选 | — |
| `sizeLG` | `double` | 可选 | — |
| `sizeMD` | `double` | 可选 | — |
| `sizeMS` | `double` | 可选 | — |
| `size` | `double` | 可选 | — |
| `sizeSM` | `double` | 可选 | — |
| `sizeXS` | `double` | 可选 | — |
| `sizeXXS` | `double` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `size` | `double` | 默认间距（unit × step，默认 16） |
| `sizeLG` | `double` | 大间距（unit × (step + 2)，默认 24） |
| `sizeMD` | `double` | 中间距（unit × (step + 1)，默认 20） |
| `sizeMS` | `double` | 中小间距（unit × step，默认 16） |
| `sizeSM` | `double` | 小间距（unit × (step |
| `sizeXL` | `double` | 超大间距（unit × (step + 4)，默认 32） |
| `sizeXS` | `double` | 特小间距（unit × (step |
| `sizeXXL` | `double` | 特大间距（unit × (step + 8)，默认 48） |
| `sizeXXS` | `double` | 极小间距（unit × (step |

