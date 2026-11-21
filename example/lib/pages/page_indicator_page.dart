import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class PageIndicatorPage extends StatelessWidget {
  const PageIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Section(
            title: '基础用法',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntPageIndicator(total: 5),
                SizedBox(height: 8),
                AntPageIndicator(total: 3, defaultCurrent: 1),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(title: '受控切换演示', child: _ControlledDemo()),
          SizedBox(height: 16.w),
          const _Section(
            title: '排列方向',
            child: Row(
              children: [
                AntPageIndicator(
                  total: 4,
                  defaultCurrent: 2,
                  direction: AntPageIndicatorDirection.horizontal,
                ),
                SizedBox(width: 24),
                AntPageIndicator(
                  total: 4,
                  defaultCurrent: 2,
                  direction: AntPageIndicatorDirection.vertical,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(
            title: '自定义颜色与尺寸',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntPageIndicator(
                  total: 4,
                  defaultCurrent: 1,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.deepOrange,
                ),
                SizedBox(height: 8),
                AntPageIndicator(
                  total: 4,
                  defaultCurrent: 1,
                  color: AntPageIndicatorPresetColor.white,
                ),
                SizedBox(height: 8),
                AntPageIndicator(
                  total: 4,
                  defaultCurrent: 1,
                  dotSize: 6,
                  activeDotSize: 18,
                  dotSpacing: 6,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(title: '与 PageView 联动', child: _PageViewDemo()),
        ],
      ),
    );
  }
}

// ============================================================
// 区块：受控切换
// ============================================================

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntPageIndicator(total: 4, current: _current),
        SizedBox(height: 12.w),
        Row(
          children: [
            AntButton(
              type: AntButtonType.normal,
              size: AntButtonSize.small,
              onTap: () =>
                  setState(() => _current = (_current - 1).clamp(0, 3)),
              child: const Text('上一页'),
            ),
            SizedBox(width: 8.w),
            AntButton(
              type: AntButtonType.normal,
              size: AntButtonSize.small,
              onTap: () =>
                  setState(() => _current = (_current + 1).clamp(0, 3)),
              child: const Text('下一页'),
            ),
            SizedBox(width: 12.w),
            Text(
              'current: $_current',
              style: TextStyle(
                fontSize: theme.fontSizeSM.sp,
                color: theme.colorText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// 区块：PageView 联动
// ============================================================

class _PageViewDemo extends StatefulWidget {
  const _PageViewDemo();

  @override
  State<_PageViewDemo> createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<_PageViewDemo> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 100.w,
          child: PageView(
            controller: _controller,
            onPageChanged: (page) => setState(() => _page = page),
            children: [
              for (var i = 1; i <= 4; i++)
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: theme.colorPrimaryBg,
                    borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
                  ),
                  child: Text(
                    '第 $i 页',
                    style: TextStyle(fontSize: theme.fontSize.sp),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 12.w),
        AntPageIndicator(total: 4, current: _page),
      ],
    );
  }
}

// ============================================================
// 区块容器（页面内私有）
// ============================================================

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
        border: Border.all(
          color: theme.colorBorderSecondary,
          width: theme.lineWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.fontSize.sp,
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
