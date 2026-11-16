import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: AntTimeline(
              items: [
                AntTimelineItem(
                  content: Text('创建服务现场 2015-09-01'),
                  color: AntTimelineColor.green,
                ),
                AntTimelineItem(
                  content: Text('初步排版 2015-09-01'),
                  color: AntTimelineColor.blue,
                ),
                AntTimelineItem(
                  content: Text('访问异常 2015-09-02'),
                  color: AntTimelineColor.red,
                ),
                AntTimelineItem(
                  content: Text('网络异常 2015-09-03'),
                  color: AntTimelineColor.gray,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '左右交替（alternate）',
            theme: theme,
            child: AntTimeline(
              mode: AntTimelineMode.alternate,
              items: [
                AntTimelineItem(
                  label: '09:00',
                  content: Text('创建站点'),
                  color: AntTimelineColor.green,
                ),
                AntTimelineItem(
                  label: '10:00',
                  content: Text('部署上线'),
                  color: AntTimelineColor.blue,
                ),
                AntTimelineItem(
                  label: '11:00',
                  content: Text('访问异常'),
                  color: AntTimelineColor.red,
                ),
                AntTimelineItem(
                  label: '12:00',
                  content: Text('问题修复'),
                  color: AntTimelineColor.gray,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '待办节点（pending）',
            theme: theme,
            child: AntTimeline(
              pending: true,
              pendingContent: Text('进行中...'),
              items: [
                AntTimelineItem(
                  content: Text('提交工单 2015-09-01'),
                  color: AntTimelineColor.green,
                ),
                AntTimelineItem(
                  content: Text('工程师处理中 2015-09-02'),
                  color: AntTimelineColor.blue,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '倒序（reverse）',
            theme: theme,
            child: AntTimeline(
              reverse: true,
              pending: true,
              items: [
                AntTimelineItem(
                  content: Text('需求评审'),
                  color: AntTimelineColor.green,
                ),
                AntTimelineItem(
                  content: Text('开发联调'),
                  color: AntTimelineColor.blue,
                ),
                AntTimelineItem(
                  content: Text('上线发布'),
                  color: AntTimelineColor.blue,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义节点',
            theme: theme,
            child: AntTimeline(
              items: [
                AntTimelineItem(
                  content: Text('已完成'),
                  color: AntTimelineColor.green,
                ),
                AntTimelineItem(
                  content: Text('自定义图标节点'),
                  customDot: AntdIcon(AntIcons.checkCircleOutlined, color: theme.colorSuccess, size: 16.w),
                ),
                AntTimelineItem(
                  content: Text('自定义颜色节点'),
                  dotColor: Colors.purple,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '时间标签（label）',
            theme: theme,
            child: AntTimeline(
              items: [
                AntTimelineItem(
                  label: '09:00',
                  content: Text('晨会，同步迭代进度'),
                  color: AntTimelineColor.blue,
                ),
                AntTimelineItem(
                  label: '11:30',
                  content: Text('需求评审会议'),
                  color: AntTimelineColor.blue,
                ),
                AntTimelineItem(
                  label: '14:00',
                  content: Text('代码评审'),
                  color: AntTimelineColor.green,
                ),
                AntTimelineItem(
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
  const _Section({required this.title, required this.theme, required this.child});

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
          Text(
            title,
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
