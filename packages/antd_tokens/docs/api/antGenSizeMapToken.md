<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGenSizeMapToken

> 种类：函数

```dart
AntSizeMapToken antGenSizeMapToken({required double sizeUnit, required double sizeStep})
```

Generates the size map token from seed size values.

对应 antd `genSizeMapToken`，公式为 `sizeUnit * (sizeStep ± n)`。

```dart
final size = antGenSizeMapToken(sizeUnit: 4, sizeStep: 4);
size.sizeXXL; // 48
size.sizeXXS; // 4
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `sizeUnit` | `double` | 可选 | — |
| `sizeStep` | `double` | 可选 | — |

返回 `AntSizeMapToken`。

