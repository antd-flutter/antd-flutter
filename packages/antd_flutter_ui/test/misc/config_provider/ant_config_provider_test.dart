import 'package:antd_flutter_ui/src/misc/config_provider/ant_config_provider.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {AntThemeData? theme}) {
  return AntScreenUtilInit(
    builder: (context, _) => AntConfigProvider(
      antdTheme: theme,
      child: MaterialApp(home: Scaffold(body: Material(child: child))),
    ),
  );
}

void main() {
  group('AntConfigProvider', () {
    testWidgets('of(context) returns config', (tester) async {
      AntConfigData? config;
      await tester.pumpWidget(_wrap(Builder(builder: (context) {
        config = AntConfigProvider.of(context);
        return const SizedBox.shrink();
      },),),);
      expect(config, isNotNull);
      expect(config, isA<AntConfigData>());
    });

    testWidgets('returns fallback when no provider', (tester) async {
      AntConfigData? config;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          config = AntConfigProvider.of(context);
          return const SizedBox.shrink();
        },),
      ),);
      expect(config!.antdTheme, isNull);
      expect(config!.locale, isNull);
      expect(config!.direction, AntConfigDirection.ltr);
    });

    testWidgets('default config has ltr direction', (tester) async {
      AntConfigData? config;
      await tester.pumpWidget(_wrap(Builder(builder: (context) {
        config = AntConfigProvider.of(context);
        return const SizedBox.shrink();
      },),),);
      expect(config!.direction, AntConfigDirection.ltr);
    });

    testWidgets('antdTheme injects AntTheme — AntTheme.of gets new theme',
        (tester) async {
      final dark = AntThemeData.dark();
      AntThemeData? resolved;
      await tester.pumpWidget(_wrap(
        Builder(builder: (context) {
          resolved = AntTheme.of(context);
          return const SizedBox.shrink();
        },),
        theme: dark,
      ),);
      expect(resolved, same(dark));
      expect(resolved!.isDark, isTrue);
    });

    testWidgets('without antdTheme AntTheme falls back to light',
        (tester) async {
      AntThemeData? resolved;
      await tester.pumpWidget(_wrap(Builder(builder: (context) {
        resolved = AntTheme.of(context);
        return const SizedBox.shrink();
      },),),);
      expect(resolved!.isDark, isFalse);
    });

    testWidgets('direction ltr maps to TextDirection.ltr', (tester) async {
      await tester.pumpWidget(const AntConfigProvider(
        direction: AntConfigDirection.ltr,
        child: Text('方向'),
      ),);
      final dir = tester.widget<Directionality>(
        find.byType(Directionality).last,
      );
      expect(dir.textDirection, TextDirection.ltr);
    });

    testWidgets('direction rtl maps to TextDirection.rtl', (tester) async {
      await tester.pumpWidget(const AntConfigProvider(
        direction: AntConfigDirection.rtl,
        child: Text('方向'),
      ),);
      final dir = tester.widget<Directionality>(
        find.byType(Directionality).last,
      );
      expect(dir.textDirection, TextDirection.rtl);
      expect(find.text('方向'), findsOneWidget);
    });

    testWidgets('locale languageCode is readable', (tester) async {
      AntConfigData? config;
      await tester.pumpWidget(_wrap(Builder(builder: (context) {
        config = AntConfigProvider.of(context);
        return const SizedBox.shrink();
      },),),);
      // 重新包裹带 locale 的 Provider。
      await tester.pumpWidget(_wrapWithLocale(
        Builder(builder: (context) {
          config = AntConfigProvider.of(context);
          return const SizedBox.shrink();
        },),
        const AntConfigLocale(languageCode: 'zh-CN'),
      ),);
      expect(config!.locale!.languageCode, 'zh-CN');
    });

    testWidgets('locale custom messages readable via text()', (tester) async {
      AntConfigData? config;
      await tester.pumpWidget(_wrapWithLocale(
        Builder(builder: (context) {
          config = AntConfigProvider.of(context);
          return const SizedBox.shrink();
        },),
        const AntConfigLocale(
          languageCode: 'en',
          messages: {'ok': 'OK', 'cancel': 'Cancel'},
        ),
      ),);
      expect(config!.text('ok'), 'OK');
      expect(config!.text('cancel'), 'Cancel');
      expect(config!.text('missing', '默认'), '默认');
    });

    testWidgets('nested provider overrides inner config', (tester) async {
      AntConfigData? outer;
      AntConfigData? inner;
      await tester.pumpWidget(AntConfigProvider(
        locale: const AntConfigLocale(languageCode: 'zh'),
        direction: AntConfigDirection.ltr,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: AntConfigProvider(
            locale: const AntConfigLocale(languageCode: 'en'),
            direction: AntConfigDirection.rtl,
            child: Builder(builder: (context) {
              inner = AntConfigProvider.of(context);
              return const SizedBox.shrink();
            },),
          ),
        ),
      ),);
      // 外层单独取一次（在嵌套之前）。
      await tester.pumpWidget(AntConfigProvider(
        locale: const AntConfigLocale(languageCode: 'zh'),
        direction: AntConfigDirection.ltr,
        child: Builder(builder: (context) {
          outer = AntConfigProvider.of(context);
          return const SizedBox.shrink();
        },),
      ),);
      expect(outer!.locale!.languageCode, 'zh');
      expect(inner!.locale!.languageCode, 'en');
      expect(inner!.direction, AntConfigDirection.rtl);
    });

    testWidgets('child renders inside provider', (tester) async {
      await tester.pumpWidget(_wrap(const Text('渲染内容')));
      expect(find.text('渲染内容'), findsOneWidget);
    });

    testWidgets('component tree contains Directionality', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      expect(find.byType(Directionality), findsWidgets);
      expect(find.byType(AntConfigProvider), findsOneWidget);
    });

    testWidgets('updateShouldNotify rebuilds dependents on theme change',
        (tester) async {
      AntThemeData? resolved;
      await tester.pumpWidget(_wrap(
        Builder(builder: (context) {
          resolved = AntTheme.of(context);
          return const SizedBox.shrink();
        },),
        theme: AntThemeData.light(),
      ),);
      final lightTheme = resolved;
      await tester.pumpWidget(_wrap(
        Builder(builder: (context) {
          resolved = AntTheme.of(context);
          return const SizedBox.shrink();
        },),
        theme: AntThemeData.dark(),
      ),);
      expect(identical(lightTheme, resolved), isFalse);
      expect(resolved!.isDark, isTrue);
    });
  });
}

Widget _wrapWithLocale(Widget child, AntConfigLocale locale) {
  return AntConfigProvider(
    locale: locale,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: child,
    ),
  );
}
