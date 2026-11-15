import 'package:flutter/widgets.dart';

import 'ant_theme_data.dart';

/// AntTheme 是一个 InheritedWidget，它将 [AntThemeData] 注入到 Widget 树中，
/// 让所有后代 Widget 都能通过 [AntTheme.of] 获取当前主题数据。
///
/// ```dart
/// AntTheme(
///   data: AntThemeData.light(),
///   child: MaterialApp(...),
/// )
/// ```
class AntTheme extends InheritedWidget {
  /// 当前主题数据
  final AntThemeData data;

  /// 创建一个 AntTheme
  const AntTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// 获取最近祖先 [AntTheme] 中的主题数据。
  ///
  /// 如果没有找到 AntTheme 祖先，返回默认的亮色主题 [AntThemeData.light]。
  static AntThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AntTheme>();
    return widget?.data ?? AntThemeData.light();
  }

  @override
  bool updateShouldNotify(AntTheme oldWidget) => data != oldWidget.data;
}

/// 一个便捷的 Builder，在 build 时提供 [AntThemeData]。
///
/// ```dart
/// AntThemeBuilder(builder: (context, theme) {
///   return Text('Hello', style: theme.font.body1);
/// })
/// ```
class AntThemeBuilder extends StatelessWidget {
  /// 构建回调
  final Widget Function(BuildContext context, AntThemeData theme) builder;

  const AntThemeBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, AntTheme.of(context));
  }
}