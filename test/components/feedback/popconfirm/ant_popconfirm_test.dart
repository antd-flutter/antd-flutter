/// AntPopconfirm widget 测试
library;

import 'package:antd_flutter_ui/src/display/popover/ant_popconfirm.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popconfirm_types.dart';
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

/// 居中放置一个触发元素 + Popconfirm。
Widget _host({
  String? title,
  String? description,
  String? okText,
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  AntPopconfirmButtonProps? okButtonProps,
  AntPopconfirmPlacement placement = AntPopconfirmPlacement.bottomLeft,
  Widget? icon,
  bool? open,
  bool disabled = false,
  Key? triggerKey,
}) {
  return _wrap(
    Center(
      child: AntPopconfirm(
        title: title,
        description: description,
        okText: okText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        okButtonProps: okButtonProps,
        placement: placement,
        icon: icon,
        open: open,
        disabled: disabled,
        child: Container(
          key: triggerKey ?? const Key('popconfirm-trigger'),
          width: 120,
          height: 40,
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('触发'),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('点击子元素弹出气泡', (tester) async {
    await tester.pumpWidget(_host(title: '确认删除？'));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsNothing);

    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsOneWidget);
    expect(find.text('确认删除？'), findsOneWidget);
  });

  testWidgets('title 与 description 渲染', (tester) async {
    await tester.pumpWidget(
      _host(title: '删除标题', description: '删除后不可恢复'),
    );
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.text('删除标题'), findsOneWidget);
    expect(find.text('删除后不可恢复'), findsOneWidget);
  });

  testWidgets('title 为空时使用默认文案「确定吗？」', (tester) async {
    await tester.pumpWidget(_host());
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.text(kAntPopconfirmDefaultTitle), findsOneWidget);
  });

  testWidgets('默认按钮文案为「确定」/「取消」', (tester) async {
    await tester.pumpWidget(_host(title: 'A'));
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.text(kAntPopconfirmDefaultOkText), findsOneWidget);
    expect(find.text(kAntPopconfirmDefaultCancelText), findsOneWidget);
  });

  testWidgets('okText / cancelText 自定义', (tester) async {
    await tester.pumpWidget(
      _host(title: 'A', okText: '删除', cancelText: '再想想'),
    );
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.text('删除'), findsOneWidget);
    expect(find.text('再想想'), findsOneWidget);
  });

  testWidgets('点击确认触发 onConfirm 并自动关闭', (tester) async {
    var confirmed = false;
    await tester
        .pumpWidget(_host(title: 'A', onConfirm: () => confirmed = true));
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntPopconfirmOkButtonKey));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
    expect(find.byKey(kAntPopconfirmBubbleKey), findsNothing);
  });

  testWidgets('点击取消触发 onCancel 并自动关闭', (tester) async {
    var cancelled = false;
    await tester
        .pumpWidget(_host(title: 'A', onCancel: () => cancelled = true));
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntPopconfirmCancelButtonKey));
    await tester.pumpAndSettle();
    expect(cancelled, isTrue);
    expect(find.byKey(kAntPopconfirmBubbleKey), findsNothing);
  });

  testWidgets('placement=bottomCenter 气泡在触发元素下方水平居中', (tester) async {
    await tester.pumpWidget(
      _host(title: 'A', placement: AntPopconfirmPlacement.bottomCenter),
    );
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    final bubble = tester.getRect(find.byKey(kAntPopconfirmBubbleKey));
    final trigger = tester.getRect(find.byKey(const Key('popconfirm-trigger')));
    expect(bubble.top, greaterThan(trigger.bottom));
    expect(
      (bubble.center.dx - trigger.center.dx).abs(),
      lessThan(20),
    );
  });

  testWidgets('placement=topCenter 气泡在触发元素上方', (tester) async {
    await tester.pumpWidget(
      _host(title: 'A', placement: AntPopconfirmPlacement.topCenter),
    );
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    final bubble = tester.getRect(find.byKey(kAntPopconfirmBubbleKey));
    final trigger = tester.getRect(find.byKey(const Key('popconfirm-trigger')));
    expect(bubble.bottom, lessThan(trigger.top));
  });

  testWidgets('placement=rightCenter 气泡在触发元素右侧', (tester) async {
    await tester.pumpWidget(
      _host(title: 'A', placement: AntPopconfirmPlacement.rightCenter),
    );
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    final bubble = tester.getRect(find.byKey(kAntPopconfirmBubbleKey));
    final trigger = tester.getRect(find.byKey(const Key('popconfirm-trigger')));
    expect(bubble.left, greaterThan(trigger.right));
  });

  testWidgets('默认问号图标，icon 自定义后替换', (tester) async {
    await tester.pumpWidget(_host(title: 'A'));
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
    // 先关闭气泡，避免复用同一位置的 Element 状态
    await tester.tapAt(const Offset(20, 30));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      _host(
          title: 'B', icon: const Icon(Icons.delete, key: Key('custom-icon'))),
    );
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.help_outline), findsNothing);
    expect(find.byKey(const Key('custom-icon')), findsOneWidget);
  });

  testWidgets('disabled=true 点击不弹出', (tester) async {
    await tester.pumpWidget(_host(title: 'A', disabled: true));
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsNothing);
  });

  testWidgets('受控 open：非空时由外部控制显隐', (tester) async {
    bool open = false;
    late StateSetter setState;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _host(title: '受控气泡', open: open);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    // 点击触发元素不改变受控状态
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsNothing);

    setState(() => open = true);
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsOneWidget);
    expect(find.text('受控气泡'), findsOneWidget);

    setState(() => open = false);
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsNothing);
  });

  testWidgets('气泡为卡片样式：背景色与圆角', (tester) async {
    await tester.pumpWidget(_host(title: 'A'));
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    final containers = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byKey(kAntPopconfirmBubbleKey),
            matching: find.byType(Container),
          ),
        )
        .toList();
    // 气泡根 Container 为最外层（宽度受限且带装饰）
    final container = containers.firstWhere((c) => c.decoration != null);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.borderRadius, isNotNull);
    expect(decoration.boxShadow, isNotNull);
  });

  testWidgets('点击气泡外空白处关闭', (tester) async {
    await tester.pumpWidget(_host(title: 'A'));
    await tester.tap(find.byKey(const Key('popconfirm-trigger')));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsOneWidget);

    await tester.tapAt(const Offset(20, 30));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopconfirmBubbleKey), findsNothing);
  });
}
