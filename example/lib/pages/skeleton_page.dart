import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({super.key});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础组合（头像+标题+段落）',
            theme: theme,
            child: const AntSkeleton(
              loading: true,
              avatar: AntSkeletonAvatar(),
              title: AntSkeletonTitle(),
              paragraph: AntSkeletonParagraph(),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '仅头像 + 段落',
            theme: theme,
            child: const AntSkeleton(
              loading: true,
              avatar: AntSkeletonAvatar(size: 48),
              title: AntSkeletonTitle(show: false),
              paragraph: AntSkeletonParagraph(rows: 4),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义行数',
            theme: theme,
            child: const AntSkeleton(
              loading: true,
              paragraph: AntSkeletonParagraph(rows: 6),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '圆角胶囊条（round）',
            theme: theme,
            child: const AntSkeleton(
              loading: true,
              round: true,
              avatar: AntSkeletonAvatar(),
              paragraph: AntSkeletonParagraph(rows: 2),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '与内容切换',
            theme: theme,
            child: Column(
              children: [
                AntSkeleton(
                  loading: _loading,
                  active: true,
                  avatar: const AntSkeletonAvatar(),
                  paragraph: const AntSkeletonParagraph(rows: 2),
                  child: Row(
                    children: [
                      AntdIcon(
                        AntIcons.userOutlined,
                        size: theme.s(40),
                        color: theme.colorPrimary,
                      ),
                      SizedBox(width: theme.s(16)),
                      Expanded(
                        child: Text(
                          'Ant Design 是一个致力于提升「用户」和「设计者」体验的设计体系。',
                          style: TextStyle(
                            fontSize: theme.s(14),
                            color: theme.colorText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: theme.s(12)),
                AntButton(
                  type: AntButtonType.primary,
                  onTap: () => setState(() => _loading = !_loading),
                  child: Text(_loading ? '显示内容' : '显示骨架屏'),
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
