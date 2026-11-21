/// AntDrawer widget 测试
library;

import 'package:antd_flutter_ui/src/feedback/drawer/ant_drawer.dart';
import 'package:antd_flutter_ui/src/feedback/drawer/ant_drawer_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );
}

/// 带受控 open 状态的宿主。
Widget _host({
  required bool open,
  VoidCallback? onClose,
  AntDrawerPlacement placement = AntDrawerPlacement.right,
  double? width,
  double? height,
  Widget? title,
  bool closable = true,
  Widget? footer,
  bool mask = true,
  bool maskClosable = true,
  Widget? child,
  Key? drawerKey,
}) {
  return _wrap(
    AntDrawer(
      key: drawerKey,
      open: open,
      placement: placement,
      width: width ?? 378,
      height: height ?? 378,
      title: title,
      closable: closable,
      onClose: onClose,
      footer: footer,
      mask: mask,
      maskClosable: maskClosable,
      child:
          child ?? const Text('抽屉内容', key: Key('drawer-body-content')),
    ),
  );
}

void main() {
  testWidgets('open=true 显示抽屉面板与遮罩', (tester) async {
    await tester.pumpWidget(_host(open: true));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerPanelKey), findsOneWidget);
    expect(find.byKey(kAntDrawerMaskKey), findsOneWidget);
    expect(find.text('抽屉内容'), findsOneWidget);
  });

  testWidgets('open=false 不显示抽屉', (tester) async {
    await tester.pumpWidget(_host(open: false));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerPanelKey), findsNothing);
    expect(find.byKey(kAntDrawerMaskKey), findsNothing);
  });

  testWidgets('placement=right 面板从右侧滑入（右对齐）', (tester) async {
    await tester.pumpWidget(_host(open: true));
    await tester.pumpAndSettle();
    final panel = tester.getRect(find.byKey(kAntDrawerPanelKey));
    final screen = tester.getRect(find.byType(Scaffold));
    expect(panel.right, screen.right);
    expect(panel.left, greaterThan(screen.center.dx));
  });

  testWidgets('placement=left 面板左对齐', (tester) async {
    await tester.pumpWidget(
      _host(open: true, placement: AntDrawerPlacement.left),
    );
    await tester.pumpAndSettle();
    final panel = tester.getRect(find.byKey(kAntDrawerPanelKey));
    final screen = tester.getRect(find.byType(Scaffold));
    expect(panel.left, screen.left);
    expect(panel.right, lessThan(screen.center.dx));
  });

  testWidgets('placement=top 面板贴顶且使用自定义高度', (tester) async {
    await tester.pumpWidget(
      _host(open: true, placement: AntDrawerPlacement.top, height: 200),
    );
    await tester.pumpAndSettle();
    final panel = tester.getRect(find.byKey(kAntDrawerPanelKey));
    final screen = tester.getRect(find.byType(Scaffold));
    expect(panel.top, screen.top);
    expect(panel.height, 200);
  });

  testWidgets('placement=bottom 面板贴底', (tester) async {
    await tester.pumpWidget(
      _host(open: true, placement: AntDrawerPlacement.bottom),
    );
    await tester.pumpAndSettle();
    final panel = tester.getRect(find.byKey(kAntDrawerPanelKey));
    final screen = tester.getRect(find.byType(Scaffold));
    expect(panel.bottom, screen.bottom);
  });

  testWidgets('title 渲染', (tester) async {
    await tester.pumpWidget(
      _host(open: true, title: const Text('Basic Drawer')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Basic Drawer'), findsOneWidget);
  });

  testWidgets('closable 关闭按钮触发 onClose，关闭动画后浮层移除', (tester) async {
    bool open = true;
    var closeCount = 0;
    late StateSetter setState;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _host(open: open, onClose: () {
              closeCount++;
              setState(() => open = false);
            },);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntDrawerCloseKey));
    await tester.pumpAndSettle();
    expect(closeCount, 1);
    // 关闭动画结束后浮层移除
    expect(find.byKey(kAntDrawerPanelKey), findsNothing);
    expect(find.byKey(kAntDrawerMaskKey), findsNothing);
  });

  testWidgets('closable=false 不显示关闭按钮', (tester) async {
    await tester.pumpWidget(_host(open: true, closable: false));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerCloseKey), findsNothing);
  });

  testWidgets('maskClosable=true 点击遮罩关闭，false 不关闭', (tester) async {
    // 可关闭
    bool open = true;
    late StateSetter setState1;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, s) {
            setState1 = s;
            return _host(
              drawerKey: const Key('drawer-closable'),
              open: open,
              onClose: () => setState1(() => open = false),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 400));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerPanelKey), findsNothing);

    // 不可关闭
    await tester.pumpWidget(_host(
      drawerKey: const Key('drawer-fixed'),
      open: true,
      maskClosable: false,
    ),);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 400));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerPanelKey), findsOneWidget);
  });

  testWidgets('mask=false 无遮罩', (tester) async {
    await tester.pumpWidget(_host(open: true, mask: false));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerPanelKey), findsOneWidget);
    expect(find.byKey(kAntDrawerMaskKey), findsNothing);
  });

  testWidgets('footer 渲染底部操作区', (tester) async {
    await tester.pumpWidget(
      _host(
        open: true,
        footer: const Text('底部操作区', key: Key('drawer-footer-text')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerFooterKey), findsOneWidget);
    expect(find.text('底部操作区'), findsOneWidget);
  });

  testWidgets('width 自定义面板宽度', (tester) async {
    await tester.pumpWidget(_host(open: true, width: 200));
    await tester.pumpAndSettle();
    final panel = tester.getRect(find.byKey(kAntDrawerPanelKey));
    expect(panel.width, 200);
  });

  testWidgets('body 内容可滚动', (tester) async {
    await tester.pumpWidget(
      _host(
        open: true,
        child: const SizedBox(
          height: 1200,
          child: Column(
            children: [
              Text('顶部内容'),
              Spacer(),
              Text('底部内容', key: Key('drawer-scroll-end')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // 初始时底部内容在可视区外，滚动后进入可视区
    final endFinder = find.text('底部内容');
    expect(
      tester.getRect(endFinder).top,
      greaterThanOrEqualTo(600),
      reason: '初始时底部内容应在可视区外',
    );
    await tester.drag(find.text('顶部内容'), const Offset(0, -800));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(endFinder).top,
      lessThan(600),
      reason: '滚动后底部内容应进入可视区',
    );
  });

  testWidgets('open 变化 false→true 打开抽屉', (tester) async {
    bool open = false;
    late StateSetter setState;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _host(open: open);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerPanelKey), findsNothing);

    setState(() => open = true);
    await tester.pumpAndSettle();
    expect(find.byKey(kAntDrawerPanelKey), findsOneWidget);
  });
}
