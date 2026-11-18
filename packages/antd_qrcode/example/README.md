# antd_qrcode_example

Ant Design v6 QRCode（antd_qrcode 独立包）组件演示画廊，覆盖全部关键形态：

- 基础二维码（默认参数）
- 纠错等级 L / M / Q / H 四档
- 自定义颜色（color / bgColor，暗色模式适配）
- 尺寸对比（64 / 96 / 128 / 160）
- bordered 开关
- 中心图标模式（icon / iconSize）
- 状态演示：expired（点击刷新）与 scanned 覆盖层

## 运行

```bash
cd packages/antd_qrcode/example
flutter pub get

# iOS
flutter run -d ios

# Android
flutter run -d android

# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# Web
flutter run -d chrome
```

## 构建

```bash
flutter build web --release
flutter build macos --debug      # macOS
flutter build apk --debug        # Android
flutter build ios --debug --no-codesign
```

## 截图

> TODO: 各平台运行截图（占位）

| 亮色 | 暗色 |
| ---- | ---- |
| ![light](../../doc/screenshots/qrcode_example_light.png) | ![dark](../../doc/screenshots/qrcode_example_dark.png) |
