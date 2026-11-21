import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

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
                child: AntdIcon(AntIcons.plusOutlined),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(
            title: '三种拖拽轴向',
            child: Column(
              children: [
                _AxisDemo(label: 'axis: x（仅水平）', axis: AntFloatingBubbleAxis.x),
                SizedBox(height: 8),
                _AxisDemo(label: 'axis: y（仅垂直）', axis: AntFloatingBubbleAxis.y),
                SizedBox(height: 8),
                _AxisDemo(
                  label: 'axis: both（任意方向）',
                  axis: AntFloatingBubbleAxis.both,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          const _Section(title: '带菜单', child: _MenuDemo()),
          SizedBox(height: 16.w),
          const _Section(title: '边缘吸附（拖拽松手自动贴边）', child: _AutoSnapDemo()),
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
                    child: AntdIcon(AntIcons.editOutlined),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  height: 90,
                  child: AntFloatingBubble(
                    initialPos: Offset(20, 10),
                    backgroundColor: Colors.teal,
                    child: AntdIcon(AntIcons.messageOutlined),
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
                child: AntdIcon(AntIcons.rocketOutlined),
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
        AntText(
          text: label,
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
            child: const AntdIcon(AntIcons.dragOutlined),
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
                icon: const AntdIcon(AntIcons.plusOutlined),
                onClick: () => setState(() => _lastAction = '新建'),
              ),
              AntFloatingBubbleMenuAction(
                label: '搜索',
                icon: const AntdIcon(AntIcons.searchOutlined),
                onClick: () => setState(() => _lastAction = '搜索'),
              ),
              AntFloatingBubbleMenuAction(
                label: '设置',
                icon: const AntdIcon(AntIcons.settingOutlined),
                onClick: () => setState(() => _lastAction = '设置'),
              ),
            ],
            child: const AntdIcon(AntIcons.menuOutlined),
          ),
        ),
        if (_lastAction != null) ...[
          SizedBox(height: 8.w),
          AntText(
            text: '最近操作：$_lastAction',
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
// 区块：边缘吸附演示（autoSnapToEdge + Controller 手动吸附）
// ============================================================

class _AutoSnapDemo extends StatefulWidget {
  const _AutoSnapDemo();

  @override
  State<_AutoSnapDemo> createState() => _AutoSnapDemoState();
}

class _AutoSnapDemoState extends State<_AutoSnapDemo> {
  final AntFloatingBubbleController _controller = AntFloatingBubbleController();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(
          text: '左：拖拽松手自动吸附最近左/右边缘（autoSnapToEdge）；右：拖拽后点按钮手动吸附',
          style: TextStyle(
            fontSize: theme.fontSizeSM.sp,
            color: theme.colorTextSecondary,
          ),
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 180.w,
                decoration: BoxDecoration(
                  color: theme.colorFillQuaternary,
                  borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
                ),
                child: const AntFloatingBubble(
                  initialPos: Offset(100, 120),
                  autoSnapToEdge: true,
                  child: AntdIcon(AntIcons.dragOutlined),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                height: 180.w,
                decoration: BoxDecoration(
                  color: theme.colorFillQuaternary,
                  borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
                ),
                child: Stack(
                  children: [
                    AntFloatingBubble(
                      controller: _controller,
                      initialPos: const Offset(100, 120),
                      child: const AntdIcon(AntIcons.dragOutlined),
                    ),
                    Positioned(
                      left: 8.w,
                      bottom: 8.w,
                      child: OutlinedButton(
                        onPressed: () => _controller.snapToNearestEdge(),
                        child: const AntText(text: '吸附边缘'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        border: Border.all(
          color: theme.colorBorderSecondary,
          width: theme.lineWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(
            text: title,
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
