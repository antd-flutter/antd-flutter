<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPullToRefreshHeader

> 种类：类

```dart
class AntPullToRefreshHeader
```

AntPullToRefresh 默认头部指示器。

指示器结构参照 [pull_to_refresh_flutter3](https://github.com/xxzj990-game/flutter_pulltorefresh)
的 `ClassicIndicator`（MIT License）整理：
状态文案 + 状态图标（箭头/转圈/完成标记）居中展示，
各状态由 `AntPullToRefreshStatus` 驱动，自定义内容仍通过
`AntPullToRefresh.header` 整体替换本指示器。

## 构造函数

### `AntPullToRefreshHeader({super.key, required this.status, this.pullingText, this.releasingText, this.finishingText, this.completeText, this.indicatorSize = kAntPullToRefreshIndicatorSize, this.spacing = kAntPullToRefreshIndicatorSpacing})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `status` | `AntPullToRefreshStatus` | 可选 | — |
| `pullingText` | `String?` | 可选 | — |
| `releasingText` | `String?` | 可选 | — |
| `finishingText` | `String?` | 可选 | — |
| `completeText` | `String?` | 可选 | — |
| `indicatorSize` | `double` | = kAntPullToRefreshIndicatorSize | — |
| `spacing` | `double` | = kAntPullToRefreshIndicatorSpacing | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `completeText` | `String?` | 刷新完成文案 |
| `finishingText` | `String?` | 刷新中文案（伴随转圈显示） |
| `indicatorSize` | `double` | 状态图标尺寸 |
| `pullingText` | `String?` | 下拉中（未达阈值）文案 |
| `releasingText` | `String?` | 达到阈值释放即刷新文案 |
| `spacing` | `double` | 图标与文案间距 |
| `status` | `AntPullToRefreshStatus` | 当前刷新状态 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildIndicator` | `Widget` | 按状态渲染图标：下拉箭头 / 释放箭头 / 转圈 / 完成标记 |
| `build` | `Widget` | — |

