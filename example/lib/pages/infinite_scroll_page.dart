import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// InfiniteScroll demo 页 — 基础/失败重试/自定义文案/阈值/没有更多。
class InfiniteScrollPage extends StatelessWidget {
  const InfiniteScrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '程序化加载（Controller）',
            theme: theme,
            child: const _ControllerDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(title: '基础用法（模拟分页加载）', theme: theme, child: _BasicDemo()),
          SizedBox(height: 16.w),
          _Section(title: '失败重试', theme: theme, child: const _RetryDemo()),
          SizedBox(height: 16.w),
          _Section(title: '自定义文案', theme: theme, child: _CustomTextDemo()),
          SizedBox(height: 16.w),
          _Section(
            title: 'threshold 提前触发',
            theme: theme,
            child: _ThresholdDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(title: '没有更多', theme: theme, child: const _NoMoreDemo()),
        ],
      ),
    );
  }
}

/// 区块卡片。
class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(
            text: title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}

/// 模拟一页数据。
List<String> _mockPage(int page) =>
    List.generate(5, (i) => '第 ${page + 1} 页 - 第 ${i + 1} 条');

/// 基础用法：模拟分页加载 3 页。
/// 程序化加载演示：AntInfiniteScrollController.callLoadMore / reset。
class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  final AntInfiniteScrollController _controller = AntInfiniteScrollController();
  final List<String> _items = _mockPage(0);
  int _page = 1;

  Future<bool> _loadMore() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _items.addAll(_mockPage(_page));
    _page++;
    setState(() {});
    return _page < 3;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: _controller.callLoadMore,
              child: const Text('callLoadMore()'),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: () {
                _items.clear();
                _items.addAll(_mockPage(0));
                _page = 1;
                setState(() {});
                _controller.reset();
              },
              child: const Text('reset()'),
            ),
          ],
        ),
        SizedBox(height: 12.w),
        AntInfiniteScroll(
          controller: _controller,
          loadMore: _loadMore,
          child: SizedBox(
            height: 300.w,
            child: SingleChildScrollView(
              child: Column(
                children: _items
                    .map(
                      (item) => Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        margin: EdgeInsets.only(bottom: 8.w),
                        decoration: BoxDecoration(
                          color: AntTheme.of(context).colorFillQuaternary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: AntText(
                          text: item,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BasicDemo extends StatefulWidget {
  const _BasicDemo();

  @override
  State<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<_BasicDemo> {
  final List<String> _items = _mockPage(0);
  int _page = 1;

  Future<bool> _loadMore() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _items.addAll(_mockPage(_page));
    _page++;
    setState(() {});
    return _page < 3;
  }

  @override
  Widget build(BuildContext context) {
    // child 必须自带滚动组件（触发只属于自己的包裹对象，对齐 antd-mobile）。
    return AntInfiniteScroll(
      loadMore: _loadMore,
      child: SizedBox(
        height: 300.w,
        child: SingleChildScrollView(
          child: Column(
            children: _items
                .map(
                  (item) => Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    margin: EdgeInsets.only(bottom: 8.w),
                    decoration: BoxDecoration(
                      color: AntTheme.of(context).colorFillQuaternary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: AntText(
                      text: item,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// 失败重试：首次加载必失败，重试成功。
class _RetryDemo extends StatelessWidget {
  const _RetryDemo();

  Future<bool> _loadMore() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    throw Exception('模拟网络错误');
  }

  @override
  Widget build(BuildContext context) {
    return AntInfiniteScroll(
      loadMore: _loadMore,
      child: SizedBox(
        height: 300.w,
        child: SingleChildScrollView(
          child: Column(
            children: _mockPage(0)
                .map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.w),
                    child: AntText(
                      text: item,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// 自定义文案。
class _CustomTextDemo extends StatefulWidget {
  const _CustomTextDemo();

  @override
  State<_CustomTextDemo> createState() => _CustomTextDemoState();
}

class _CustomTextDemoState extends State<_CustomTextDemo> {
  Future<bool> _loadMore() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AntInfiniteScroll(
      loadMore: _loadMore,
      loadingText: '努力加载中…',
      hasMoreText: '上拉查看更多',
      noMoreText: '到底啦，没有更多啦',
      loadFailedText: '加载出错了',
      loadFailedRetryText: '重新加载',
      child: SizedBox(
        height: 300.w,
        child: SingleChildScrollView(
          child: Column(
            children: _mockPage(0)
                .map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.w),
                    child: AntText(
                      text: item,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// threshold：距底部 300 逻辑像素即触发。
class _ThresholdDemo extends StatefulWidget {
  const _ThresholdDemo();

  @override
  State<_ThresholdDemo> createState() => _ThresholdDemoState();
}

class _ThresholdDemoState extends State<_ThresholdDemo> {
  final List<String> _items = _mockPage(0);
  int _page = 1;

  Future<bool> _loadMore() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _items.addAll(_mockPage(_page));
    _page++;
    setState(() {});
    return _page < 2;
  }

  @override
  Widget build(BuildContext context) {
    return AntInfiniteScroll(
      threshold: 300,
      loadMore: _loadMore,
      child: SizedBox(
        height: 300.w,
        child: SingleChildScrollView(
          child: Column(
            children: _items
                .map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.w),
                    child: AntText(
                      text: item,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// 没有更多：直接返回 false。
class _NoMoreDemo extends StatelessWidget {
  const _NoMoreDemo();

  @override
  Widget build(BuildContext context) {
    return AntInfiniteScroll(
      loadMore: () async => false,
      child: SizedBox(
        height: 300.w,
        child: SingleChildScrollView(
          child: Column(
            children: _mockPage(0)
                .map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.w),
                    child: AntText(
                      text: item,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
