/// 手动映射的本地化实现（与 `l10n/app_en.arb` / `l10n/app_zh.arb` 保持一致）。
///
/// 文案新增时需同步维护三个文件：两个 arb + 本文件。
library;

import 'package:material_ui/material_ui.dart';

/// 抽象文案集合。
abstract class AppStrings {
  /// 应用标题。
  String get appTitle;

  /// 搜索框占位文案。
  String get searchPlaceholder;

  /// 线性 tab 标题。
  String tabOutlined(int count);

  /// 填充 tab 标题。
  String tabFilled(int count);

  /// 双色 tab 标题。
  String tabTwoTone(int count);

  /// 搜索无结果文案。
  String emptyResult(String query);

  /// 已复制文案。
  String copied(String name);

  /// 关于按钮 tooltip。
  String get aboutTooltip;

  /// 关于弹窗标题。
  String get aboutTitle;

  /// 关于弹窗正文。
  String get aboutBody;

  /// 关闭按钮文案。
  String get close;

  /// 双色主色标签。
  String get twoToneColorLabel;

  /// 切换到亮色模式的 tooltip。
  String get themeLight;

  /// 切换到暗色模式的 tooltip。
  String get themeDark;
}

/// 英文文案。
class AppStringsEn implements AppStrings {
  @override
  String get appTitle => 'Ant Design Icons';

  @override
  String get searchPlaceholder => 'Search icons by name...';

  @override
  String tabOutlined(int count) => 'Outlined ($count)';

  @override
  String tabFilled(int count) => 'Filled ($count)';

  @override
  String tabTwoTone(int count) => 'TwoTone ($count)';

  @override
  String emptyResult(String query) => 'No icons found for "$query"';

  @override
  String copied(String name) => 'Copied: $name';

  @override
  String get aboutTooltip => 'About';

  @override
  String get aboutTitle => 'Ant Design Icons for Flutter';

  @override
  String get aboutBody =>
      'Flutter port of the Ant Design icon library.\n\n'
      '• Outlined + Filled: TTF font icons (698)\n'
      '• TwoTone: SVG two-color icons (150), with customizable primary color\n\n'
      'Tap any icon to copy its constant name.';

  @override
  String get close => 'Close';

  @override
  String get twoToneColorLabel => 'twoToneColor';

  @override
  String get themeLight => 'Light mode';

  @override
  String get themeDark => 'Dark mode';
}

/// 中文文案。
class AppStringsZh implements AppStrings {
  @override
  String get appTitle => 'Ant Design 图标';

  @override
  String get searchPlaceholder => '按名称搜索图标…';

  @override
  String tabOutlined(int count) => '线性（$count）';

  @override
  String tabFilled(int count) => '填充（$count）';

  @override
  String tabTwoTone(int count) => '双色（$count）';

  @override
  String emptyResult(String query) => '未找到与「$query」匹配的图标';

  @override
  String copied(String name) => '已复制：$name';

  @override
  String get aboutTooltip => '关于';

  @override
  String get aboutTitle => 'Ant Design Icons for Flutter';

  @override
  String get aboutBody =>
      'Ant Design 图标库的 Flutter 移植版。\n\n'
      '• 线性 + 填充：TTF 字体图标（698 个）\n'
      '• 双色：SVG 双色图标（150 个），支持自定义主色\n\n'
      '点击任意图标可复制其常量名。';

  @override
  String get close => '关闭';

  @override
  String get twoToneColorLabel => 'twoToneColor';

  @override
  String get themeLight => '亮色模式';

  @override
  String get themeDark => '暗色模式';
}

/// 本地化 InheritedWidget，通过 `AppLocalizations.of(context)` 就近读取文案。
class AppLocalizations extends InheritedWidget {
  const AppLocalizations({
    super.key,
    required this.strings,
    required super.child,
  });

  /// 当前语言文案集合。
  final AppStrings strings;

  /// 获取最近祖先的文案集合；无祖先时回退英文。
  static AppStrings of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<AppLocalizations>();
    return widget?.strings ?? _FallbackStrings()._en;
  }

  /// 由 [Locale] 解析文案集合（目前支持 zh / en）。
  static AppStrings resolve(Locale? locale) =>
      locale?.languageCode == 'zh' ? AppStringsZh() : AppStringsEn();

  @override
  bool updateShouldNotify(AppLocalizations oldWidget) =>
      strings.runtimeType != oldWidget.strings.runtimeType;
}

/// 无祖先时的英文回退文案。
class _FallbackStrings implements AppStrings {
  final AppStrings _en = AppStringsEn();

  @override
  String get appTitle => _en.appTitle;

  @override
  String get searchPlaceholder => _en.searchPlaceholder;

  @override
  String tabOutlined(int count) => _en.tabOutlined(count);

  @override
  String tabFilled(int count) => _en.tabFilled(count);

  @override
  String tabTwoTone(int count) => _en.tabTwoTone(count);

  @override
  String emptyResult(String query) => _en.emptyResult(query);

  @override
  String copied(String name) => _en.copied(name);

  @override
  String get aboutTooltip => _en.aboutTooltip;

  @override
  String get aboutTitle => _en.aboutTitle;

  @override
  String get aboutBody => _en.aboutBody;

  @override
  String get close => _en.close;

  @override
  String get twoToneColorLabel => _en.twoToneColorLabel;

  @override
  String get themeLight => _en.themeLight;

  @override
  String get themeDark => _en.themeDark;
}
