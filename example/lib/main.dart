library;

/// antd-flutter 官网示例应用入口
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_device_preview.dart';
import 'pages/home_page.dart';

/// 全局亮暗模式切换（demo 演示用）
class ThemeModeController extends ValueNotifier<bool> {
  ThemeModeController() : super(false);
  void toggle() => value = !value;
}

final themeModeController = ThemeModeController();

void main() {
  // device_preview 中间件隔离接入（仅 desktop/web 启用，不区分
  // debug/release；移动端原样返回默认绑定，零影响）。
  AntDevicePreview.bootstrap();
  runApp(const AntdFlutterExampleApp());
}

/// antd-flutter 官网根组件
class AntdFlutterExampleApp extends StatelessWidget {
  const AntdFlutterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntResponsiveInit(
      // OHOS 折叠态经 AntOhosChannel 透出；其他平台自动从
      // displayFeatures 推导，无法获取时为 unknown/flat。
      foldStateProvider: AntPlatform.isOhos
          ? () => AntOhosChannelRegistry.channel.getFoldStateSync()
          : null,
      builder: (context, data, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: themeModeController,
          builder: (context, isDark, _) {
            return AntTheme(
              data: isDark ? AntThemeData.dark() : AntThemeData.light(),
              // device_preview 一行接入（3.0 绑定层模拟，透传即可）。
              child: AntDevicePreview.wrap(
                context,
                MaterialApp(
                  title: 'antd-flutter',
                  debugShowCheckedModeBanner: false,
                  locale: AntDevicePreview.localeOf(context),
                  builder: AntDevicePreview.appBuilder,
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  theme: AntThemeData.light().toThemeData(),
                  darkTheme: AntThemeData.dark().toThemeData(),
                  home: const HomePage(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
