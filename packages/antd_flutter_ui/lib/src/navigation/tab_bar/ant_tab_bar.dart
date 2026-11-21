/// AntTabBar — antd-mobile TabBar 底部标签栏的 Flutter 实现
///
/// API 与 antd-mobile TabBar 对齐：
/// - [items] — 标签项列表
/// - [activeKey] — 受控激活项
/// - [defaultActiveKey] — 非受控默认激活项
/// - [onChange] — 切换回调
/// - [border] — 顶部边框（默认 true）
/// - [safeArea] — 底部安全区适配（默认 false）
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_tab_bar_types.dart';

// ============================================================
// AntTabBar
// ============================================================

/// 底部标签栏 — 移动端页面底部 Tab 切换。
///
/// 对齐 antd-mobile TabBar 组件，图标 + 标题 + 角标，
/// 激活项高亮 colorPrimary，支持受控与非受控模式。
///
/// ```dart
/// AntTabBar<Tab>(
///   items: tabs,
///   keyOf: (tab) => tab.id,
///   titleBuilder: (context, tab, index) => Text(tab.label),
///   iconBuilder: (context, tab) => Icon(tab.icon),
/// )
/// ```
class AntTabBar<T> extends StatefulWidget {
  const AntTabBar({
    super.key,
    required this.items,
    this.keyOf,
    this.titleBuilder,
    this.iconBuilder,
    this.activeIconBuilder,
    this.badgeTextOf,
    this.badgeDotOf,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
    this.border = true,
    this.safeArea = false,
  });

  /// 标签项列表。
  final List<T> items;

  /// 提取唯一标识，默认使用下标。
  final Object Function(T item)? keyOf;

  /// 标题构建器，未提供时回退为 `Text('$item')`。
  final AntTabBarTitleBuilder<T>? titleBuilder;

  /// 图标构建器。
  final AntTabBarIconBuilder<T>? iconBuilder;

  /// 激活态图标构建器，未提供时复用普通图标。
  final AntTabBarActiveIconBuilder<T>? activeIconBuilder;

  /// 文字角标（如 '5'、'99+'）。
  final String? Function(T item)? badgeTextOf;

  /// 红点角标。
  final bool Function(T item)? badgeDotOf;

  /// 受控激活项 key。
  final Object? activeKey;

  /// 非受控默认激活项 key。
  final Object? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<T>? onChange;

  /// 是否显示顶部边框。
  final bool border;

  /// 是否适配底部安全区。
  final bool safeArea;

  @override
  State<AntTabBar<T>> createState() => _AntTabBarState<T>();
}

class _AntTabBarState<T> extends State<AntTabBar<T>> {
  Object? _internalKey;

  /// 当前激活 key（受控优先）。
  Object? get _currentKey => widget.activeKey ?? _internalKey;

  Object _keyAt(int index) => widget.keyOf?.call(widget.items[index]) ?? index;

  @override
  void initState() {
    super.initState();
    _internalKey =
        widget.defaultActiveKey ?? (widget.items.isEmpty ? null : _keyAt(0));
  }

  void _handleTap(T item, int index) {
    final key = _keyAt(index);
    if (key == _currentKey) return;
    if (widget.activeKey == null) {
      setState(() => _internalKey = key);
    }
    widget.onChange?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final currentKey = _currentKey;

    Widget bar = Container(
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        border: widget.border
            ? Border(top: BorderSide(color: t.colorSplit, width: 0.5.w))
            : null,
      ),
      child: SafeArea(
        top: false,
        bottom: widget.safeArea,
        child: SizedBox(
          height: 50.w,
          child: Row(
            children: [
              for (var i = 0; i < widget.items.length; i++)
                Expanded(
                  child: _TabItem(
                    title: widget.titleBuilder?.call(
                          context,
                          widget.items[i],
                          i,
                        ) ??
                        Text('${widget.items[i]}'),
                    icon: widget.iconBuilder?.call(context, widget.items[i]),
                    activeIcon: widget.activeIconBuilder
                        ?.call(context, widget.items[i]),
                    badgeText: widget.badgeTextOf?.call(widget.items[i]),
                    badgeDot: widget.badgeDotOf?.call(widget.items[i]) ?? false,
                    active: _keyAt(i) == currentKey,
                    colorPrimary: t.colorPrimary,
                    colorTextSecondary: t.colorTextSecondary,
                    onTap: () => _handleTap(widget.items[i], i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return bar;
  }
}

// ============================================================
// 内部：单个标签项
// ============================================================

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.badgeText,
    required this.badgeDot,
    required this.active,
    required this.colorPrimary,
    required this.colorTextSecondary,
    required this.onTap,
  });

  final Widget title;
  final Widget? icon;
  final Widget? activeIcon;
  final String? badgeText;
  final bool badgeDot;
  final bool active;
  final Color colorPrimary;
  final Color colorTextSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? colorPrimary : colorTextSecondary;
    final currentIcon = active ? (activeIcon ?? icon) : icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentIcon != null)
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconTheme.merge(
                  data: IconThemeData(size: 22.sp, color: color),
                  child: currentIcon,
                ),
                if (badgeDot)
                  Positioned(
                    right: -2.w,
                    top: -2.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (badgeText != null)
                  Positioned(
                    right: -8.w,
                    top: -6.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.w,
                      ),
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      constraints: BoxConstraints(minWidth: 14.w),
                      alignment: Alignment.center,
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          if (currentIcon != null) SizedBox(height: 2.w),
          DefaultTextStyle(
            style: TextStyle(fontSize: 10.sp, color: color),
            child: title,
          ),
        ],
      ),
    );
  }
}
