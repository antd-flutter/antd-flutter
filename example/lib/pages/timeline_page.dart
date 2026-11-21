import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _TimelineData {
  const _TimelineData({
    this.label,
    this.content,
    this.color,
    this.customDot,
    this.dotColor,
    this.disabled = false,
  });

  final String? label;
  final Widget? content;
  final AntTimelineColor? color;
  final Widget? customDot;
  final Color? dotColor;
  final bool disabled;
}

Widget _timeline({
  Key? key,
  List<_TimelineData> items = const [],
  AntTimelineMode mode = AntTimelineMode.left,
  bool pending = false,
  Widget? pendingDot,
  Widget? pendingContent,
  bool reverse = false,
}) {
  return AntTimeline<_TimelineData>(
    key: key,
    items: items,
    labelBuilder: (context, item, index) =>
        item.label == null ? null : Text(item.label!),
    contentBuilder: (context, item, index) => item.content,
    dotBuilder: (context, item) => item.customDot,
    colorOf: (item) => item.color,
    dotColorOf: (item) => item.dotColor,
    disabledOf: (item) => item.disabled,
    mode: mode,
    pending: pending,
    pendingDot: pendingDot,
    pendingContent: pendingContent,
    reverse: reverse,
  );
}

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: _timeline(
              items: [
                _TimelineData(
                  content: Text('创建服务现场 2015-09-01'),
                  color: AntTimelineColor.green,
                ),
                _TimelineData(
                  content: Text('初步排版 2015-09-01'),
                  color: AntTimelineColor.blue,
                ),
                _TimelineData(
                  content: Text('访问异常 2015-09-02'),
                  color: AntTimelineColor.red,
                ),
                _TimelineData(
                  content: Text('网络异常 2015-09-03'),
                  color: AntTimelineColor.gray,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '左右交替（alternate）',
            theme: theme,
            child: _timeline(
              mode: AntTimelineMode.alternate,
              items: [
                _TimelineData(
                  label: '09:00',
                  content: Text('创建站点'),
                  color: AntTimelineColor.green,
                ),
                _TimelineData(
                  label: '10:00',
                  content: Text('部署上线'),
                  color: AntTimelineColor.blue,
                ),
                _TimelineData(
                  label: '11:00',
                  content: Text('访问异常'),
                  color: AntTimelineColor.red,
                ),
                _TimelineData(
                  label: '12:00',
                  content: Text('问题修复'),
                  color: AntTimelineColor.gray,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '待办节点（pending）',
            theme: theme,
            child: _timeline(
              pending: true,
              pendingContent: Text('进行中...'),
              items: [
                _TimelineData(
                  content: Text('提交工单 2015-09-01'),
                  color: AntTimelineColor.green,
                ),
                _TimelineData(
                  content: Text('工程师处理中 2015-09-02'),
                  color: AntTimelineColor.blue,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '倒序（reverse）',
            theme: theme,
            child: _timeline(
              reverse: true,
              pending: true,
              items: [
                _TimelineData(
                  content: Text('需求评审'),
                  color: AntTimelineColor.green,
                ),
                _TimelineData(
                  content: Text('开发联调'),
                  color: AntTimelineColor.blue,
                ),
                _TimelineData(
                  content: Text('上线发布'),
                  color: AntTimelineColor.blue,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义节点',
            theme: theme,
            child: _timeline(
              items: [
                _TimelineData(
                  content: Text('已完成'),
                  color: AntTimelineColor.green,
                ),
                _TimelineData(
                  content: Text('自定义图标节点'),
                  customDot: AntdIcon(
                    AntIcons.checkCircleOutlined,
                    color: theme.colorSuccess,
                    size: theme.s(16),
                  ),
                ),
                _TimelineData(
                  content: Text('自定义颜色节点'),
                  dotColor: Colors.purple,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '时间标签（label）',
            theme: theme,
            child: _timeline(
              items: [
                _TimelineData(
                  label: '09:00',
                  content: Text('晨会，同步迭代进度'),
                  color: AntTimelineColor.blue,
                ),
                _TimelineData(
                  label: '11:30',
                  content: Text('需求评审会议'),
                  color: AntTimelineColor.blue,
                ),
                _TimelineData(
                  label: '14:00',
                  content: Text('代码评审'),
                  color: AntTimelineColor.green,
                ),
                _TimelineData(
                  label: '18:00',
                  content: Text('发布 v2.3.0'),
                  disabled: true,
                  color: AntTimelineColor.gray,
                ),
              ],
            ),
          ),
        ],
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
