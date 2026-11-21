import 'package:antd_flutter_plus/antd_flutter_plus.dart';
// 注：组件 export 行追加到 antd_flutter_plus.dart 后可改回 barrel 导入
import 'package:material_ui/material_ui.dart';

class EllipsisPage extends StatelessWidget {
  const EllipsisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    const longText =
        'antd-mobile 是蚂蚁集团开源的移动端组件库，提供了大量高质量的移动端组件，'
        '包括基础组件、布局组件、数据展示组件、反馈组件、导航组件等等，'
        '支持 React、Vue、Angular 等多种框架，是国内使用最广泛的移动端组件库之一。';
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法（两行截断）',
            theme: theme,
            child: const AntEllipsis(
              content: longText,
              rows: 2,
              expandText: '展开',
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '三行截断 + 收起',
            theme: theme,
            child: const AntEllipsis(
              content: longText,
              rows: 3,
              expandText: '展开',
              collapseText: '收起',
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'direction: end（截尾，默认）',
            theme: theme,
            child: const AntEllipsis(
              content: longText,
              rows: 1,
              direction: AntEllipsisDirection.end,
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'direction: start（截头）',
            theme: theme,
            child: const AntEllipsis(
              content: longText,
              rows: 1,
              direction: AntEllipsisDirection.start,
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'direction: middle（截中间）',
            theme: theme,
            child: const AntEllipsis(
              content: longText,
              rows: 1,
              direction: AntEllipsisDirection.middle,
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '点击内容回调',
            theme: theme,
            child: AntEllipsis(
              content: longText,
              rows: 2,
              expandText: '展开',
              collapseText: '收起',
              onContentClick: () => _showMsg(context, '点击了文本内容'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '短文本（不截断）',
            theme: theme,
            child: const AntEllipsis(content: '短文本，不触发省略'),
          ),
        ],
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: AntText(text: msg)));
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
          AntText(
            text: title,
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
