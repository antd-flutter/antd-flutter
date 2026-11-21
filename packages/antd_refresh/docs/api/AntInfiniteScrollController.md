<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInfiniteScrollController

> 种类：类

```dart
class AntInfiniteScrollController
```

`AntInfiniteScroll` 的控制器：程序化触发加载更多 / 重置分页状态。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_state` | `AntInfiniteScrollState?` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `attach` | `void` | 组件挂载时由内部调用（对应 ScrollPosition.attach 惯例） |
| `callLoadMore` | `Future<void>` | 程序化触发加载更多（加载中为空操作 |
| `detach` | `void` | 组件销毁/换绑时由内部调用 |
| `reset` | `void` | 重置分页状态：清除失败态并恢复「还有更多」（切换数据源/筛选条件后使用） |

