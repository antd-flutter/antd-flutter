# antd_swipe_action_example

`antd_swipe_action`（AntSwipeAction）组件演示画廊。

## 运行

```bash
cd packages/antd_swipe_action/example
flutter pub get
flutter run              # 任意平台：ios / android / macos / windows / linux / web
flutter build web --release --base-href /antd-flutter/swipe_action/   # 静态部署
```

## Demo 区块

1. **左右滑基础** — rightActions / leftActions / 双向滑
2. **fling 快甩** — 松手速度超 500px/s 直接开/关
3. **rubber-band 弹性** — 超过按钮总宽后 1/9 阻尼 + 100px 过拉上限
4. **danger 危险操作** — `colorError` 红色删除按钮
5. **disabled 禁用** — 按钮置灰且点击不触发回调
6. **closeOnAction** — 点击操作后收起 / 保持展开对照
7. **多按钮** — 右 4 个 / 左 2 个按钮
8. **ListView 手势竞争** — 横滑 vs 纵滚方向隔离
9. **onOpened / onClosed** — 展开/收起回调事件展示

## 文案说明（R34）

AntSwipeAction **无内置默认文案**：动作按钮文案（`AntSwipeActionItem.text`）完全由使用方传入，
组件本身不涉及国际化（R34 暂不涉及）。
