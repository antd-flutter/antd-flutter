// antd_refresh example 组件画廊烟囱测试。
import 'package:antd_refresh/antd_refresh.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:antd_refresh_example/main.dart';

void main() {
  testWidgets('画廊启动并展示基础下拉刷新分区', (WidgetTester tester) async {
    await tester.pumpWidget(const AntdRefreshGalleryApp());
    await tester.pumpAndSettle();

    // 侧栏与内容标题各出现一次
    expect(find.text('基础下拉刷新'), findsNWidgets(2));
    // 基础分区至少渲染出一个 AntPullToRefresh 实例（视口不同可见数量可能变化）
    expect(find.byType(AntPullToRefresh), findsWidgets);
  });
}
