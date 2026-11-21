/// AntMessage widget 测试
library;

import 'package:antd_flutter_ui/src/feedback/message/ant_message.dart';
import 'package:antd_flutter_ui/src/feedback/loading/ant_loading.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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

/// 触发一条提示并完成入场动画（显式 pump，避免推进自动消失计时器）。
Future<void> showMessage(
  WidgetTester tester,
  Widget content, {
  AntMessageType type = AntMessageType.info,
  Duration? duration,
  bool closable = false,
  VoidCallback? onClose,
}) async {
  await tester.pumpWidget(_wrap(const SizedBox.shrink()));
  final context = tester.element(find.byType(Scaffold));
  AntMessage.show(
    context,
    content,
    type: type,
    duration: duration,
    closable: closable,
    onClose: onClose,
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

void main() {
  testWidgets('info 类型渲染默认图标与内容', (tester) async {
    await showMessage(tester, const Text('信息提示'));
    expect(find.text('信息提示'), findsOneWidget);
    expect(find.byIcon(AntIcons.infoCircleFilled), findsOneWidget);
    final theme = AntThemeData.light();
    expect(
      tester.widget<Icon>(find.byIcon(AntIcons.infoCircleFilled)).color,
      theme.colorInfo,
    );
  });

  testWidgets('success 类型渲染成功图标与主题色', (tester) async {
    await showMessage(tester, const Text('成功提示'), type: AntMessageType.success);
    expect(find.text('成功提示'), findsOneWidget);
    expect(find.byIcon(AntIcons.checkCircleFilled), findsOneWidget);
    final theme = AntThemeData.light();
    expect(
      tester.widget<Icon>(find.byIcon(AntIcons.checkCircleFilled)).color,
      theme.colorSuccess,
    );
  });

  testWidgets('warning 类型渲染警告图标与主题色', (tester) async {
    await showMessage(
      tester,
      const Text('警告提示'),
      type: AntMessageType.warning,
    );
    expect(find.byIcon(AntIcons.warningFilled), findsOneWidget);
    final theme = AntThemeData.light();
    expect(
      tester.widget<Icon>(find.byIcon(AntIcons.warningFilled)).color,
      theme.colorWarning,
    );
  });

  testWidgets('error 类型渲染错误图标与主题色', (tester) async {
    await showMessage(tester, const Text('错误提示'), type: AntMessageType.error);
    expect(find.byIcon(AntIcons.closeCircleFilled), findsOneWidget);
    final theme = AntThemeData.light();
    expect(
      tester.widget<Icon>(find.byIcon(AntIcons.closeCircleFilled)).color,
      theme.colorError,
    );
  });

  testWidgets('loading 类型渲染加载指示器', (tester) async {
    await showMessage(tester, const Text('加载中...'), type: AntMessageType.loading);
    expect(find.text('加载中...'), findsOneWidget);
    expect(find.byType(AntLoading), findsOneWidget);
    expect(find.byIcon(AntIcons.infoCircleFilled), findsNothing);
  });

  testWidgets('默认 3 秒后自动消失（含出场动画）', (tester) async {
    await showMessage(tester, const Text('三秒消失'));
    expect(find.text('三秒消失'), findsOneWidget);
    await tester.pump(kAntMessageDefaultDuration);
    // 出场动画
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('三秒消失'), findsNothing);
    expect(find.byKey(kAntMessageItemKey), findsNothing);
  });

  testWidgets('duration 自定义 1 秒后自动消失', (tester) async {
    await showMessage(
      tester,
      const Text('一秒消失'),
      duration: const Duration(seconds: 1),
    );
    // 未到时长仍显示
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('一秒消失'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('一秒消失'), findsNothing);
  });

  testWidgets('多条提示叠加显示', (tester) async {
    await showMessage(tester, const Text('第一条'));
    await showMessage(tester, const Text('第二条'));
    expect(find.text('第一条'), findsOneWidget);
    expect(find.text('第二条'), findsOneWidget);
    // 垂直堆叠：第二条在第一条下方
    final first = tester.getRect(find.text('第一条'));
    final second = tester.getRect(find.text('第二条'));
    expect(second.top, greaterThan(first.top));
  });

  testWidgets('onClose 回调在自动消失时触发', (tester) async {
    var closed = false;
    await showMessage(
      tester,
      const Text('回调提示'),
      onClose: () => closed = true,
    );
    expect(closed, isFalse);
    await tester.pump(kAntMessageDefaultDuration);
    await tester.pump(const Duration(milliseconds: 250));
    expect(closed, isTrue);
    expect(find.text('回调提示'), findsNothing);
  });

  testWidgets('loading 类型不自动消失', (tester) async {
    await showMessage(tester, const Text('持续加载'), type: AntMessageType.loading);
    await tester.pump(const Duration(seconds: 10));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('持续加载'), findsOneWidget);
    expect(find.byType(AntLoading), findsOneWidget);
  });

  testWidgets('内容支持任意 Widget', (tester) async {
    await showMessage(
      tester,
      const Row(
        key: Key('custom-content'),
        children: [
          Icon(AntIcons.starFilled),
          Text('自定义内容'),
        ],
      ),
    );
    expect(find.byKey(const Key('custom-content')), findsOneWidget);
    expect(find.text('自定义内容'), findsOneWidget);
  });

  testWidgets('默认文字样式取主题 fontSize 与 colorText', (tester) async {
    await showMessage(tester, const Text('样式文字'));
    final text = tester.widget<Text>(find.text('样式文字'));
    expect(text.style, isNull);
    final defaultStyle = tester
        .widget<DefaultTextStyle>(
          find.ancestor(
            of: find.text('样式文字'),
            matching: find.byType(DefaultTextStyle),
          ).first,
        )
        .style;
    final theme = AntThemeData.light();
    expect(defaultStyle.fontSize, theme.fontSize);
    expect(defaultStyle.color, theme.colorText);
  });

  testWidgets('滑入动画：入场后卡片出现在顶部安全区下方', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    final context = tester.element(find.byType(Scaffold));
    AntMessage.show(context, const Text('滑入提示'));
    // 动画进行中已可见
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('滑入提示'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 150));
    final rect = tester.getRect(find.text('滑入提示'));
    final safeTop = MediaQuery.paddingOf(tester.element(find.byType(Scaffold))).top;
    expect(rect.top, greaterThanOrEqualTo(safeTop));
  });

  testWidgets('全部消失后 Overlay 中不再有提示元素', (tester) async {
    await showMessage(tester, const Text('会消失的提示'));
    await tester.pump(kAntMessageDefaultDuration);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byKey(kAntMessageItemKey), findsNothing);
    // 再触发一条验证 Overlay 条目可重建
    final context = tester.element(find.byType(Scaffold));
    AntMessage.show(context, const Text('新的提示'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('新的提示'), findsOneWidget);
    await tester.pump(kAntMessageDefaultDuration);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('新的提示'), findsNothing);
  });

  testWidgets('closable=true 显示关闭按钮，点击手动关闭', (tester) async {
    var closed = false;
    await showMessage(
      tester,
      const Text('手动关闭'),
      type: AntMessageType.loading,
      closable: true,
      onClose: () => closed = true,
    );
    expect(find.byKey(kAntMessageCloseKey), findsOneWidget);
    await tester.tap(find.byKey(kAntMessageCloseKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(closed, isTrue);
    expect(find.text('手动关闭'), findsNothing);
  });

  testWidgets('handle.close() 可手动关闭 loading 提示', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    final context = tester.element(find.byType(Scaffold));
    final handle = AntMessage.show(
      context,
      const Text('句柄关闭'),
      type: AntMessageType.loading,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('句柄关闭'), findsOneWidget);
    handle.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('句柄关闭'), findsNothing);
  });
}
