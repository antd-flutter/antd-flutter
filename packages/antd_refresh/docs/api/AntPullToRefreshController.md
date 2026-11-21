<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPullToRefreshController

> 种类：类

```dart
class AntPullToRefreshController
```

`AntPullToRefresh` 的控制器：程序化触发下拉刷新。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_state` | `AntPullToRefreshState?` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `attach` | `void` | 组件挂载时由内部调用（对应 ScrollPosition.attach 惯例） |
| `callRefresh` | `Future<void>` | 程序化触发下拉刷新：头部展开 → 等待 onRefresh 完成 → 回弹 |
| `detach` | `void` | 组件销毁/换绑时由内部调用 |

