library;

/// antd-flutter 官网示例应用入口
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'pages/home_page.dart';

/// 全局亮暗模式切换（demo 演示用）
class ThemeModeController extends ValueNotifier<bool> {
  ThemeModeController() : super(false);
  void toggle() => value = !value;
}

final themeModeController = ThemeModeController();

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
    return AntScreenUtilInit(
      builder: (context, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: themeModeController,
          builder: (context, isDark, _) {
            return AntTheme(
              data: isDark ? AntThemeData.dark() : AntThemeData.light(),
              child: MaterialApp(
                title: 'antd-flutter',
                debugShowCheckedModeBanner: false,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                theme: AntThemeData.light().toThemeData(),
                darkTheme: AntThemeData.dark().toThemeData(),
                home: const HomePage(),
              ),
            );
          },
        );
      },
    );
  }
}