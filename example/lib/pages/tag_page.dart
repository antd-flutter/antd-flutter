import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class TagPage extends StatelessWidget {
  const TagPage({super.key});

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
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                const AntTag(child: '标签一'),
                const AntTag(child: '标签二'),
                const AntTag(child: '标签三'),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '彩色标签',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: const [
                AntTag(child: '成功', color: AntTagColor.success),
                AntTag(child: '处理中', color: AntTagColor.processing),
                AntTag(child: '错误', color: AntTagColor.error),
                AntTag(child: '默认', color: AntTagColor.standard),
                AntTag(child: '警告', color: AntTagColor.warning),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '无边框',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: const [
                AntTag(
                  child: '成功',
                  color: AntTagColor.success,
                  bordered: false,
                ),
                AntTag(
                  child: '处理中',
                  color: AntTagColor.processing,
                  bordered: false,
                ),
                AntTag(child: '错误', color: AntTagColor.error, bordered: false),
                AntTag(
                  child: '警告',
                  color: AntTagColor.warning,
                  bordered: false,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '可关闭',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntTag(
                  child: '标签一',
                  closable: true,
                  onClose: () => _showMsg(context, '标签一已关闭'),
                ),
                AntTag(
                  child: '标签二',
                  closable: true,
                  onClose: () => _showMsg(context, '标签二已关闭'),
                ),
                AntTag(
                  child: '标签三',
                  closable: true,
                  color: AntTagColor.error,
                  onClose: () => _showMsg(context, '标签三已关闭'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '图标标签',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: const [
                AntTag(
                  child: '已完成',
                  color: AntTagColor.success,
                  icon: AntdIcon(AntIcons.checkCircleOutlined),
                ),
                AntTag(
                  child: '进行中',
                  color: AntTagColor.processing,
                  icon: AntdIcon(AntIcons.syncOutlined),
                ),
                AntTag(
                  child: '出错',
                  color: AntTagColor.error,
                  icon: AntdIcon(AntIcons.closeCircleOutlined),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义颜色',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: const [
                AntTag(child: '紫色', customColor: Colors.purple),
                AntTag(child: '青色', customColor: Colors.teal),
                AntTag(child: '粉色', customColor: Colors.pink),
                AntTag(child: '靛蓝', customColor: Colors.indigo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
