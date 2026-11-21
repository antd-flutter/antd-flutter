# antd_tree - Flutter 泛型树与树选择

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tree/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tree/README_CN.md)

## 定位与设计

`antd_tree` 在**你自己的数据模型 `T`** 之上提供两个 Ant Design 树形控件：`AntTree<T>` 负责层级展示，支持展开、选中与可选复选框；`AntTreeSelect<T>` 负责在下拉面板中从同一层级里选择一个或多个 key。整棵层级完全由回调描述——`keyOf`、`titleBuilder`、`childrenOf`、`disabledOf`、`checkableOf`，选择器另有 `labelOf`。

设计原则：

- **你的模型就是树。** 不需要节点包装类，子节点来自 `childrenOf`。
- **由 key 承载状态。** 展开、选中与勾选集合都存放 `keyOf` 返回的值。
- **受控与非受控并存。** `expandedKeys` / `selectedKeys` / `checkedKeys` / `value` 非空时为受控属性；对应的 `default*` 属性提供非受控初始值。
- **勾选默认遵循树语义。** 勾选父节点会向下级联，部分勾选的父节点呈现半选状态；`checkStrictly` 可关闭联动。
- **只负责布局，不负责滚动。** `AntTree` 渲染为 Column，自身不滚动；层级可能超出视口时请外包滚动视图。`AntTreeSelect` 自己管理下拉面板的滚动。

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_tree: ^1.0.0
```

用 `AntTheme` 包裹子树；行高、缩进、颜色与下拉外观均来自设计 token：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:material_ui/material_ui.dart';

class Region {
  const Region(
    this.id,
    this.name, {
    this.children = const <Region>[],
  });

  final int id;
  final String name;
  final List<Region> children;
}

const regions = <Region>[
  Region(
    1,
    'Zhejiang',
    children: [
      Region(2, 'Hangzhou'),
      Region(3, 'Ningbo'),
    ],
  ),
  Region(
    4,
    'Jiangsu',
    children: [
      Region(5, 'Nanjing'),
      Region(6, 'Suzhou'),
    ],
  ),
];

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 280,
                child: SingleChildScrollView(
                  child: AntTree<Region>(
                    dataSource: regions,
                    keyOf: (region) => region.id,
                    titleBuilder: (context, region) => Text(region.name),
                    childrenOf: (region) => region.children,
                    defaultExpandAll: true,
                    checkable: true,
                    onCheck: (checked, halfChecked) {
                      debugPrint('checked=$checked half=$halfChecked');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
```

示例渲染一棵默认全展开、可勾选的地区树。勾选 `Zhejiang` 会同时选中两个城市；只勾选 `Hangzhou` 时父节点进入半选状态。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tree/docs/api-index.md)

### 1. 受控展开与选中

```dart
class ControlledTree extends StatefulWidget {
  const ControlledTree({super.key});

  @override
  State<ControlledTree> createState() => _ControlledTreeState();
}

class _ControlledTreeState extends State<ControlledTree> {
  Set<Object> _expanded = <Object>{1};
  Set<Object> _selected = <Object>{2};

  @override
  Widget build(BuildContext context) {
    return AntTree<Region>(
      dataSource: regions,
      keyOf: (region) => region.id,
      titleBuilder: (context, region) => Text(region.name),
      childrenOf: (region) => region.children,
      expandedKeys: _expanded,
      onExpand: (keys) => setState(() => _expanded = keys),
      selectedKeys: _selected,
      onSelect: (keys) => setState(() => _selected = keys),
    );
  }
}
```

`expandedKeys` 与 `selectedKeys` 由调用方持有；把回调返回的集合写回 state 即可保持同步。

### 2. 单节点规则与严格勾选

```dart
AntTree<Region>(
  dataSource: regions,
  keyOf: (region) => region.id,
  titleBuilder: (context, region) => Text(region.name),
  childrenOf: (region) => region.children,
  checkable: true,
  checkStrictly: true,
  showLine: true,
  checkableOf: (region) => region.children.isEmpty,
  disabledOf: (region) => region.id == 3,
  onCheck: (checked, halfChecked) {
    debugPrint('checked=$checked half=$halfChecked');
  },
)
```

`showLine` 绘制层级引导线，`checkableOf` 让只有叶子显示复选框，`Ningbo` 被禁用。`checkStrictly: true` 关闭父子联动，此时 `checked` 只包含直接切换的节点。

### 3. 单选与多选树选择

```dart
Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    AntTreeSelect<Region>(
      dataSource: regions,
      keyOf: (region) => region.id,
      labelOf: (region) => region.name,
      childrenOf: (region) => region.children,
      treeDefaultExpandAll: true,
      placeholder: 'Select a region',
      allowClear: true,
      onChange: (value) => debugPrint('selected $value'),
    ),
    const SizedBox(height: 12),
    AntTreeSelect<Region>(
      dataSource: regions,
      keyOf: (region) => region.id,
      labelOf: (region) => region.name,
      childrenOf: (region) => region.children,
      multiple: true,
      defaultValue: const <Object>[2, 5],
      onChange: (value) => debugPrint('selected $value'),
    ),
  ],
)
```

多选模式下触发器展示 chip，`onChange` 发出 `List<Object>`；单选模式发出单个 key，清空后发出 `null`。

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/tree/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_tree/
├── lib/
│   ├── antd_tree.dart                     # barrel 导出
│   └── src/
│       ├── tree/
│       │   ├── ant_tree.dart              # 展开 / 选中 / 勾选渲染
│       │   └── ant_tree_types.dart        # 回调与类型定义
│       └── tree_select/
│           ├── ant_tree_select.dart       # 触发器与下拉面板
│           └── ant_tree_select_types.dart # 尺寸枚举与回调
├── example/lib/main.dart                  # 可运行示例
├── docs/api-index.md                      # 生成的 API 索引
└── README.md
```

## License

MIT，详见仓库 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
