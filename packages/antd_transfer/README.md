# antd_transfer

Ant Design (antd-mobile) Transfer 穿梭框的 Flutter 实现 — AntTransfer（双栏穿梭）、AntTransferItem（数据项，携带 children 即为树形 TreeTransfer 模式），支持多选、受控/非受控、搜索过滤、禁用项、oneWay 单向模式，以及多级树形穿梭（父子勾选联动、半选 indeterminate、禁用子树联动、树模式搜索过滤），API 对齐 antd Transfer / TreeTransfer。

> 当前为预览版本。

> R33 判定：穿梭框为固定布局类组件（双栏列表，非滚动场景），不需要 sliver 支持。

> 归属边界（读码评估）：AntCheckbox（含 indeterminate 半选状态）为 ui 共享基础组件，留在 `antd_flutter_ui` 不迁，本包经 ui barrel 引用（依赖核对结论：AntCheckbox 依赖无法解除，保留 antd_flutter_ui 依赖）。

## 安装

```yaml
dependencies:
  antd_transfer: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_transfer/antd_transfer.dart';

// ── 基础穿梭 ────────────────────────────────────────────
AntTransfer(
  dataSource: [
    AntTransferItem(key: 'a', title: '选项 A'),
    AntTransferItem(key: 'b', title: '选项 B'),
    AntTransferItem(key: 'c', title: '选项 C'),
  ],
  onChange: (targetKeys, direction, moveKeys) => print(targetKeys),
)

// ── 多级树形穿梭（TreeTransfer）：数据项携带 children 即树形模式 ──
AntTransfer(
  dataSource: [
    AntTransferItem(key: 'g1', title: '分组 1', children: [
      AntTransferItem(key: 'a', title: '选项 A'),
      AntTransferItem(key: 'b', title: '选项 B'),
    ]),
    AntTransferItem(key: 'g2', title: '分组 2', children: [
      AntTransferItem(key: 'c', title: '选项 C'),
    ]),
  ],
  defaultExpandAll: true,
  showSearch: true,
  onChange: (targetKeys, direction, moveKeys) => print(targetKeys),
)
```

完整演示见 `example/`（基础穿梭 / 多选 / 受控 / 禁用项 / 多级树形穿梭（勾父带子/半选/树形展示）/ 搜索过滤 / 自定义渲染，R35.4 断点适配 + 暗色切换）。

## 迁移说明（P08 批次）

- 从 `antd_flutter_ui`（data_entry/transfer）迁出，多级 TreeTransfer 增强随迁，`///` 文档注释完整随迁，源码零修改（仅 import 调整）。
- 主包 `antd_flutter_plus` 经 re-export 保持符号兼容。
- 依赖方向：antd_transfer → antd_flutter_ui → antd_theme/tokens/color/icons，不依赖其他独立组件包。

## License

MIT
