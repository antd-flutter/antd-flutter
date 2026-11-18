<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# atPullEdge

> 种类：函数

```dart
bool atPullEdge(ScrollMetrics? metrics, {required bool isTop})
```

内层可滚动组件是否停在拉动边缘（top：顶部；bottom：底部）。

滚轮事件被 Scrollable 的 PointerSignalResolver 消费后，
在边缘处会被 clamp 成 no-op，不会产生任何过冲通知，
因此需要用滚动度量自行判定「继续滚动即是拉动」。

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `metrics` | `ScrollMetrics?` | 可选 | — |
| `isTop` | `bool` | 可选 | — |

返回 `bool`。

