# antd_pull_to_refresh

Ant Design **PullToRefresh（下拉刷新）** 的 Flutter 独立组件包，API 对齐 antd-mobile v5。

从主包 [antd_flutter_plus](https://github.com/antd-flutter/antd-flutter) 拆分而来（P08 独立包拆分）；主包经 re-export 保持对外 API 完全兼容，已接入主包的用户无需改动。

## 定位

- **独立理由**：下拉刷新手势状态机（idle → pulling → canRelease → refreshing → complete）为单包独享引擎，且「只想用下拉刷新」的独立使用场景强。
- **零三方依赖**：不引入任何第三方包。

## R33 判定

**包裹类组件，不需要 sliver 支持（R33）**：`AntPullToRefresh` 以 `child` 包裹调用方自带的可滚动组件（ListView/CustomScrollView 等均可），通过 NotificationListener + 手势状态机实现，不要求 sliver 家族形态。

## 使用

```yaml
dependencies:
  antd_pull_to_refresh: ^0.1.0-beta.1
```

```dart
import 'package:antd_pull_to_refresh/antd_pull_to_refresh.dart';

AntPullToRefresh(
  onRefresh: () async {
    await Future<void>.delayed(const Duration(seconds: 1));
  },
  child: ListView(children: const [Text('item')]),
)
```
