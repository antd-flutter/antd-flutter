/// AntCalendar 国际化文案配置。
///
/// 独立包内建 locale 体系（风格对齐主包 AntConfigProvider / AntConfigLocale）：
/// - 内建常用语言预设：`zh` / `zhTw` / `en` / `ja` / `ko` / `fr` / `de` /
///   `es` / `ru` / `pt` / `it` / `ar` / `th` / `vi` / `id`；
/// - [AntCalendarLocale.fromLanguageCode] 按语言码解析（未知码回退中文）；
/// - 支持自定义字段覆盖（构造参数）与 `messages` 扩展文案表；
/// - 组件可经 `locale` 参数注入，或全局经 [AntCalendarLocaleProvider] 注入，
///   都未提供时回退中文预设。
library;

import 'package:flutter/widgets.dart';

/// 中文（简体）内置文案常量，作为所有 locale 的最终回退。
const AntCalendarLocale _zhDefaults = AntCalendarLocale._raw(
  languageCode: 'zh',
  monthTitlePattern: '{year}年{month}月',
  todayText: '本月',
  confirmText: '确定',
  cancelText: '取消',
  yearSuffix: '年',
  monthSuffix: '月',
  weekLabels: ['一', '二', '三', '四', '五', '六', '日'],
);

/// 日历国际化文案。
class AntCalendarLocale {
  /// 创建国际化配置（未提供的字段逐级回退 [fallback]，最终回退中文预设）。
  const AntCalendarLocale({
    this.languageCode = 'zh',
    this.monthTitlePattern,
    this.todayText,
    this.confirmText,
    this.cancelText,
    this.yearSuffix,
    this.monthSuffix,
    this.weekLabels,
    this.messages = const {},
    AntCalendarLocale? fallback,
  }) : _fallback = fallback;

  /// 内建预设构造（全字段必填，作为回退终点）。
  const AntCalendarLocale._raw({
    required this.languageCode,
    required this.monthTitlePattern,
    required this.todayText,
    required this.confirmText,
    required this.cancelText,
    required this.yearSuffix,
    required this.monthSuffix,
    required this.weekLabels,
  })  : _fallback = null,
        messages = const {};

  /// 中文（简体）预设 — 默认，向后兼容既有文案。
  static const AntCalendarLocale zh = _zhDefaults;

  /// 中文（繁体）预设。
  static const AntCalendarLocale zhTw = AntCalendarLocale._raw(
    languageCode: 'zh-TW',
    monthTitlePattern: '{year}年{month}月',
    todayText: '本月',
    confirmText: '確定',
    cancelText: '取消',
    yearSuffix: '年',
    monthSuffix: '月',
    weekLabels: ['一', '二', '三', '四', '五', '六', '日'],
  );

  /// 英语预设。
  static const AntCalendarLocale en = AntCalendarLocale._raw(
    languageCode: 'en',
    monthTitlePattern: '{month}/{year}',
    todayText: 'Today',
    confirmText: 'OK',
    cancelText: 'Cancel',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
  );

  /// 日语预设。
  static const AntCalendarLocale ja = AntCalendarLocale._raw(
    languageCode: 'ja',
    monthTitlePattern: '{year}年{month}月',
    todayText: '今月',
    confirmText: '決定',
    cancelText: 'キャンセル',
    yearSuffix: '年',
    monthSuffix: '月',
    weekLabels: ['月', '火', '水', '木', '金', '土', '日'],
  );

  /// 韩语预设。
  static const AntCalendarLocale ko = AntCalendarLocale._raw(
    languageCode: 'ko',
    monthTitlePattern: '{year}년 {month}월',
    todayText: '이번 달',
    confirmText: '확인',
    cancelText: '취소',
    yearSuffix: '년',
    monthSuffix: '월',
    weekLabels: ['월', '화', '수', '목', '금', '토', '일'],
  );

  /// 法语预设。
  static const AntCalendarLocale fr = AntCalendarLocale._raw(
    languageCode: 'fr',
    monthTitlePattern: '{month}/{year}',
    todayText: 'Ce mois',
    confirmText: 'OK',
    cancelText: 'Annuler',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['lun', 'mar', 'mer', 'jeu', 'ven', 'sam', 'dim'],
  );

  /// 德语预设。
  static const AntCalendarLocale de = AntCalendarLocale._raw(
    languageCode: 'de',
    monthTitlePattern: '{month}.{year}',
    todayText: 'Dieser Monat',
    confirmText: 'OK',
    cancelText: 'Abbrechen',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
  );

