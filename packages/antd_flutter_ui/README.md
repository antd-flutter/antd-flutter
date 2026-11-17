# antd_flutter_ui

Ant Design v6 Flutter 基础组件库（P08 组件库拆分产物）。

## 定位

- **基础库**：承载基础层/通用展示/通用录入/通用反馈/全局组件，以及被多个独立组件包消费的**共享引擎**（`lib/src/engines/`：滚轮选择引擎 + 列数据模型、虚拟键盘/格子输入模型）。
- 依赖方向：独立组件包（antd_picker 等）→ 本包 → antd_theme / antd_tokens / antd_color / antd_icons_flutter；**独立包之间禁止互相依赖**。
- 全量接入经伞包 `antd_flutter_plus`（re-export 本包全部组件）；按需接入可直接依赖本包。
- 正式双轨文档（dart doc + 人工文档页静态站）在 P08 全部组件迁移完成后经 gen-docs 统一生成，本包暂不放 docs/。
