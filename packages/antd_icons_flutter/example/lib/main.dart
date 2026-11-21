/// Ant Design Icons for Flutter 预览应用入口。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData(light/dark).toThemeData()`
/// - 支持嵌入模式 URL 参数（见 [AppLaunchConfig]）
/// - 文案中英文国际化（见 `lib/l10n/`）
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:material_ui/material_ui.dart';

import 'app_launch_config.dart';
import 'gallery_page.dart';
import 'l10n/app_localizations.dart';

/// 全局亮暗模式切换（初始值来自 URL `?theme=` 参数）。
class ThemeController extends ValueNotifier<bool> {
  ThemeController({required bool initialDark}) : super(initialDark);

  /// 切换明暗。
  void toggle() => value = !value;
}

/// 全局主题控制器（demo 演示用）。
late final ThemeController themeModeController;

/// 启动配置（web 端解析 `Uri.base` 查询参数）。
final AppLaunchConfig launchConfig = AppLaunchConfig.fromUri(Uri.base);

void main() {
  themeModeController = ThemeController(initialDark: launchConfig.isDark);
  runApp(const AntdIconsGalleryApp());
}

/// antd 图标画廊根组件。
class AntdIconsGalleryApp extends StatelessWidget {
  const AntdIconsGalleryApp({super.key});

  /// Color → `#1677ff` 形式的种子色字符串。
  static String _toSeedHex(Color color) {
    final argb = color.toARGB32();
    final rgb = argb & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: themeModeController,
        builder: (context, isDark, _) {
          final antThemeData = AntThemeData.fromSeed(
            AntSeedToken(colorPrimary: _toSeedHex(launchConfig.primaryColor)),
            isDark: isDark,
          );
          // 与根 example 约定一致：AntTheme 包裹 + MaterialApp 挂
          // toThemeData() 派生主题，Material 控件自动呈现 antd 风格。
          return AntTheme(
            data: antThemeData,
            child: MaterialApp(
              title: 'Ant Design Icons',
              debugShowCheckedModeBanner: false,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              theme: AntThemeData.fromSeed(
                AntSeedToken(
                  colorPrimary: _toSeedHex(launchConfig.primaryColor),
                ),
                isDark: false,
              ).toThemeData(),
              darkTheme: AntThemeData.fromSeed(
                AntSeedToken(
                  colorPrimary: _toSeedHex(launchConfig.primaryColor),
                ),
                isDark: true,
              ).toThemeData(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('zh')],
              home: GalleryPage(embedded: launchConfig.embedded),
              builder: (context, child) => AppLocalizations(
                strings: AppLocalizations.resolve(
                  Localizations.maybeLocaleOf(context),
                ),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          );
        },
      );
  }
}
