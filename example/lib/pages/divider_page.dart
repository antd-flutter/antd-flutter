/// Divider 分割线演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class DividerPage extends StatelessWidget {
  const DividerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '默认水平实线分割'),
          _BasicDemo(),
          _Section(title: '带标题', description: 'child 作为标题，orientation 控制位置'),
          _TitleDemo(),
          _Section(title: '标题位置', description: 'orientation: left / center / right'),
          _OrientationDemo(),
          _Section(title: '标题边距', description: 'orientationMargin 设置标题与边缘距离'),
          _MarginDemo(),
          _Section(title: '垂直分割', description: 'type: vertical，用于行内分隔'),
          _VerticalDemo(),
          _Section(title: '虚线', description: 'variant: dashed 或 dashed: true'),
          _DashedDemo(),
          _Section(title: '点线', description: 'variant: dotted'),
          _DottedDemo(),
          _Section(title: '普通文本标题', description: 'plain: true，文字更小更淡'),
          _PlainDemo(),
          _Section(title: '自定义样式', description: 'color / thickness / spacing / indent'),
          _CustomDemo(),
        ],
      ),
    );
  }
}

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
    return const Column(
      children: [
        Text('段落一：春眠不觉晓，处处闻啼鸟。'),
        AntDivider(),
        Text('段落二：夜来风雨声，花落知多少。'),
      ],
    );
  }
}

class _TitleDemo extends StatelessWidget {
  const _TitleDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('内容区域'),
        AntDivider(child: Text('标题文本')),
        Text('内容区域'),
      ],
    );
  }
}

class _OrientationDemo extends StatelessWidget {
  const _OrientationDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AntDivider(
          orientation: AntDividerOrientation.left,
          child: Text('左侧标题'),
        ),
        AntDivider(
          orientation: AntDividerOrientation.center,
          child: Text('中间标题'),
        ),
        AntDivider(
          orientation: AntDividerOrientation.right,
          child: Text('右侧标题'),
        ),
      ],
    );
  }
}

class _MarginDemo extends StatelessWidget {
  const _MarginDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AntDivider(
          orientation: AntDividerOrientation.left,
          orientationMargin: 48,
          child: Text('左边距 48'),
        ),
        AntDivider(
          orientation: AntDividerOrientation.right,
          orientationMargin: 48,
          child: Text('右边距 48'),
        ),
      ],
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) {
    return const AntRow(
      children: [
        Text('文本一'),
        AntDivider(type: AntDividerType.vertical),
        Text('链接一'),
        AntDivider(type: AntDividerType.vertical),
        Text('链接二'),
      ],
    );
  }
}

class _DashedDemo extends StatelessWidget {
  const _DashedDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('段落一'),
        AntDivider(
          variant: AntDividerVariant.dashed,
          child: Text('虚线标题'),
        ),
        Text('段落二'),
        AntDivider(dashed: true),
        Text('段落三'),
      ],
    );
  }
}

class _DottedDemo extends StatelessWidget {
  const _DottedDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('段落一'),
        AntDivider(
          variant: AntDividerVariant.dotted,
          child: Text('点线标题'),
        ),
        Text('段落二'),
      ],
    );
  }
}

class _PlainDemo extends StatelessWidget {
  const _PlainDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('段落一'),
        AntDivider(plain: true, child: Text('普通标题')),
        Text('段落二'),
        AntDivider(child: Text('非普通标题')),
        Text('段落三'),
      ],
    );
  }
}

class _CustomDemo extends StatelessWidget {
  const _CustomDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('自定义颜色'),
        AntDivider(color: Colors.blue),
        Text('自定义粗细'),
        AntDivider(thickness: 3),
        Text('自定义间距'),
        AntDivider(spacing: 48),
        Text('缩进'),
        AntDivider(indent: 32, endIndent: 32),
      ],
    );
  }
}