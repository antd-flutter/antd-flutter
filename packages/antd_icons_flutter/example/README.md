# antd_icons_example

Ant Design Icons for Flutter 图标预览画廊应用。

## 支持平台

全平台：iOS / Android / macOS / Windows / Linux / Web

## 运行

```bash
cd packages/antd_icons_flutter/example
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
flutter build windows --debug    # Windows
flutter build linux --debug      # Linux（需 clang/cmake/ninja/pkg-config/libgtk-3-dev）
```

## 嵌入模式（Web）

URL 查询参数：`?theme=dark`、`?primary=#1677ff`、`?embedded=true`，见 `lib/app_launch_config.dart`。
