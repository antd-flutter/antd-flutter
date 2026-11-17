<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFontSizePair

> 种类：类

```dart
class AntFontSizePair
```

字号-行高对。

由 `antGenFontSizes` 生成，对应 antd 字号阶梯中的单项。

## 构造函数

### `AntFontSizePair(this.size, this.lineHeight)`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `size` | `double` | 可选 | — |
| `lineHeight` | `double` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `lineHeight` | `double` | 推荐行高，按 (size + 8) / size 计算 |
| `size` | `double` | 字号（逻辑像素），恒为偶数（除 antGenFontSizes 中回填的基准字号外） |

