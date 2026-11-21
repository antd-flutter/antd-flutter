import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法（点击可全屏预览）',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                AntImage(
                  src: 'https://picsum.photos/id/1015/600/400',
                  width: 200,
                  height: 140,
                ),
                AntImage(
                  src: 'https://picsum.photos/id/1016/600/400',
                  width: 200,
                  height: 140,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '尺寸与圆角',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                AntImage(
                  src: 'https://picsum.photos/id/1020/600/400',
                  width: 180,
                  height: 120,
                  radius: 0,
                ),
                AntImage(
                  src: 'https://picsum.photos/id/1021/600/400',
                  width: 180,
                  height: 120,
                  radius: 12,
                ),
                AntImage(
                  src: 'https://picsum.photos/id/1022/600/400',
                  width: 120,
                  height: 120,
                  radius: 60,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '填充模式 fit',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                _FitDemo(
                  label: 'cover',
                  theme: theme,
                  child: AntImage(
                    src: 'https://picsum.photos/id/1024/600/400',
                    width: 150,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                _FitDemo(
                  label: 'contain',
                  theme: theme,
                  child: AntImage(
                    src: 'https://picsum.photos/id/1024/600/400',
                    width: 150,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                _FitDemo(
                  label: 'fill',
                  theme: theme,
                  child: AntImage(
                    src: 'https://picsum.photos/id/1024/600/400',
                    width: 150,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '预览开关 preview',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                AntImage(
                  src: 'https://picsum.photos/id/1025/600/400',
                  width: 160,
                  height: 110,
                  preview: true,
                ),
                AntImage(
                  src: 'https://picsum.photos/id/1025/600/400',
                  width: 160,
                  height: 110,
                  preview: false,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '预览组 PreviewGroup（多图左右切换）',
            theme: theme,
            child: AntImagePreviewGroup(
              children: [
                AntImage(
                  src: 'https://picsum.photos/id/1035/600/400',
                  width: 130,
                  height: 90,
                ),
                AntImage(
                  src: 'https://picsum.photos/id/1036/600/400',
                  width: 130,
                  height: 90,
                ),
                AntImage(
                  src: 'https://picsum.photos/id/1038/600/400',
                  width: 130,
                  height: 90,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'previewSrc 缩略图与大图分离',
            theme: theme,
            child: AntImage(
              src: 'https://picsum.photos/id/1040/300/200',
              previewSrc: 'https://picsum.photos/id/1040/1200/800',
              width: 180,
              height: 120,
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '加载失败',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                AntImage(
                  src: 'https://invalid.example.com/bad.png',
                  width: 160,
                  height: 110,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义 fallback 占位',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                AntImage(
                  src: 'https://invalid.example.com/bad.png',
                  width: 160,
                  height: 110,
                  errorWidget: Container(
                    color: theme.colorFillTertiary,
                    alignment: Alignment.center,
                    child: AntText(
                      text: '图片走丢了',
                      style: TextStyle(
                        fontSize: theme.s(13),
                        color: theme.colorTextSecondary,
                      ),
                    ),
                  ),
                ),
                AntImage(
                  src: 'https://invalid.example.com/bad.png',
                  width: 160,
                  height: 110,
                  fallback: 'https://picsum.photos/id/1060/600/400',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 填充模式演示项。
class _FitDemo extends StatelessWidget {
  const _FitDemo({
    required this.label,
    required this.theme,
    required this.child,
  });

  final String label;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        SizedBox(height: theme.s(6)),
        AntText(
          text: label,
          style: TextStyle(fontSize: theme.s(12), color: theme.colorTextSecondary),
        ),
      ],
    );
  }
}

/// 展示区块容器。
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
