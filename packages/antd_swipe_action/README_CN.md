# antd_swipe_action - Flutter 滑动操作组件

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_swipe_action/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_swipe_action/README_CN.md)

`antd_swipe_action` 在 Flutter 中实现 Ant Design Mobile 的 SwipeAction 交互，适用于列表行和消息条目。横向滑动一行会从另一侧露出操作按钮；内容跟手移动，超过操作区宽度后产生阻尼，松手时吸附到展开或关闭状态。它面向消息列表、购物车行、收件箱等触屏场景。

## 定位与设计

- **一行两组操作。** 左滑露出 `rightActions`，右滑露出 `leftActions`。
- **只响应水平手势。** 行内使用水平拖动识别器，垂直方向的 `ListView`/`CustomScrollView` 滚动不受影响。
- **内容跟手移动。** 在操作区总宽度内 1:1 跟随，之后进入橡皮筋阻尼；松手后吸附到展开或关闭位置。
- **操作是声明式的。** 按钮为 `AntSwipeActionItem`，包含文案、颜色、回调和禁用状态；没有命令式控制器。
- **依赖自包含。** 只依赖 `antd_theme` 与 `material_ui`。

## 安装

需要 Flutter 3.10+ 与 Dart 3.0+。

```yaml
dependencies:
  antd_swipe_action: ^1.0.0
```

请用 `AntTheme` 包裹应用子树；操作按钮默认色与行背景来自当前主题：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

```dart
import 'package:antd_swipe_action/antd_swipe_action.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('收件箱')),
            body: ListView(
              children: [
                AntSwipeAction(
                  rightActions: [
                    AntSwipeActionItem(
                      text: '归档',
                      onPressed: () => debugPrint('archive'),
                    ),
                  ],
                  child: const ListTile(
                    title: Text('季度报告'),
                    subtitle: Text('左滑归档'),
                  ),
                ),
                AntSwipeAction(
                  rightActions: [
                    AntSwipeActionItem(
                      text: '删除',
                      color: Colors.red,
                      onPressed: () => debugPrint('delete'),
                    ),
                  ],
                  child: const ListTile(
                    title: Text('旧发票'),
                    subtitle: Text('左滑删除'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
```

左滑一行会露出 `归档`/`删除` 按钮。点击按钮会执行回调，并因 `closeOnAction` 默认为 `true` 而关闭该行。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_swipe_action/docs/api-index.md)

在一行两侧都露出操作：

```dart
AntSwipeAction(
  leftActions: [
    AntSwipeActionItem(
      text: 'Pin',
      color: Colors.blueGrey,
      onPressed: () => debugPrint('pin'),
    ),
  ],
  rightActions: [
    AntSwipeActionItem(
      text: 'Share',
      color: Colors.blue,
      onPressed: () => debugPrint('share'),
    ),
    AntSwipeActionItem(
      text: 'Delete',
      color: Colors.red,
      onPressed: () => debugPrint('delete'),
    ),
  ],
  child: const ListTile(title: Text('Swipe either way')),
)
```

点击操作后保持展开，并监听生命周期：

```dart
AntSwipeAction(
  closeOnAction: false,
  onOpened: (side) => debugPrint('opened on $side'),
  onClosed: () => debugPrint('closed'),
  rightActions: [
    AntSwipeActionItem(
      text: 'Select',
      onPressed: () => debugPrint('selected'),
    ),
  ],
  child: const ListTile(title: Text('Stays open after selection')),
)
```

在列表中构建行，包含禁用与自定义颜色的操作：

```dart
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) {
    final message = messages[index];
    return AntSwipeAction(
      rightActions: [
        AntSwipeActionItem(
          text: 'Edit',
          onPressed: () => edit(message),
        ),
        AntSwipeActionItem(text: 'Locked', disabled: true),
        AntSwipeActionItem(
          text: 'Remove',
          color: Theme.of(context).colorScheme.error,
          onPressed: () => remove(message),
        ),
      ],
      child: ListTile(title: Text(message.title)),
    );
  },
)
```

## 项目结构

```text
packages/antd_swipe_action/
├── lib/
│   ├── antd_swipe_action.dart                  # barrel 导出
│   └── src/swipe_action/
│       ├── ant_swipe_action.dart               # 手势、吸附动画、操作层
│       └── ant_swipe_action_types.dart         # 操作项模型与常量
├── test/
│   └── ant_swipe_action_test.dart              # 行为、几何与吸附逻辑
├── example/lib/main.dart                       # 交互式演示入口
└── docs/api-index.md                           # 逐符号 API 索引
```

## 许可证

MIT。见仓库根目录 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
