import 'package:antd_flutter_ui/src/feedback/error_block/ant_error_block.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: Center(child: child)),
        ),
      ),
    ),
  );
}

void main() {
  group('AntErrorBlock', () {
    testWidgets('default status renders default title and description',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntErrorBlock(status: AntErrorBlockStatus.defaultStatus)),
      );
      expect(find.text('常见问题提示'), findsOneWidget);
      expect(find.text('有可能是系统问题，请稍后重试'), findsOneWidget);
    });

    testWidgets('empty status renders default title and description',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntErrorBlock(status: AntErrorBlockStatus.empty)),
      );
      expect(find.text('暂无数据'), findsOneWidget);
      expect(find.text('点击刷新试试'), findsOneWidget);
    });

    testWidgets('disconnected status renders default title and description',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntErrorBlock(status: AntErrorBlockStatus.disconnected)),
      );
      expect(find.text('网络出现问题'), findsOneWidget);
      expect(find.text('点击刷新试试'), findsOneWidget);
    });

    testWidgets('busy status renders default title and description',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntErrorBlock(status: AntErrorBlockStatus.busy)),
      );
      expect(find.text('系统繁忙'), findsOneWidget);
      expect(find.text('点击刷新试试'), findsOneWidget);
    });

    testWidgets('each status renders a CustomPaint illustration',
        (tester) async {
      for (final status in AntErrorBlockStatus.values) {
        await tester.pumpWidget(_wrap(AntErrorBlock(status: status)));
        expect(
          find.byKey(AntErrorBlock.illustrationKey),
          findsOneWidget,
          reason: '$status',
        );
      }
    });

    testWidgets('default status is defaultStatus', (tester) async {
      await tester.pumpWidget(_wrap(const AntErrorBlock()));
      expect(find.text('常见问题提示'), findsOneWidget);
    });

    testWidgets('custom title and description override defaults',
        (tester) async {
      await tester.pumpWidget(_wrap(const AntErrorBlock(
        status: AntErrorBlockStatus.empty,
        title: '购物车是空的',
        description: '快去挑选心仪的商品吧',
      ),),);
      expect(find.text('购物车是空的'), findsOneWidget);
      expect(find.text('快去挑选心仪的商品吧'), findsOneWidget);
      expect(find.text('暂无数据'), findsNothing);
      expect(find.text('点击刷新试试'), findsNothing);
    });

    testWidgets('children renders action area with tappable button',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(AntErrorBlock(
        status: AntErrorBlockStatus.disconnected,
        children: ElevatedButton(
          onPressed: () => tapped = true,
          child: const Text('点击刷新'),
        ),
      ),),);
      expect(find.text('点击刷新'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });

    testWidgets('image overrides default illustration', (tester) async {
      await tester.pumpWidget(_wrap(const AntErrorBlock(
        status: AntErrorBlockStatus.defaultStatus,
        image: Icon(AntIcons.cloudServerOutlined, key: Key('my-image')),
      ),),);
      expect(find.byKey(const Key('my-image')), findsOneWidget);
      expect(find.byKey(AntErrorBlock.illustrationKey), findsNothing);
    });

    testWidgets('illustration painters repaint on status change',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntErrorBlock(status: AntErrorBlockStatus.empty)),
      );
      final first = tester.widget<CustomPaint>(find.byKey(AntErrorBlock.illustrationKey));
      await tester.pumpWidget(
        _wrap(const AntErrorBlock(status: AntErrorBlockStatus.busy)),
      );
      final second = tester.widget<CustomPaint>(find.byKey(AntErrorBlock.illustrationKey));
      expect(
        (first.painter! as dynamic).status,
        isNot(equals((second.painter! as dynamic).status)),
      );
    });

    testWidgets('styles use theme tokens', (tester) async {
      final theme = AntThemeData.light();
      await tester.pumpWidget(_wrap(const AntErrorBlock(
        status: AntErrorBlockStatus.defaultStatus,
        title: '标题文案',
        description: '描述文案',
      ),),);
      final titleStyle = tester.widget<Text>(find.text('标题文案')).style!;
      expect(titleStyle.fontSize, 20);
      expect(titleStyle.fontWeight, FontWeight.w600);
      expect(titleStyle.color, theme.colorTextHeading);
      final descStyle = tester.widget<Text>(find.text('描述文案')).style!;
      expect(descStyle.fontSize, theme.fontSize);
      expect(descStyle.color, theme.colorTextSecondary);
    });
  });
}
