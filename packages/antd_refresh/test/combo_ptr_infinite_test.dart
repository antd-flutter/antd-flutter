import 'package:antd_refresh/antd_refresh.dart';
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

/// 组合被测组件：PTR 包 InfiniteScroll 包 ListView（example 组合区块同构）。
class _Combo extends StatefulWidget {
  const _Combo({this.onState, this.onRefreshStatus});
  final ValueChanged<String>? onState;
  final ValueChanged<AntPullToRefreshStatus>? onRefreshStatus;

  @override
  State<_Combo> createState() => _ComboState();
}

class _ComboState extends State<_Combo> {
  int _pageStart = 0;
  int refreshes = 0;
  int loads = 0;

  Future<void> _refresh() async {
    refreshes++;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    setState(() => _pageStart = 0);
  }

  Future<bool> _loadMore() async {
    loads++;
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (_pageStart >= 30) return false;
    setState(() => _pageStart += 10);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    widget.onState?.call('r$refreshes l$loads p$_pageStart');
    return SizedBox(
      height: 460,
      child: AntPullToRefresh(
        onRefresh: _refresh,
        pullStatusChange: widget.onRefreshStatus,
        child: AntInfiniteScroll(
          loadMore: _loadMore,
          child: ListView(
            children: [
              for (var i = 0; i < _pageStart + 10; i++)
                ListTile(title: Text('item $i')),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('combo: no layout crash with bounded height', (tester) async {
    await tester.pumpWidget(_wrap(const _Combo()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('item 0'), findsOneWidget);
  });

  testWidgets('combo: pull refresh resets, no spurious load after reset',
      (tester) async {
    final states = <String>[];
    await tester.pumpWidget(_wrap(_Combo(onState: states.add)));
    await tester.pumpAndSettle();
    int pageOf(String s) => int.parse(s.split(' p').last);
    // 下拉刷新（重置数据）
    await tester.drag(find.byType(ListView), const Offset(0, 80));
    await tester.pumpAndSettle();
    // 刷新重置后不得误触发加载（pixels 被钳到底部 ≠ 用户滚到底）
    expect(pageOf(states.last), 0);
    // 滚到底触发加载 → 翻到第 2 页
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(pageOf(states.last), 10);
    // 多次循环稳定：再刷新重置再加载
    await tester.drag(find.byType(ListView), const Offset(0, 2000));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 80));
    await tester.pumpAndSettle();
    expect(pageOf(states.last), 0);
    await tester.drag(find.byType(ListView), const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(pageOf(states.last), 10);
    expect(tester.takeException(), isNull);
  });

  testWidgets('combo: PTR refresh still works while IS idle at bottom',
      (tester) async {
    await tester.pumpWidget(_wrap(const _Combo()));
    await tester.pumpAndSettle();
    // 滚到底（IS 触发边缘，通知被 IS 消费）
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    // 回到顶部后下拉刷新仍可用
    final statuses = <AntPullToRefreshStatus>[];
    await tester.drag(find.byType(ListView), const Offset(0, 2000));
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      _wrap(
        _Combo(onRefreshStatus: statuses.add),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 80));
    await tester.pumpAndSettle();
    expect(statuses, contains(AntPullToRefreshStatus.refreshing));
  });

  testWidgets('combo: noMore footer does not overlap last item',
      (tester) async {
    await tester.pumpWidget(_wrap(const _Combo()));
    await tester.pumpAndSettle();
    // 连续滚到底直到没有更多（第 4 页后）。
    for (var i = 0; i < 6; i++) {
      await tester.drag(find.byType(ListView), const Offset(0, -1500));
      await tester.pumpAndSettle();
    }
    expect(find.text('没有更多了'), findsOneWidget);
    final footerTop = tester.getTopLeft(find.text('没有更多了')).dy;
    // 找最后一个可见 item（列表尽头）。
    final items = find.byType(ListTile);
    double lastBottom = 0;
    for (final element in items.evaluate()) {
      final rect = tester.getRect(find.byWidget(element.widget));
      if (rect.bottom > lastBottom) lastBottom = rect.bottom;
    }
    expect(footerTop, greaterThanOrEqualTo(lastBottom));
    expect(tester.takeException(), isNull);
  });
}
