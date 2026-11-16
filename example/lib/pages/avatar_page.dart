import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});

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
            child: Row(
              children: [
                AntAvatar(child: 'A'),
                SizedBox(width: 16.w),
                AntAvatar(child: 'U', backgroundColor: Colors.blueGrey),
                SizedBox(width: 16.w),
                AntAvatar(icon: const Icon(Icons.person)),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '尺寸',
            theme: theme,
            child: Row(
              children: [
                AntAvatar(child: 'L', presetSize: AntAvatarSize.large),
                SizedBox(width: 16.w),
                AntAvatar(child: 'D'),
                SizedBox(width: 16.w),
                AntAvatar(child: 'S', presetSize: AntAvatarSize.small),
                SizedBox(width: 16.w),
                AntAvatar(child: '64', size: 64),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '形状',
            theme: theme,
            child: Row(
              children: [
                AntAvatar(child: 'C', shape: AntAvatarShape.circle),
                SizedBox(width: 16.w),
                AntAvatar(child: 'S', shape: AntAvatarShape.square),
                SizedBox(width: 16.w),
                AntAvatar(
                  icon: const Icon(Icons.person),
                  shape: AntAvatarShape.square,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '文字头像',
            theme: theme,
            child: Wrap(
              spacing: 16.w,
              runSpacing: 16.w,
              children: [
                AntAvatar(child: '张'),
                AntAvatar(child: '李四', backgroundColor: Colors.green),
                AntAvatar(child: '王五六', backgroundColor: Colors.orange),
                AntAvatar(child: '赵七八九', backgroundColor: Colors.purple),
              ],
            ),
          ),
          SizedBox(height: 16.w),
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
                SizedBox(height: 16.w),
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
                SizedBox(height: 16.w),
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
          SizedBox(height: 16.w),
          _Section(
            title: '图片头像',
            theme: theme,
            child: Row(
              children: [
                AntAvatar(
                  src: 'https://avatars.githubusercontent.com/u/12102236?v=4',
                ),
                SizedBox(width: 16.w),
                AntAvatar(
                  src: 'https://avatars.githubusercontent.com/u/12102236?v=4',
                  shape: AntAvatarShape.square,
                ),
                SizedBox(width: 16.w),
                AntAvatar(
                  src: 'https://invalid.example.com/bad.png',
                  onError: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('图片加载失败')),
                    );
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