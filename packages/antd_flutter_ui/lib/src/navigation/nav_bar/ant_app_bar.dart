library;

import 'package:material_ui/material_ui.dart';

import 'ant_nav_bar.dart';

/// Ant Design 风格的 AppBar 别名（内部委托 [AntNavBar]）。
///
/// Flutter 生态习惯把顶部导航栏叫 `AppBar`，此组件提供同样的命名与
/// `title/leading/actions` 参数形态，便于从 Material `AppBar` 迁移；
/// 尺寸、边框与主题仍由 AntNavBar / AntTheme 决定。
///
/// ```dart
/// AntAppBar(
///   title: const Text('标题'),
///   actions: [
///     IconButton(onPressed: onSearch, icon: const Icon(Icons.search)),
///   ],
/// )
/// ```
class AntAppBar extends StatelessWidget {
  const AntAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.onBack,
    this.border = true,
  });

  /// 标题，居中展示；为空时仅显示左右操作区。
  final Widget? title;

  /// 左侧自定义内容；传入后不再显示默认返回箭头。
  final Widget? leading;

  /// 右侧操作区，按顺序横向排列。
  final List<Widget>? actions;

  /// 未显式提供 [leading] 时，若当前路由可返回则自动显示返回箭头。
  final bool automaticallyImplyLeading;

  /// 点击返回箭头回调；缺省为 `Navigator.maybePop`。
  final VoidCallback? onBack;

  /// 是否显示底部边框。
  final bool border;

  @override
  Widget build(BuildContext context) {
    final canPop =
        automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false);
    final showBack = leading == null && canPop;

    return AntNavBar(
      border: border,
      back: showBack,
      onBack: onBack ??
          () {
            final navigator = Navigator.maybeOf(context);
            if (navigator != null && navigator.canPop()) {
              navigator.maybePop();
            }
          },
      left: leading,
      right: actions == null || actions!.isEmpty
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
      child: title ?? const SizedBox.shrink(),
    );
  }
}

/// 兼容命名：`AntdAppBar` 与 [AntAppBar] 等价。
typedef AntdAppBar = AntAppBar;
