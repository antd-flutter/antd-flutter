// AntPopup widget 测试
library;


import 'package:antd_flutter_ui/src/engines/overlay_shell.dart';
import 'package:antd_flutter_ui/src/feedback/popup/ant_popup.dart';
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

/// 带状态开关的受控 AntPopup 宿主。
class _Host extends StatefulWidget {
  const _Host({
    this.position = AntPopupPosition.bottom,
    this.body,
    this.showCloseIcon = false,
    this.maskClosable = true,
    this.borderRadius,
    this.backgroundColor,
    this.initialVisible = false,
    this.onClose,
  });

  final AntPopupPosition position;
  final Widget? body;
  final bool showCloseIcon;
  final bool maskClosable;
  final double? borderRadius;
  final Color? backgroundColor;
  final bool initialVisible;
  final VoidCallback? onClose;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late bool visible = widget.initialVisible;

  void toggle() => setState(() => visible = !visible);

  @override
  Widget build(BuildContext context) {
    return _wrap(
      Column(
        children: [
          TextButton(
            key: const Key('toggle'),
            onPressed: toggle,
            child: Text(visible ? '关闭' : '打开'),
          ),
          Expanded(
            child: AntPopup(
              visible: visible,
              position: widget.position,
              body: widget.body ?? const Text('弹出内容'),
              showCloseIcon: widget.showCloseIcon,
              maskClosable: widget.maskClosable,
              borderRadius: widget.borderRadius,
              backgroundColor: widget.backgroundColor,
              onClose: widget.onClose,
            ),
          ),
        ],
      ),
    );
  }
}

Finder get _mask => find.byKey(kAntPopupMaskKey);
Finder get _panel => find.byKey(kAntPopupPanelKey);

void main() {
  testWidgets('visible=false 不显示浮层', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: false,
      body: Text('弹出内容'),
    ),);
    await tester.pump();
    expect(_mask, findsNothing);
    expect(_panel, findsNothing);
  });

  testWidgets('visible=true 显示浮层与内容', (tester) async {
    await tester.pumpWidget(const _Host(initialVisible: true));
    await tester.pumpAndSettle();
    expect(_mask, findsOneWidget);
    expect(_panel, findsOneWidget);
    expect(find.text('弹出内容'), findsOneWidget);
  });

  testWidgets('toggle 切换显示/隐藏', (tester) async {
    await tester.pumpWidget(const _Host());
    await tester.pump();
    expect(_mask, findsNothing);
    await tester.tap(find.byKey(const Key('toggle')));
    await tester.pumpAndSettle();
    expect(_mask, findsOneWidget);
    await tester.tap(find.byKey(const Key('toggle')));
    await tester.pumpAndSettle();
    expect(_mask, findsNothing);
  });

  testWidgets('底部弹出：面板贴底', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      position: AntPopupPosition.bottom,
    ),);
    await tester.pumpAndSettle();
    final size = tester.getSize(_panel);
    final topLeft = tester.getTopLeft(_panel);
    final screenH = tester.view.physicalSize.height /
        tester.view.devicePixelRatio;
    expect(topLeft.dy + size.height, closeTo(screenH, 1));
    // 桌面端测试视口：面板宽度按基座封顶（375），水平居中
    final screenW =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(
      topLeft.dx,
      closeTo((screenW - kAntMobileOverlayDefaultMaxWidth) / 2, 1),
    );
  });

  testWidgets('顶部弹出：面板贴顶', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      position: AntPopupPosition.top,
    ),);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(_panel).dy, 0);
  });

  testWidgets('左侧弹出：面板贴左', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      position: AntPopupPosition.left,
    ),);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(_panel).dx, 0);
  });

  testWidgets('右侧弹出：面板贴右', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      position: AntPopupPosition.right,
    ),);
    await tester.pumpAndSettle();
    final screenW =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getTopRight(_panel).dx, closeTo(screenW, 1));
  });

  testWidgets('滑入动画存在（中间态面板未就位）', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      position: AntPopupPosition.bottom,
    ),);
    // 只推进一小部分动画时间
    await tester.pump(const Duration(milliseconds: 60));
    final topLeft = tester.getTopLeft(_panel);
    expect(topLeft.dy, greaterThan(0));
    await tester.pumpAndSettle();
  });

  testWidgets('遮罩淡入动画存在（初始透明）', (tester) async {
    await tester.pumpWidget(const _Host(initialVisible: true));
    await tester.pump();
    final opacity = tester
        .widget<FadeTransition>(
          find.ancestor(of: _mask, matching: find.byType(FadeTransition)),
        )
        .opacity
        .value;
    expect(opacity, lessThan(1));
    await tester.pumpAndSettle();
  });

  testWidgets('showCloseIcon 点击关闭图标触发 onClose 并移除浮层', (tester) async {
    var closed = false;
    await tester.pumpWidget(_Host(
      initialVisible: true,
      showCloseIcon: true,
      onClose: () => closed = true,
    ),);
    await tester.pumpAndSettle();
    expect(find.byKey(kAntPopupCloseKey), findsOneWidget);
    await tester.tap(find.byKey(kAntPopupCloseKey));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
    expect(_mask, findsNothing);
  });

  testWidgets('maskClosable=true 点击遮罩关闭', (tester) async {
    var closed = false;
    await tester.pumpWidget(_Host(
      initialVisible: true,
      onClose: () => closed = true,
    ),);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
    expect(_mask, findsNothing);
  });

  testWidgets('maskClosable=false 点击遮罩不关闭', (tester) async {
    var closed = false;
    await tester.pumpWidget(_Host(
      initialVisible: true,
      maskClosable: false,
      onClose: () => closed = true,
    ),);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(closed, isFalse);
    expect(_mask, findsOneWidget);
  });

  testWidgets('关闭动画后浮层移除', (tester) async {
    await tester.pumpWidget(const _Host(initialVisible: true));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggle')));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(_mask, findsNothing);
    expect(_panel, findsNothing);
  });

  testWidgets('自定义圆角样式生效', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      borderRadius: 0,
    ),);
    await tester.pumpAndSettle();
        final decor = tester.widget<Container>(_panel);
    final shape = decor.decoration! as BoxDecoration;
    expect(
      (shape.borderRadius! as BorderRadius).topLeft,
      const Radius.circular(0),
    );
  });

  testWidgets('自定义背景色生效', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      backgroundColor: Colors.amber,
    ),);
    await tester.pumpAndSettle();
        final decor = tester.widget<Container>(_panel);
    expect((decor.decoration! as BoxDecoration).color, Colors.amber);
  });

  testWidgets('body 内容可滚动', (tester) async {
    await tester.pumpWidget(const _Host(
      initialVisible: true,
      body: SingleChildScrollView(
        key: Key('scroll'),
        child: SizedBox(
          height: 800,
          child: Column(
            children: [
              Text('顶部文本'),
              Spacer(),
              Text('底部文本'),
            ],
          ),
        ),
      ),
    ),);
    await tester.pumpAndSettle();
    expect(find.text('顶部文本'), findsOneWidget);
    await tester.drag(find.byKey(const Key('scroll')), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('底部文本'), findsOneWidget);
  });
}
