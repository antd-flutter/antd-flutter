<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntScale

> 种类：类

```dart
class AntScale
```

统一缩放因子 —— 所有设计尺寸乘以该因子。

设计值（antd 的 14 / 40 / 16 / 8 等）是 1.0 倍下的逻辑像素；
需要整体放大/缩小时只改 `factor`，控件内的 `t.s(12)` 与
主题 token（fontSize / controlHeight / borderRadius / size*）
全部随之变化。

```dart
AntTheme(data: AntThemeData.light(scale: const AntScale(1.15)), child: ...)
// 或按设备自动推导
AntTheme(data: AntThemeData.light(scale: AntScale.auto(context)), child: ...)
```

## 构造函数

### `AntScale(this.factor)`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `factor` | `double` | 可选 | — |

### `AntScale.auto(BuildContext context, {double base = 375, double min = 0.9, double max = 1.2})`

按设备短边自动推导（仅移动端生效）。

- 基准 `base`：短边 / base 得到因子；
- `min`/`max`：夹取范围，避免小屏过小、大屏过大；
- 桌面（macOS/Windows/Linux/Web 桌面）恒为 `none`。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `context` | `BuildContext` | 可选 | — |
| `base` | `double` | = 375 | — |
| `min` | `double` | = 0.9 | — |
| `max` | `double` | = 1.2 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `factor` | `double` | 缩放倍数，1.0 = 设计值原样 |
| `none` | `AntScale` | 不缩放 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `call` | `double` | 设计值 → 实际值（组件内唯一入口） |
| `copyWith` | `AntScale` | — |
| `toString` | `String` | — |

