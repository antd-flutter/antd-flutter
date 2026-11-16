/// 组件展示页 — 根据 snakeName 路由到对应组件演示页
library;

import 'package:flutter/material.dart';

import 'button_page.dart';
import 'divider_page.dart';
import 'flex_page.dart';
import 'float_button_page.dart';
import 'icon_page.dart';
import 'notice_bar_page.dart';
import 'space_page.dart';
import 'typography_page.dart';

class ComponentPage extends StatelessWidget {
  const ComponentPage({super.key, required this.snakeName});

  /// 组件蛇形名（如 "button"），用于路由
  final String snakeName;

  @override
  Widget build(BuildContext context) {
    switch (snakeName) {
      case 'button':
        return const ButtonPage();
      case 'divider':
        return const DividerPage();
      case 'flex':
        return const FlexPage();
      case 'float_button':
        return const FloatButtonPage();
      case 'icon':
        return const IconPage();
      case 'notice_bar':
        return const NoticeBarPage();
      case 'space':
        return const SpacePage();
      case 'typography':
        return const TypographyPage();
      default:
        return _PlaceholderPage(snakeName: snakeName);
    }
  }
}

/// 未实现组件的占位页
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.snakeName});

  final String snakeName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: AntSpace(
        direction: AntSpaceDirection.vertical,
        align: AntSpaceAlign.center,
        size: const AntSpaceSize.middle(),
        children: [
          Icon(Icons.construction_outlined, size: 64, color: theme.colorScheme.outline),
          Text(snakeName, style: theme.textTheme.headlineSmall),
          Text('该组件正在开发中，敬请期待',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
        ],
      ),
    );
  }
}