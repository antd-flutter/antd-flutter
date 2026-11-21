/// AntConfigProvider — antd React ConfigProvider 的 Flutter 实现
///
/// 为组件树注入全局配置：主题数据、国际化 locale、文本方向。
/// InheritedWidget 模式，child 常与 [AntTheme] 和 [Directionality] 组合包裹。
///
/// API 与 antd React ConfigProvider 对齐：
/// - [AntConfigProvider.antdTheme] — 主题注入（内部组合 AntTheme）
/// - [AntConfigProvider.locale] — 国际化配置
/// - [AntConfigProvider.direction] — 文本方向（ltr / rtl）
///
/// ```dart
/// AntConfigProvider(
///   antdTheme: AntThemeData.dark(),
///   locale: AntConfigLocale(languageCode: 'zh-CN'),
///   direction: AntConfigDirection.ltr,
///   child: MaterialApp(...),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_config_provider_types.dart';
export 'ant_config_provider_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntConfigData — 解析后的配置快照
// ============================================================

/// AntConfigProvider 注入的配置数据。
class AntConfigData {
  /// 创建配置快照。
  const AntConfigData({
    this.antdTheme,
    this.locale,
    this.direction = AntConfigDirection.ltr,
  });

  /// 无 Provider 时的默认配置。
  static const AntConfigData fallback = AntConfigData();

  /// 主题数据；null 表示未注入（组件回退 AntTheme 默认主题）。
  final AntThemeData? antdTheme;

  /// 国际化配置；null 表示未设置。
  final AntConfigLocale? locale;

  /// 文本方向，默认 ltr。
  final AntConfigDirection direction;

  /// 便捷读取：文案（无 locale 时回退 key）。
  String text(String key, [String? fallback]) =>
      locale?.text(key, fallback) ?? fallback ?? key;
}

// ============================================================
// AntConfigProvider
// ============================================================

/// 全局化配置入口 — 为组件树注入主题 / 国际化 / 文本方向。
///
/// 对齐 antd React ConfigProvider 组件。
class AntConfigProvider extends StatelessWidget {
  /// 创建 AntConfigProvider。
  const AntConfigProvider({
    super.key,
    this.antdTheme,
    this.locale,
    this.direction,
    required this.child,
  });

  /// 注入的主题数据；非空时内部组合 AntTheme 使后代组件生效新主题。
  final AntThemeData? antdTheme;

  /// 国际化配置。
  final AntConfigLocale? locale;

  /// 文本方向；非空时内部组合 Directionality。
  final AntConfigDirection? direction;

  /// 被包裹的组件树。
  final Widget child;

  /// 获取最近祖先 [AntConfigProvider] 的配置。
  ///
  /// 实现约定：无 Provider 时返回 [AntConfigData.fallback]（不抛错），
  /// 可通过 `locale == null` 判断是否存在 Provider。
  static AntConfigData of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<_AntConfigScope>();
    if (widget == null) return AntConfigData.fallback;
    return AntConfigData(
      antdTheme: widget.provider.antdTheme,
      locale: widget.provider.locale,
      direction: widget.provider.direction ?? AntConfigDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _AntConfigScope(provider: this, child: child);

    final dir = direction ?? AntConfigDirection.ltr;
    content = Directionality(
      textDirection: dir == AntConfigDirection.rtl
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: content,
    );

    if (antdTheme != null) {
      content = AntTheme(data: antdTheme!, child: content);
    }

    return content;
  }
}

// ============================================================
// _AntConfigScope — InheritedWidget
// ============================================================

class _AntConfigScope extends InheritedWidget {
  const _AntConfigScope({
    required this.provider,
    required super.child,
  });

  final AntConfigProvider provider;

  @override
  bool updateShouldNotify(_AntConfigScope oldWidget) =>
      provider.antdTheme != oldWidget.provider.antdTheme ||
      provider.locale != oldWidget.provider.locale ||
      provider.direction != oldWidget.provider.direction;
}
