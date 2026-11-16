import 'package:antd_flutter_plus/src/components/feedback/result_page/ant_result_page.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: Center(child: child)),
        ),
      ),
    ),
  );
}

void main() {
  group('AntResultPage', () {
    testWidgets('success renders check icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.success,
        title: '操作成功',
      ),),);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('error renders cancel icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.error,
        title: '提交失败',
      ),),);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('warning renders warning icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.warning,
        title: '操作存在风险',
      ),),);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('info renders info icon (default status)', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(title: '提示')));
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('waiting renders schedule icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.waiting,
        title: '等待处理',
      ),),);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('title and subTitle render', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.success,
        title: '操作成功',
        subTitle: '申请已提交，等待审核',
      ),),);
      expect(find.text('操作成功'), findsOneWidget);
      expect(find.text('申请已提交，等待审核'), findsOneWidget);
    });

    testWidgets('description renders multi-line detail list', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.success,
        title: '操作成功',
        description: [
          Text('订单号：20240101'),
          Text('支付方式：支付宝'),
          Text('金额：￥199.00'),
        ],
      ),),);
      expect(find.text('订单号：20240101'), findsOneWidget);
      expect(find.text('支付方式：支付宝'), findsOneWidget);
      expect(find.text('金额：￥199.00'), findsOneWidget);
    });

    testWidgets('buttons render and tap callback fires', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(AntResultPage(
        status: AntResultPageStatus.success,
        title: '操作成功',
        buttons: [
          ElevatedButton(
            onPressed: () => tapped = true,
            child: const Text('查看订单'),
          ),
          const ElevatedButton(onPressed: null, child: Text('返回首页')),
        ],
      ),),);
      expect(find.text('查看订单'), findsOneWidget);
      expect(find.text('返回首页'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton).first);
      expect(tapped, isTrue);
    });

    testWidgets('children renders custom content', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.info,
        title: '提示',
        children: Text('自定义内容区'),
      ),),);
      expect(find.text('自定义内容区'), findsOneWidget);
    });

    testWidgets('custom icon overrides default', (tester) async {
      await tester.pumpWidget(_wrap(const AntResultPage(
        status: AntResultPageStatus.success,
        title: '自定义图标',
        icon: Icon(Icons.star, key: Key('my-icon')),
      ),),);
      expect(find.byKey(const Key('my-icon')), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('layout is vertically centered', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 300,
        height: 600,
        child: AntResultPage(status: AntResultPageStatus.success, title: '居中'),
      ),),);
      final column = tester.widget<Column>(
        find.byKey(const Key('ant_result_page_layout')),
      );
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);

      // 图标实际位于容器垂直中点附近（上半个容器内存在内容留白）。
      final iconCenter = tester.getCenter(find.byIcon(Icons.check_circle));
      final containerTop =
          tester.getTopLeft(find.byKey(const Key('ant_result_page_layout')));
      expect(iconCenter.dy, greaterThan(containerTop.dy + 100));
    });

    testWidgets('buttons area is horizontally centered', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox(
        width: 300,
        child: AntResultPage(
          status: AntResultPageStatus.success,
          title: '操作成功',
          buttons: [
            ElevatedButton(onPressed: null, child: Text('返回首页')),
          ],
        ),
      ),),);
      final wrap = tester.widget<Wrap>(
        find.byKey(const Key('ant_result_page_buttons')),
      );
      expect(wrap.alignment, WrapAlignment.center);
    });
  });
}
