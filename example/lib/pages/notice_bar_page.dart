/// NoticeBar 通告栏演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class NoticeBarPage extends StatelessWidget {
  const NoticeBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认 normal 颜色，超长文本自动横向滚动'),
          _BasicDemo(),
          _Section(title: '语义颜色', description: 'color: normal / alert / error / info / success'),
          _ColorDemo(),
          _Section(title: '可关闭', description: 'closeable: true，点击关闭按钮隐藏通告栏'),
          _CloseableDemo(),
          _Section(title: '多行展示', description: 'wrap: true，关闭滚动，文本自动换行'),
          _WrapDemo(),
          _Section(title: '自定义图标 + extra', description: '自定义左侧 icon 与右侧操作区'),
          _CustomDemo(),
          _Section(title: 'neutral 圆角', description: 'shape: neutral，4px 圆角'),
          _NeutralDemo(),
          _Section(title: 'rounded 胶囊', description: 'shape: rounded，胶囊形圆角'),
          _RoundedDemo(),
          _Section(title: '全边框', description: 'bordered: full，四周边框'),
          _FullBorderDemo(),
          _Section(title: '无边框', description: 'bordered: none，无任何边框'),
          _NoneBorderDemo(),
        ],
      ),
    );
  }
}

// ============================================================
// 演示区块
// ============================================================

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
            ),
        ],
      ),
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNoticeBar(
      content: '这是一段超长的通告内容，超出宽度后将自动开始横向滚动，'
          '滚动到末尾后会从右侧重新进入并循环播放。',
    );
  }
}

class _ColorDemo extends StatelessWidget {
  const _ColorDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AntNoticeBar(content: 'normal：默认颜色', color: AntNoticeBarColor.normal),
        SizedBox(height: 12),
        AntNoticeBar(content: 'alert：警告类通告', color: AntNoticeBarColor.alert),
        SizedBox(height: 12),
        AntNoticeBar(content: 'error：错误类通告', color: AntNoticeBarColor.error),
        SizedBox(height: 12),
        AntNoticeBar(content: 'info：信息类通告', color: AntNoticeBarColor.info),
        SizedBox(height: 12),
        AntNoticeBar(content: 'success：成功类通告', color: AntNoticeBarColor.success),
      ],
    );
  }
}

class _CloseableDemo extends StatelessWidget {
  const _CloseableDemo();

  @override
  Widget build(BuildContext context) {
    return AntNoticeBar(
      content: '这条通告可以关闭',
      closeable: true,
      onClose: () => _showSnackbar(context, '通告已关闭'),
    );
  }
}

class _WrapDemo extends StatelessWidget {
  const _WrapDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNoticeBar(
      content: '适用于当前页面内信息的通知，是一种较醒目的页面内通知方式。'
          '开启 wrap 后超长文本不再滚动，而是自动换行展示全部内容。',
      wrap: true,
    );
  }
}

class _CustomDemo extends StatelessWidget {
  const _CustomDemo();

  @override
  Widget build(BuildContext context) {
    return AntNoticeBar(
      content: '自定义图标与操作区',
      icon: const Icon(AntIcons.compassOutlined),
      extra: const Text('查看详情'),
      onClick: () => _showSnackbar(context, '点击了通告栏'),
    );
  }
}

class _NeutralDemo extends StatelessWidget {
  const _NeutralDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNoticeBar(
      content: 'neutral 圆角形状',
      shape: AntNoticeBarShape.neutral,
    );
  }
}

class _RoundedDemo extends StatelessWidget {
  const _RoundedDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNoticeBar(
      content: 'rounded 胶囊形状',
      shape: AntNoticeBarShape.rounded,
    );
  }
}

class _FullBorderDemo extends StatelessWidget {
  const _FullBorderDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNoticeBar(
      content: 'full 全边框模式',
      shape: AntNoticeBarShape.rectangular,
      bordered: AntNoticeBarBorder.full,
    );
  }
}

class _NoneBorderDemo extends StatelessWidget {
  const _NoneBorderDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNoticeBar(
      content: 'none 无边框模式',
      shape: AntNoticeBarShape.rectangular,
      bordered: AntNoticeBarBorder.none,
    );
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
  );
}