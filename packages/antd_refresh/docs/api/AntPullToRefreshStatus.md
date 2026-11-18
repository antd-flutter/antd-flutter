<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPullToRefreshStatus

> 种类：枚举

```dart
enum AntPullToRefreshStatus
```

下拉刷新状态。

对齐 antd-mobile PullToRefresh 的生命周期：
idle → pulling → canRelease → refreshing → complete。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `idle` | 初始状态（未下拉） |
| `pulling` | 下拉中但未达到触发阈值 |
| `canRelease` | 下拉已达到阈值，松手即可触发刷新 |
| `refreshing` | 刷新中（onRefresh 执行期间） |
| `complete` | 刷新完成（展示 completeText，回弹结束后回到 idle） |

