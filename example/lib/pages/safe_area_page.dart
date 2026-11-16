library;

/// SafeArea 安全区演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SafeAreaPage extends StatelessWidget {
  const SafeAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '顶部占位', description: 'position=top，模拟刘海屏顶部安全区 44pt'),
          _TopPlaceholderDemo(),
          _Section(title: '底部占位', description: 'position=bottom，模拟底部指示条 34pt'),
          _BottomPlaceholderDemo(),
          _Section(title: '包装模式', description: 'child 不为 null 时包装子组件并添加安全区内边距'),
          _WrapDemo(),
          _Section(title: '键盘适配', description: 'maintainBottomViewPadding=true 时键盘弹出仍保持底部内边距'),
          _KeyboardDemo(),
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

/// 模拟安全区高度的容器
class _SimulatedDevice extends StatelessWidget {
  const _SimulatedDevice({
    required this.child,
    this.top = 0,
    this.bottom = 0,
  });

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: EdgeInsets.only(top: top, bottom: bottom),
          viewPadding: EdgeInsets.only(top: top, bottom: bottom),
        ),
        child: child,
      ),
    );
  }
}

class _TopPlaceholderDemo extends StatelessWidget {
  const _TopPlaceholderDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SimulatedDevice(
      top: 44,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: theme.colorScheme.primaryContainer,
            child: const AntSafeArea(position: AntSafeAreaPosition.top),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('顶部安全区占位 44pt', style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _BottomPlaceholderDemo extends StatelessWidget {
  const _BottomPlaceholderDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SimulatedDevice(
      bottom: 34,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('底部安全区占位 34pt', style: theme.textTheme.bodySmall),
          ),
          Container(
            color: theme.colorScheme.primaryContainer,
            child: const AntSafeArea(position: AntSafeAreaPosition.bottom),
          ),
        ],
      ),
    );
  }
}

class _WrapDemo extends StatelessWidget {
  const _WrapDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SimulatedDevice(
      top: 44,
      bottom: 34,
      child: Container(
        color: theme.colorScheme.primaryContainer,
        child: const AntSafeArea(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text('被 AntSafeArea 包装的内容，顶部和底部自动留出安全区'),
          ),
        ),
      ),
    );
  }
}

class _KeyboardDemo extends StatelessWidget {
  const _KeyboardDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SimulatedDevice(
      bottom: 34,
      child: Container(
        color: theme.colorScheme.primaryContainer,
        child: const AntSafeArea(
          position: AntSafeAreaPosition.bottom,
          maintainBottomViewPadding: true,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text('maintainBottomViewPadding=true\n键盘弹出时底部内边距保持不变'),
          ),
        ),
      ),
    );
  }
}