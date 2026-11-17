import 'package:flutter/material.dart';

import 'ant_material_bridge.dart';
import 'ant_theme_data.dart';

/// AntTheme 主题注入 Widget。
///
/// 职责：
/// 1. 通过 [AntThemeScope]（InheritedWidget）注入 [AntThemeData]，
///    后代通过 [AntTheme.of] 就近读取；
/// 2. 自动将 antd 主题转换为 Flutter [ThemeData] 并注入 [Theme]，
///    后代的 `Theme.of(context)` 即可取到 antd 派生的 Material 主题，
///    原生 Material 控件自动呈现 antd 风格（包裹即覆盖，无开关参数）。
///
/// ```dart
/// AntTheme(
///   data: AntThemeData.light(),
///   child: MaterialApp(theme: ..., home: ...),
/// )
/// ```
class AntTheme extends StatelessWidget {
  /// 当前主题数据
  final AntThemeData data;

  /// 子组件
  final Widget child;

  /// 创建一个 AntTheme
  const AntTheme({
    super.key,
    required this.data,
    required this.child,
  });

  /// 获取最近祖先 [AntTheme] 中的主题数据。
  ///
  /// 如果没有找到 AntTheme 祖先，返回默认的亮色主题 [AntThemeData.light]。
  static AntThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AntThemeScope>();
    return widget?.data ?? AntThemeData.light();
  }

  @override
  Widget build(BuildContext context) {
    return AntThemeScope(
      data: data,
      child: Theme(data: data.toThemeData(), child: child),
    );
  }
}

/// [AntTheme] 内部的 InheritedWidget，负责 [AntThemeData] 的就近读取与
/// 数据变更通知（data 不相等时通知依赖方重建）。
class AntThemeScope extends InheritedWidget {
  const AntThemeScope({
    super.key,
    required this.data,
    required super.child,
  });

  /// 当前主题数据
  final AntThemeData data;

  @override
  bool updateShouldNotify(AntThemeScope oldWidget) => data != oldWidget.data;
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