  /// 西班牙语预设。
  static const AntCalendarLocale es = AntCalendarLocale._raw(
    languageCode: 'es',
    monthTitlePattern: '{month}/{year}',
    todayText: 'Este mes',
    confirmText: 'Aceptar',
    cancelText: 'Cancelar',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'],
  );

  /// 俄语预设。
  static const AntCalendarLocale ru = AntCalendarLocale._raw(
    languageCode: 'ru',
    monthTitlePattern: '{month}.{year}',
    todayText: 'Этот месяц',
    confirmText: 'OK',
    cancelText: 'Отмена',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'],
  );

  /// 葡萄牙语预设。
  static const AntCalendarLocale pt = AntCalendarLocale._raw(
    languageCode: 'pt',
    monthTitlePattern: '{month}/{year}',
    todayText: 'Este mês',
    confirmText: 'Confirmar',
    cancelText: 'Cancelar',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'],
  );

  /// 意大利语预设。
  static const AntCalendarLocale it = AntCalendarLocale._raw(
    languageCode: 'it',
    monthTitlePattern: '{month}/{year}',
    todayText: 'Questo mese',
    confirmText: 'OK',
    cancelText: 'Annulla',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['lun', 'mar', 'mer', 'gio', 'ven', 'sab', 'dom'],
  );

  /// 阿拉伯语预设（RTL 语言，文案方向由组件树 Directionality 控制）。
  static const AntCalendarLocale ar = AntCalendarLocale._raw(
    languageCode: 'ar',
    monthTitlePattern: '{month}/{year}',
    todayText: 'هذا الشهر',
    confirmText: 'موافق',
    cancelText: 'إلغاء',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت', 'أحد'],
  );

  /// 泰语预设。
  static const AntCalendarLocale th = AntCalendarLocale._raw(
    languageCode: 'th',
    monthTitlePattern: '{month}/{year}',
    todayText: 'เดือนนี้',
    confirmText: 'ตกลง',
    cancelText: 'ยกเลิก',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'],
  );

  /// 越南语预设。
  static const AntCalendarLocale vi = AntCalendarLocale._raw(
    languageCode: 'vi',
    monthTitlePattern: '{month}/{year}',
    todayText: 'Tháng này',
    confirmText: 'Xác nhận',
    cancelText: 'Hủy',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
  );

  /// 印尼语预设。
  static const AntCalendarLocale id = AntCalendarLocale._raw(
    languageCode: 'id',
    monthTitlePattern: '{month}/{year}',
    todayText: 'Bulan ini',
    confirmText: 'OK',
    cancelText: 'Batal',
    yearSuffix: '',
    monthSuffix: '',
    weekLabels: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
  );

  /// 按语言码解析内建预设（大小写不敏感，支持 `zh_CN` / `zh-Hans` 等分隔写法）。
  ///
  /// 未知语言码回退中文预设。
  static AntCalendarLocale fromLanguageCode(String code) {
    final normalized = code
        .replaceAll('_', '-')
        .toLowerCase();
    const presets = {
      'zh': zh,
      'zh-cn': zh,
      'zh-hans': zh,
      'zh-tw': zhTw,
      'zh-hk': zhTw,
      'zh-mo': zhTw,
      'zh-hant': zhTw,
      'en': en,
      'ja': ja,
      'ko': ko,
      'fr': fr,
      'de': de,
      'es': es,
      'ru': ru,
      'pt': pt,
      'it': it,
      'ar': ar,
      'th': th,
      'vi': vi,
      'id': id,
    };
    final primary = normalized.split('-').first;
    return presets[normalized] ?? presets[primary] ?? zh;
  }

  /// 语言码，如 `zh`、`en`、`zh-CN`。
  final String languageCode;

  /// 头部年月标题模板，`{year}` / `{month}` 为占位符。
  final String? monthTitlePattern;

  /// 「本月 / 回到今天」按钮文案。
  final String? todayText;

  /// 确认按钮文案。
  final String? confirmText;

  /// 取消按钮文案。
  final String? cancelText;

  /// 年份后缀（年月跳转滚轮列，如「2024年」「2024년」）。
  final String? yearSuffix;

  /// 月份后缀（年月跳转滚轮列，如「6月」「6월」）。
  final String? monthSuffix;

