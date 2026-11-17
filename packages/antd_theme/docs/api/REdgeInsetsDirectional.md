<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# REdgeInsetsDirectional

> 种类：类

```dart
class REdgeInsetsDirectional
```

## 构造函数

### `REdgeInsetsDirectional.all(double value)`

Creates insets where all the offsets are `value`.

{@tool snippet}

Adapt eight-pixel margin on all sides:

```dart
const REdgeInsetsDirectional.all(8.0)
```
{@end-tool}

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double` | 可选 | — |

### `REdgeInsetsDirectional.fromSTEB(double start, double top, double end, double bottom)`

Creates adapt insets from offsets from the start, top, end, and bottom.

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `start` | `double` | 可选 | — |
| `top` | `double` | 可选 | — |
| `end` | `double` | 可选 | — |
| `bottom` | `double` | 可选 | — |

### `REdgeInsetsDirectional.only({double bottom = 0, double end = 0, double start = 0, double top = 0})`

Creates insets with only the given values non-zero.

{@tool snippet}

Adapt margin indent of 40 pixels on the leading side:

```dart
const REdgeInsetsDirectional.only(start: 40.0)
```
{@end-tool}

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `bottom` | `double` | = 0 | — |
| `end` | `double` | = 0 | — |
| `start` | `double` | = 0 | — |
| `top` | `double` | = 0 | — |

