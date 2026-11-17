/// 启动配置 — 从 URL 查询参数解析（嵌入场景由宿主页面注入）。
///
/// 支持的参数（仅 web 端经 `Uri.base` 生效，其他平台均为默认值）：
/// - `embed=1`       隐藏顶部导航（标题栏 / 主题切换 / 关于），仅渲染图标内容区
/// - `theme=dark`    强制暗色主题；`theme=light` 强制亮色主题
/// - `primary=0xFF1677FF` 或 `#1677ff` 自定义主题色种子
library;

import 'dart:ui';

/// 启动配置。
class AppLaunchConfig {
  const AppLaunchConfig({
    required this.embedded,
    required this.isDark,
    required this.primaryColor,
  });

  /// 默认配置（非嵌入 / 亮色 / antd 默认蓝）。
  const AppLaunchConfig.fallback()
      : this(embedded: false, isDark: false, primaryColor: defaultPrimaryColor);

  /// antd 品牌蓝（v4/v5 经典主色）。
  static const Color defaultPrimaryColor = Color(0xFF1677FF);

  /// 是否嵌入模式（隐藏顶部导航）。
  final bool embedded;

  /// 初始是否为暗色主题。
  final bool isDark;

  /// 主题色种子。
  final Color primaryColor;

  /// 从 URI 查询参数解析；无参数时字段均为默认值。
  factory AppLaunchConfig.fromUri(Uri uri) {
    final params = uri.queryParameters;

    final embed = params['embed'] == '1' || params['embed'] == 'true';

    // theme 参数仅在合法取值时生效，缺省为亮色（用户仍可通过
    // 顶栏按钮切换；强制场景显式传 dark/light）。
    final themeParam = params['theme']?.toLowerCase();
    final bool isDark = switch (themeParam) {
      'dark' => true,
      'light' => false,
      _ => false,
    };

    final primary = _parseColor(params['primary']) ?? defaultPrimaryColor;

    return AppLaunchConfig(
      embedded: embed,
      isDark: isDark,
      primaryColor: primary,
    );
  }

  /// 解析 `0xFF1677FF` / `#1677ff` / `1677ff` 形式的颜色值；非法返回 null。
  static Color? _parseColor(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    var hex = raw.trim();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.startsWith('0x') || hex.startsWith('0X')) hex = hex.substring(2);
    if (hex.length == 6) hex = 'FF$hex';
    final value = int.tryParse(hex, radix: 16);
    if (value == null || hex.length != 8) return null;
    return Color(value);
  }
}
