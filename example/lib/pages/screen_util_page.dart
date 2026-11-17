library;

/// ScreenUtil 桌面缩放演示页
///
/// 展示 AntScreenUtilInit 桌面最大宽度上限与等比放大配置：
/// - 实时显示当前窗口宽度与生效的缩放因子
///   （AntResponsive.scaleFactor，由 AntScreenUtilInit 上报）
/// - 通过开关 / 滑块模拟 allowScaleUp / maxWidth / maxScaleFactor 配置，
///   按 AntScreenUtilInit.resolveDesktopScale 实时预览当前窗口下的因子
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

class ScreenUtilPage extends StatelessWidget {
  const ScreenUtilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorBgLayout,
      appBar: AppBar(
        backgroundColor: theme.colorBgContainer,
        title: Text(
          'ScreenUtil 桌面缩放',
          style: TextStyle(color: theme.colorTextHeading),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== 实际生效因子（全局上报） ====================
          _LiveFactorCard(theme: theme),
          const SizedBox(height: 16),

          // ==================== 配置模拟器 ====================
          const _ConfigSimulator(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ============================================================
// 实际生效因子：读取 AntResponsive.scaleFactor（细粒度 aspect 订阅）
// ============================================================

class _LiveFactorCard extends StatelessWidget {
  final AntThemeData theme;

  const _LiveFactorCard({required this.theme});

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
            '当前生效缩放因子（AntScreenUtilInit 全局配置上报）',
            style: TextStyle(
              color: theme.colorTextHeading,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Metric(
                theme: theme,
                label: '窗口宽度',
                value: '${data.width.toStringAsFixed(0)} px',
              ),
              const SizedBox(width: 24),
              _Metric(
                theme: theme,
                label: '缩放因子',
                value: data.scaleFactor.toStringAsFixed(3),
                highlight: data.scaleFactor > 1,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'app 入口未开启放大（默认 allowScaleUp: false），因子恒为 1；'
            '下方模拟器可预览放大配置的效果。',
            style: TextStyle(
              color: theme.colorTextSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final AntThemeData theme;
  final String label;
  final String value;
  final bool highlight;

  const _Metric({
    required this.theme,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: theme.colorTextSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight ? theme.colorPrimary : theme.colorTextHeading,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 配置模拟器：开关 + 滑块实时预览因子计算
// ============================================================

class _ConfigSimulator extends StatefulWidget {
  const _ConfigSimulator();

  @override
  State<_ConfigSimulator> createState() => _ConfigSimulatorState();
}

class _ConfigSimulatorState extends State<_ConfigSimulator> {
  bool _allowScaleUp = false;
  double _maxWidth = 1920;
  double _maxScaleFactor = 1.5;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    // 与 AntScreenUtilInit.resolveDesktopScale 相同语义的实时预览。
    final windowWidth = AntResponsive.widthOf(context);
    final factor = _allowScaleUp && windowWidth > _maxWidth
        ? (windowWidth / _maxWidth).clamp(1.0, _maxScaleFactor)
        : 1.0;

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
            '放大配置模拟器（当前窗口宽度 ${windowWidth.toStringAsFixed(0)} px）',
            style: TextStyle(
              color: theme.colorTextHeading,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '预览因子：${factor.toStringAsFixed(3)}',
            style: TextStyle(
              color: factor > 1 ? theme.colorPrimary : theme.colorTextHeading,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('allowScaleUp 允许超宽放大',
                style: TextStyle(
                    color: theme.colorTextHeading, fontSize: 14)),
            value: _allowScaleUp,
            onChanged: (v) => setState(() => _allowScaleUp = v),
          ),
          _Slider(
            theme: theme,
            label: 'maxWidth 基准宽度上限：${_maxWidth.toStringAsFixed(0)} px',
            min: 768,
            max: 3840,
            value: _maxWidth,
            onChanged: (v) => setState(() => _maxWidth = v),
          ),
          _Slider(
            theme: theme,
            label: 'maxScaleFactor 放大倍率封顶：${_maxScaleFactor.toStringAsFixed(1)}',
            min: 1.0,
            max: 3.0,
            value: _maxScaleFactor,
            onChanged: (v) => setState(() => _maxScaleFactor = v),
          ),
          const SizedBox(height: 8),
          Text(
            '拖宽窗口超过 maxWidth 后，开启 allowScaleUp 即可看到因子 > 1；'
            '继续拖宽至倍率超过封顶值后不再放大。',
            style: TextStyle(color: theme.colorTextSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Slider extends StatelessWidget {
  final AntThemeData theme;
  final String label;
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  const _Slider({
    required this.theme,
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: theme.colorTextHeading, fontSize: 14)),
        Slider(
          min: min,
          max: max,
          value: value.clamp(min, max),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
