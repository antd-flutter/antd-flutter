/// AntModal widget 测试
library;

import 'package:antd_flutter_plus/src/components/feedback/modal/ant_modal.dart';
import 'package:antd_flutter_plus/src/components/general/button/ant_button.dart';
import 'package:antd_flutter_plus/src/components/general/button/ant_button_types.dart';
import 'package:antd_theme/antd_theme.dart';
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

/// 带状态开关的受控 AntModal 宿主。
class _Host extends StatefulWidget {
  const _Host({
    super.key,
    this.footer,
    this.hideFooter = false,
    this.width,
    this.maskClosable = true,
    this.closable = true,
    this.centered = false,
    this.initialOpen = true,
  });

  final Widget? footer;
  final bool hideFooter;
  final double? width;
  final bool maskClosable;
  final bool closable;
  final bool centered;
  final bool initialOpen;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late bool open = widget.initialOpen;

  @override
  Widget build(BuildContext context) {
    return _wrap(
      Column(
        children: [
          TextButton(
            key: const Key('toggle'),
            onPressed: () => setState(() => open = !open),
            child: Text(open ? '关闭' : '打开'),
          ),
          Expanded(
            child: AntModal(
              open: open,
              title: '对话框标题',
              content: const Text('对话框内容'),
              footer: widget.hideFooter ? null : widget.footer,
              width: widget.width,
              maskClosable: widget.maskClosable,
              closable: widget.closable,
              centered: widget.centered,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('open=true 显示遮罩与对话框卡片', (tester) async {
    await tester.pumpWidget(_wrap(const AntModal(open: true)));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalMaskKey), findsOneWidget);
    expect(find.byKey(kAntModalCardKey), findsOneWidget);
  });

  testWidgets('open=false 不显示对话框', (tester) async {
    await tester.pumpWidget(_wrap(const AntModal(open: false)));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCardKey), findsNothing);
    expect(find.byKey(kAntModalMaskKey), findsNothing);
  });

  testWidgets('open 变化 false→true 打开，true→false 关闭', (tester) async {
    await tester.pumpWidget(const _Host(initialOpen: false));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCardKey), findsNothing);

    await tester.tap(find.byKey(const Key('toggle')));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCardKey), findsOneWidget);

