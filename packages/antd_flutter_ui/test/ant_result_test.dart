import 'package:antd_flutter_ui/src/feedback/result/ant_result.dart';
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

void main() {
  group('AntResult', () {
    testWidgets('success renders check icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.success,
        title: '成功',
      ),),);
      expect(find.byIcon(AntIcons.checkCircleFilled), findsOneWidget);
    });

    testWidgets('error renders cancel icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.error,
        title: '失败',
      ),),);
      expect(find.byIcon(AntIcons.closeCircleFilled), findsOneWidget);
    });

    testWidgets('info renders info icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.info,
        title: '提示',
      ),),);
      expect(find.byIcon(AntIcons.infoCircleFilled), findsOneWidget);
    });

    testWidgets('warning renders warning icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.warning,
        title: '警告',
      ),),);
      expect(find.byIcon(AntIcons.warningFilled), findsOneWidget);
    });

    testWidgets('404 renders numeric label', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.notFound,
        title: '页面不存在',
      ),),);
      expect(find.text('404'), findsOneWidget);
      expect(find.text('页面不存在'), findsOneWidget);
    });

    testWidgets('403 renders numeric label', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.forbidden,
      ),),);
      expect(find.text('403'), findsOneWidget);
    });

    testWidgets('500 renders numeric label', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.serverError,
      ),),);
      expect(find.text('500'), findsOneWidget);
    });

    testWidgets('title and subTitle render', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.success,
        title: '操作成功',
        subTitle: '数据已保存到服务器',
      ),),);
      expect(find.text('操作成功'), findsOneWidget);
      expect(find.text('数据已保存到服务器'), findsOneWidget);
    });

    testWidgets('extra renders action buttons', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.success,
        title: '操作成功',
        extra: Row(
          children: [
            OutlinedButton(onPressed: null, child: Text('再改一次')),
            ElevatedButton(onPressed: null, child: Text('回到首页')),
          ],
        ),
      ),),);
      expect(find.text('再改一次'), findsOneWidget);
      expect(find.text('回到首页'), findsOneWidget);
    });

    testWidgets('children renders custom content', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.info,
        title: '提示',
        children: Text('自定义内容区'),
      ),),);
      expect(find.text('自定义内容区'), findsOneWidget);
    });

    testWidgets('custom icon overrides default', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(
        status: AntResultStatus.success,
        title: '自定义图标',
        icon: Icon(AntIcons.starFilled, key: Key('my-icon')),
      ),),);
      expect(find.byKey(const Key('my-icon')), findsOneWidget);
      expect(find.byIcon(AntIcons.checkCircleFilled), findsNothing);
    });

    testWidgets('default status renders info icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntResult(title: '默认状态')));
      expect(find.byIcon(AntIcons.infoCircleFilled), findsOneWidget);
      expect(find.text('默认状态'), findsOneWidget);
    });
  });
}
