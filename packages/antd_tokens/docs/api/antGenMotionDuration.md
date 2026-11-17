<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGenMotionDuration

> 种类：函数

```dart
AntMotionDurationToken antGenMotionDuration({required double motionUnit, required double motionBase, required bool motion})
```

Generates motion duration tokens from seed motion values.

对应 antd `genCommonMapToken` 中的动效部分：
fast = base + unit、mid = base + 2 × unit、slow = base + 3 × unit，
结果保留一位小数；`motion` 为 `false` 时全部归零。

```dart
final m = antGenMotionDuration(motionUnit: 0.1, motionBase: 0, motion: true);
m.mid; // 0.2
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `motionUnit` | `double` | 可选 | — |
| `motionBase` | `double` | 可选 | — |
| `motion` | `bool` | 可选 | — |

返回 `AntMotionDurationToken`。

