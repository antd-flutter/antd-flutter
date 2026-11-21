import 'package:antd_flutter_ui/src/feedback/alert/ant_alert.dart';
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
          child: Material(child: child),
        ),
      ),
    ),
  );
}

Container _alertContainer(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.ancestor(
      of: find.text('提示'),
      matching: find.byType(Container),
    ).first,
  );
  return container;
}

void main() {
  group('AntAlert', () {
    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(message: '提示')));
      expect(find.text('提示'), findsOneWidget);
    });

    testWidgets('success type uses success background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.success)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorSuccessBg),
      );
    });

    testWidgets('warning type uses warning background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.warning)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorWarningBg),
      );
    });

    testWidgets('error type uses error background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.error)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorErrorBg),
      );
    });

    testWidgets('info type uses info background', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(message: '提示')));
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      expect(
        decoration.color,
        equals(AntThemeData.light().colorInfoBg),
      );
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', description: '这是描述内容')),
      );
      expect(find.text('提示'), findsOneWidget);
      expect(find.text('这是描述内容'), findsOneWidget);
    });

    testWidgets('showIcon true shows default icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', showIcon: true)),
      );
      expect(find.byIcon(AntIcons.infoCircleFilled), findsOneWidget);
    });

    testWidgets('showIcon false hides icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(message: '提示')));
      expect(find.byIcon(AntIcons.infoCircleFilled), findsNothing);
    });

    testWidgets('closable shows close icon, tap closes and fires onClose',
        (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(AntAlert(
        message: '提示',
        closable: true,
        onClose: () => closed = true,
      ),),);
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeOutlined));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.text('提示'), findsNothing);
    });

    testWidgets('action area renders', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(
        message: '提示',
        action: Text('撤销'),
      ),),);
      expect(find.text('撤销'), findsOneWidget);
    });

    testWidgets('banner has no border and rounded corners', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(
        message: '提示',
        banner: true,
      ),),);
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('提示'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNull);
      expect(decoration.borderRadius, equals(BorderRadius.zero));
    });

    testWidgets('non-banner has left accent strip and light border',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAlert(message: '提示', type: AntAlertType.error)),
      );
      final decoration = _alertContainer(tester).decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.left.width, equals(border.right.width));
      // 左侧语义色竖条
      final accent = tester.widgetList<Container>(
        find.byType(Container),
      ).where((c) {
        final d = c.decoration;
        return d is BoxDecoration &&
            d.color == AntThemeData.light().colorError;
      });
      expect(accent, isNotEmpty);
    });

    testWidgets('custom icon overrides default icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntAlert(
        message: '提示',
        showIcon: true,
        icon: Icon(AntIcons.starFilled),
      ),),);
      expect(find.byIcon(AntIcons.starFilled), findsOneWidget);
      expect(find.byIcon(AntIcons.infoCircleFilled), findsNothing);
    });

    group('icon 与文字对齐（回归：批次 0-1 验收反馈）', () {
      Rect iconRect(WidgetTester tester, IconData icon) =>
          tester.getRect(find.byIcon(icon));

      /// message 文本 RenderBox 区域（取 Expanded 内 Text 的首个字符）。
      Rect messageRect(WidgetTester tester, String text) =>
          tester.getRect(find.text(text).first);

      testWidgets('无描述时图标与 message 垂直居中', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntAlert(
              message: '信息提示',
              showIcon: true,
            ),
          ),
        );
        final icon = iconRect(tester, AntIcons.infoCircleFilled);
        final text = messageRect(tester, '信息提示');
        // 允许半行高误差（基线差异），但必须明显居中而非顶对齐。
        final iconCenter = icon.center.dy;
        final textCenter = text.center.dy;
        expect((iconCenter - textCenter).abs(), lessThan(2.0));
        // 顶对齐回归判定：若仍是 start 对齐，图标 top 应等于文字 top，
        // 修复后图标中心应大于文字 top + 图标半径的一半以上。
        expect(icon.top, greaterThan(text.top + 1.0));
      });

      testWidgets('多行 message 时图标仍与首行文字垂直居中', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntAlert(
              message: '信息提示信息提示信息提示信息提示信息提示信息提示'
                  '信息提示信息提示信息提示信息提示信息提示信息提示',
              showIcon: true,
            ),
          ),
        );
        final icon = iconRect(tester, AntIcons.infoCircleFilled);
        // 多行且无描述时，antd 语义仍为整体居中：图标中心应在文本块中心附近
        // （文本块远高于图标，居中后图标 top 明显大于文本 top）。
        final text = messageRect(
          tester,
          '信息提示信息提示信息提示信息提示信息提示信息提示'
              '信息提示信息提示信息提示信息提示信息提示信息提示',
        );
        expect(icon.center.dy, closeTo(text.center.dy, 3.0));
        expect(icon.top, greaterThan(text.top + 0.5));
      });

      testWidgets('有描述时图标与 message 首行视觉居中', (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AntAlert(
              message: '信息提示',
              description: '这是描述内容，图标应与 message 首行视觉居中',
              showIcon: true,
            ),
          ),
        );
        final icon = iconRect(tester, AntIcons.infoCircleFilled);
        final message = messageRect(tester, '信息提示');
        // 有描述时图标放大到 20（antd withDescriptionIconSize），
        // 并在首行盒（fontSize*1.5≈21）内居中：icon.top ≈ message.top + 0.5。
        expect(icon.width, closeTo(20.0, 0.5));
        expect(
          icon.center.dy,
          closeTo(message.top + (message.height > 30 ? 10.5 : 10.5), 2.5),
        );
      });
    });
  });
}
