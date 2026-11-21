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
/// AntSideBar(
///   items: [
///     AntSideBarItem(key: 'a', title: '选项一'),
///     AntSideBarItem(key: 'b', title: '选项二'),
///   ],
///   onChange: (key) => print(key),
/// )
/// ```
class AntSideBar extends StatefulWidget {
  const AntSideBar({
    super.key,
    required this.items,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
  });

  /// 导航项列表。
  final List<AntSideBarItem> items;

  /// 受控激活项 key。
  final String? activeKey;

  /// 非受控默认激活项 key。
  final String? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<String>? onChange;

  @override
  State<AntSideBar> createState() => _AntSideBarState();
}

class _AntSideBarState extends State<AntSideBar> {
  String? _internalKey;

  String? get _currentKey => widget.activeKey ?? _internalKey;

  @override
  void initState() {
    super.initState();
    _internalKey = widget.defaultActiveKey ?? widget.items.firstOrNull?.key;
  }

  void _handleTap(AntSideBarItem item) {
    if (item.disabled || item.key == _currentKey) return;
    if (widget.activeKey == null) {
      setState(() => _internalKey = item.key);
    }
    widget.onChange?.call(item.key);
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
          for (final item in widget.items)
            _SideBarItem(
              item: item,
              active: item.key == currentKey,
              colorPrimary: t.colorPrimary,
              colorText: t.colorText,
              colorTextSecondary: t.colorTextSecondary,
              colorTextDisabled: t.colorTextDisabled,
              colorError: t.colorError,
              colorBgContainer: t.colorBgContainer,
              colorBgLayout: t.colorBgLayout,
              onTap: () => _handleTap(item),
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
    required this.item,
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

  final AntSideBarItem item;
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
    final textColor = item.disabled
        ? colorTextDisabled
        : (active ? colorPrimary : colorTextSecondary);
    final bgColor = active ? colorBgContainer : colorBgLayout;

    return GestureDetector(
      onTap: item.disabled ? null : onTap,
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
              child: item.titleWidget != null
                  ? DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                      child: item.titleWidget!,
                    )
                  : Text(
                      item.title ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (item.badgeDot)
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
            if (item.badgeText != null)
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
                    item.badgeText!,
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