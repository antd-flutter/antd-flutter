<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInfiniteScroll

> 种类：类

```dart
class AntInfiniteScroll
```

无限滚动 — 滚动到底部自动加载更多数据。

对齐 antd-mobile InfiniteScroll 组件。

## 构造函数

### `AntInfiniteScroll({super.key, required this.child, required this.loadMore, this.threshold = AntInfiniteScrollDefaults.threshold, this.loadingText, this.hasMoreText, this.noMoreText, this.loadFailedText, this.loadFailedRetryText, this.controller})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `loadMore` | `Future<bool> Function()` | 可选 | — |
| `threshold` | `double` | = AntInfiniteScrollDefaults.threshold | — |
| `loadingText` | `String?` | 可选 | — |
| `hasMoreText` | `String?` | 可选 | — |
| `noMoreText` | `String?` | 可选 | — |
| `loadFailedText` | `String?` | 可选 | — |
| `loadFailedRetryText` | `String?` | 可选 | — |
| `controller` | `AntInfiniteScrollController?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 列表内容，由使用方传入（ListView / Column 等任意滚动内容） |
| `controller` | `AntInfiniteScrollController?` | 程序化控制器（R35.2 Controller 优先）：经 AntInfiniteScrollController… |
| `hasMoreText` | `String?` | 还有更多数据时的提示文案，为空时取默认文案 |
| `loadFailedRetryText` | `String?` | 加载失败重试按钮文案，为空时取默认文案 |
| `loadFailedText` | `String?` | 加载失败提示文案，为空时取默认文案 |
| `loadMore` | `Future<bool> Function()` | 加载函数，返回 false 表示没有更多数据 |
| `loadingText` | `String?` | 加载中文案，为空时取默认文案 |
| `noMoreText` | `String?` | 没有更多数据时的提示文案，为空时取默认文案 |
| `threshold` | `double` | 触发阈值：滚动位置距底部小于该值（逻辑像素）时触发加载，默认 0 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `AntInfiniteScrollState` | — |

