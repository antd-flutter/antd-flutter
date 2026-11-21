# antd_table

Ant Design v6 Table 表格组件的 Flutter 实现 — 支持排序、筛选、固定列/固定表头、行选择（单选/多选/禁用）、合并单元格、展开行、树形数据、分页、汇总行、分组表头，API 对齐 antd React Table。

> 当前为预览版本。

> R33 判定：Table 表格横向滚动场景判定不需要 sliver 支持。现有实现为固定布局 + 表体内部滚动（固定列经位置计算实现），不依赖外层滚动位置；横向滚动经组件内部 SingleChildScrollView 完成，sliver 变体无可评估收益。

> 后续增强项（随包迁移，不阻塞本次拆分）：
> - 虚拟滚动（antd React Table 的 virtual 能力）
> - 列宽拖拽调整
> - 可编辑单元格

## 安装

```yaml
dependencies:
  antd_table: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_table/antd_table.dart';

// ── 基础表格 ────────────────────────────────────────────
AntTable(
  columns: [
    AntColumn(title: '姓名', dataIndex: 'name'),
    AntColumn(title: '年龄', dataIndex: 'age'),
  ],
  dataSource: [
    {'name': '张三', 'age': 32},
    {'name': '李四', 'age': 28},
  ],
);

// ── 排序 + 筛选 ─────────────────────────────────────────
AntColumn(
  title: '年龄',
  dataIndex: 'age',
  sorter: (a, b) => (a['age'] as int).compareTo(b['age'] as int),
);

// ── 固定列 / 固定表头 ───────────────────────────────────
AntColumn(title: '操作', dataIndex: 'op', fixed: true);
AntTable(columns: columns, dataSource: data, scrollY: 200);

// ── 行选择 ──────────────────────────────────────────────
AntTable(
  columns: columns,
  dataSource: data,
  rowSelection: AntTableRowSelection(
    onChange: (keys, rows) {},
  ),
);

// ── 分页 ────────────────────────────────────────────────
AntTable(
  columns: columns,
  dataSource: data,
  pagination: AntTablePagination(pageSize: 10),
);
```

完整高级用法（合并单元格 / 展开行 / 树形数据 / 汇总行 / 分组表头）见 `example` 演示。

## 依赖

- `antd_theme`（设计 Token / 主题 / 屏幕适配）
- `material_ui`

不依赖 `antd_flutter_ui` 及其他独立组件包。主包 `antd_flutter_plus` 经 re-export 保持对外兼容。
