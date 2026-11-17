<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGenRadius

> 种类：函数

```dart
AntRadiusToken antGenRadius(double radiusBase)
```

Generates the radius token ladder from a base radius.

与 antd `genRadius` 一致：按基数所在区间分别推导
XS/SM/LG/Outer 各档位（如基数 6 → LG 8、SM 6、XS 2、Outer 4）。
区间阈值请勿调整，否则会破坏与 antd 的一致性。

```dart
final radius = antGenRadius(6);
radius.borderRadiusLG; // 8
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `radiusBase` | `double` | 可选 | — |

返回 `AntRadiusToken`。

