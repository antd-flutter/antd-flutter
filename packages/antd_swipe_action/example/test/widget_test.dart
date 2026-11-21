// antd_swipe_action example 组件画廊烟囱测试。
import 'package:antd_swipe_action/antd_swipe_action.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:antd_swipe_action_example/main.dart';

void main() {
  testWidgets('画廊启动并展示左右滑基础分区', (WidgetTester tester) async {
    await tester.pumpWidget(const AntdSwipeActionGalleryApp());
    await tester.pumpAndSettle();

    // 侧栏与内容标题各出现一次
    expect(find.text('左右滑基础'), findsNWidgets(2));
    // 基础分区渲染出 AntSwipeAction 实例
    expect(find.byType(AntSwipeAction), findsWidgets);
  });
}
