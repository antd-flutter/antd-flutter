import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntPullToRefresh 演示页
class PullToRefreshPage extends StatefulWidget {
  const PullToRefreshPage({super.key});

  @override
  State<PullToRefreshPage> createState() => _PullToRefreshPageState();
}

class _PullToRefreshPageState extends State<PullToRefreshPage> {
  /// 程序化刷新控制器（R35.2 Controller 优先，替代 GlobalKey State 直调）。
  final AntPullToRefreshController _refreshController =
      AntPullToRefreshController();

  Future<void> _mockRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('PullToRefresh 下拉刷新')),
      body: ListView(
        padding: EdgeInsets.all(theme.s(16)),
        children: [
          _Section(
            title: '程序化刷新（Controller）',
            theme: theme,
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _refreshController.callRefresh,
                      child: const Text('callRefresh()'),
                    ),
                  ],
                ),
                SizedBox(height: theme.s(12)),
                SizedBox(
                  height: theme.s(220),
                  child: AntPullToRefresh(
                    controller: _refreshController,
                    onRefresh: _mockRefresh,
                    child: _buildItems(5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '基础用法',
            theme: theme,
            child: SizedBox(
              height: theme.s(220),
              child: AntPullToRefresh(
                onRefresh: _mockRefresh,
                child: _buildItems(5),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义文案',
            theme: theme,
            child: SizedBox(
              height: theme.s(220),
              child: AntPullToRefresh(
                onRefresh: _mockRefresh,
                pullingText: '下拉加载最新内容',
                releasingText: '松手立即加载',
                finishingText: '正在加载...',
                completeText: '加载完成',
                child: _buildItems(5),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '阈值与头部高度',
            theme: theme,
            child: SizedBox(
              height: theme.s(220),
              child: AntPullToRefresh(
                onRefresh: _mockRefresh,
                headHeight: 60,
                threshold: 100,
                child: _buildItems(5),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义头部',
            theme: theme,
            child: SizedBox(
              height: theme.s(220),
              child: AntPullToRefresh(
                onRefresh: _mockRefresh,
                headHeight: 50,
                header: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AntIcons.reloadOutlined,
                        size: theme.s(18),
                        color: theme.colorPrimary,
                      ),
                      SizedBox(width: theme.s(6)),
                      Text('自定义头部提示', style: TextStyle(fontSize: theme.s(14))),
                    ],
                  ),
                ),
                child: _buildItems(5),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '刷新回调展示',
            theme: theme,
            child: const _RefreshCallbackDemo(),
          ),
        ],
      ),
    );
  }

  Widget _buildItems(int count) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(AntIcons.fileTextOutlined),
        title: Text('列表项 ${index + 1}'),
        subtitle: const Text('下拉列表即可刷新内容'),
      ),
    );
  }
}

/// 记录状态回调的演示。
class _RefreshCallbackDemo extends StatefulWidget {
  const _RefreshCallbackDemo();

  @override
  State<_RefreshCallbackDemo> createState() => _RefreshCallbackDemoState();
}

class _RefreshCallbackDemoState extends State<_RefreshCallbackDemo> {
  AntPullToRefreshStatus _status = AntPullToRefreshStatus.idle;
  int _refreshCount = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: theme.s(220),
          child: AntPullToRefresh(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(seconds: 1));
              if (mounted) setState(() => _refreshCount++);
            },
            pullStatusChange: (status) {
              if (mounted) setState(() => _status = status);
            },
            child: ListView(
              children: const [
                ListTile(title: Text('下拉我试试')),
                ListTile(title: Text('观察下方状态变化')),
              ],
            ),
          ),
        ),
        SizedBox(height: theme.s(12)),
        Text(
          '当前状态：$_status',
          style: TextStyle(fontSize: theme.s(14), color: theme.colorTextSecondary),
        ),
        SizedBox(height: theme.s(4)),
        Text(
          '累计刷新次数：$_refreshCount',
          style: TextStyle(fontSize: theme.s(14), color: theme.colorTextSecondary),
        ),
      ],
    );
  }
}

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
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.s(16),
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: theme.s(12)),
          child,
        ],
      ),
    );
  }
}
