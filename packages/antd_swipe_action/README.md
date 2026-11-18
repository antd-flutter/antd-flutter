# antd_swipe_action

Ant Design **SwipeAction（滑动操作）** 的 Flutter 独立组件包，API 对齐 antd-mobile v5。

从主包 [antd_flutter_plus](https://github.com/antd-flutter/antd-flutter) 拆分而来（P08 独立包拆分）；主包经 re-export 保持对外 API 完全兼容，已接入主包的用户无需改动。

## 定位

- **独立理由**：左右滑动手势吸附状态机（拖动跟手 → 松手超过按钮总宽一半展开/回弹 → 点击操作收起）为单包独享引擎，且「只想用滑动操作」的列表行增强场景独立性强。
- **零三方依赖**：不引入任何第三方包。

## R33 判定

**行内手势组件，不需要 sliver 支持（R33）**：`AntSwipeAction` 以 `child` 包裹任意行内容（ListTile/Container 等均可），通过 GestureDetector + Transform.translate 实现拖动跟手与吸附动画，由调用方自行放入 ListView 等滚动容器，不涉及 sliver 家族形态。

## 使用

```yaml
dependencies:
  antd_swipe_action: ^0.1.0-beta.1
```

```dart
import 'package:antd_swipe_action/antd_swipe_action.dart';

AntSwipeAction(
  rightActions: [
    AntSwipeActionItem(text: '删除', onPressed: () {}),
  ],
  child: const ListTile(title: Text('左滑试试')),
)
```
