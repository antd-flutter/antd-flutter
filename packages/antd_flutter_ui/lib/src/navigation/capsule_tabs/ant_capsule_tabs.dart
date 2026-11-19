/// AntCapsuleTabs — antd-mobile CapsuleTabs 胶囊选项卡的 Flutter 实现
///
/// API 与 antd-mobile CapsuleTabs 对齐：
/// - [items] — 选项卡项列表
/// - [activeKey] — 受控激活项
/// - [defaultActiveKey] — 非受控默认激活项
/// - [onChange] — 切换回调
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_capsule_tabs_types.dart';

// ============================================================
// AntCapsuleTabs
// ============================================================

/// 胶囊选项卡 — 圆角胶囊形选项卡组，激活项白色凸起。
///
/// 对齐 antd-mobile CapsuleTabs 组件，整体灰色圆角容器，
/// 激活项白色背景 + 阴影，常用于筛选切换。
///
/// ```dart
/// AntCapsuleTabs(
///   items: [
///     AntCapsuleTabItem(key: 'a', title: '选项一'),
///     AntCapsuleTabItem(key: 'b', title: '选项二'),
///   ],
///   onChange: (key) => print(key),
/// )
/// ```
class AntCapsuleTabs extends StatefulWidget {
  const AntCapsuleTabs({
    super.key,
    required this.items,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
  });

  /// 选项卡项列表。
  final List<AntCapsuleTabItem> items;

  /// 受控激活项 key。
  final String? activeKey;

  /// 非受控默认激活项 key。
  final String? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<String>? onChange;

  @override
  State<AntCapsuleTabs> createState() => _AntCapsuleTabsState();
}

class _AntCapsuleTabsState extends State<AntCapsuleTabs> {
  String? _internalKey;

  String? get _currentKey => widget.activeKey ?? _internalKey;

  @override
  void initState() {
    super.initState();
    _internalKey = widget.defaultActiveKey ?? widget.items.firstOrNull?.key;
  }

  void _handleTap(AntCapsuleTabItem item) {
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
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: t.colorFillSecondary,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in widget.items)
            _CapsuleItem(
              item: item,
              active: item.key == currentKey,
              colorPrimary: t.colorPrimary,
              colorText: t.colorText,
              colorTextSecondary: t.colorTextSecondary,
              colorTextDisabled: t.colorTextDisabled,
              colorBgContainer: t.colorBgContainer,
              borderRadius: t.borderRadius,
              onTap: () => _handleTap(item),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// 内部：单个胶囊项
// ============================================================

class _CapsuleItem extends StatelessWidget {
  const _CapsuleItem({
    required this.item,
    required this.active,
    required this.colorPrimary,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextDisabled,
    required this.colorBgContainer,
    required this.borderRadius,
    required this.onTap,
  });

  final AntCapsuleTabItem item;
  final bool active;
  final Color colorPrimary;
  final Color colorText;
  final Color colorTextSecondary;
  final Color colorTextDisabled;
  final Color colorBgContainer;
  final double borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = item.disabled
        ? colorTextDisabled
        : (active ? colorPrimary : colorTextSecondary);

    return GestureDetector(
      onTap: item.disabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.w),
        decoration: BoxDecoration(
          color: active ? colorBgContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: item.titleWidget != null
            ? DefaultTextStyle(
                style: TextStyle(
                  fontSize: 13.sp,
                  color: textColor,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
                child: item.titleWidget!,
              )
            : Text(
                item.title ?? '',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: textColor,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
      ),
    );
  }
}