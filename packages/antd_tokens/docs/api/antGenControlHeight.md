<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGenControlHeight

> 种类：函数

```dart
AntControlHeightToken antGenControlHeight(double controlHeight)
```

Generates control height variants from a base height.

对应 antd `genControlHeight`：SM = 0.75 ×、XS = 0.5 ×、LG = 1.25 ×。

```dart
final h = antGenControlHeight(32);
h.controlHeightLG; // 40
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `controlHeight` | `double` | 可选 | — |

返回 `AntControlHeightToken`。

