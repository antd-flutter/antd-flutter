<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_swipe_action API 文档总览

> 自动生成时间：2026-11-20T00:16:33.112853；共 12 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（2）

| 名称 | 说明 |
| --- | --- |
| [`AntSwipeAction`](api/AntSwipeAction.md) | 滑动操作 — 左滑/右滑行内容露出操作按钮，松手吸附展开或收起 |
| [`AntSwipeActionItem`](api/AntSwipeActionItem.md) | 滑动操作按钮配置 |

## 常量（10）

| 名称 | 说明 |
| --- | --- |
| [`kAntSwipeActionContentKey`](api/kAntSwipeActionContentKey.md) | 内容区 key，便于测试定位行内容容器 |
| [`kAntSwipeActionCurve`](api/kAntSwipeActionCurve.md) | 吸附动画曲线（参考 flutterswipeactioncell 的 easeOutQuart） |
| [`kAntSwipeActionDuration`](api/kAntSwipeActionDuration.md) | 吸附动画时长 |
| [`kAntSwipeActionLeftKey`](api/kAntSwipeActionLeftKey.md) | 左侧操作区 key |
| [`kAntSwipeActionRightKey`](api/kAntSwipeActionRightKey.md) | 右侧操作区 key |
| [`kAntSwipeActionWidth`](api/kAntSwipeActionWidth.md) | 默认单个操作按钮宽度 |
| [`kAntSwipeContentPointerLimit`](api/kAntSwipeContentPointerLimit.md) | 内容位移超过该距离时忽略内容区指针（露出操作按钮可点） |
| [`kAntSwipeFlingVelocity`](api/kAntSwipeFlingVelocity.md) | fling 快甩速度阈值（px/s）：松手速度超过该值即按甩动方向开/关 |
| [`kAntSwipeOverDragLimit`](api/kAntSwipeOverDragLimit.md) | rubber-band 最大过拉距离：超出按钮总宽后最多再多拉 100px |
| [`kAntSwipeRubberBandFactor`](api/kAntSwipeRubberBandFactor.md) | rubber-band 弹性阻尼系数：超出按钮总宽后，每 1px 手指位移仅拉动 1/9px （与 flutter… |

