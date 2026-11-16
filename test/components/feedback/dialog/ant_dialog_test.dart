// AntDialog widget 测试
library;

import 'package:antd_flutter_plus/src/components/feedback/dialog/ant_dialog.dart';
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

/// 带状态开关的受控 AntDialog 宿主。
class _Host extends StatefulWidget {
  const _Host({this.content});

  final Widget? content;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late bool visible = false;

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
            child: AntDialog(
              visible: visible,
              content: widget.content,
            ),
          ),
        ],
      ),
    );
  }
}

Finder get _mask => find.byKey(kAntDialogMaskKey);
Finder get _card => find.byKey(kAntDialogCardKey);
Finder get _ok => find.byKey(kAntDialogOkButtonKey);
Finder get _cancel => find.byKey(kAntDialogCancelButtonKey);

void main() {
  testWidgets('visible=false 不显示浮层', (tester) async {
    await tester.pumpWidget(const _Host(content: Text('内容')));
    await tester.pump();
    expect(_mask, findsNothing);
    expect(_card, findsNothing);
  });

  testWidgets('visible=true 显示浮层', (tester) async {
    await tester.pumpWidget(const _Host(content: Text('内容')));
    await tester.tap(find.byKey(const Key('toggle')));
    await tester.pumpAndSettle();
    expect(_mask, findsOneWidget);
    expect(_card, findsOneWidget);
  });

  testWidgets('title 与 content 渲染', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(
        visible: true,
        title: '对话框标题',
        content: Text('对话框内容'),
      ),
    ),);
    await tester.pumpAndSettle();
    expect(find.text('对话框标题'), findsOneWidget);
    expect(find.text('对话框内容'), findsOneWidget);
  });

  testWidgets('alert 模式仅显示确认按钮', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(visible: true, mode: AntDialogMode.alert),
    ),);
    await tester.pumpAndSettle();
    expect(_ok, findsOneWidget);
    expect(_cancel, findsNothing);
    expect(find.text(kAntDialogDefaultOkText), findsOneWidget);
  });

  testWidgets('confirm 模式显示确认与取消双按钮', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(
        visible: true,
        mode: AntDialogMode.confirm,
        okText: '好的',
        cancelText: '再想想',
      ),
    ),);
    await tester.pumpAndSettle();
    expect(_ok, findsOneWidget);
    expect(_cancel, findsOneWidget);
    expect(find.text('好的'), findsOneWidget);
    expect(find.text('再想想'), findsOneWidget);
  });

  testWidgets('alert 点击确认按钮触发回调并自动关闭', (tester) async {
    var okCount = 0;
    await tester.pumpWidget(_wrap(
      AntDialog(visible: true, onClick: () => okCount++),
    ),);
    await tester.pumpAndSettle();
    await tester.tap(_ok);
    await tester.pumpAndSettle();
    expect(okCount, 1);
    expect(_mask, findsNothing);
  });

  testWidgets('confirm 确认按钮触发 onClick 且关闭', (tester) async {
    var clicked = 0;
    await tester.pumpWidget(_wrap(
      AntDialog(
        visible: true,
        mode: AntDialogMode.confirm,
        onClick: () => clicked++,
      ),
    ),);
    await tester.pumpAndSettle();
    await tester.tap(_ok);
    await tester.pumpAndSettle();
    expect(clicked, 1);
    expect(_mask, findsNothing);
  });

  testWidgets('confirm 取消按钮关闭且不触发确认逻辑', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(visible: true, mode: AntDialogMode.confirm),
    ),);
    await tester.pumpAndSettle();
    await tester.tap(_cancel);
    await tester.pumpAndSettle();
    expect(_mask, findsNothing);
  });

  testWidgets('closeOnMaskClick=true 点击遮罩关闭', (tester) async {
    await tester.pumpWidget(_wrap(const AntDialog(visible: true)));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(_mask, findsNothing);
  });

  testWidgets('closeOnMaskClick=false 点击遮罩不关闭', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(visible: true, closeOnMaskClick: false),
    ),);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(_mask, findsOneWidget);
  });

  testWidgets('actions 自定义按钮区渲染并响应点击', (tester) async {
    var clicked = 0;
    await tester.pumpWidget(_wrap(
      AntDialog(
        visible: true,
        actions: [
          AntDialogAction(
            text: '自定义操作',
            bold: true,
            onClick: () => clicked++,
          ),
        ],
      ),
    ),);
    await tester.pumpAndSettle();
    expect(_ok, findsNothing);
    await tester.tap(find.text('自定义操作'));
    await tester.pumpAndSettle();
    expect(clicked, 1);
    expect(_mask, findsNothing);
  });

  testWidgets('actions 显式 null 隐藏按钮区', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(visible: true, actions: null),
    ),);
    await tester.pumpAndSettle();
    expect(_ok, findsNothing);
    expect(find.byType(GestureDetector).evaluate().isEmpty, isFalse);
  });

  testWidgets('缩放淡入动画存在（中间态）', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(visible: true, content: Text('内容')),
    ),);
    await tester.pump(const Duration(milliseconds: 60));
    // 遮罩未完全淡入
    final opacity = tester
        .widget<FadeTransition>(
          find.ancestor(of: _mask, matching: find.byType(FadeTransition)),
        )
        .opacity
        .value;
    expect(opacity, lessThan(1));
    // 卡片缩放未到 1
    final scale = tester
        .widget<ScaleTransition>(
          find.ancestor(of: _card, matching: find.byType(ScaleTransition)),
        )
        .scale
        .value;
    expect(scale, lessThan(1));
    await tester.pumpAndSettle();
    expect(scale, lessThanOrEqualTo(1));
  });

  testWidgets('关闭反向动画后浮层移除', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(visible: true, content: Text('内容')),
    ),);
    await tester.pumpAndSettle();
    await tester.tap(_ok);
    await tester.pump(const Duration(milliseconds: 60));
    // 动画进行中浮层仍在
    expect(_mask, findsOneWidget);
    await tester.pumpAndSettle();
    expect(_mask, findsNothing);
    expect(_card, findsNothing);
  });

  testWidgets('卡片宽度约为 0.7 屏宽', (tester) async {
    await tester.pumpWidget(_wrap(const AntDialog(visible: true)));
    await tester.pumpAndSettle();
    final screenW =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getSize(_card).width,
        closeTo(screenW * kAntDialogDefaultWidthFactor, 1),);
  });

  testWidgets('自定义 widthFactor 生效', (tester) async {
    await tester.pumpWidget(_wrap(
      const AntDialog(visible: true, widthFactor: 0.9),
    ),);
    await tester.pumpAndSettle();
    final screenW =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getSize(_card).width, closeTo(screenW * 0.9, 1));
  });

  testWidgets('函数式 alert：点击确认返回 true', (tester) async {
    late bool result;
    await tester.pumpWidget(_wrap(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            result = await AntDialog.alert(
              context,
              title: '提示',
              content: const Text('操作成功'),
              okText: '知道了',
            );
          },
          child: const Text('open'),
        ),
      ),
    ),);
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('操作成功'), findsOneWidget);
    await tester.tap(find.text('知道了'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
    expect(find.text('操作成功'), findsNothing);
  });

  testWidgets('函数式 confirm：确认返回 true / 遮罩关闭返回 false', (tester) async {
    bool? confirmResult;
    await tester.pumpWidget(_wrap(
      Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            confirmResult = await AntDialog.confirm(
              context,
              content: const Text('确定吗？'),
            );
          },
          child: const Text('open'),
        ),
      ),
    ),);
    // 第一次：点确认
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntDialogOkButtonKey));
    await tester.pumpAndSettle();
    expect(confirmResult, isTrue);
    // 第二次：点遮罩
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(confirmResult, isFalse);
  });
}
