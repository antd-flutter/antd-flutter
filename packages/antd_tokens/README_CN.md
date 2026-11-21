# antd_tokens - Flutter 的 Ant Design v6 设计令牌

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tokens/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tokens/README_CN.md)

`antd_tokens` 是 `antd_flutter` 体系的令牌层。它把 Ant Design v6 的种子令牌、令牌生成算法、颜色别名映射与阴影令牌移植为纯 Dart 实现。对每个下游组件来说，本包回答同一个问题：给定一个种子（主色、字号、圆角基数、控件高度），某个组件应使用的 `colorTextSecondary`、`fontSizeHeading1` 或 `controlHeightSM` 究竟是多少？

把生成过程与主题分离是有意为之。生成器都是普通函数，不依赖 `BuildContext`、Widget 或继承状态，因此同一套算法可以运行在测试、CLI 工具或主题对象中。`AntSeedToken` 不可变且便于 `copyWith`；`AntColorTokens` 与 `AntShadowTokens` 产出 Flutter `Color` 和 `BoxShadow`，同时通过 `AntColorTokensCss` 暴露原始 CSS 字符串，供需要输出 CSS 变量的场景使用。

## 定位与设计

- **种子 → 映射 → 别名，完全对齐 antd。** 每个生成器对应一个 antd 函数（`genFontSizes`、`genRadius`、`genSizeMapToken`、`genControlHeight`、`genCommonMapToken` 的运动部分），包括取整与钳制规则。
- **提供函数，而不是框架对象。** 每个生成器都是返回不可变值对象的顶层函数，没有隐式全局状态，也不依赖 Flutter 的 Widget 树。
- **亮色与暗色是同一组种子的两套映射。** `AntColorTokens.light` 与 `.dark` 共享别名，仅映射表不同，组件代码无需按明暗分支。
- **CSS 字符串始终可用。** `AntColorTokensCss` 在解析后的 `Color` getter 旁提供原始值（`#1677ff`、`rgba(...)`），保证 Web 与移动端输出一致。
- **阴影由单一颜色生成。** `AntShadowTokens.generate` 从一个阴影色推导全部 13 组层级阴影，暗色主题只需更换该输入。

## 安装

要求 Dart 3.0+、Flutter 3.10+。

```yaml
dependencies:
  antd_tokens: ^1.0.0
```

## 快速开始

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  // 从 antd 默认值出发，只覆盖品牌需要变化的字段。
  const seed = AntSeedToken();
  final brand = seed.copyWith(colorPrimary: '#722ed1', borderRadius: 8);

  // 生成器把标量种子展开为完整梯级。
  print(antGenFontMapToken(brand.fontSize).fontSizeLG); // 16
  print(antGenRadius(brand.borderRadius).borderRadiusLG); // 8

  // 颜色别名按明暗各自生成一份映射。
  final colors = AntColorTokens.light(brand);
  print(colors.colorPrimary);
}
```

## API

[API 文档](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_tokens/docs/api-index.md)

### 推导尺寸、高度与动效梯级

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  final sizes = antGenSizeMapToken(sizeUnit: 4, sizeStep: 4);
  print(sizes.size); // 16
  print(sizes.sizeXXL); // 48

  final heights = antGenControlHeight(32);
  print(heights.controlHeightSM); // 24

  final motion = antGenMotionDuration(
    motionUnit: 0.1,
    motionBase: 0,
    motion: true,
  );
  print(motion.mid); // 0.2
}
```

### 读取亮色与暗色颜色别名

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  final light = AntColorTokens.light(const AntSeedToken());
  print(light.colorPrimary);
  print(light.css.colorPrimary); // '#1677ff'

  final dark = AntColorTokens.dark(AntSeedToken.dark());
  print(dark.colorBgContainer);
}
```

### 由单一阴影色构建层级阴影

```dart
import 'package:antd_tokens/antd_tokens.dart';

void main() {
  final shadows = AntShadowTokens.generate('#000000');
  print(shadows.boxShadow.length);
  print(shadows.boxShadowSecondary);
}
```

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/tokens/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
antd_tokens/
├── lib/
│   ├── antd_tokens.dart             # 公共出口
│   └── src/
│       ├── ant_seed_token.dart      # 种子令牌 + 明暗工厂
│       ├── ant_token_generators.dart # 生成器聚合出口
│       ├── ant_color_tokens.dart    # 颜色别名映射（亮/暗）
│       ├── ant_shadow_tokens.dart   # 层级阴影
│       ├── generators/              # 字体、圆角、尺寸、高度、动效
│       └── css/                     # AntColorTokensCss 原始字符串
├── test/
│   ├── ant_color_tokens_test.dart
│   ├── ant_seed_token_test.dart
│   ├── ant_shadow_tokens_test.dart
│   └── ant_token_generators_test.dart
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
