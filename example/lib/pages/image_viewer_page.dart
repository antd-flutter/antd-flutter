import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

/// 演示图片地址。
const List<String> kDemoImages = [
  'https://picsum.photos/id/1015/600/400',
  'https://picsum.photos/id/1016/600/400',
  'https://picsum.photos/id/1020/600/400',
];

/// ImageViewer demo 页 — 单图/多图/受控/初始页/组合入口。
class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '单图预览',
            theme: theme,
            child: const _SingleDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '多图切换',
            theme: theme,
            child: const _MultiDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '受控开关',
            theme: theme,
            child: const _ControlledDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义初始页',
            theme: theme,
            child: const _DefaultIndexDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '与其他组件组合（按钮入口）',
            theme: theme,
            child: const _ComboDemo(),
          ),
        ],
      ),
    );
  }
}

/// 区块卡片。
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

/// 缩略图。
Widget _thumb(String src, {double size = 120}) {
  return AntImage(
    src: src,
    width: size,
    height: size * 0.66,
    fit: BoxFit.cover,
  );
}

/// 单图预览。
class _SingleDemo extends StatefulWidget {
  const _SingleDemo();

  @override
  State<_SingleDemo> createState() => _SingleDemoState();
}

class _SingleDemoState extends State<_SingleDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.w,
      children: [
        GestureDetector(
          onTap: () => setState(() => _open = true),
          child: _thumb(kDemoImages[0]),
        ),
        AntImageViewer(
          images: [kDemoImages[0]],
          open: _open,
          onClose: () => setState(() => _open = false),
          afterClose: () {},
        ),
      ],
    );
  }
}

/// 多图切换。
class _MultiDemo extends StatefulWidget {
  const _MultiDemo();

  @override
  State<_MultiDemo> createState() => _MultiDemoState();
}

class _MultiDemoState extends State<_MultiDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: [
            for (final src in kDemoImages)
              GestureDetector(
                onTap: () => setState(() => _open = true),
                child: _thumb(src),
              ),
          ],
        ),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

/// 受控开关：文字按钮切换。
class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntButton(
          type: AntButtonType.primary,
          child: Text(_open ? '关闭预览' : '打开预览'),
          onTap: () => setState(() => _open = !_open),
        ),
        SizedBox(height: 8.w),
        Text(
          '当前状态：${_open ? '已打开' : '已关闭'}',
          style: TextStyle(fontSize: 14.sp, color: theme.colorTextSecondary),
        ),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

/// 自定义初始页：从第 2 张开始。
class _DefaultIndexDemo extends StatefulWidget {
  const _DefaultIndexDemo();

  @override
  State<_DefaultIndexDemo> createState() => _DefaultIndexDemoState();
}

class _DefaultIndexDemoState extends State<_DefaultIndexDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntButton(
          child: const Text('从第 2 张开始预览'),
          onTap: () => setState(() => _open = true),
        ),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          defaultIndex: 1,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

/// 组合入口：AntImage 缩略图 + AntImageViewer 全屏。
class _ComboDemo extends StatefulWidget {
  const _ComboDemo();

  @override
  State<_ComboDemo> createState() => _ComboDemoState();
}

class _ComboDemoState extends State<_ComboDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.w,
          children: [
            AntImage(
              src: kDemoImages[1],
              width: 180,
              height: 120,
              preview: false,
            ),
          ],
        ),
        SizedBox(height: 8.w),
        AntButton(
          type: AntButtonType.dashed,
          child: const Text('查看大图'),
          onTap: () => setState(() => _open = true),
        ),
        AntImageViewer(
          images: kDemoImages,
          open: _open,
          maxZoomRatio: 5,
          enableCompositeZoom: true,
          onClose: () => setState(() => _open = false),
        ),
      ],
    );
  }
}
