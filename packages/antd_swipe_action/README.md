# antd_swipe_action

Ant Design SwipeAction（滑动操作）的 Flutter 组件包，API 对齐 antd-mobile v5 — 左右滑动手势吸附，展开操作按钮。

> 当前为预览版本。

## 安装

```yaml
dependencies:
  antd_swipe_action: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_swipe_action/antd_swipe_action.dart';

// ── 基础用法：左滑显示操作按钮 ───────────────────────────
AntSwipeAction(
  rightActions: [
    AntSwipeActionItem(text: '删除', onPressed: () {}),
  ],
  child: const ListTile(title: Text('左滑试试')),
);

// ── 左右滑 + 多按钮 + 关键参数 ───────────────────────────
AntSwipeAction(
  rightActions: [
    AntSwipeActionItem(text: '更多', onPressed: () {}),
    AntSwipeActionItem(
      text: '删除',
      color: Colors.red,
      onPressed: _delete,
      disabled: false,
    ),
  ],
  leftActions: [
    AntSwipeActionItem(text: '置顶', onPressed: _pin),
  ],
  closeOnAction: true,               // 点击操作后是否收起
  actionWidth: 64,                   // 单个按钮宽度
  onOpened: () {},                   // 展开回调
  onClosed: () {},                   // 收起回调
  child: const ListTile(title: Text('左右滑')),
);
```

组件以 `child` 包裹任意行内容（ListTile / Container 等），由调用方自行放入 ListView 等滚动容器。

## 文档与演示

- [API 文档总览](docs/api-index.md)
- 在线演示：<https://flutter-open.github.io/antd-flutter/swipe_action/>

## License

MIT License，详见仓库根 [LICENSE](../../LICENSE)。
