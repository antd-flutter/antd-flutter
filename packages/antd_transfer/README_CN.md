# antd_transfer - Flutter 泛型穿梭框与树形穿梭框

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_transfer/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_transfer/README_CN.md)

## 定位与设计

`antd_transfer` 在**你自己的数据模型 `T`** 之上实现 Ant Design 穿梭框交互。组件同时渲染源面板与目标面板，支持复选选择、移入移出、可选搜索以及单向模式；当数据项能通过 `childrenOf` 暴露子节点时，同一个组件自动切换为树形穿梭框，具备父子勾选联动、半选（indeterminate）状态与整棵子树移动能力。

数据层刻意保持轻薄：没有强制的包装数据类，也没有 `Map` 行数据。组件只通过少量回调读取你的对象（`keyOf`、`titleBuilder`、`descriptionOf`、`childrenOf`、`disabledOf`、`searchTextOf`），并且所有回调与受控属性都以 key 而非对象实例交流。

设计原则：

- **由 key 承载状态。** `targetKeys`、`selectedKeys` 以及所有移动回调都使用 `keyOf` 返回的值。
- **组件不修改你的数据。** `targetKeys` 与 `selectedKeys` 非空时即为受控属性；对应的 `default*` 属性用于非受控场景的初始值。
- **树形模式自动推断。** 某个节点的 `childrenOf` 返回非空列表时即成为分支；不存在独立的树形组件或模式开关。
- **渲染自包含。** 面板外观、边框与尺寸来自 `AntTheme`；包依赖 `antd_theme`、`antd_icons_flutter`，并通过 `antd_flutter_ui` 复用共享复选框。

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_transfer: ^1.0.0
```

用 `AntTheme` 包裹应用（或使用该组件的子树），面板即可获得主题颜色、边框与缩放：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_transfer/antd_transfer.dart';
import 'package:material_ui/material_ui.dart';

class FileItem {
  const FileItem(
    this.id,
    this.name, {
    this.description,
    this.disabled = false,
    this.children = const <FileItem>[],
  });

  final int id;
  final String name;
  final String? description;
  final bool disabled;
  final List<FileItem> children;
}

const source = <FileItem>[
  FileItem(1, 'Design.fig', description: 'Figma'),
  FileItem(2, 'Spec.md', description: 'Markdown'),
  FileItem(3, 'Budget.xlsx', description: 'Spreadsheet', disabled: true),
];

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 320,
                child: AntTransfer<FileItem>(
                  dataSource: source,
                  keyOf: (item) => item.id,
                  titleBuilder: (context, item) => Text(item.name),
                  descriptionOf: (item) => item.description,
                  defaultTargetKeys: const <Object>[2],
                  onChange: (targetKeys, direction, moveKeys) {
                    debugPrint('$direction moved $moveKeys -> $targetKeys');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
```

组件渲染两个面板与一个穿梭按钮。`Spec.md` 初始位于目标侧，禁用的 `Budget.xlsx` 行既不能被选中也不能被移动。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_transfer/docs/api-index.md)

### 1. 受控目标 key 与选中项

```dart
class ControlledTransfer extends StatefulWidget {
  const ControlledTransfer({super.key});

  @override
  State<ControlledTransfer> createState() => _ControlledTransferState();
}

class _ControlledTransferState extends State<ControlledTransfer> {
  List<Object> _targetKeys = <Object>[2];
  List<Object> _selectedKeys = <Object>[];

  @override
  Widget build(BuildContext context) {
    return AntTransfer<FileItem>(
      dataSource: source,
      keyOf: (item) => item.id,
      titleBuilder: (context, item) => Text(item.name),
      targetKeys: _targetKeys,
      selectedKeys: _selectedKeys,
      onChange: (targetKeys, direction, moveKeys) {
        setState(() => _targetKeys = targetKeys);
      },
      onSelectChange: (sourceSelected, targetSelected) {
        setState(() {
          _selectedKeys = <Object>[...sourceSelected, ...targetSelected];
        });
      },
    );
  }
}
```

一旦传入 `targetKeys`，所有者就必须在 `onChange` 中写回新列表；否则面板会继续渲染上一次的归属状态。

### 2. 用自定义模型构建树形穿梭

```dart
const tree = <FileItem>[
  FileItem(
    10,
    'Design',
    children: [
      FileItem(11, 'UI.fig'),
      FileItem(12, 'Icons.svg'),
    ],
  ),
  FileItem(
    20,
    'Engineering',
    children: [
      FileItem(21, 'API.md'),
      FileItem(22, 'Schema.sql', disabled: true),
    ],
  ),
];

AntTransfer<FileItem>(
  dataSource: tree,
  keyOf: (item) => item.id,
  titleBuilder: (context, item) => Text(item.name),
  childrenOf: (item) => item.children,
  disabledOf: (item) => item.disabled,
  defaultExpandAll: true,
  defaultTargetKeys: const <Object>[11, 21],
  onChange: (targetKeys, direction, moveKeys) {
    debugPrint('tree move $direction: $moveKeys');
  },
)
```

勾选 `Design` 会同时勾选它的两个子节点；只选中部分子节点时分支显示半选状态。移动分支会连同整棵子树一起移动，而禁用的 `Schema.sql` 不参与选择与移动。

### 3. 搜索与单向模式

```dart
AntTransfer<FileItem>(
  dataSource: source,
  keyOf: (item) => item.id,
  titleBuilder: (context, item) => Text(item.name),
  descriptionOf: (item) => item.description,
  titles: const ['Available files', 'Attached'],
  operations: const ['Attach', ''],
  showSearch: true,
  oneWay: true,
  filterOption: (input, item) =>
      item.name.toLowerCase().contains(input.toLowerCase()),
  onChange: (targetKeys, direction, moveKeys) {
    debugPrint('attached $moveKeys');
  },
)
```

`oneWay: true` 隐藏返回操作，数据只能移动至目标面板；`operations` 中对应位置传空字符串可保留纯图标按钮。

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/transfer/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_transfer/
├── lib/
│   ├── antd_transfer.dart              # barrel 导出
│   └── src/transfer/
│       ├── ant_transfer.dart           # 面板、选择、移动与树形逻辑
│       └── ant_transfer_types.dart     # 方向枚举与回调类型
├── example/lib/main.dart               # 可运行示例
├── docs/api-index.md                   # 生成的 API 索引
└── README.md
```

## License

MIT，详见仓库 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
