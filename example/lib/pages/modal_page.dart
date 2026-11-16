import 'package:antd_flutter_plus/antd_flutter_plus.dart';
/// AntModal 对话框演示页
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class ModalPage extends StatelessWidget {
  const ModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法（受控 open）',
            theme: theme,
            child: const _BasicModalDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '确认风格 showAntModal',
            theme: theme,
            child: AntButton(
              type: AntButtonType.primary,
              onTap: () async {
                final ok = await showAntModal(
                  context,
                  title: '删除确认',
                  content: const Text('确定要删除这条记录吗？此操作不可撤销。'),
                );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok == true ? '已确认删除' : '已取消')),
                );
              },
              child: const Text('打开确认对话框'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'confirmLoading 加载态',
            theme: theme,
            child: const _LoadingModalDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义 footer',
            theme: theme,
            child: const _CustomFooterModalDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '遮罩与关闭配置',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () {
                showAntModal(
                  context,
                      title: '点击遮罩不关闭',
                      content: const Text('maskClosable = false'),
                  maskClosable: false,
                );
              },
                  child: const Text('遮罩不可关闭'),
                ),
                AntButton(
                  onTap: () {
                showAntModal(
                  context,
                      title: '无右上角关闭',
                      content: const Text('closable = false'),
                  closable: false,
                );
              },
                  child: const Text('无关闭图标'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '宽度配置',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              children: [
                AntButton(
                  onTap: () {
                showAntModal(
                  context,
                      title: '窄对话框',
                      content: const Text('width = 260'),
                  width: 260,
                );
              },
                  child: const Text('width 260'),
                ),
                AntButton(
                  onTap: () {
                showAntModal(
                  context,
                      title: '宽对话框',
                      content: const Text('width = 420'),
                  width: 420,
                );
              },
                  child: const Text('width 420'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '居中',
            theme: theme,
            child: AntButton(
              onTap: () {
                showAntModal(
                  context,
                  title: '垂直居中',
                  content: const Text('centered = true'),
                  centered: true,
                );
              },
              child: const Text('居中对话框'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 基础用法（受控 open）
// ============================================================

class _BasicModalDemo extends StatefulWidget {
  const _BasicModalDemo();

  @override
  State<_BasicModalDemo> createState() => _BasicModalDemoState();
}

class _BasicModalDemoState extends State<_BasicModalDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntButton(
          type: AntButtonType.primary,
          onTap: () => setState(() => _open = true),
          child: const Text('打开对话框'),
        ),
        // AntModal 挂载在页面内，浮层通过 Overlay 渲染。
        AntModal(
          open: _open,
          title: '基础对话框',
          content: const Text('这是一段对话框内容，点击确认或取消关闭。'),
          onOk: () => setState(() => _open = false),
          onCancel: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

// ============================================================
// confirmLoading 加载态
// ============================================================

class _LoadingModalDemo extends StatefulWidget {
  const _LoadingModalDemo();

  @override
  State<_LoadingModalDemo> createState() => _LoadingModalDemoState();
}

class _LoadingModalDemoState extends State<_LoadingModalDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntButton(
          onTap: () => setState(() => _open = true),
          child: const Text('提交（2 秒 loading）'),
        ),
        AntModal(
          open: _open,
          title: '确认提交',
          content: const Text('点击确认后按钮进入加载态。'),
          okText: '提交',
          confirmLoading: _open,
          onOk: () {
            Future<void>.delayed(const Duration(seconds: 2), () {
              if (mounted) setState(() => _open = false);
            });
          },
          onCancel: () => setState(() => _open = false),
        ),
      ],
    );
  }
}

// ============================================================
// 自定义 footer
// ============================================================

class _CustomFooterModalDemo extends StatefulWidget {
  const _CustomFooterModalDemo();

  @override
  State<_CustomFooterModalDemo> createState() => _CustomFooterModalDemoState();
}

class _CustomFooterModalDemoState extends State<_CustomFooterModalDemo> {
  bool _open = false;
  bool _open2 = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      children: [
        AntButton(
          onTap: () => setState(() => _open = true),
          child: const Text('自定义底部按钮'),
        ),
        AntModal(
          open: _open,
          title: '自定义 footer',
          content: const Text('底部按钮由 footer 自定义。'),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AntButton(
                onTap: () => setState(() => _open = false),
                child: const Text('我知道了'),
              ),
            ],
          ),
        ),
      SizedBox(height: 8.w),
      AntButton(
        onTap: () => setState(() => _open2 = true),
        child: const Text('隐藏底部（footer=null）'),
      ),
      AntModal(
        open: _open2,
        title: '无底部',
        content: const Text('footer 传 null 隐藏整个底部。'),
        footer: null,
        closable: true,
      ),
      ],
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
