# antd_qrcode

Ant Design v6 QRCode 组件的 Flutter 实现 — 二维码展示，支持纠错等级、状态覆盖层与内嵌图标，API 对齐 antd QRCode。

> 当前为预览版本。

## 安装

```yaml
dependencies:
  antd_qrcode: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_qrcode/antd_qrcode.dart';

// ── 基础用法 ─────────────────────────────────────────────
AntQRCode(value: 'https://example.com');

// ── 常用参数 ─────────────────────────────────────────────
AntQRCode(
  value: 'https://example.com',
  size: 160,                          // 尺寸
  errorLevel: AntQRCodeErrorLevel.m,  // 纠错等级 L / M / Q / H
  color: Colors.black,                // 码点颜色
  bgColor: Colors.white,              // 背景色
  bordered: true,                     // 边框开关
);

// ── 内嵌图标 ─────────────────────────────────────────────
AntQRCode(value: 'https://example.com', icon: true, iconSize: 40);

// ── 状态覆盖层（过期刷新 / 已扫描） ──────────────────────
AntQRCode(
  value: 'https://example.com',
  status: AntQRCodeStatus.expired,
  onRefresh: () {}, // 点击「点击刷新」覆盖层后回调，自行更新 value
);
```

## 文档与演示

- [API 文档总览](docs/api-index.md)
- 在线演示：<https://flutter-open.github.io/antd-flutter/qr_code/>

## License

MIT License，详见仓库根 [LICENSE](../../LICENSE)；内置 QR 生成引擎来源与授权见 [LICENSE-THIRD-PARTY.md](LICENSE-THIRD-PARTY.md)。
