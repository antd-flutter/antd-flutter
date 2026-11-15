/// AntNoticeBar Widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';
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

void main() {
  group('AntNoticeBar — 基础渲染', () {
    testWidgets('renders content text', (tester) async {
      await tester.pumpWidget(_wrap(const AntNoticeBar(content: '通告内容')));
      expect(find.text('通告内容'), findsOneWidget);
      expect(find.byType(AntNoticeBar), findsOneWidget);
    });

    testWidgets('renders default sound icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntNoticeBar(content: '通告')));
      expect(find.byIcon(AntIcons.soundOutlined), findsOneWidget);
    });

    testWidgets('renders custom icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '通告',
          icon: Icon(AntIcons.compassOutlined),
        ),),
      );
      expect(find.byIcon(AntIcons.compassOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.soundOutlined), findsNothing);
    });

    testWidgets('renders contentWidget when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '文本',
          contentWidget: Text('自定义内容'),
        ),),
      );
      expect(find.text('自定义内容'), findsOneWidget);
      expect(find.text('文本'), findsNothing);
    });

    testWidgets('onClick fires on tap', (tester) async {
      var clicked = false;
      await tester.pumpWidget(
        _wrap(AntNoticeBar(content: '点击', onClick: () => clicked = true)),
      );
      await tester.tap(find.byType(AntNoticeBar));
      expect(clicked, isTrue);
    });
  });

  group('AntNoticeBar — 语义颜色', () {
    testWidgets('normal color uses colorFillContent background',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '默认', color: AntNoticeBarColor.normal)),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorFillContent);
    });

    testWidgets('alert color uses colorWarningBg background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '警告', color: AntNoticeBarColor.alert)),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorWarningBg);
    });

    testWidgets('error color uses colorError background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '错误', color: AntNoticeBarColor.error)),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorError);
    });

    testWidgets('info color uses colorInfoBg background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '信息', color: AntNoticeBarColor.info)),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorInfoBg);
    });

    testWidgets('success color uses colorSuccessBg background', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '成功', color: AntNoticeBarColor.success)),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AntThemeData.light().colorSuccessBg);
    });
  });

  group('AntNoticeBar — 可关闭', () {
    testWidgets('closeable shows close icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '可关闭', closeable: true)),
      );
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
    });

    testWidgets('not closeable hides close icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '不可关闭')),
      );
      expect(find.byIcon(AntIcons.closeOutlined), findsNothing);
    });

    testWidgets('custom closeIcon renders', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '自定义关闭',
          closeable: true,
          closeIcon: Icon(AntIcons.checkOutlined),
        ),),
      );
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.closeOutlined), findsNothing);
    });

    testWidgets('tapping close hides the bar and calls onClose',
        (tester) async {
      var closed = false;
      await tester.pumpWidget(
        _wrap(AntNoticeBar(
          content: '关闭我',
          closeable: true,
          onClose: () => closed = true,
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.closeOutlined));
      await tester.pump();
      expect(closed, isTrue);
      // 关闭后内容与图标不再可见
      expect(find.text('关闭我'), findsNothing);
      expect(find.byIcon(AntIcons.closeOutlined), findsNothing);
    });
  });

  group('AntNoticeBar — extra 操作区', () {
    testWidgets('extra widget renders in right area', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '带操作',
          extra: Text('查看详情'),
        ),),
      );
      expect(find.text('查看详情'), findsOneWidget);
    });
  });

  group('AntNoticeBar — 形状与边框', () {
    testWidgets('rectangular shape has no borderRadius', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '直角',
          shape: AntNoticeBarShape.rectangular,
        ),),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNull);
    });

    testWidgets('neutral shape has borderRadius', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '圆角',
          shape: AntNoticeBarShape.neutral,
        ),),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('rounded shape has capsule borderRadius', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '胶囊',
          shape: AntNoticeBarShape.rounded,
        ),),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('block border has only top and bottom sides', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '上下边框',
          shape: AntNoticeBarShape.rectangular,
          bordered: AntNoticeBarBorder.block,
        ),),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.style, BorderStyle.solid);
      expect(border.bottom.style, BorderStyle.solid);
      expect(border.left.style, BorderStyle.none);
      expect(border.right.style, BorderStyle.none);
    });

    testWidgets('full border has all four sides', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '全边框',
          shape: AntNoticeBarShape.rectangular,
          bordered: AntNoticeBarBorder.full,
        ),),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.style, BorderStyle.solid);
      expect(border.bottom.style, BorderStyle.solid);
      expect(border.left.style, BorderStyle.solid);
      expect(border.right.style, BorderStyle.solid);
    });

    testWidgets('none border has no border', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '无边框',
          shape: AntNoticeBarShape.rectangular,
          bordered: AntNoticeBarBorder.none,
        ),),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });
  });

  group('AntNoticeBar — wrap 多行', () {
    testWidgets('wrap mode renders text without clipping', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '适用于当前页面内信息的通知，是一种较醒目的页面内通知方式',
          wrap: true,
        ),),
      );
      expect(find.text('适用于当前页面内信息的通知，是一种较醒目的页面内通知方式'),
          findsOneWidget,);
      // wrap 模式下不应有 ClipRect（滚动裁剪）
      expect(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(ClipRect),
        ),
        findsNothing,
      );
    });

    testWidgets('wrap mode has auto height (no fixed height)', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '多行展示内容',
          wrap: true,
        ),),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints, isNull);
    });
  });

  group('AntNoticeBar — 滚动', () {
    testWidgets('short text does not scroll (offset stays zero)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(content: '短文本', delay: 100)),
      );
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 100));
      // 短文本不触发滚动，Transform.translate 偏移为 0
      final transform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Transform),
        ),
      );
      expect(transform.transform.getTranslation().x, 0.0);
    });

    testWidgets('long text starts scrolling after delay', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNoticeBar(
          content: '这是一段非常长的通告内容用于测试滚动效果'
              '这是一段非常长的通告内容用于测试滚动效果'
              '这是一段非常长的通告内容用于测试滚动效果'
              '这是一段非常长的通告内容用于测试滚动效果',
          delay: 100,
          speed: 200,
        ),),
      );
      // 等待 delay 后滚动启动
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 100));
      // 滚动已启动，Transform.translate 偏移非零（文本已开始移动）
      final transform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(AntNoticeBar),
          matching: find.byType(Transform),
        ),
      );
      expect(transform.transform.getTranslation().x, isNonZero);
    });
  });
}