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
/// AntTabBar(
///   items: [
///     AntTabBarItem(key: 'home', title: '首页', icon: Icons.home),
///     AntTabBarItem(key: 'me', title: '我的', icon: Icons.person),
///   ],
///   onChange: (key) => print(key),
/// )
/// ```
class AntTabBar extends StatefulWidget {
  const AntTabBar({
    super.key,
    required this.items,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
    this.border = true,
    this.safeArea = false,
  });

  /// 标签项列表。
  final List<AntTabBarItem> items;

  /// 受控激活项 key。
  final String? activeKey;

  /// 非受控默认激活项 key。
  final String? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<String>? onChange;

  /// 是否显示顶部边框。
  final bool border;

  /// 是否适配底部安全区。
  final bool safeArea;

  @override
  State<AntTabBar> createState() => _AntTabBarState();
}

class _AntTabBarState extends State<AntTabBar> {
  String? _internalKey;

  /// 当前激活 key（受控优先）。
  String? get _currentKey => widget.activeKey ?? _internalKey;

  @override
  void initState() {
    super.initState();
    _internalKey = widget.defaultActiveKey ?? widget.items.firstOrNull?.key;
  }

  void _handleTap(String key) {
    if (key == _currentKey) return;
    if (widget.activeKey == null) {
      setState(() => _internalKey = key);
    }
    widget.onChange?.call(key);
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
              for (final item in widget.items)
                Expanded(
                  child: _TabItem(
                    item: item,
                    active: item.key == currentKey,
                    colorPrimary: t.colorPrimary,
                    colorTextSecondary: t.colorTextSecondary,
                    onTap: () => _handleTap(item.key),
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
    required this.item,
    required this.active,
    required this.colorPrimary,
    required this.colorTextSecondary,
    required this.onTap,
  });

  final AntTabBarItem item;
  final bool active;
  final Color colorPrimary;
  final Color colorTextSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? colorPrimary : colorTextSecondary;
    final icon = active ? (item.activeIcon ?? item.icon) : item.icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 22.sp, color: color),
                if (item.badgeDot)
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
                if (item.badgeText != null)
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
                        item.badgeText!,
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
          if (icon != null) SizedBox(height: 2.w),
          if (item.titleWidget != null)
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 10.sp,
                color: color,
              ),
              child: item.titleWidget!,
            )
          else if (item.title != null)
            Text(
              item.title!,
              style: TextStyle(fontSize: 10.sp, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}