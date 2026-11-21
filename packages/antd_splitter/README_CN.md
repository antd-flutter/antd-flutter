# antd_splitter - Flutter 可拖拽分栏组件

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_splitter/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_splitter/README_CN.md)

`antd_splitter` 将 Ant Design 的 Splitter 分栏模式带到 Flutter。它把两个或多个面板沿水平或垂直方向排列，用户拖动分隔条即可调整面板尺寸。每个面板可以声明初始尺寸、受控尺寸、最小/最大约束，以及是否允许折叠。

这是一个**布局**组件，而不是滚动组件：拖动时它会重新布局子节点。因此本包没有 sliver 版本，并且 Splitter 在主轴方向必须获得有界尺寸。

## 定位与设计

- **面板是配置对象。** `children` 只接受 `AntSplitterPanel`，每个面板保存自己的约束和一个子节点。
- **尺寸使用逻辑像素。** 实际渲染尺寸会乘以当前 `AntTheme` 的缩放系数，从而适配不同密度。
- **受控时状态归调用方所有。** `AntSplitterPanel.size` 非空即视为受控值；调用方必须在 `onResize` 中回写，否则拖动不会生效。
- **回调返回完整尺寸向量。** 调整与折叠回调给出所有面板的尺寸，而不是增量。
- **依赖面尽量小。** 本包只依赖 `antd_theme`、`antd_icons_flutter`、`material_ui`，不依赖主包 `antd_flutter_plus`。

## 安装

需要 Flutter 3.10+ 与 Dart 3.0+。

```yaml
dependencies:
  antd_splitter: ^1.0.0
```

请用 `AntTheme` 包裹子树，使面板样式、分隔条颜色和缩放来自设计 Token：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

```dart
import 'package:antd_splitter/antd_splitter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 240,
                child: AntSplitter(
                  children: [
                    AntSplitterPanel(
                      defaultSize: 180,
                      min: 120,
                      child: const ColoredBox(
                        color: Color(0xFFE6F4FF),
                        child: Center(child: Text('侧边栏')),
                      ),
                    ),
                    AntSplitterPanel(
                      child: const ColoredBox(
                        color: Color(0xFFF6FFED),
                        child: Center(child: Text('内容区')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
```

没有 `defaultSize` 的面板会平分剩余空间。上面的例子中侧边栏占 180 逻辑像素，内容区拿走剩余宽度。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_splitter/docs/api-index.md)

添加尺寸约束与折叠控件：

```dart
AntSplitter(
  onCollapse: (collapsed, sizes) {
    debugPrint('collapsed=$collapsed sizes=$sizes');
  },
  children: [
    AntSplitterPanel(
      defaultSize: 220,
      min: 160,
      max: 360,
      collapsible: true,
      child: const Center(child: Text('Inspector')),
    ),
    AntSplitterPanel(
      min: 320,
      child: const Center(child: Text('Canvas')),
    ),
    AntSplitterPanel(
      defaultSize: 180,
      resizable: false,
      child: const Center(child: Text('Pinned')),
    ),
  ],
)
```

在垂直分栏中嵌套水平分栏：

```dart
SizedBox(
  height: 320,
  child: AntSplitter(
    layout: AntSplitterLayout.vertical,
    children: [
      AntSplitterPanel(
        defaultSize: 96,
        child: const Center(child: Text('Toolbar')),
      ),
      AntSplitterPanel(
        child: AntSplitter(
          children: [
            AntSplitterPanel(
              defaultSize: 200,
              min: 160,
              child: const Center(child: Text('Navigator')),
            ),
            AntSplitterPanel(
              child: const Center(child: Text('Editor')),
            ),
          ],
        ),
      ),
    ],
  ),
)
```

只在拖动结束时提交尺寸，并在 `onResize` 中回写：

```dart
AntSplitter(
  lazy: true,
  onResize: (sizes) => setState(() => _sidebarSize = sizes.first),
  children: [
    AntSplitterPanel(
      size: _sidebarSize,
      min: 160,
      max: 400,
      child: const Center(child: Text('Controlled sidebar')),
    ),
    AntSplitterPanel(
      child: const Center(child: Text('Content')),
    ),
  ],
)
```

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/splitter/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_splitter/
├── lib/
│   ├── antd_splitter.dart                  # barrel 导出
│   └── src/splitter/
│       ├── ant_splitter.dart               # 分栏、面板、拖动/折叠引擎
│       └── ant_splitter_types.dart         # 布局枚举与折叠回调
├── test/
│   ├── ant_splitter_test.dart              # 行为与边界用例
│   └── ant_splitter_matrix_test.dart       # 布局矩阵与点击区域几何
├── example/lib/main.dart                   # 交互式演示入口
└── docs/api-index.md                       # 逐符号 API 索引
```

## 许可证

MIT。见仓库根目录 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
