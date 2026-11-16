import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class FloatingBubblePage extends StatelessWidget {
  const FloatingBubblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Section(
            title: '基础用法',
            child: SizedBox(
              height: 120,
              child: AntFloatingBubble(
                initialPos: Offset(100, 30),
                child: Icon(Icons.add),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(
            title: '三种拖拽轴向',
            child: Column(
              children: [
                _AxisDemo(
                  label: 'axis: x（仅水平）',
                  axis: AntFloatingBubbleAxis.x,
                ),
                SizedBox(height: 8),
                _AxisDemo(
                  label: 'axis: y（仅垂直）',
                  axis: AntFloatingBubbleAxis.y,
                ),
                SizedBox(height: 8),
                _AxisDemo(
                  label: 'axis: both（任意方向）',
                  axis: AntFloatingBubbleAxis.both,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(
            title: '带菜单',
            child: _MenuDemo(),
          ),
          SizedBox(height: 16.w),
          const _Section(
            title: '自定义图标',
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 90,
                  child: AntFloatingBubble(
                    initialPos: Offset(20, 10),
                    child: Icon(Icons.edit),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  height: 90,
                  child: AntFloatingBubble(
                    initialPos: Offset(20, 10),
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.chat_bubble_outline),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(
            title: '初始位置',
            child: SizedBox(
              height: 140,
              child: AntFloatingBubble(
                initialPos: Offset(220, 70),
                child: Icon(Icons.rocket_launch),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 区块：拖拽轴向演示
// ============================================================

class _AxisDemo extends StatelessWidget {
  const _AxisDemo({required this.label, required this.axis});

  final String label;
  final AntFloatingBubbleAxis axis;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: theme.fontSizeSM.sp,
            color: theme.colorTextSecondary,
          ),
        ),
        SizedBox(height: 4.w),
        Container(
          height: 80.w,
          decoration: BoxDecoration(
            color: theme.colorFillQuaternary,
            borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
          ),
          child: AntFloatingBubble(
            axis: axis,
            initialPos: const Offset(16, 16),
            child: const Icon(Icons.open_with),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 区块：菜单演示
// ============================================================

class _MenuDemo extends StatefulWidget {
  const _MenuDemo();

  @override
  State<_MenuDemo> createState() => _MenuDemoState();
}

class _MenuDemoState extends State<_MenuDemo> {
  String? _lastAction;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 160.w,
          decoration: BoxDecoration(
            color: theme.colorFillQuaternary,
            borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
          ),
          child: AntFloatingBubble(
            initialPos: Offset(120.w, 60),
            menu: [
              AntFloatingBubbleMenuAction(
                label: '新建',
                icon: const Icon(Icons.add),
                onClick: () => setState(() => _lastAction = '新建'),
              ),
              AntFloatingBubbleMenuAction(
                label: '搜索',
                icon: const Icon(Icons.search),
                onClick: () => setState(() => _lastAction = '搜索'),
              ),
              AntFloatingBubbleMenuAction(
                label: '设置',
                icon: const Icon(Icons.settings),
                onClick: () => setState(() => _lastAction = '设置'),
              ),
            ],
            child: const Icon(Icons.menu),
          ),
        ),
        if (_lastAction != null) ...[
          SizedBox(height: 8.w),
          Text(
            '最近操作：$_lastAction',
            style: TextStyle(
              fontSize: theme.fontSizeSM.sp,
              color: theme.colorTextSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// 区块容器（页面内私有）
// ============================================================

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
        border: Border.all(color: theme.colorBorderSecondary, width: theme.lineWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.fontSize.sp,
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
