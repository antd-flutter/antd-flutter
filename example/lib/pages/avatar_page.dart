import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});

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
            child: Row(
              children: [
                AntAvatar(child: 'A'),
                SizedBox(width: theme.s(16)),
                AntAvatar(child: 'U', backgroundColor: Colors.blueGrey),
                SizedBox(width: theme.s(16)),
                AntAvatar(icon: const Icon(AntIcons.userOutlined)),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '尺寸',
            theme: theme,
            child: Row(
              children: [
                AntAvatar(child: 'L', presetSize: AntAvatarSize.large),
                SizedBox(width: theme.s(16)),
                AntAvatar(child: 'D'),
                SizedBox(width: theme.s(16)),
                AntAvatar(child: 'S', presetSize: AntAvatarSize.small),
                SizedBox(width: theme.s(16)),
                AntAvatar(child: '64', size: 64),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '形状',
            theme: theme,
            child: Row(
              children: [
                AntAvatar(child: 'C', shape: AntAvatarShape.circle),
                SizedBox(width: theme.s(16)),
                AntAvatar(child: 'S', shape: AntAvatarShape.square),
                SizedBox(width: theme.s(16)),
                AntAvatar(
                  icon: const Icon(AntIcons.userOutlined),
                  shape: AntAvatarShape.square,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '文字头像',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                AntAvatar(child: '张'),
                AntAvatar(child: '李四', backgroundColor: Colors.green),
                AntAvatar(child: '王五六', backgroundColor: Colors.orange),
                AntAvatar(child: '赵七八九', backgroundColor: Colors.purple),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '头像组',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntAvatarGroup(
                  spacing: -8,
                  children: [
                    AntAvatar(child: 'A'),
                    AntAvatar(child: 'B', backgroundColor: Colors.green),
                    AntAvatar(child: 'C', backgroundColor: Colors.orange),
                    AntAvatar(child: 'D', backgroundColor: Colors.purple),
                  ],
                ),
                SizedBox(height: theme.s(16)),
                AntAvatarGroup(
                  spacing: -8,
                  maxCount: 3,
                  children: [
                    AntAvatar(child: 'A'),
                    AntAvatar(child: 'B', backgroundColor: Colors.green),
                    AntAvatar(child: 'C', backgroundColor: Colors.orange),
                    AntAvatar(child: 'D', backgroundColor: Colors.purple),
                    AntAvatar(child: 'E', backgroundColor: Colors.teal),
                  ],
                ),
                SizedBox(height: theme.s(16)),
                AntAvatarGroup(
                  spacing: 8,
                  children: [
                    AntAvatar(child: 'A'),
                    AntAvatar(child: 'B', backgroundColor: Colors.green),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '图片头像',
            theme: theme,
            child: Row(
              children: [
                AntAvatar(
                  src: 'https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png',
                ),
                SizedBox(width: theme.s(16)),
                AntAvatar(
                  src: 'https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png',
                  shape: AntAvatarShape.square,
                ),
                SizedBox(width: theme.s(16)),
                AntAvatar(src: 'assets/avatar_demo.png'),
                SizedBox(width: theme.s(16)),
                AntAvatar(
                  src: 'https://invalid.example.com/bad.png',
                  onError: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('图片加载失败')));
                  },
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
