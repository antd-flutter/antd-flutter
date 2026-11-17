<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# REdgeInsets

> 种类：类

```dart
class REdgeInsets
```

## 构造函数

### `REdgeInsets.all(double value)`

Creates adapt insets where all the offsets are `value`.

{@tool snippet}

Adapt height-pixel margin on all sides:

```dart
const REdgeInsets.all(8.0)
```
{@end-tool}

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double` | 可选 | — |

### `REdgeInsets.fromLTRB(double left, double top, double right, double bottom)`

Creates adapt insets from offsets from the left, top, right, and bottom.

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `left` | `double` | 可选 | — |
| `top` | `double` | 可选 | — |
| `right` | `double` | 可选 | — |
| `bottom` | `double` | 可选 | — |

### `REdgeInsets.only({double bottom = 0, double right = 0, double left = 0, double top = 0})`

Creates adapt insets with only the given values non-zero.

{@tool snippet}

Adapt left margin indent of 40 pixels:

```dart
const REdgeInsets.only(left: 40.0)
```
{@end-tool}

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `bottom` | `double` | = 0 | — |
| `right` | `double` | = 0 | — |
| `left` | `double` | = 0 | — |
| `top` | `double` | = 0 | — |

### `REdgeInsets.symmetric({double vertical = 0, double horizontal = 0})`

Creates adapt insets with symmetrical vertical and horizontal offsets.

{@tool snippet}

Adapt Eight pixel margin above and below, no horizontal margins:

```dart
const REdgeInsets.symmetric(vertical: 8.0)
```
{@end-tool}

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `vertical` | `double` | = 0 | — |
| `horizontal` | `double` | = 0 | — |

