<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntBreakpoints

> 种类：类

```dart
class AntBreakpoints
```

断点判断工具。

```dart
if (AntBreakpoints.isUp(context, AntBreakpoint.md)) {
  // ≥768 逻辑
}
```

## 构造函数

### `AntBreakpoints._()`

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isBetween` | `bool` | 屏幕宽度是否在 min 和 max 之间（含边界） |
| `isDown` | `bool` | 屏幕宽度是否 < bp 的最小宽度 |
| `isUp` | `bool` | 屏幕宽度是否 ≥ bp 的最小宽度 |

