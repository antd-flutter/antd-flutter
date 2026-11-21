/// AntSideBar — antd-mobile SideBar 侧边导航栏的 Flutter 实现
///
/// API 与 antd-mobile SideBar 对齐：
/// - [items] — 导航项列表
/// - [activeKey] — 受控激活项
/// - [defaultActiveKey] — 非受控默认激活项
/// - [onChange] — 切换回调
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_side_bar_types.dart';

// ============================================================
// AntSideBar
// ============================================================

/// 侧边导航栏 — 垂直排列的导航菜单，常用于分类筛选。
///
/// 对齐 antd-mobile SideBar 组件，激活项左侧有高亮条，
/// 白色背景 + colorPrimary 文字；非激活项灰色背景。
///
/// ```dart
/// AntSideBar<Category>(
///   items: categories,
///   keyOf: (category) => category.id,
///   titleBuilder: (context, category, index) => Text(category.name),
/// )
/// ```
class AntSideBar<T> extends StatefulWidget {
  const AntSideBar({
    super.key,
    required this.items,
    this.keyOf,
    this.titleBuilder,
    this.badgeTextOf,
    this.badgeDotOf,
    this.disabledOf,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
  });

  /// 导航项列表。
  final List<T> items;

  /// 提取唯一标识，默认使用下标。
  final Object Function(T item)? keyOf;

  /// 标题构建器，未提供时回退为 `Text('$item')`。
  final AntSideBarTitleBuilder<T>? titleBuilder;

  /// 文字角标。
  final String? Function(T item)? badgeTextOf;

  /// 圆点角标。
  final bool Function(T item)? badgeDotOf;

  /// 是否禁用某项。
  final bool Function(T item)? disabledOf;

  /// 受控激活项 key。
  final Object? activeKey;

  /// 非受控默认激活项 key。
  final Object? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<T>? onChange;

  @override
  State<AntSideBar<T>> createState() => _AntSideBarState<T>();
}

class _AntSideBarState<T> extends State<AntSideBar<T>> {
  Object? _internalKey;

  Object? get _currentKey => widget.activeKey ?? _internalKey;

  Object _keyAt(int index) => widget.keyOf?.call(widget.items[index]) ?? index;

  @override
  void initState() {
    super.initState();
    _internalKey =
        widget.defaultActiveKey ?? (widget.items.isEmpty ? null : _keyAt(0));
  }

  void _handleTap(T item, int index) {
    if ((widget.disabledOf?.call(item) ?? false) ||
        _keyAt(index) == _currentKey) {
      return;
    }
    if (widget.activeKey == null) {
      setState(() => _internalKey = _keyAt(index));
    }
    widget.onChange?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final currentKey = _currentKey;

    return Container(
      color: t.colorBgLayout,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < widget.items.length; i++)
            _SideBarItem(
              title: widget.titleBuilder?.call(
                    context,
                    widget.items[i],
                    i,
                  ) ??
                  Text('${widget.items[i]}'),
              badgeText: widget.badgeTextOf?.call(widget.items[i]),
              badgeDot: widget.badgeDotOf?.call(widget.items[i]) ?? false,
              disabled: widget.disabledOf?.call(widget.items[i]) ?? false,
              active: _keyAt(i) == currentKey,
              colorPrimary: t.colorPrimary,
              colorText: t.colorText,
              colorTextSecondary: t.colorTextSecondary,
              colorTextDisabled: t.colorTextDisabled,
              colorError: t.colorError,
              colorBgContainer: t.colorBgContainer,
              colorBgLayout: t.colorBgLayout,
              onTap: () => _handleTap(widget.items[i], i),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// 内部：单个侧边导航项
// ============================================================

class _SideBarItem extends StatelessWidget {
  const _SideBarItem({
    required this.title,
    required this.badgeText,
    required this.badgeDot,
    required this.disabled,
    required this.active,
    required this.colorPrimary,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextDisabled,
    required this.colorError,
    required this.colorBgContainer,
    required this.colorBgLayout,
    required this.onTap,
  });

  final Widget title;
  final String? badgeText;
  final bool badgeDot;
  final bool disabled;
  final bool active;
  final Color colorPrimary;
  final Color colorText;
  final Color colorTextSecondary;
  final Color colorTextDisabled;
  final Color colorError;
  final Color colorBgContainer;
  final Color colorBgLayout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = disabled
        ? colorTextDisabled
        : (active ? colorPrimary : colorTextSecondary);
    final bgColor = active ? colorBgContainer : colorBgLayout;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 46.w,
        color: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            // 左侧高亮条
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3.w,
              height: active ? 16.w : 0,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: active ? colorPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textColor,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: title,
              ),
            ),
            if (badgeDot)
              // antd Badge 圆点：10×10、danger 色
              Container(
                width: 10.w,
                height: 10.w,
                margin: EdgeInsets.only(left: 6.w),
                decoration: BoxDecoration(
                  color: colorError,
                  shape: BoxShape.circle,
                ),
              ),
            if (badgeText != null)
              // antd Badge 文字角标：9px/行高 12、上下 1 左右 4 内边距，
              // 固定 14 高，不能随行高被拉满；宽度按内容自适应。
              Container(
                height: 14.w,
                margin: EdgeInsets.only(left: 6.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                constraints: BoxConstraints(minWidth: 14.w),
                decoration: BoxDecoration(
                  color: colorError,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    badgeText!,
                    textAlign: TextAlign.center,
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
      ),
    );
  }
}
