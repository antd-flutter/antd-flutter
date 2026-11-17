library;

/// Responsive 响应式演示页
///
/// 展示 AntResponsive 布局信息实时值（宽度/断点/设备类型/方向/平台/折叠态），
/// 并验证细粒度 aspect 订阅：两个局部组件分别只依赖不同 aspect，
/// 仅在各自 aspect 变化时 rebuild。
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorBgLayout,
      appBar: AppBar(
        backgroundColor: theme.colorBgContainer,
        title: Text(
          'Responsive 响应式',
          style: TextStyle(color: theme.colorTextHeading),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== 整体快照 ====================
          _InfoCard(theme: theme),
          const SizedBox(height: 16),

          // ==================== 细粒度订阅验证 ====================
          Text(
            '细粒度 aspect 订阅（仅对应 aspect 变化时 rebuild）',
            style: TextStyle(
              color: theme.colorTextSecondary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _BreakpointOnlyPanel()),
              SizedBox(width: 12),
              Expanded(child: _PlatformOnlyPanel()),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ============================================================
// 整体布局快照（AntResponsive.of — 任一字段变化刷新）
// ============================================================

class _InfoCard extends StatelessWidget {
  final AntThemeData theme;

  const _InfoCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    final data = AntResponsive.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AntLayoutData 快照（AntResponsive.of）',
            style: TextStyle(
              color: theme.colorTextHeading,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _row('width', data.width.toStringAsFixed(1), theme),
          _row('breakpoint', data.breakpoint?.name ?? '< xs（<480）', theme),
          _row('deviceType', data.deviceType.name, theme),
          _row(
            'orientation',
            data.orientation == AntOrientation.portrait
                ? 'portrait'
                : 'landscape',
            theme,
          ),
          _row('foldState', data.foldState.name, theme),
          _row('targetPlatform', data.targetPlatform.name, theme),
          _row('isOhos', '${data.isOhos}', theme),
          _row('isDesktop', '${data.isDesktop}', theme),
        ],
      ),
    );
  }

  Widget _row(String label, String value, AntThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: theme.colorTextTertiary,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: theme.colorText,
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 仅依赖断点 aspect 的局部组件
// ============================================================

class _BreakpointOnlyPanel extends StatelessWidget {
  const _BreakpointOnlyPanel();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final bp = AntResponsive.breakpointOf(context);
    final data = AntResponsive.of(context);

    return _Panel(
      theme: theme,
      title: '仅订阅 breakpoint',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: AntBreakpoint.values.map((b) {
              final active = bp != null && bp >= b;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: active
                      ? theme.colorPrimaryBg
                      : theme.colorFillQuaternary,
                  borderRadius: BorderRadius.circular(theme.borderRadiusXS.r),
                  border: Border.all(
                    color: active
                        ? theme.colorPrimaryBorder
                        : theme.colorBorderSecondary,
                  ),
                ),
                child: Text(
                  b.name,
                  style: TextStyle(
                    color: active
                        ? theme.colorPrimaryText
                        : theme.colorTextTertiary,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            '当前: ${bp?.name ?? "无"}（width ${data.width.toStringAsFixed(0)}）',
            style: TextStyle(
              color: theme.colorTextSecondary,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            '断点变化（≥480 边界跨越）才 rebuild',
            style: TextStyle(color: theme.colorTextQuaternary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 仅依赖平台 aspect 的局部组件
// ============================================================

class _PlatformOnlyPanel extends StatelessWidget {
  const _PlatformOnlyPanel();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final platform = AntResponsive.platformOf(context);
    final data = AntResponsive.of(context);

    return _Panel(
      theme: theme,
      title: '仅订阅 platform',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'targetPlatform: ${platform.name}',
            style: TextStyle(
              color: theme.colorText,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'isOhos: ${data.isOhos}  isDesktop: ${data.isDesktop}',
            style: TextStyle(
              color: theme.colorText,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '平台信息变化（运行中不变）才 rebuild',
            style: TextStyle(color: theme.colorTextQuaternary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final AntThemeData theme;
  final String title;
  final Widget child;

  const _Panel({required this.theme, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadius.r),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.colorTextHeading,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
