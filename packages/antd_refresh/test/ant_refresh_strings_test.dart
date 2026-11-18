import 'package:antd_refresh/antd_refresh.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

Widget _buildList({
  Locale? locale,
  AntRefreshStrings? strings,
  String? pullingText,
}) {
  return AntPullToRefresh(
    locale: locale,
    strings: strings,
    pullingText: pullingText,
    child: ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(title: Text('item $index')),
    ),
  );
}

/// 发送一串鼠标滚轮事件（桌面端），累积下拉位移。
///
/// 桌面滚轮路径要求 `AntPlatform.isDesktop`，测试宿主默认为 Android，
/// 需设置 debugDefaultTargetPlatformOverride。
Future<void> sendWheelScroll(
  WidgetTester tester, {
  required int ticks,
  required double deltaPerTick,
}) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  addTearDown(() => debugDefaultTargetPlatformOverride = null);
  final pointer = TestPointer(1, PointerDeviceKind.mouse);
  final center = tester.getCenter(find.byType(ListView).first);
  await tester.sendEventToBinding(pointer.hover(center));
  await tester.pump();
  for (var i = 0; i < ticks; i++) {
    await tester.sendEventToBinding(pointer.scroll(Offset(0, deltaPerTick)));
    await tester.pump();
  }
  // 滚轮停止 = 松手（settle 时长 400ms），这里只验证 pulling 文案，
  // 在松手前断言，不触发 settle。
}

void main() {
  group('AntRefreshStrings 全语言字段完整性', () {
    test('内置 11 种语言全部字段非空', () {
      expect(
        AntRefreshStrings.supportedLanguageCodes.toSet(),
        <String>{'zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'ru', 'pt', 'it', 'ar'},
      );
      for (final String code in AntRefreshStrings.supportedLanguageCodes) {
        final AntRefreshStrings s = AntRefreshStrings.builtIn[code]!;
        expect(s.pullingText, isNotEmpty, reason: '$code pullingText');
        expect(s.releasingText, isNotEmpty, reason: '$code releasingText');
        expect(s.finishingText, isNotEmpty, reason: '$code finishingText');
        expect(s.completeText, isNotEmpty, reason: '$code completeText');
      }
    });

    test('每种语言的四个字段互不相同（防止复制粘贴错译）', () {
      for (final String code in AntRefreshStrings.supportedLanguageCodes) {
        final AntRefreshStrings s = AntRefreshStrings.builtIn[code]!;
        expect(
          <String>{
            s.pullingText,
            s.releasingText,
            s.finishingText,
            s.completeText,
          }.length,
          4,
          reason: '$code 存在重复文案',
        );
      }
    });
  });

  group('AntRefreshStrings.resolve 回退', () {
    test('命中各内置语言（含地区/大小写变体）', () {
      expect(AntRefreshStrings.resolve('zh'), same(AntRefreshStrings.zh));
      expect(AntRefreshStrings.resolve('zh_CN'), same(AntRefreshStrings.zh));
      expect(AntRefreshStrings.resolve('en'), same(AntRefreshStrings.en));
      expect(AntRefreshStrings.resolve('EN-us'), same(AntRefreshStrings.en));
      expect(AntRefreshStrings.resolve('ja'), same(AntRefreshStrings.ja));
      expect(AntRefreshStrings.resolve('ko'), same(AntRefreshStrings.ko));
      expect(AntRefreshStrings.resolve('fr'), same(AntRefreshStrings.fr));
      expect(AntRefreshStrings.resolve('de'), same(AntRefreshStrings.de));
      expect(AntRefreshStrings.resolve('es'), same(AntRefreshStrings.es));
      expect(AntRefreshStrings.resolve('ru'), same(AntRefreshStrings.ru));
      expect(AntRefreshStrings.resolve('pt'), same(AntRefreshStrings.pt));
      expect(AntRefreshStrings.resolve('pt-BR'), same(AntRefreshStrings.pt));
      expect(AntRefreshStrings.resolve('it'), same(AntRefreshStrings.it));
      expect(AntRefreshStrings.resolve('ar'), same(AntRefreshStrings.ar));
    });

    test('未命中与空值回退中文', () {
      expect(AntRefreshStrings.resolve('xx'), same(AntRefreshStrings.zh));
      expect(AntRefreshStrings.resolve(null), same(AntRefreshStrings.zh));
      expect(AntRefreshStrings.resolve(''), same(AntRefreshStrings.zh));
      expect(AntRefreshStrings.resolve('xx').pullingText, '下拉刷新');
    });

    test('AntRefreshStrings.of 走 languageCode 解析', () {
      expect(
        AntRefreshStrings.of(const Locale('en', 'US')),
        same(AntRefreshStrings.en),
      );
      expect(
        AntRefreshStrings.of(const Locale('und')),
        same(AntRefreshStrings.zh),
      );
    });

    test('copyWith 覆写个别字段', () {
      final AntRefreshStrings custom =
          AntRefreshStrings.en.copyWith(pullingText: '自定义下拉');
      expect(custom.pullingText, '自定义下拉');
      expect(custom.releasingText, AntRefreshStrings.en.releasingText);
    });
  });

  group('AntPullToRefresh locale 接入', () => _widgetTests());
}

void _widgetTests() {
  testWidgets('locale: zh 渲染中文文案', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(_buildList(locale: const Locale('en'))));
    // 先以 en 为基线确认机制生效，再切 zh 断言。
    await tester.pumpWidget(_wrap(_buildList(locale: const Locale('zh'))));
    await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
    expect(find.text('下拉刷新'), findsOneWidget);
    expect(find.text('Pull down to refresh'), findsNothing);
  });

  testWidgets('locale: en 渲染英文文案', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(_buildList(locale: const Locale('en'))));
    await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
    expect(find.text('Pull down to refresh'), findsOneWidget);
    expect(find.text('下拉刷新'), findsNothing);
  });

  testWidgets('显式 pullingText 优先于 locale', (WidgetTester tester) async {
    await tester.pumpWidget(
      _wrap(_buildList(locale: const Locale('en'), pullingText: '继续拉')),
    );
    await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
    expect(find.text('继续拉'), findsOneWidget);
    expect(find.text('Pull down to refresh'), findsNothing);
  });

  testWidgets('自定义 strings 覆写优先于内置解析', (WidgetTester tester) async {
    const AntRefreshStrings custom = AntRefreshStrings(
      pullingText: 'CUSTOM',
      releasingText: 'CUSTOM-R',
      finishingText: 'CUSTOM-F',
      completeText: 'CUSTOM-C',
    );
    await tester.pumpWidget(_wrap(_buildList(strings: custom)));
    await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
    expect(find.text('CUSTOM'), findsOneWidget);
  });

  testWidgets('未传 locale 时默认（系统语言，测试环境 en）渲染不抛错',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(_buildList()));
    await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
    // 测试宿主默认 locale 不一定可断言具体文案，只验证头部出现且无异常。
    expect(find.byKey(kAntPullToRefreshHeaderKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
