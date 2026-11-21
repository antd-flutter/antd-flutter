# antd_theme - Flutter 的 Ant Design v6 主题系统

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_theme/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_theme/README_CN.md)

`antd_theme` 把 `antd_tokens` 的原始令牌变成可从 Widget 树读取的 Flutter 主题。它端到端承载 antd 的三层结构——**Seed → Map → Alias**——并用一个 `AntThemeData` 对象暴露约一百个颜色别名，以及字体、间距、圆角、控件高度、动效、阴影、z-index 与屏幕断点数值。组件读取 `theme.colorBgContainer` 或 `theme.fontSizeHeading1`，而不是硬编码数字或按明暗分支。

主题中与 Flutter 强相关的部分也由本包负责：`AntTheme` 继承作用域、`AntThemeBuilder` 便捷组件、让原生 Material 控件继承 antd 值的 Material 桥接（`toThemeData()`）、断点与平台辅助类，以及通过 `theme.s()` 把设计值换算为设备值的 `AntScale`。本包不提供视觉组件，只定义这些组件所消费的契约。

## 定位与设计

- **一个对象，三层结构。** `AntThemeData` 同时持有种子、生成的令牌映射与别名 getter。用 `fromSeed` 创建主题时会重新执行推导；此后读取 `theme.colorPrimary` 就是直接字段访问。
- **明暗是属性，不是代码分支。** `AntThemeData.light()` 与 `.dark()` 提供完全相同的 API 表面。组件从不检查 `isDark` 来选色，而是直接请求别名，由对应映射表给出值。
- **桥接 Material，而非替换它。** `toThemeData()` 把 antd 令牌映射到 `ColorScheme`、`TextTheme` 与组件主题，使原生 Material 控件外观一致。`AntTheme` 用 `Theme(data: ...)` 包裹应用，同时通过继承作用域保留 `AntThemeData` 的读取能力。
- **缩放只有一个入口。** `theme.s(12)` 把设计值乘以 `AntScale.factor`。`AntScale.auto(context)` 依据屏幕短边推导该系数，并夹在 `min` 与 `max` 之间、在桌面端禁用；`AntScale.none` 保持 1:1。
- **响应式数据靠继承，而非每个组件重建。** `AntResponsiveInit` 只解析一次宽度、断点、设备类型、方向、折叠态与平台，然后通过 `AntResponsive` 暴露，查询成本很低。
- **平台差异集中在一处。** `AntPlatform` 统一承载悬停、触摸涟漪、滚动条与键盘预期，避免 `Platform.isX` 检查散落在各组件中。

## 安装

要求 Dart 3.0+、Flutter 3.10+。

```yaml
dependencies:
  antd_theme: ^1.0.0
```

## 快速开始

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    AntTheme(
      data: AntThemeData.light(scale: const AntScale(1.1)),
      child: MaterialApp(
        home: AntThemeBuilder(
          builder: (context, theme) {
            return Scaffold(
              backgroundColor: theme.colorBgLayout,
              body: Center(
                child: Container(
                  padding: EdgeInsets.all(theme.s(16)),
                  decoration: BoxDecoration(
                    color: theme.colorBgContainer,
                    borderRadius: BorderRadius.circular(theme.borderRadiusLG),
                    boxShadow: theme.boxShadowTertiary,
                  ),
                  child: Text(
                    'Ant Design tokens in Flutter',
                    style: TextStyle(
                      color: theme.colorText,
                      fontSize: theme.fontSizeLG,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
```

## API

[API 文档](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_theme/docs/api-index.md)

### 创建主题、缩放数值、桥接 Material

```dart
import 'package:antd_theme/antd_theme.dart';

void main() {
  final light = AntThemeData.light();
  final dark = AntThemeData.dark();

  print(light.colorPrimary);
  print(dark.colorBgContainer);
  print(light.s(12)); // 按主题系数缩放的设计值

  // 原生 Material 组件也可继承 antd 数值。
  final material = light.toThemeData();
  print(material.colorScheme.primary);
}
```

### 按断点与平台分支

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: BreakpointBadge()));

class BreakpointBadge extends StatelessWidget {
  const BreakpointBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final breakpoint = AntBreakpoint.of(context);
    final compact = breakpoint == null ||
        breakpoint == AntBreakpoint.xs ||
        breakpoint == AntBreakpoint.sm;

    return Center(
      child: Text(
        compact ? 'compact layout' : 'wide layout (${breakpoint!.name})',
        style: TextStyle(fontSize: AntPlatform.isDesktop ? 14 : 16),
      ),
    );
  }
}
```

## 项目结构

```text
antd_theme/
├── lib/
│   ├── antd_theme.dart              # 公共出口
│   └── src/
│       ├── ant_theme_data.dart      # AntThemeData + 别名 getter + s()
│       ├── ant_theme.dart           # AntTheme 作用域 + AntThemeBuilder
│       ├── ant_material_bridge.dart # toThemeData() 桥接
│       ├── ant_responsive.dart      # AntResponsiveInit / AntResponsive
│       ├── ant_breakpoint.dart      # 断点解析
│       ├── ant_scale.dart           # 设计值到设备值缩放
│       ├── ant_platform.dart        # 平台能力辅助
│       ├── ant_screen_util.dart
│       ├── ant_overlay_material.dart
│       ├── enum/                    # 断点与响应式枚举
│       └── types/                   # 布局与子令牌数据类型
├── test/
│   ├── ant_material_bridge_test.dart
│   ├── ant_responsive_test.dart
│   ├── ant_scale_test.dart
│   └── ant_theme_test.dart
└── docs/
    ├── api-index.md
    └── api/
```

## 许可证

MIT

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" />
