import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

/// AntDrawer 演示页
class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool _rightOpen = false;
  bool _leftOpen = false;
  bool _topOpen = false;
  bool _bottomOpen = false;
  bool _footerOpen = false;
  bool _noMaskOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return AntScreenUtilInit(
      builder: (context, _) => SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: '右侧基础用法',
              theme: theme,
              child: AntButton(
                onTap: () => setState(() => _rightOpen = true),
                child: const Text('Open Drawer'),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '左侧滑入',
              theme: theme,
              child: AntButton(
                onTap: () => setState(() => _leftOpen = true),
                child: const Text('左侧打开'),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '顶部滑入',
              theme: theme,
              child: AntButton(
                onTap: () => setState(() => _topOpen = true),
                child: const Text('顶部打开'),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '底部滑入',
              theme: theme,
              child: AntButton(
                onTap: () => setState(() => _bottomOpen = true),
                child: const Text('底部打开'),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '带底部操作区',
              theme: theme,
              child: AntButton(
                onTap: () => setState(() => _footerOpen = true),
                child: const Text('带 Footer'),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '遮罩配置（无遮罩 + 不可点遮罩关闭）',
              theme: theme,
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.w,
                children: [
                  AntButton(
                    onTap: () => setState(() => _noMaskOpen = true),
                    child: const Text('无遮罩抽屉'),
                  ),
                  AntButton(
                    onTap: () => _showFixedMaskDrawer(context),
                    child: const Text('遮罩不可关闭'),
                  ),
                ],
              ),
            ),
            _buildDrawers(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawers() {
    return Stack(
      children: [
        AntDrawer(
          open: _rightOpen,
          title: const Text('Basic Drawer'),
          onClose: () => setState(() => _rightOpen = false),
          child: const Text('右侧抽屉内容，超出高度可滚动。'),
        ),
        AntDrawer(
          open: _leftOpen,
          placement: AntDrawerPlacement.left,
          title: const Text('左侧抽屉'),
          onClose: () => setState(() => _leftOpen = false),
          child: const Text('左侧滑入的抽屉内容。'),
        ),
        AntDrawer(
          open: _topOpen,
          placement: AntDrawerPlacement.top,
          height: 240,
          title: const Text('顶部抽屉'),
          onClose: () => setState(() => _topOpen = false),
          child: const Text('顶部滑入的抽屉内容。'),
        ),
        AntDrawer(
          open: _bottomOpen,
          placement: AntDrawerPlacement.bottom,
          height: 240,
          title: const Text('底部抽屉'),
          onClose: () => setState(() => _bottomOpen = false),
          child: const Text('底部滑入的抽屉内容。'),
        ),
        AntDrawer(
          open: _footerOpen,
          title: const Text('带 Footer 抽屉'),
          onClose: () => setState(() => _footerOpen = false),
          footer: Wrap(
            spacing: 8.w,
            children: [
              AntButton(
                onTap: () => setState(() => _footerOpen = false),
                child: const Text('取消'),
              ),
              AntButton(
                type: AntButtonType.primary,
                onTap: () => setState(() => _footerOpen = false),
                child: const Text('提交'),
              ),
            ],
          ),
          child: const Text('带底部操作区的抽屉内容。'),
        ),
        AntDrawer(
          open: _noMaskOpen,
          mask: false,
          title: const Text('无遮罩抽屉'),
          onClose: () => setState(() => _noMaskOpen = false),
          child: const Text('没有遮罩的抽屉，页面仍可交互。'),
        ),
      ],
    );
  }

  void _showFixedMaskDrawer(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) => Stack(
        children: [
          AntDrawer(
            open: true,
            maskClosable: false,
            title: const Text('遮罩不可关闭'),
            onClose: () => Navigator.of(dialogContext).pop(),
            child: const Text('点击遮罩不会关闭，请使用右上角关闭按钮。'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorTextHeading,
          ),
        ),
        SizedBox(height: 8.w),
        child,
      ],
    );
  }
}
