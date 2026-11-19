import 'package:antd_flutter_ui/src/display/timeline/ant_timeline.dart';
import 'package:antd_theme/antd_theme.dart';
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

List<AntTimelineItem> _basicItems() => [
      const AntTimelineItem(content: Text('创建站点'), color: AntTimelineColor.green),
      const AntTimelineItem(content: Text('部署上线'), color: AntTimelineColor.blue),
      const AntTimelineItem(content: Text('访问异常'), color: AntTimelineColor.red),
      const AntTimelineItem(content: Text('待处理'), color: AntTimelineColor.gray),
    ];

void main() {
  group('AntTimeline', () {
    testWidgets('renders item count', (tester) async {
      await tester.pumpWidget(_wrap(AntTimeline(items: _basicItems())));
      expect(find.text('创建站点'), findsOneWidget);
      expect(find.text('部署上线'), findsOneWidget);
      expect(find.text('访问异常'), findsOneWidget);
      expect(find.text('待处理'), findsOneWidget);
    });

    testWidgets('renders item content', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimeline(
        items: [
          AntTimelineItem(
            content: Text('文本'),
            customDot: Icon(Icons.star),
          ),
        ],
      ),),);
      expect(find.text('文本'), findsOneWidget);
    });

    testWidgets('mode alternate alternates sides', (tester) async {
      await tester.pumpWidget(_wrap(AntTimeline(
        items: _basicItems(),
        mode: AntTimelineMode.alternate,
      ),),);
      final first = tester.getTopLeft(find.text('创建站点'));
      final second = tester.getTopLeft(find.text('部署上线'));
      final center = tester.getSize(find.byType(AntTimeline)).width / 2;
      // 第一项在左半区，第二项在右半区
      expect(first.dx + tester.getSize(find.text('创建站点')).width, lessThan(center));
      expect(second.dx, greaterThan(center));
    });

    testWidgets('mode left aligns content right of dot', (tester) async {
      await tester.pumpWidget(_wrap(AntTimeline(
        items: _basicItems(),
        mode: AntTimelineMode.left,
      ),),);
      final rowLeft = tester.getTopLeft(find.byType(AntTimeline));
      final content = tester.getTopLeft(find.text('创建站点'));
      // 默认模式内容在节点列右侧，有缩进
      expect(content.dx, greaterThan(rowLeft.dx + 10));
    });

    testWidgets('mode right aligns content left of dot', (tester) async {
      await tester.pumpWidget(_wrap(AntTimeline(
        items: _basicItems(),
        mode: AntTimelineMode.right,
      ),),);
      final timeline = tester.getTopLeft(find.byType(AntTimeline));
      final width = tester.getSize(find.byType(AntTimeline)).width;
      final content = tester.getTopLeft(find.text('创建站点'));
      // 内容在左半区
      expect(content.dx - timeline.dx, lessThan(width / 2));
    });

    testWidgets('pending appends loading spinner', (tester) async {
      await tester.pumpWidget(_wrap(AntTimeline(
        items: _basicItems(),
        pending: true,
      ),),);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // pending 节点在最后一个 item 之后
      final last = tester.getTopLeft(find.text('待处理'));
      final spinner = tester.getTopLeft(find.byType(CircularProgressIndicator));
      expect(spinner.dy, greaterThan(last.dy));
    });

    testWidgets('pendingDot replaces spinner', (tester) async {
      await tester.pumpWidget(_wrap(AntTimeline(
        items: _basicItems(),
        pending: true,
        pendingDot: const Icon(Icons.more_horiz),
      ),),);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('reverse flips order', (tester) async {
      await tester.pumpWidget(_wrap(AntTimeline(
        items: _basicItems(),
        reverse: true,
      ),),);
      final first = tester.getTopLeft(find.text('待处理'));
      final last = tester.getTopLeft(find.text('创建站点'));
      expect(first.dy, lessThan(last.dy));
    });

    testWidgets('preset colors map to theme tokens', (tester) async {
      final light = AntThemeData.light();
      await tester.pumpWidget(_wrap(AntTimeline(items: _basicItems())));
      // 找到所有圆形节点装饰
      final dots = tester.widgetList<Container>(
        find.byWidgetPredicate(
          (w) => w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration! as BoxDecoration).shape == BoxShape.circle,
        ),
      ).toList();
      expect(dots.length, 4);
      final colors = dots
          .map((d) => (d.decoration! as BoxDecoration).color)
          .whereType<Color>()
          .toSet();
      expect(colors, contains(light.colorPrimary));
      expect(colors, contains(light.colorError));
      expect(colors, contains(light.colorSuccess));
    });

    testWidgets('customDot renders custom widget', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimeline(
        items: [
          AntTimelineItem(
            content: Text('自定义'),
            customDot: Icon(Icons.check_circle),
          ),
        ],
      ),),);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('dotColor overrides node color', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimeline(
        items: [
          AntTimelineItem(content: Text('紫色'), dotColor: Colors.purple),
        ],
      ),),);
      final dot = tester.widget<Container>(
        find.byWidgetPredicate(
          (w) => w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration! as BoxDecoration).shape == BoxShape.circle,
        ),
      );
      expect((dot.decoration! as BoxDecoration).color, Colors.purple);
    });

    testWidgets('label renders in label column', (tester) async {
      await tester.pumpWidget(_wrap(const AntTimeline(
        items: [
          AntTimelineItem(label: '09:00', content: Text('会议开始')),
        ],
      ),),);
      expect(find.text('09:00'), findsOneWidget);
      expect(find.text('会议开始'), findsOneWidget);
      final label = tester.getTopLeft(find.text('09:00'));
      final content = tester.getTopLeft(find.text('会议开始'));
      expect(content.dx, greaterThan(label.dx));
    });

    testWidgets('disabled dims item and blocks tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(AntTimeline(
        items: [
          AntTimelineItem(
            content: const Text('禁用项'),
            disabled: true,
            onTap: () => tapped = true,
          ),
        ],
      ),),);
      // Opacity 包裹（视觉降级）
      expect(find.byType(Opacity), findsOneWidget);
      await tester.tap(find.text('禁用项'));
      expect(tapped, isFalse);
    });

    testWidgets('enabled item fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(AntTimeline(
        items: [
          AntTimelineItem(
            content: const Text('可点击'),
            onTap: () => tapped = true,
          ),
        ],
      ),),);
      await tester.tap(find.text('可点击'));
      expect(tapped, isTrue);
    });
  });
}
