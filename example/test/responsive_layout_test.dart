library;

/// 响应式布局断言测试：宽屏 / 窄屏 / 折叠屏三态 + demo 页模拟尺寸抽查
import 'package:antd_flutter_example/main.dart';
import 'package:antd_flutter_example/pages/component_page.dart';
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以指定逻辑尺寸泵入 example 应用（与 main.dart 相同的根组件链）。
Future<void> pumpApp(WidgetTester tester, Size logicalSize) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = logicalSize;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const AntdFlutterExampleApp());
  await tester.pumpAndSettle();
}

/// 抽查的 demo 页（覆盖任务要求的 button/card/table/grid/modal/drawer/
/// message 等主要页面）。
const List<String> kSweepPages = <String>[
  'button',
  'card',
  'table',
  'grid',
  'modal',
  'drawer',
  'message',
  'input',
  'form',
  'list',
  'tabs',
  'alert',
  'progress',
  'steps',
];

/// 在指定逻辑尺寸下泵入单个 demo 页，收集渲染异常（溢出等）。
Future<List<FlutterErrorDetails>> pumpDemoPage(
  WidgetTester tester,
  Size logicalSize,
  String snakeName,
) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = logicalSize;
  addTearDown(tester.view.reset);

  final errors = <FlutterErrorDetails>[];
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) => errors.add(details);
  try {
    await tester.pumpWidget(
      AntScreenUtilInit(
        builder: (context, _) => AntResponsiveInit(
          builder: (context, data, child) => MaterialApp(
            home: Scaffold(body: ComponentPage(snakeName: snakeName)),
          ),
        ),
      ),
    );
    // 分帧泵进，避免常驻动画页面 pumpAndSettle 永不结束。
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  } finally {
    FlutterError.onError = originalOnError;
  }
  return errors;
}

void main() {
  group('HomePage 响应式布局', () {
    testWidgets('宽屏 1024×800：Header + 常驻侧栏（无 NavBar/Drawer）', (tester) async {
      await pumpApp(tester, const Size(1024, 800));

      expect(find.byType(AntLayoutHeader), findsOneWidget);
      expect(find.byType(AntLayoutSider), findsOneWidget);
      expect(find.byType(AntNavBar), findsNothing);
      // 总览页 Hero 标题正常渲染
      expect(find.text('Ant Design v6 设计规范的 Flutter 组件库'), findsOneWidget);
    });

    testWidgets('窄屏 600×800：NavBar + Drawer（无常驻侧栏）', (tester) async {
      await pumpApp(tester, const Size(600, 800));

      expect(find.byType(AntNavBar), findsOneWidget);
      expect(find.byType(AntLayoutSider), findsNothing);
      expect(find.byType(AntLayoutHeader), findsNothing);
      // 点菜单按钮打开抽屉
      await tester.tap(find.byType(AntdIcon).first);
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('折叠屏模拟 681×841（半折形态）：布局不抛异常', (tester) async {
      await pumpApp(tester, const Size(681, 841));

      expect(tester.takeException(), isNull);
      // 半折宽度 < 840 → 窄屏形态
      expect(find.byType(AntNavBar), findsOneWidget);
      expect(find.byType(AntLayoutSider), findsNothing);
    });
  });

  group('demo 页模拟尺寸抽查（无溢出/布局异常）', () {
    const sizes = <String, Size>{
      'phone-375x812': Size(375, 812),
      'fold-681x841': Size(681, 841),
      'desktop-1440x900': Size(1440, 900),
    };

    for (final entry in sizes.entries) {
      for (final snakeName in kSweepPages) {
        testWidgets('${entry.key} · $snakeName 无布局异常', (tester) async {
          final errors = await pumpDemoPage(tester, entry.value, snakeName);
          final messages = errors
              .map((e) => e.toString())
              .where((m) => !m.contains('overflowed by'))
              .toList();
          expect(messages, isEmpty, reason: '${entry.key} 下 $snakeName 页渲染异常');
          final overflows = errors
              .where((e) => e.toString().contains('overflowed by'))
              .toList();
          expect(overflows, isEmpty, reason: '${entry.key} 下 $snakeName 页存在溢出');
        });
      }
    }
  });
}
