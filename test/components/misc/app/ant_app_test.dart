import 'package:antd_flutter_plus/src/components/misc/app/ant_app.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_flutter_plus/src/components/feedback/notification/ant_notification.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  GlobalKey<NavigatorState>? navigatorKey,
  AntAppMessageConfig? message,
  AntAppNotificationConfig? notification,
  AntAppModalConfig? modal,
}) {
  final navKey = navigatorKey ?? GlobalKey<NavigatorState>();
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      navigatorKey: navKey,
      home: Scaffold(
        body: AntApp(
        navigatorKey: navKey,
        message: message,
        notification: notification,
        modal: modal,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders child', (tester) async {
    await tester.pumpWidget(_wrap(const Text('内容')));
    expect(find.text('内容'), findsOneWidget);
  });

  testWidgets('of(context) returns AntAppState', (tester) async {
    AntAppState? captured;
    await tester.pumpWidget(_wrap(
      Builder(builder: (context) {
        captured = AntApp.of(context);
        return const SizedBox.shrink();
      },),
    ),);
    expect(captured, isNotNull);
    expect(captured, isA<AntAppState>());
  });

  testWidgets('of(context) throws when no AntApp ancestor', (tester) async {
    Object? error;
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        try {
          AntApp.of(context);
        } catch (e) {
          error = e;
        }
        return const SizedBox.shrink();
      },),
    ),);
    expect(error, isA<FlutterError>());
  });

  testWidgets('messageShow pops a message via App context', (tester) async {
    await tester.pumpWidget(_wrap(Builder(builder: (context) {
      return TextButton(
        onPressed: () =>
            AntApp.of(context).messageShow(const Text('全局提示')),
        child: const Text('show'),
      );
    },),),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('全局提示'), findsOneWidget);
  });

  testWidgets('messageShow merges AntApp.message default config', (tester) async {
    await tester.pumpWidget(_wrap(
      Builder(builder: (context) => TextButton(
        onPressed: () =>
            AntApp.of(context).messageShow(const Text('可关闭提示')),
        child: const Text('show'),
      ),),
      message: const AntAppMessageConfig(closable: true),
    ),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('可关闭提示'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('messageShow success type renders', (tester) async {
    await tester.pumpWidget(_wrap(Builder(builder: (context) {
      return TextButton(
        onPressed: () => AntApp.of(context)
            .messageShow(const Text('成功提示'), type: AntAppMessageType.success),
        child: const Text('show'),
      );
    },),),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('成功提示'), findsOneWidget);
  });

  testWidgets('notificationShow pops a notification via App context',
      (tester) async {
    AntNotification.closeAll();
    await tester.pumpWidget(_wrap(Builder(builder: (context) {
      return TextButton(
        onPressed: () => AntApp.of(context)
            .notificationShow('通知内容', title: '通知标题'),
        child: const Text('show'),
      );
    },),),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('通知标题'), findsOneWidget);
    // title 存在时 message 仅作为标题回退，不再重复渲染。
    expect(find.text('通知内容'), findsNothing);
    // 等 4.5s 自动关闭 Timer 走完，避免测试结束时残留 pending timer。
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('notificationShow merges AntApp.notification default title',
      (tester) async {
    AntNotification.closeAll();
    await tester.pumpWidget(_wrap(
      Builder(builder: (context) => TextButton(
        onPressed: () => AntApp.of(context).notificationShow('正文'),
        child: const Text('show'),
      ),),
      notification: const AntAppNotificationConfig(title: '默认标题'),
    ),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('默认标题'), findsOneWidget);
    expect(find.text('正文'), findsNothing);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('modal shows dialog via App context', (tester) async {
    await tester.pumpWidget(_wrap(Builder(builder: (context) {
      return TextButton(
        onPressed: () =>
            AntApp.of(context).modal(title: '确认框', content: const Text('确定吗')),
        child: const Text('show'),
      );
    },),),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('确认框'), findsOneWidget);
    expect(find.text('确定吗'), findsOneWidget);
  });

  testWidgets('modal ok returns true and closes', (tester) async {
    bool? result;
    await tester.pumpWidget(_wrap(Builder(builder: (context) {
      return TextButton(
        onPressed: () async {
          result = await AntApp.of(context).modal(title: '确认');
        },
        child: const Text('show'),
      );
    },),),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('确定').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(result, isTrue);
    expect(find.text('确认'), findsNothing);
  });

  testWidgets('modal merges AntApp.modal default okText', (tester) async {
    await tester.pumpWidget(_wrap(
      Builder(builder: (context) => TextButton(
        onPressed: () => AntApp.of(context).modal(title: '弹窗'),
        child: const Text('show'),
      ),),
      modal: const AntAppModalConfig(okText: '好的'),
    ),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('好的'), findsOneWidget);
  });

  testWidgets('state methods work from deep Builder context', (tester) async {
    AntAppState? deep;
    await tester.pumpWidget(_wrap(Column(
      children: [
        Builder(builder: (context) {
          deep = AntApp.of(context);
          return const SizedBox.shrink();
        },),
      ],
    ),),);
    // 深层 Builder 拿到的状态可直接调用，无需再取 context。
    expect(() => deep!.messageShow(const Text('深度调用')), returnsNormally);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('深度调用'), findsOneWidget);
  });

  testWidgets('nested MaterialApp works normally', (tester) async {
    final navKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      home: Scaffold(
        body: AntApp(
          navigatorKey: navKey,
          child: Builder(builder: (context) {
            return TextButton(
              onPressed: () =>
                  AntApp.of(context).messageShow(const Text('嵌套场景')),
              child: const Text('show'),
            );
          },),
        ),
      ),
    ),);
    await tester.tap(find.text('show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('嵌套场景'), findsOneWidget);
  });

  testWidgets('state API still works after tree rebuild', (tester) async {
    AntAppState? state;
    await tester.pumpWidget(_wrap(Builder(builder: (context) {
      state = AntApp.of(context);
      return const SizedBox.shrink();
    },),),);
    await tester.pumpWidget(_wrap(Builder(builder: (context) {
      state = AntApp.of(context);
      return const SizedBox.shrink();
    },),),);
    expect(state, isNotNull);
    expect(() => state!.messageShow(const Text('重建后调用')), returnsNormally);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('重建后调用'), findsOneWidget);
  });
}
