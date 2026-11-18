# antd_refresh

antd-flutter 的刷新/加载更多底层引擎包。

**来源声明**：本包是 [easy_refresh](https://pub.dev/packages/easy_refresh)
v3.5.0（MIT License，Copyright (c) 2021 xuelongqy）的**完整移植复刻**：
- 保留原实现的全部能力（`IndicatorNotifier` 状态机、`_ErScrollPhysics` 物理层、
  Header/Footer 协议、Controller、全部内置指示器样式、桌面端滚轮/鼠标支持）；
- 类名加 `Er` 前缀做命名空间隔离（如 `ErIndicatorNotifier` / `ErHeader` /
  `ErClassicHeader`），避免与原包冲突；
- 其余实现逻辑保持与原包一致。

License 合规见 [LICENSE-THIRD-PARTY.md](LICENSE-THIRD-PARTY.md)。
