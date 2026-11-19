/// AntCollapse — antd React Collapse 的 Flutter 实现
///
/// API 与 antd React Collapse 对齐：
/// - [items] — 面板列表
/// - [accordion] — 手风琴模式
/// - [activeKey] / [defaultActiveKey] — 受控 / 默认展开 key
/// - [onChange] — 展开状态变化回调
/// - [expandIconPosition] — 箭头位置
/// - [expandIcon] — 自定义箭头
/// - [bordered] — 无边框变体（bordered: false）
/// - [size] — 尺寸
///
/// ```dart
/// AntCollapse(items: [AntCollapsePanel(label: '标题', child: Text('内容'))])
/// AntCollapse(accordion: true, items: [...])
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/collapse/ant_collapse_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/collapse/ant_collapse_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntCollapse
// ============================================================

/// 折叠面板 — 内容分组折叠展示。
///
/// 对齐 antd React Collapse 组件。
class AntCollapse extends StatefulWidget {
  const AntCollapse({
    super.key,
    required this.items,
    this.accordion = false,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
    this.expandIconPosition = AntCollapseExpandIconPosition.left,
    this.expandIcon,
    this.bordered = true,
    this.size = AntCollapseSize.middle,
  });

  /// 面板列表。
  final List<AntCollapsePanel> items;

  /// 手风琴模式（同时只展开一个面板）。
  final bool accordion;

  /// 受控展开 key 集合（accordion 模式下最多一个）。
  final List<String>? activeKey;

  /// 默认展开 key 集合。
  final List<String>? defaultActiveKey;

  /// 展开状态变化回调。
  final ValueChanged<List<String>>? onChange;

  /// 箭头位置。
  final AntCollapseExpandIconPosition expandIconPosition;

  /// 自定义箭头构建（isExpanded 表示当前是否展开）。
  final Widget Function(BuildContext context, bool isExpanded)? expandIcon;

  /// 是否有边框（false 为无边框变体 borderless）。
  final bool bordered;

  /// 尺寸。
  final AntCollapseSize size;

  @override
  State<AntCollapse> createState() => _AntCollapseState();
}

class _AntCollapseState extends State<AntCollapse> {
  late Set<String> _expandedKeys;

  bool get _isControlled => widget.activeKey != null;

  @override
  void initState() {
    super.initState();
    _expandedKeys = _initialKeys();
  }

  @override
  void didUpdateWidget(covariant AntCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled) {
      _expandedKeys = widget.activeKey!.toSet();
    }
  }

  Set<String> _initialKeys() {
    if (_isControlled) return widget.activeKey!.toSet();
    final keys = widget.defaultActiveKey?.toSet() ?? <String>{};
    if (widget.accordion && keys.length > 1) {
      return {keys.first};
    }
    return keys;
  }

  String _panelKey(AntCollapsePanel panel, int index) =>
      panel.key ?? 'panel_$index';

  void _toggle(String key) {
    if (_isControlled) {
      // 受控模式：只回调，不改变内部状态
      widget.onChange?.call(_expandedKeys.toList());
      return;
    }
    setState(() {
      if (_expandedKeys.contains(key)) {
        _expandedKeys.remove(key);
      } else {
        if (widget.accordion) {
          _expandedKeys..clear()..add(key);
        } else {
          _expandedKeys.add(key);
        }
      }
    });
    widget.onChange?.call(_expandedKeys.toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final paddings = _resolvePaddings(theme);

    final outerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      border: widget.bordered
          ? Border.all(color: theme.colorBorderSecondary, width: 1)
          : null,
    );

    return DecoratedBox(
      decoration: outerDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.items.length; i++)
            _buildPanel(context, theme, widget.items[i], i, paddings, i > 0),
        ],
      ),
    );
  }

  ({double vertical, double horizontal}) _resolvePaddings(
    AntThemeData theme,
  ) {
    switch (widget.size) {
      case AntCollapseSize.large:
        return (vertical: theme.paddingMD, horizontal: theme.padding);
      case AntCollapseSize.small:
        return (vertical: theme.paddingSM, horizontal: theme.paddingSM);
      case AntCollapseSize.middle:
        return (vertical: theme.paddingSM + 2, horizontal: theme.padding);
    }
  }

  Widget _buildPanel(
    BuildContext context,
    AntThemeData theme,
    AntCollapsePanel panel,
    int index,
    ({double vertical, double horizontal}) paddings,
    bool showTopBorder,
  ) {
    final key = _panelKey(panel, index);
    final expanded = _expandedKeys.contains(key);
    final isRight =
        widget.expandIconPosition == AntCollapseExpandIconPosition.right;

    final icon = widget.expandIcon?.call(context, expanded) ??
        AnimatedRotation(
          turns: expanded ? 0.25 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 12.w,
            color: panel.disabled
                ? theme.colorTextDisabled
                : theme.colorTextSecondary,
          ),
        );

    Widget headerRow = Row(
      children: [
        if (!isRight) ...[
          icon,
          SizedBox(width: theme.marginXS),
        ],
        Expanded(
          child: Text(
            panel.label,
            style: TextStyle(
              fontSize: theme.fontSize,
              fontWeight: FontWeight.w500,
              color: panel.disabled
                  ? theme.colorTextDisabled
                  : theme.colorTextHeading,
            ),
          ),
        ),
        if (panel.extra != null) ...[
          SizedBox(width: theme.marginXS),
          panel.extra!,
        ],
        if (isRight) ...[
          SizedBox(width: theme.marginXS),
          icon,
        ],
      ],
    );

    if (!panel.disabled) {
      headerRow = GestureDetector(
        onTap: () => _toggle(key),
        behavior: HitTestBehavior.opaque,
        child: headerRow,
      );
    }

    // 内容懒加载：首次展开或 forceRender 时才挂载
    final shouldRenderContent = panel.forceRender || expanded;

    return Container(
      key: ValueKey<String>('collapse_item_$key'),
      decoration: BoxDecoration(
        border: showTopBorder
            ? Border(
                top: BorderSide(color: theme.colorBorderSecondary, width: 1),
              )
            : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: paddings.vertical,
              horizontal: paddings.horizontal,
            ),
            child: headerRow,
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: shouldRenderContent
                  ? Align(
                      heightFactor: expanded ? 1 : 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: paddings.horizontal,
                          right: paddings.horizontal,
                          bottom: paddings.vertical,
                        ),
                        child: panel.child,
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
