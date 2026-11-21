# antd_tree example

antd_tree 组件演示画廊（AntTree / AntTreeSelect）。

## 运行

```bash
cd packages/antd_tree/example
flutter pub get
flutter run -d macos   # macOS 真机验证
flutter run -d chrome  # Web
```

## 覆盖形态

- 基础树（选中、showLine 连接线、禁用节点）
- 多选 checkbox 树（父子联动 / checkStrictly 严格模式）
- 受控树（expandedKeys / selectedKeys / checkedKeys 程序化操控，R35 判定演示）
- 异步加载（onExpand 注入模拟 loadData）
- 默认展开（defaultExpandedKeys / defaultExpandAll）
- TreeSelect（单选 / 多选 / treeDefaultExpandAll / 尺寸）

R35.4：AntResponsiveInit 断点布局（宽屏双栏 / 窄屏单栏）+ 暗色切换 + 窗口缩放无溢出。
