# antd_qrcode - 支持纠错等级与状态覆盖层的二维码渲染器

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/README_CN.md)

`antd_qrcode` 从字符串渲染二维码，API 对齐 antd v6 QRCode。支持四种纠错等级、自定义前景/背景色、边框、可选的中心图标，以及 `active` / `expired` / `scanned` 三种状态覆盖层。

组件只负责展示：把文本编码为二维码矩阵并绘制，不做扫码、解码或图片导出。编码运行在从 `package:qr` 3.0.3（BSD-3-Clause）吸收的纯 Dart 引擎上；绘制使用 `CustomPaint`，因此没有三方渲染依赖、没有平台通道、也不访问网络。

## 定位与设计

| 方面 | 决策 |
| --- | --- |
| 方向 | 文本 → 二维码矩阵 → 绘制模块。不解码、不扫码、不导出图片 |
| 引擎 | `package:qr` 3.0.3 源码吸收进 `lib/src/engines/qr/`，仅经 `AntQrMatrix` 暴露 |
| 渲染 | `CustomPaint` + `AntQrPainter`；每个深色模块都是方块，定位角与对齐图案同样如此 |
| 尺寸 | 外框为 `size`，码区为 `size` 减去每边 12px 内边距，均按主题因子缩放 |
| 状态 | `expired` / `scanned` 时二维码仍绘制在 92% 不透明度的覆盖层之下 |
| 本地化 | 覆盖层文案为固定中文；该 API 不做国际化 |

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_qrcode: ^1.0.0
```

在本 monorepo 内：

```yaml
dependencies:
  antd_qrcode:
    path: ../packages/antd_qrcode
```

## 快速开始

```dart
import 'package:antd_qrcode/antd_qrcode.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const QrApp());

class QrApp extends StatelessWidget {
  const QrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: AntQRCode(
              value: 'https://github.com/flutter-open/antd-flutter',
              size: 200,
              errorLevel: AntQRCodeErrorLevel.h,
              bordered: true,
            ),
          ),
        ),
      ),
    );
  }
}
```

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/docs/api-index.md)

提高冗余度并添加中心图标：

```dart
AntQRCode(
  value: 'https://example.com/ticket/001',
  size: 220,
  errorLevel: AntQRCodeErrorLevel.h,
  icon: true,
  iconSize: 44,
)
```

自定义前景与背景配色：

```dart
AntQRCode(
  value: 'WIFI:S:AntdDemo;T:WPA;P:password;;',
  color: const Color(0xFF0B3D91),
  bgColor: const Color(0xFFF7F9FC),
  bordered: false,
)
```

显示过期覆盖层，并在点击时刷新内容：

```dart
AntQRCode(
  value: 'ticket-001',
  status: AntQRCodeStatus.expired,
  onRefresh: () => debugPrint('request a new token'),
)
```

## 项目结构

```text
antd_qrcode/
├── lib/
│   ├── antd_qrcode.dart                    # 公开 barrel
│   └── src/
│       ├── qr_code/
│       │   ├── ant_qr_code.dart            # AntQRCode + AntQrPainter
│       │   └── ant_qr_code_types.dart      # 纠错等级 + 状态枚举
│       └── engines/qr/                     # 吸收的纯 Dart 二维码引擎
│           ├── ant_qr_engine.dart          # 中间层：AntQrMatrix
│           ├── qr_code.dart
│           ├── qr_image.dart
│           └── error_correct_level.dart
├── example/lib/main.dart                   # 演示画廊
├── test/
│   ├── ant_qr_code_test.dart
│   └── qr_engine_baseline_test.dart
├── docs/api-index.md
├── LICENSE-THIRD-PARTY.md
├── README.md
├── README_CN.md
├── CHANGELOG.md
└── pubspec.yaml
```

## 许可证

MIT。见仓库根目录 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。吸收的二维码引擎为 BSD-3-Clause，见 [LICENSE-THIRD-PARTY.md](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_qrcode/LICENSE-THIRD-PARTY.md)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