    await tester.tap(find.byKey(const Key('toggle')));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCardKey), findsNothing);
  });

  testWidgets('title 与 content 渲染', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntModal(
          open: true,
          title: '对话框标题',
          content: Text('对话框内容'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('对话框标题'), findsOneWidget);
    expect(find.text('对话框内容'), findsOneWidget);
  });

  testWidgets('点击确认按钮触发 onOk 并关闭', (tester) async {
    var okCount = 0;
    await tester.pumpWidget(_wrap(AntModalHostBridge(onOk: () => okCount++)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntModalOkButtonKey));
    await tester.pumpAndSettle();
    expect(okCount, 1);
    expect(find.byKey(kAntModalCardKey), findsNothing);
  });

  testWidgets('点击取消按钮触发 onCancel 并关闭', (tester) async {
    var cancelCount = 0;
    await tester.pumpWidget(
      _wrap(AntModalHostBridge(onCancel: () => cancelCount++)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntModalCancelButtonKey));
    await tester.pumpAndSettle();
    expect(cancelCount, 1);
    expect(find.byKey(kAntModalCardKey), findsNothing);
  });

  testWidgets('confirmLoading 加载态下确认按钮禁点', (tester) async {
    var okCount = 0;
    await tester.pumpWidget(
      _wrap(
        AntModalHostBridge(
          onOk: () => okCount++,
          confirmLoading: true,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(kAntModalOkButtonKey), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
    expect(okCount, 0);
    expect(find.byKey(kAntModalCardKey), findsOneWidget);
  });

  testWidgets('footer=null 隐藏底部按钮', (tester) async {
    await tester.pumpWidget(_wrap(const _Host(hideFooter: true)));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalOkButtonKey), findsNothing);
    expect(find.byKey(kAntModalCancelButtonKey), findsNothing);
    expect(find.byKey(kAntModalCardKey), findsOneWidget);
  });

  testWidgets('footer 自定义 Widget 渲染', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const _Host(
          footer: TextButton(
            key: Key('custom-footer'),
            onPressed: null,
            child: Text('自定义底部'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('custom-footer')), findsOneWidget);
    expect(find.text('自定义底部'), findsOneWidget);
    // 默认按钮不渲染
    expect(find.byKey(kAntModalOkButtonKey), findsNothing);
  });

  testWidgets('maskClosable=true 点击遮罩关闭，false 不关闭', (tester) async {
    // 可关闭
    var cancelCount = 0;
    await tester.pumpWidget(
      _wrap(
        AntModalHostBridge(
          onCancel: () => cancelCount++,
          key: const Key('modal-mask-on'),
          maskClosable: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 550));
    await tester.pumpAndSettle();
    expect(cancelCount, 1);
    expect(find.byKey(kAntModalCardKey), findsNothing);

    // 不可关闭
    await tester.pumpWidget(
      const _Host(maskClosable: false, initialOpen: true),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 550));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCardKey), findsOneWidget);
  });

  testWidgets('closable=true 右上角图标关闭，false 无图标', (tester) async {
    var cancelCount = 0;
    await tester.pumpWidget(
      _wrap(AntModalHostBridge(onCancel: () => cancelCount++)),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCloseKey), findsOneWidget);
    await tester.tap(find.byKey(kAntModalCloseKey));
    await tester.pumpAndSettle();
    expect(cancelCount, 1);
    expect(find.byKey(kAntModalCardKey), findsNothing);

    // 无关闭图标
    await tester.pumpWidget(const _Host(closable: false));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCloseKey), findsNothing);
  });

  testWidgets('centered=true 垂直居中，默认偏上展示', (tester) async {
    await tester.pumpWidget(const _Host(centered: true));
    await tester.pumpAndSettle();
    final card = tester.getRect(find.byKey(kAntModalCardKey));
    final screen = tester.getRect(find.byType(Scaffold));
    expect(
      (card.center.dy - screen.center.dy).abs(),
      lessThan(20),
    );

    // 默认偏上
    await tester.pumpWidget(const _Host(key: Key('top-mode')));
    await tester.pumpAndSettle();
    final card2 = tester.getRect(find.byKey(kAntModalCardKey));
    expect(card2.center.dy, lessThan(screen.center.dy));
  });

  testWidgets('width 控制对话框宽度', (tester) async {
    await tester.pumpWidget(const _Host(width: 400));
    await tester.pumpAndSettle();
    final card = tester.getRect(find.byKey(kAntModalCardKey));
    expect(card.width, closeTo(400, 1));
  });

  testWidgets('遮罩淡入动画完成后可见', (tester) async {
    await tester.pumpWidget(_wrap(const AntModal(open: true)));
    // 首帧动画进行中（透明度较低）
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byKey(kAntModalMaskKey), findsOneWidget);
    // 动画完成后卡片完全可见
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byKey(kAntModalCardKey), findsOneWidget);
    final opacity = tester
        .widget<FadeTransition>(
          find.ancestor(
            of: find.byKey(kAntModalMaskKey),
            matching: find.byType(FadeTransition),
          ).first,
        )
        .opacity
        .value;
    expect(opacity, 1);
  });

  testWidgets('showAntModal 函数式确认返回 true', (tester) async {
    var okCount = 0;
    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) {
            return TextButton(
              key: const Key('launch'),
              onPressed: () async {
                final ok = await showAntModal(
                  context,
                  title: '函数式标题',
                  content: const Text('函数式内容'),
                  onOk: () => okCount++,
                );
                expect(ok, isTrue);
              },
              child: const Text('打开'),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('launch')));
    await tester.pumpAndSettle();
    expect(find.text('函数式标题'), findsOneWidget);
    expect(find.byKey(kAntModalCardKey), findsOneWidget);
    await tester.tap(find.byKey(kAntModalOkButtonKey));
    await tester.pumpAndSettle();
    expect(okCount, 1);
    expect(find.byKey(kAntModalCardKey), findsNothing);
  });

  testWidgets('showAntModal 取消按钮文案自定义并返回 false', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) {
            return TextButton(
              key: const Key('launch2'),
              onPressed: () async {
                final ok = await showAntModal(
                  context,
                  title: '自定义取消',
                  cancelText: '不要了',
                  okText: '就这么办',
                );
                expect(ok, isFalse);
              },
              child: const Text('打开'),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('launch2')));
    await tester.pumpAndSettle();
    expect(find.text('不要了'), findsOneWidget);
    expect(find.text('就这么办'), findsOneWidget);
    await tester.tap(find.byKey(kAntModalCancelButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntModalCardKey), findsNothing);
  });

  testWidgets('确认按钮为主色主按钮，取消按钮为默认按钮', (tester) async {
    await tester.pumpWidget(_wrap(const AntModal(open: true)));
    await tester.pumpAndSettle();
    final okButton =
        tester.widget<AntButton>(find.byKey(kAntModalOkButtonKey));
    final cancelButton =
        tester.widget<AntButton>(find.byKey(kAntModalCancelButtonKey));
    expect(okButton.type, AntButtonType.primary);
    expect(cancelButton.type, AntButtonType.normal);
  });
}

/// 测试桥接宿主：open 受外部 key 控制区分用例。
class AntModalHostBridge extends StatefulWidget {
  const AntModalHostBridge({
    super.key,
    this.onOk,
    this.onCancel,
    this.confirmLoading = false,
    this.maskClosable = true,
  });

  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final bool confirmLoading;
  final bool maskClosable;

  @override
  State<AntModalHostBridge> createState() => _AntModalHostBridgeState();
}

class _AntModalHostBridgeState extends State<AntModalHostBridge> {
  bool open = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AntModal(
            open: open,
            title: '对话框标题',
            content: const Text('对话框内容'),
            onOk: widget.onOk == null
                ? null
                : () {
                    widget.onOk?.call();
                    setState(() => open = false);
                  },
            onCancel: widget.onCancel == null
                ? null
                : () {
                    widget.onCancel?.call();
                    setState(() => open = false);
                  },
            confirmLoading: widget.confirmLoading,
            maskClosable: widget.maskClosable,
          ),
        ),
      ],
    );
  }
}
