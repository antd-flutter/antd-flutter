/// AntToast widget 测试
library;

import 'package:antd_flutter_plus/src/components/feedback/toast/ant_toast.dart';
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

/// 触发一条提示并完成入场动画（显式 pump，避免推进自动消失计时器）。
Future<AntToastHandle> showToast(
  WidgetTester tester,
  Object content, {
  Object? icon,
  Duration? duration,
  bool maskClickable = true,
  AntToastPosition position = AntToastPosition.center,
  VoidCallback? onClose,
}) async {
  final context = tester.element(find.byType(Scaffold));
  final handle = AntToast.show(
    context,
    content,
    icon: icon,
    duration: duration,
    maskClickable: maskClickable,
    position: position,
    onClose: onClose,
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  return handle;
}

void main() {
  testWidgets('show 显示深色半透明圆角卡片', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '这是一条提示');
    expect(find.byKey(kAntToastKey), findsOneWidget);
    expect(find.text('这是一条提示'), findsOneWidget);
    // 深色半透明遮罩色
    final container = tester.widget<Container>(
      find.ancestor(of: find.text('这是一条提示'), matching: find.byType(Container)).first,
    );
    expect((container.decoration as BoxDecoration).color, kAntToastMaskColor);
  });

  testWidgets('content 支持 String', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '纯文字内容');
    expect(find.text('纯文字内容'), findsOneWidget);
  });

  testWidgets('content 支持 Widget', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(
      tester,
      const Row(key: Key('toast-custom'), children: [
        Icon(Icons.star),
        Text('自定义内容'),
      ],),
    );
    expect(find.byKey(const Key('toast-custom')), findsOneWidget);
    expect(find.text('自定义内容'), findsOneWidget);
  });

  testWidgets('icon success 渲染成功图标', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '上传成功', icon: AntToastIconType.success);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });

  testWidgets('icon fail 渲染失败图标', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '上传失败', icon: AntToastIconType.fail);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('icon loading 渲染加载指示器', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '加载中', icon: AntToastIconType.loading);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('icon 支持自定义 Widget', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(
      tester,
      '自定义图标',
      icon: const Icon(Icons.favorite, key: Key('toast-icon')),
    );
    expect(find.byKey(const Key('toast-icon')), findsOneWidget);
  });

  testWidgets('默认 2 秒后自动消失（fake async 含出场动画）', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '两秒消失');
    expect(find.text('两秒消失'), findsOneWidget);
    await tester.pump(kAntToastDefaultDuration);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('两秒消失'), findsNothing);
    expect(find.byKey(kAntToastKey), findsNothing);
  });

  testWidgets('loading 类型不自动消失，handle.close() 手动关闭', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    final handle = await showToast(
      tester,
      '持续加载',
      icon: AntToastIconType.loading,
    );
    await tester.pump(const Duration(seconds: 10));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('持续加载'), findsOneWidget);
    handle.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('持续加载'), findsNothing);
    expect(find.byKey(kAntToastKey), findsNothing);
  });

  testWidgets('onClose 回调在自动消失时触发', (tester) async {
    var closed = false;
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '回调提示', onClose: () => closed = true);
    expect(closed, isFalse);
    await tester.pump(kAntToastDefaultDuration);
    await tester.pump(const Duration(milliseconds: 250));
    expect(closed, isTrue);
  });

  testWidgets('maskClickable=true 遮罩穿透：下层按钮可点', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      Column(
        children: [
          ElevatedButton(
            key: const Key('under-btn'),
            onPressed: () => tapped = true,
            child: const Text('下层按钮'),
          ),
        ],
      ),
    ),);
    await showToast(tester, '穿透提示', maskClickable: true, position: AntToastPosition.bottom);
    await tester.tap(find.byKey(const Key('under-btn')));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('maskClickable=false 遮罩拦截：下层按钮不可点', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      Column(
        children: [
          ElevatedButton(
            key: const Key('under-btn-2'),
            onPressed: () => tapped = true,
            child: const Text('下层按钮2'),
          ),
        ],
      ),
    ),);
    await showToast(tester, '拦截提示', maskClickable: false, position: AntToastPosition.bottom);
    await tester.tap(find.byKey(const Key('under-btn-2')), warnIfMissed: false);
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('position top 显示在屏幕上方区域', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '顶部提示', position: AntToastPosition.top);
    final rect = tester.getRect(find.text('顶部提示'));
    final size = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(rect.center.dy, lessThan(size.height / 2));
  });

  testWidgets('position center 显示在屏幕中央', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '中央提示', position: AntToastPosition.center);
    final rect = tester.getRect(find.text('中央提示'));
    final size = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect((rect.center.dy - size.height / 2).abs(), lessThan(80));
  });

  testWidgets('position bottom 显示在屏幕下方区域', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '底部提示', position: AntToastPosition.bottom);
    final rect = tester.getRect(find.text('底部提示'));
    final size = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(rect.center.dy, greaterThan(size.height / 2));
  });

  testWidgets('淡入缩放动画：入场过程中透明度渐增', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    final context = tester.element(find.byType(Scaffold));
    AntToast.show(context, '动画提示');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // 动画中已可见且透明度未达 1
    expect(find.text('动画提示'), findsOneWidget);
    final fade = tester.widget<FadeTransition>(
      find.ancestor(of: find.text('动画提示'), matching: find.byType(FadeTransition)).first,
    );
    expect(fade.opacity.value, lessThan(1.0));
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('多条提示简化为替换当前', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '第一条提示');
    await showToast(tester, '第二条提示');
    expect(find.text('第一条提示'), findsNothing);
    expect(find.text('第二条提示'), findsOneWidget);
    expect(find.byKey(kAntToastKey), findsOneWidget);
  });

  testWidgets('消失后 Overlay 中不再有提示元素，且可再次弹出', (tester) async {
    await tester.pumpWidget(_wrap(const SizedBox.shrink()));
    await showToast(tester, '会消失的提示');
    await tester.pump(kAntToastDefaultDuration);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byKey(kAntToastKey), findsNothing);
    await showToast(tester, '新的提示');
    expect(find.text('新的提示'), findsOneWidget);
  });
}
