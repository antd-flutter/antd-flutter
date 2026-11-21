# antd_floating - 可拖拽的浮动面板与浮动气泡

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_floating/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_floating/README_CN.md)

## 定位与设计

`antd_floating` 为 Flutter 实现 antd-mobile v5 的两个组件：`AntFloatingPanel` 是在多个锚点高度之间吸附的底部面板，`AntFloatingBubble` 是可拖拽、可展开菜单的浮动操作按钮。两者都由手势驱动，且相互独立。

- **两个独立组件。** 各自对齐 antd-mobile 的对应组件，可单独使用。
- **面板几何。** 锚点是基准高度（父容器高度，或设置后的 `contentHeight`）的升序比例（0–1）；面板从最低锚点开始。
- **面板运动。** 拖动时高度直接跟随手指，松手后以 250 ms 动画吸附到最近锚点。
- **气泡几何。** 位置相对父容器左上角，并按当前主题缩放因子换算，因此在不同密度下保持比例。
- **气泡命中区域。** 气泡渲染为铺满父容器的透明层，自身与菜单之外使用 `IgnorePointer`。请把它放在内容之上的 `Stack` 或 `Overlay` 中。
- **状态访问。** 两个组件都提供 `ChangeNotifier` 控制器；对未挂载控制器的调用是安全的空操作。
- **内容自行滚动。** 面板不添加滚动行为，且底部对齐；内部请放置 `ListView` / `CustomScrollView`。

## 安装

需要 Dart `>=3.0.0 <4.0.0` 与 Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_floating: ^1.0.0
```

## 快速开始

以下应用完整且可直接运行：

```dart
import 'package:antd_floating/antd_floating.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const FloatingApp());

class FloatingApp extends StatelessWidget {
  const FloatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: Color(0xFFF5F5F5))),
              Align(
                alignment: Alignment.bottomCenter,
                child: AntFloatingPanel(
                  onHeightChange: (ratio) => debugPrint('panel: $ratio'),
                  child: ListView.builder(
                    itemCount: 30,
                    itemBuilder: (context, i) => ListTile(title: Text('Item $i')),
                  ),
                ),
              ),
              AntFloatingBubble(
                initialPos: const Offset(24, 120),
                onClick: () => debugPrint('bubble tapped'),
                child: const Icon(Icons.edit_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_floating/docs/api-index.md)

通过 `import 'package:antd_floating/antd_floating.dart';` 引入两个组件、各自的控制器与选项类型。

### 自定义锚点的面板

```dart
AntFloatingPanel(
  anchors: const [0.3, 0.6, 1.0],
  onHeightChange: (ratio) => debugPrint('$ratio'),
  child: ListView.builder(
    itemCount: 50,
    itemBuilder: (context, i) => ListTile(title: Text('Row $i')),
  ),
);
```

### 以代码控制面板

```dart
final panel = AntFloatingPanelController();

AntFloatingPanel(
  controller: panel,
  child: ListView.builder(
    itemCount: 50,
    itemBuilder: (context, i) => ListTile(title: Text('Row $i')),
  ),
);

// 在按钮或快捷键回调中：
panel.expand();
panel.snapToAnchorAt(1);
panel.collapse();
panel.resetToInitial();
```

### 带菜单的气泡

```dart
AntFloatingBubble(
  initialPos: const Offset(24, 120),
  autoSnapToEdge: true,
  menu: [
    AntFloatingBubbleMenuAction(
      label: 'Edit',
      icon: const Icon(Icons.edit_outlined),
      onClick: () {},
    ),
    AntFloatingBubbleMenuAction(
      label: 'Share',
      icon: const Icon(Icons.share_outlined),
      onClick: () {},
    ),
  ],
  child: const Icon(Icons.add, color: Colors.white),
);
```

## 项目结构

```text
packages/antd_floating/
├── lib/
│   ├── antd_floating.dart                     # 公共出口
│   └── src/
│       ├── floating_panel/
│       │   ├── ant_floating_panel.dart        # 面板组件
│       │   ├── ant_floating_panel_types.dart  # 高度变化回调类型
│       │   └── ant_floating_panel_controller.dart
│       └── floating_bubble/
│           ├── ant_floating_bubble.dart       # 气泡组件
│           ├── ant_floating_bubble_types.dart # 轴向、边缘与菜单项
│           └── ant_floating_bubble_controller.dart
├── example/lib/main.dart                      # 示例应用
├── docs/api-index.md                          # 生成的 API 索引
├── test/
│   ├── floating_panel/ant_floating_panel_test.dart
│   └── floating_bubble/ant_floating_bubble_test.dart
├── CHANGELOG.md
├── README.md
├── README_CN.md
└── pubspec.yaml
```

## 许可证

MIT。详见仓库根目录的 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
