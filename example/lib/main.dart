/// antd-flutter 官网示例应用入口
library;

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const AntdFlutterExampleApp(),
    ),
  );
}

/// antd-flutter 官网根组件
class AntdFlutterExampleApp extends StatelessWidget {
  const AntdFlutterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'antd-flutter',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1677FF), // Ant Design v6 主色
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}