<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntBreakpoint

> 种类：枚举

```dart
enum AntBreakpoint
```

Ant Design 响应式断点枚举。

与 antd `Grid` 的 `Breakpoint` 一致，值从小到大排列。

## 构造函数

### `AntBreakpoint(this.minWidth)`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `minWidth` | `int` | 可选 | — |

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `xs` | 超小屏（≥480） |
| `sm` | 小屏（≥576） |
| `md` | 中屏（≥768） |
| `lg` | 大屏（≥992） |
| `xl` | 超大屏（≥1200） |
| `xxl` | 特大屏（≥1600） |
| `xxxl` | 巨屏（≥1920） |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `minWidth` | `int` | 断点最小宽度（逻辑像素） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `<` | `bool` | 当前断点是否 < other |
| `<=` | `bool` | 当前断点是否 ≤ other |
| `>` | `bool` | 当前断点是否 > other |
| `>=` | `bool` | 当前断点是否 ≥ other |
| `fromWidth` | `AntBreakpoint?` | 从屏幕宽度解析当前命中的最大断点 |
| `of` | `AntBreakpoint?` | 从 BuildContext 解析当前断点（基于窗口宽度） |

