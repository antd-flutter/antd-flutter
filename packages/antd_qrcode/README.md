# antd_qrcode

Ant Design v6 [QRCode](https://ant.design/components/qrcode-cn) 组件的 Flutter 实现（独立组件包）。

## 特性

- `AntQRCode` — 二维码展示，API 对齐 antd v6 QRCode
  - `value` / `size` / `errorLevel`（L/M/Q/H）/ `color` / `bgColor`
  - 中间图标模式（`icon` / `iconSize`）
  - 状态覆盖层：`status` = active / expired / scanned，过期后 `onRefresh` 刷新
  - `bordered` 边框开关
- QR 生成引擎（qr_flutter）经组件内中间层隔离，SDK 语义不泄漏到组件 API
- 主题接入：`antd_theme` Design Token

## 安装

```yaml
dependencies:
  antd_qrcode: ^0.1.0-beta.1
```

## 使用

```dart
import 'package:antd_qrcode/antd_qrcode.dart';

AntQRCode(value: 'https://example.com')
AntQRCode(value: 'https://example.com', status: AntQRCodeStatus.expired, onRefresh: () {})
```

## 说明

- **Flutter 别名层**：QRCode 无 Flutter 语义对应物（Flutter SDK 无内置二维码组件），按独立包准入标准不造别名，直接使用 `AntQRCode`。
- **`.antd` 扩展**：本包无高频 Flutter 组件对应场景，评估后不实现 `.antd` 扩展。
