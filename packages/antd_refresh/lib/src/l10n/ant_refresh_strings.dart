/// AntRefresh 内建国际化文案（零依赖轻量实现，不引入 intl）。
///
/// 内置常用语言全集（默认中文 zh）：
/// zh / en / ja / ko / fr / de / es / ru / pt / it / ar。
/// 未命中的 locale 回退中文；调用方可传入自定义 [AntRefreshStrings]
/// 实例覆盖内置文案。
library;

import 'dart:ui' show Locale;

/// 下拉刷新组件各阶段文案集合。
///
/// 全部字段非空；内置各语言实例经 [AntRefreshStrings.resolve] 解析，
/// 自定义覆写可基于 [AntRefreshStrings.copyWith] 修改个别字段。
class AntRefreshStrings {
  const AntRefreshStrings({
    required this.pullingText,
    required this.releasingText,
    required this.finishingText,
    required this.completeText,
  });

  /// 下拉中（未达阈值）文案。
  final String pullingText;

  /// 达到阈值释放即刷新文案。
  final String releasingText;

  /// 刷新中文案（伴随转圈显示）。
  final String finishingText;

  /// 刷新完成文案。
  final String completeText;

  /// 覆写个别字段，未指定的字段沿用当前实例。
  AntRefreshStrings copyWith({
    String? pullingText,
    String? releasingText,
    String? finishingText,
    String? completeText,
  }) {
    return AntRefreshStrings(
      pullingText: pullingText ?? this.pullingText,
      releasingText: releasingText ?? this.releasingText,
      finishingText: finishingText ?? this.finishingText,
      completeText: completeText ?? this.completeText,
    );
  }

  // ============================================================
  // 内置语言全集（默认中文）
  // ============================================================

  /// 中文（默认）。
  static const AntRefreshStrings zh = AntRefreshStrings(
    pullingText: '下拉刷新',
    releasingText: '释放刷新',
    finishingText: '加载中...',
    completeText: '刷新完成',
  );

  /// 英语。
  static const AntRefreshStrings en = AntRefreshStrings(
    pullingText: 'Pull down to refresh',
    releasingText: 'Release to refresh',
    finishingText: 'Loading...',
    completeText: 'Refresh complete',
  );

  /// 日语。
  static const AntRefreshStrings ja = AntRefreshStrings(
    pullingText: '下に引いて更新',
    releasingText: '指を離して更新',
    finishingText: '読み込み中...',
    completeText: '更新完了',
  );

  /// 韩语。
  static const AntRefreshStrings ko = AntRefreshStrings(
    pullingText: '당겨서 새로고침',
    releasingText: '놓으면 새로고침',
    finishingText: '불러오는 중...',
    completeText: '새로고침 완료',
  );

  /// 法语。
  static const AntRefreshStrings fr = AntRefreshStrings(
    pullingText: 'Tirez pour actualiser',
    releasingText: 'Relâchez pour actualiser',
    finishingText: 'Chargement...',
    completeText: 'Actualisation terminée',
  );

  /// 德语。
  static const AntRefreshStrings de = AntRefreshStrings(
    pullingText: 'Ziehen zum Aktualisieren',
    releasingText: 'Loslassen zum Aktualisieren',
    finishingText: 'Wird geladen...',
    completeText: 'Aktualisierung abgeschlossen',
  );

  /// 西班牙语。
  static const AntRefreshStrings es = AntRefreshStrings(
    pullingText: 'Tira para actualizar',
    releasingText: 'Suelta para actualizar',
    finishingText: 'Cargando...',
    completeText: 'Actualización completada',
  );

  /// 俄语。
  static const AntRefreshStrings ru = AntRefreshStrings(
    pullingText: 'Потяните вниз для обновления',
    releasingText: 'Отпустите для обновления',
    finishingText: 'Загрузка...',
    completeText: 'Обновление завершено',
  );

  /// 葡萄牙语。
  static const AntRefreshStrings pt = AntRefreshStrings(
    pullingText: 'Puxe para atualizar',
    releasingText: 'Solte para atualizar',
    finishingText: 'Carregando...',
    completeText: 'Atualização concluída',
  );

  /// 意大利语。
  static const AntRefreshStrings it = AntRefreshStrings(
    pullingText: 'Trascina per aggiornare',
    releasingText: 'Rilascia per aggiornare',
    finishingText: 'Caricamento...',
    completeText: 'Aggiornamento completato',
  );

  /// 阿拉伯语（RTL 语言，仅文案，不做镜像布局处理）。
  static const AntRefreshStrings ar = AntRefreshStrings(
    pullingText: 'اسحب للأسفل للتحديث',
    releasingText: 'اترك للتحديث',
    finishingText: 'جار التحميل...',
    completeText: 'تم التحديث',
  );

  /// 内置语言码 → 文案映射（zh 为默认回退）。
  static const Map<String, AntRefreshStrings> builtIn = <String, AntRefreshStrings>{
    'zh': zh,
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
  };

  /// 内置支持的语言码列表。
  static List<String> get supportedLanguageCodes =>
      builtIn.keys.toList(growable: false);

  // ============================================================
  // 解析
  // ============================================================

  /// 按语言码解析内置文案；未命中（含 null）回退中文。
  ///
  /// 仅取语言主码（`-`/`_` 前段），忽略地区与脚本子码，
  /// 如 `zh_CN`/`pt-BR` 分别命中 zh / pt。
  static AntRefreshStrings resolve(String? localeCode) {
    if (localeCode == null || localeCode.isEmpty) return zh;
    final String primary = localeCode
        .replaceAll('_', '-')
        .split('-')
        .first
        .toLowerCase();
    return builtIn[primary] ?? zh;
  }

  /// 按 [Locale] 解析内置文案；未命中回退中文。
  static AntRefreshStrings of(Locale locale) => resolve(locale.languageCode);
}
