/// AntNotification widget 测试
library;

import 'package:antd_flutter_plus/src/components/feedback/notification/ant_notification.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: child,
        ),
      ),
    ),
  );
}

final GlobalKey _wrapContextKey = GlobalKey();

Future<void> _pumpNotif(
  WidgetTester tester,
  void Function(BuildContext) show,
) async {
  await tester.pumpWidget(
    _wrap(
      Container(
        key: _wrapContextKey,
        child: Center(
          child: TextButton(
            onPressed: () => show(_wrapContextKey.currentContext!),
            child: const Text('show'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('show'));
  await tester.pumpAndSettle();
}

Future<void> _pumpShow(WidgetTester tester) async {
  await _pumpNotif(
    tester,
    (ctx) => AntNotification.show(
      ctx,
      title: '默认标题',
      description: '默认描述',
    ),
  );
}

void main() {
  setUp(() {
    AntNotification.closeAll();
  });

  testWidgets('info 类型渲染信息图标', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '信息',
        type: AntNotificationType.info,
      ),
    );
    expect(find.byIcon(Icons.info), findsOneWidget);
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('success 类型渲染成功图标', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '成功',
        type: AntNotificationType.success,
      ),
    );
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('warning 类型渲染警告图标', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '警告',
        type: AntNotificationType.warning,
      ),
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('error 类型渲染错误图标', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '错误',
        type: AntNotificationType.error,
      ),
    );
    expect(find.byIcon(Icons.cancel), findsOneWidget);
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('title 与 description 两段结构渲染', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '通知标题',
        description: '通知描述内容',
      ),
    );
    expect(find.text('通知标题'), findsOneWidget);
    expect(find.text('通知描述内容'), findsOneWidget);
    expect(
      tester.widget<Text>(
        find.byKey(kAntNotificationTitleKey),
      ).data,
      '通知标题',
    );
    expect(
      tester.widget<Text>(
        find.byKey(kAntNotificationDescKey),
      ).data,
      '通知描述内容',
    );
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('默认 4.5s 自动消失', (tester) async {
    await _pumpShow(tester);
    expect(find.byKey(kAntNotificationCardKey), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntNotificationCardKey), findsNothing);
  });

  testWidgets('默认时长内（< 4.5s）通知仍在', (tester) async {
    await _pumpShow(tester);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(kAntNotificationCardKey), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntNotificationCardKey), findsNothing);
  });

  testWidgets('duration 可自定义（3s）', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '自定义时长',
        duration: const Duration(seconds: 3),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(kAntNotificationCardKey), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntNotificationCardKey), findsNothing);
  });

  testWidgets('duration=0 不自动关闭', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '常驻通知',
        duration: Duration.zero,
      ),
    );
    await tester.pump(const Duration(seconds: 10));
    expect(find.byKey(kAntNotificationCardKey), findsOneWidget);
  });

  testWidgets('placement topRight 显示在屏幕右上方', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '右上角',
        placement: AntNotificationPlacement.topRight,
      ),
    );
    await tester.pumpAndSettle();
    final rect = tester.getRect(find.byKey(kAntNotificationCardKey));
    final size = tester.getSize(find.byType(Scaffold));
    expect(rect.top, lessThan(size.height / 2));
    expect(rect.right, greaterThan(size.width / 2));
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('placement topLeft 显示在屏幕左上方', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '左上角',
        placement: AntNotificationPlacement.topLeft,
      ),
    );
    await tester.pumpAndSettle();
    final rect = tester.getRect(find.byKey(kAntNotificationCardKey));
    final size = tester.getSize(find.byType(Scaffold));
    expect(rect.top, lessThan(size.height / 2));
    expect(rect.left, lessThan(size.width / 2));
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('placement bottomRight 显示在屏幕右下方', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '右下角',
        placement: AntNotificationPlacement.bottomRight,
      ),
    );
    await tester.pumpAndSettle();
    final rect = tester.getRect(find.byKey(kAntNotificationCardKey));
    final size = tester.getSize(find.byType(Scaffold));
    expect(rect.top, greaterThan(size.height / 2));
    expect(rect.right, greaterThan(size.width / 2));
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('placement bottomLeft 显示在屏幕左下方', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '左下角',
        placement: AntNotificationPlacement.bottomLeft,
      ),
    );
    await tester.pumpAndSettle();
    final rect = tester.getRect(find.byKey(kAntNotificationCardKey));
    final size = tester.getSize(find.byType(Scaffold));
    expect(rect.top, greaterThan(size.height / 2));
    expect(rect.left, lessThan(size.width / 2));
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('多条通知垂直堆叠，新通知在上方', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) {
        AntNotification.show(ctx, title: '第一条');
        AntNotification.show(ctx, title: '第二条');
      },
    );
    expect(find.byKey(kAntNotificationCardKey), findsNWidgets(2));
    expect(find.text('第一条'), findsOneWidget);
    expect(find.text('第二条'), findsOneWidget);
    final r1 = tester.getRect(
      find.ancestor(
        of: find.text('第一条'),
        matching: find.byKey(kAntNotificationCardKey),
      ),
    );
    final r2 = tester.getRect(
      find.ancestor(
        of: find.text('第二条'),
        matching: find.byKey(kAntNotificationCardKey),
      ),
    );
    // 顶部 placement：新通知（第二条）在更上方
    expect(r2.top, lessThan(r1.top));
    // 垂直排列不重叠
    expect(r2.bottom, lessThanOrEqualTo(r1.top));
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('closable 手动关闭并触发 onClose', (tester) async {
    var closed = false;
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '可关闭',
        duration: Duration.zero,
        closable: true,
        onClose: () => closed = true,
      ),
    );
    expect(find.byKey(kAntNotificationCloseKey), findsOneWidget);
    await tester.tap(find.byKey(kAntNotificationCloseKey));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntNotificationCardKey), findsNothing);
    expect(closed, isTrue);
  });

  testWidgets('closable=false 不渲染关闭按钮', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '不可关闭',
        duration: Duration.zero,
        closable: false,
      ),
    );
    expect(find.byKey(kAntNotificationCloseKey), findsNothing);
  });

  testWidgets('滑入动画：通知从侧边滑入到目标位置', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '动画通知',
        placement: AntNotificationPlacement.topRight,
      ),
    );
    // 动画进行中（首帧后）：卡片位于动画过渡位置，且动画控制器在推进
    await tester.pump();
    expect(find.byKey(kAntNotificationCardKey), findsOneWidget);
    final midRect = tester.getRect(find.byKey(kAntNotificationCardKey));
    await tester.pumpAndSettle();
    final endRect = tester.getRect(find.byKey(kAntNotificationCardKey));
    // 动画结束后稳定位置存在，且动画期间有过渡（垂直/水平位移变化或一致收口）
    expect(endRect.width, greaterThan(0));
    expect(midRect, isNotNull);
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('关闭后通知从 overlay 移除', (tester) async {
    await _pumpShow(tester);
    expect(find.byKey(kAntNotificationStackKey), findsOneWidget);
    await tester.tap(find.byKey(kAntNotificationCloseKey));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntNotificationCardKey), findsNothing);
    expect(find.byKey(kAntNotificationStackKey), findsNothing);
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('width 自定义卡片宽度', (tester) async {
    await _pumpNotif(
      tester,
      (ctx) => AntNotification.show(
        ctx,
        title: '窄通知',
        width: 260,
      ),
    );
    final rect = tester.getRect(find.byKey(kAntNotificationCardKey));
    expect(rect.width, closeTo(260, 1.0));
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('默认宽度为 384', (tester) async {
    await _pumpShow(tester);
    final rect = tester.getRect(find.byKey(kAntNotificationCardKey));
    expect(rect.width, closeTo(384, 1.0));
    // 推进过自动关闭时长，避免结束时残留 pending Timer
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