  /// 周标签（自周一起始的 7 个标签；周日起始时组件自动轮转）。
  final List<String>? weekLabels;

  /// 自定义文案扩展表（key → 文案），经 [text] 读取。
  final Map<String, String> messages;

  /// 字段缺失时的一级回退预设（最终回退中文内置文案）。
  final AntCalendarLocale? _fallback;

  /// 生效的月标题模板。
  String get effectiveMonthTitlePattern =>
      monthTitlePattern ??
      _fallback?.monthTitlePattern ??
      _zhDefaults.monthTitlePattern!;

  /// 生效的「本月」文案。
  String get effectiveTodayText =>
      todayText ?? _fallback?.todayText ?? _zhDefaults.todayText!;

  /// 生效的确认文案。
  String get effectiveConfirmText =>
      confirmText ?? _fallback?.confirmText ?? _zhDefaults.confirmText!;

  /// 生效的取消文案。
  String get effectiveCancelText =>
      cancelText ?? _fallback?.cancelText ?? _zhDefaults.cancelText!;

  /// 生效的年份后缀。
  String get effectiveYearSuffix =>
      yearSuffix ?? _fallback?.yearSuffix ?? _zhDefaults.yearSuffix!;

  /// 生效的月份后缀。
  String get effectiveMonthSuffix =>
      monthSuffix ?? _fallback?.monthSuffix ?? _zhDefaults.monthSuffix!;

  /// 生效的周标签（自周一起始）。
  List<String> get effectiveWeekLabels =>
      weekLabels ?? _fallback?.weekLabels ?? _zhDefaults.weekLabels!;

  /// 按周起始约定返回周标签序列（周日起始时把周一标签轮转到末位）。
  List<String> weekLabelsFor({required bool weekStartsOnMonday}) {
    final labels = effectiveWeekLabels;
    if (weekStartsOnMonday || labels.length < 7) return labels;
    return [...labels.sublist(1), labels.first];
  }

  /// 头部年月标题（模板占位符替换）。
  String monthTitle(int year, int month) => effectiveMonthTitlePattern
      .replaceAll('{year}', '$year')
      .replaceAll('{month}', '$month');

  /// 年月跳转滚轮列文案（如「2024年」「6月」）。
  String yearLabel(int year) => '$year$effectiveYearSuffix';

  /// 年月跳转滚轮列月份文案（如「6月」）。
  String monthLabel(int month) => '$month$effectiveMonthSuffix';

  /// 读取自定义扩展文案，key 不存在时返回 [fallbackText]（默认 key 本身）。
  String text(String key, [String? fallbackText]) =>
      messages[key] ?? fallbackText ?? key;

  /// 从组件树读取注入的 locale；未注入时返回 null。
  static AntCalendarLocale? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AntCalendarLocaleProvider>()
      ?.locale;

  /// 从组件树读取注入的 locale；未注入时回退中文预设。
  static AntCalendarLocale of(BuildContext context) =>
      maybeOf(context) ?? zh;

  @override
  bool operator ==(Object other) =>
      other is AntCalendarLocale &&
      other.languageCode == languageCode &&
      other.monthTitlePattern == monthTitlePattern &&
      other.todayText == todayText &&
      other.confirmText == confirmText &&
      other.cancelText == cancelText &&
      other.yearSuffix == yearSuffix &&
      other.monthSuffix == monthSuffix &&
      _listEquals(other.weekLabels, weekLabels) &&
      other._fallback == _fallback;

  static bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null || b == null) return identical(a, b);
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        languageCode,
        monthTitlePattern,
        todayText,
        confirmText,
        cancelText,
        yearSuffix,
        monthSuffix,
        Object.hashAll(weekLabels ?? const []),
      );
}

/// 日历国际化注入 — InheritedWidget，包裹一次全局生效。
///
/// ```dart
/// AntCalendarLocaleProvider(
///   locale: AntCalendarLocale.en,
///   child: AntCalendar(...),
/// )
/// ```
class AntCalendarLocaleProvider extends InheritedWidget {
  /// 创建注入节点。
  const AntCalendarLocaleProvider({
    super.key,
    required this.locale,
    required super.child,
  });

  /// 注入的国际化配置。
  final AntCalendarLocale locale;

  @override
  bool updateShouldNotify(AntCalendarLocaleProvider oldWidget) =>
      oldWidget.locale != locale;
}
