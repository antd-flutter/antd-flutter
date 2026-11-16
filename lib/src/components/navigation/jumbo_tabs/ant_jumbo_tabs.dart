/// AntJumboTabs — antd-mobile JumboTabs 大选项卡的 Flutter 实现
///
/// API 与 antd-mobile JumboTabs 对齐：
/// - [items] — 选项卡项列表（含主标题 + 描述）
/// - [activeKey] — 受控激活项
/// - [defaultActiveKey] — 非受控默认激活项
/// - [onChange] — 切换回调
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_jumbo_tabs_types.dart';

// ============================================================
// AntJumboTabs
// ============================================================

/// 大选项卡 — 主标题 + 描述的大尺寸选项卡，常用于服务分类。
///
/// 对齐 antd-mobile JumboTabs 组件，每个选项卡含主标题与描述，
/// 激活项主标题高亮 + 底部指示条。
///
/// ```dart
/// AntJumboTabs(
///   items: [
///     AntJumboTabItem(key: 'a', title: '全部', description: '所有订单'),
///     AntJumboTabItem(key: 'b', title: '待付款', description: '等待付款'),
///   ],
///   onChange: (key) => print(key),
/// )
/// ```
class AntJumboTabs extends StatefulWidget {
  const AntJumboTabs({
    super.key,
    required this.items,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
  });

  /// 选项卡项列表。
  final List<AntJumboTabItem> items;

  /// 受控激活项 key。
  final String? activeKey;

  /// 非受控默认激活项 key。
  final String? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<String>? onChange;

  @override
  State<AntJumboTabs> createState() => _AntJumboTabsState();
}

class _AntJumboTabsState extends State<AntJumboTabs> {
  String? _internalKey;

  String? get _currentKey => widget.activeKey ?? _internalKey;

  @override
  void initState() {
    super.initState();
    _internalKey = widget.defaultActiveKey ?? widget.items.firstOrNull?.key;
  }

  void _handleTap(AntJumboTabItem item) {
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: t.colorBgContainer,
            border: Border(
              bottom: BorderSide(color: t.colorSplit, width: 0.5.w),
            ),
          ),
          child: Row(
            children: [
              for (final item in widget.items)
                Expanded(
                  child: _JumboItem(
                    item: item,
                    active: item.key == currentKey,
                    colorPrimary: t.colorPrimary,
                    colorText: t.colorText,
                    colorTextSecondary: t.colorTextSecondary,
                    colorTextDisabled: t.colorTextDisabled,
                    onTap: () => _handleTap(item),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 内部：单个大选项卡项
// ============================================================

class _JumboItem extends StatelessWidget {
  const _JumboItem({
    required this.item,
    required this.active,
    required this.colorPrimary,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextDisabled,
    required this.onTap,
  });

  final AntJumboTabItem item;
  final bool active;
  final Color colorPrimary;
  final Color colorText;
  final Color colorTextSecondary;
  final Color colorTextDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = item.disabled
        ? colorTextDisabled
        : (active ? colorPrimary : colorText);

    return GestureDetector(
      onTap: item.disabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.w, bottom: 8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.titleWidget != null)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: titleColor,
                    ),
                    child: item.titleWidget!,
                  )
                else
                  Text(
                    item.title ?? '',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: titleColor,
                    ),
                  ),
                if (item.description != null) ...[
                  SizedBox(height: 2.w),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: item.disabled
                          ? colorTextDisabled
                          : colorTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 底部指示条
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.w,
            width: active ? 20.w : 0,
            decoration: BoxDecoration(
              color: active ? colorPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
          SizedBox(height: 8.w),
        ],
      ),
    );
  }
}