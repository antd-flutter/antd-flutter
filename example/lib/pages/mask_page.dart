library;

/// AntMask 背景遮罩演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class MaskPage extends StatefulWidget {
  const MaskPage({super.key});

  @override
  State<MaskPage> createState() => _MaskPageState();
}

class _MaskPageState extends State<MaskPage> {
  bool _basicVisible = false;
  double _basicOpacity = kAntMaskDefaultOpacity;
  Color _basicColor = kAntMaskDefaultColor;
  bool _contentVisible = false;
  bool _lightVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(
                title: '基础显隐 / 点击回调',
                theme: theme,
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.w,
                  children: [
                    AntButton(
                      onTap: () => setState(() {
                        _basicOpacity = kAntMaskDefaultOpacity;
                        _basicColor = kAntMaskDefaultColor;
                        _basicVisible = true;
                      }),
                      child: const Text('显示遮罩'),
                    ),
                    AntButton(
                      onTap: () => setState(() => _basicVisible = false),
                      child: const Text('隐藏遮罩'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.w),
              _Section(
                title: '自定义透明度',
                theme: theme,
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.w,
                  children: [
                    for (final value in <double>[0.3, 0.5, 0.8])
                      AntButton(
                        onTap: () => setState(() {
                          _basicOpacity = value;
                          _basicColor = kAntMaskDefaultColor;
                          _basicVisible = true;
                        }),
                        child: Text('透明度 $value'),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.w),
              _Section(
                title: '带内容组合（Loading）',
                theme: theme,
                child: AntButton(
                  onTap: () {
                    setState(() => _contentVisible = true);
                    Future<void>.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _contentVisible = false);
                    });
                  },
                  child: const Text('显示 Loading 遮罩（2 秒后关闭）'),
                ),
              ),
              SizedBox(height: 16.w),
              _Section(
                title: '深浅色遮罩',
                theme: theme,
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.w,
                  children: [
                    AntButton(
                      onTap: () => setState(() {
                        _basicOpacity = kAntMaskDefaultOpacity;
                        _basicColor = kAntMaskDefaultColor;
                        _basicVisible = true;
                      }),
                      child: const Text('深色遮罩'),
                    ),
                    AntButton(
                      onTap: () => setState(() {
                        _basicOpacity = kAntMaskDefaultOpacity;
                        _basicColor = Colors.white;
                        _basicVisible = true;
                      }),
                      child: const Text('浅色遮罩'),
                    ),
                    AntButton(
                      onTap: () => setState(() => _lightVisible = true),
                      child: const Text('独立浅色遮罩'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 基础 / 透明度 / 深浅色共用遮罩：点击关闭
        AntMask(
          visible: _basicVisible,
          opacity: _basicOpacity,
          color: _basicColor,
          onAction: () => setState(() => _basicVisible = false),
        ),
        // Loading 内容组合遮罩
        AntMask(
          visible: _contentVisible,
          destroyOnClose: true,
          onAction: () => setState(() => _contentVisible = false),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: theme.colorBgContainer,
                borderRadius: BorderRadius.circular(theme.borderRadiusLG),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AntSpin(),
                  SizedBox(height: 12.w),
                  Text(
                    '正在加载...',
                    style: TextStyle(fontSize: 14.sp, color: theme.colorText),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 独立浅色遮罩
        AntMask(
          visible: _lightVisible,
          opacity: 0.6,
          color: Colors.white,
          onAction: () => setState(() => _lightVisible = false),
          child: Center(
            child: Text(
              '浅色遮罩上层内容',
              style: TextStyle(fontSize: 16.sp, color: theme.colorText),
            ),
          ),
        ),
      ],
    );
  }
}

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
