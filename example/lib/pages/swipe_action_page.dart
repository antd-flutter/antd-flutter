import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SwipeActionPage extends StatefulWidget {
  const SwipeActionPage({super.key});

  @override
  State<SwipeActionPage> createState() => _SwipeActionPageState();
}

class _SwipeActionPageState extends State<SwipeActionPage> {
  String _lastAction = '尚未触发操作';

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _record(String msg) {
    setState(() => _lastAction = msg);
    _showMsg(msg);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '左滑单按钮',
            theme: theme,
            child: AntSwipeAction(
              rightActions: [
                AntSwipeActionItem(
                  text: '删除',
                  color: theme.colorError,
                  onPressed: () => _record('已删除'),
                ),
              ],
              child: const _RowTile(title: '左滑显示删除按钮'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '左滑多按钮',
            theme: theme,
            child: AntSwipeAction(
              rightActions: [
                AntSwipeActionItem(text: '收藏', onPressed: () => _record('已收藏')),
                AntSwipeActionItem(
                  text: '编辑',
                  color: theme.colorWarning,
                  onPressed: () => _record('已进入编辑'),
                ),
                AntSwipeActionItem(
                  text: '删除',
                  color: theme.colorError,
                  onPressed: () => _record('已删除'),
                ),
              ],
              child: const _RowTile(title: '左滑显示三个按钮'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '左右双侧',
            theme: theme,
            child: AntSwipeAction(
              leftActions: [
                AntSwipeActionItem(
                  text: '置顶',
                  color: theme.colorSuccess,
                  onPressed: () => _record('已置顶'),
                ),
                AntSwipeActionItem(
                  text: '标记',
                  color: theme.colorPrimary,
                  onPressed: () => _record('已标记'),
                ),
              ],
              rightActions: [
                AntSwipeActionItem(
                  text: '更多',
                  onPressed: () => _record('更多操作'),
                ),
                AntSwipeActionItem(
                  text: '删除',
                  color: theme.colorError,
                  onPressed: () => _record('已删除'),
                ),
              ],
              child: const _RowTile(title: '右滑置顶/标记，左滑更多/删除'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '危险操作',
            theme: theme,
            child: AntSwipeAction(
              rightActions: [
                AntSwipeActionItem(
                  text: '清空数据',
                  color: theme.colorError,
                  onPressed: () => _record('数据已清空（危险操作）'),
                ),
              ],
              child: const _RowTile(title: '左滑清空数据（危险）'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '禁用操作',
            theme: theme,
            child: AntSwipeAction(
              rightActions: [
                AntSwipeActionItem(
                  text: '不可点',
                  color: theme.colorTextQuaternary,
                  disabled: true,
                ),
                AntSwipeActionItem(
                  text: '可用',
                  onPressed: () => _record('可用按钮被点击'),
                ),
              ],
              child: const _RowTile(title: '左滑：禁用 + 可用按钮'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '回调结果展示',
            theme: theme,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(theme.s(12)),
                  margin: EdgeInsets.only(bottom: theme.s(12)),
                  decoration: BoxDecoration(
                    color: theme.colorBgLayout,
                    borderRadius: BorderRadius.circular(theme.borderRadius),
                  ),
                  child: Text(
                    '最近操作：$_lastAction',
                    style: TextStyle(
                      fontSize: theme.fontSize,
                      color: theme.colorText,
                    ),
                  ),
                ),
                AntSwipeAction(
                  rightActions: [
                    AntSwipeActionItem(
                      text: '点赞',
                      onPressed: () => _record('点赞成功 👍'),
                    ),
                    AntSwipeActionItem(
                      text: '删除',
                      color: theme.colorError,
                      onPressed: () => _record('删除成功'),
                    ),
                  ],
                  child: const _RowTile(title: '左滑操作后结果展示在上方'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      height: theme.s(56),
      padding: EdgeInsets.symmetric(horizontal: theme.s(16)),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: theme.fontSize, color: theme.colorText),
      ),
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
