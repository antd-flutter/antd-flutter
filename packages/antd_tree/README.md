# antd_tree

Ant Design v6 Tree / TreeSelect 组件的 Flutter 实现 — 树形控件，支持展开/收起、选中、checkbox 多选（父子联动/半选态/严格模式）、连接线、缩进、禁用节点，及树形下拉选择（单选/多选、默认展开、尺寸），API 对齐 antd React Tree / TreeSelect。

> 当前为预览版本。

> R33 判定：Tree 为数据展示类组件，内部以 Column 平铺渲染节点（展开动画经 AnimatedSize），自身不是滚动集合，滚动由外层容器（SingleChildScrollView/ListView 等）负责，不需要 sliver 支持。超大树的虚拟滚动（antd React 的 virtual 能力）为后续增强项，不阻塞本次拆分。

> R35 判定（Controller 评估）：Tree 的展开/选中/勾选均为标准受控/非受控双模式（`expandedKeys` / `selectedKeys` / `checkedKeys` + `onExpand` / `onSelect` / `onCheck`），程序化操控（expandAll / collapseAll / checkAll 等价能力）通过受控 keys + setState 即可实现（见 example「受控树」分区按钮演示），无 imperative Controller 语义需求，不引入 AntTreeController。

## 安装

```yaml
dependencies:
  antd_tree: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_tree/antd_tree.dart';

// ── 基础树 ──────────────────────────────────────────────
AntTree(
  treeData: [
    AntTreeNode(key: 'zj', title: '浙江', children: [
      AntTreeNode(key: 'hz', title: '杭州'),
    ]),
  ],
  onSelect: (selectedKeys) {},
);

// ── 多选 checkbox 树（父子联动） ────────────────────────
AntTree(
  treeData: treeData,
  checkable: true,
  onCheck: (checkedKeys, halfCheckedKeys) {},
);

// ── 严格模式（父子不联动） ──────────────────────────────
AntTree(treeData: treeData, checkable: true, checkStrictly: true);

// ── 受控模式 ────────────────────────────────────────────
AntTree(
  treeData: treeData,
  expandedKeys: _expanded,
  onExpand: (keys) => setState(() => _expanded = keys),
  selectedKeys: _selected,
  checkedKeys: _checked,
);

// ── TreeSelect 下拉选择 ─────────────────────────────────
AntTreeSelect(
  treeData: [
    AntTreeSelectOption(value: 'zj', label: '浙江', children: [
      AntTreeSelectOption(value: 'hz', label: '杭州'),
    ]),
  ],
  multiple: true,
  onChange: (value) {},
);
```

## 组件

| 组件/类型 | 说明 |
| --- | --- |
| `AntTree` | 树形控件 |
| `AntTreeNode` | 树节点数据 |
| `AntTreeOnCheck` | 勾选回调（checkedKeys + halfCheckedKeys） |
| `AntTreeSelect` | 树选择下拉组件 |
| `AntTreeSelectOption` | 树选择选项 |
| `AntTreeSelectSize` | 树选择尺寸（large / middle / small） |
| `AntTreeSelectFieldNames` | 自定义字段名 |

## Example

```bash
cd packages/antd_tree/example
flutter pub get
flutter run -d macos   # 或 chrome / windows 等全平台
```

demo 覆盖：基础树 / showLine / 禁用节点 / checkbox 联动与严格模式 / 受控树（程序化展开/勾选）/ 异步加载 / 默认展开 / TreeSelect 单选·多选·默认展开，含暗色切换与宽窄屏自适应（R35.4）。
