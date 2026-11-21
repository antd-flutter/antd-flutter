/// AntConfigProvider 类型定义
library;

/// 文本方向。
enum AntConfigDirection {
  /// 从左到右
  ltr,

  /// 从右到左
  rtl,
}

/// AntConfigProvider 国际化配置。
///
/// 由语言码 + 自定义文案 Map 组成，`messages` 作为文案扩展位，
/// 组件可通过 `locale.messages['key']` 读取自定义文案。
class AntConfigLocale {
  /// 创建国际化配置。
  const AntConfigLocale({
    required this.languageCode,
    this.messages = const {},
  });

  /// 语言码，如 `zh`、`en`、`zh-CN`。
  final String languageCode;

  /// 自定义文案表（key → 文案）。
  final Map<String, String> messages;

  /// 读取文案，key 不存在时返回 [fallback]（默认为 key 本身）。
  String text(String key, [String? fallback]) =>
      messages[key] ?? fallback ?? key;

  @override
  bool operator ==(Object other) =>
      other is AntConfigLocale &&
      other.languageCode == languageCode &&
      _mapEquals(other.messages, messages);

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (b[key] != a[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(languageCode, Object.hashAll(messages.keys));
}
