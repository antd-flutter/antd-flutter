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
/// AntJumboTabs<Category>(
///   items: categories,
///   keyOf: (category) => category.id,
///   titleBuilder: (context, category, index) => Text(category.name),
///   descriptionBuilder: (context, category, index) => Text(category.desc),
/// )
/// ```
class AntJumboTabs<T> extends StatefulWidget {
  const AntJumboTabs({
    super.key,
    required this.items,
    this.keyOf,
    this.titleBuilder,
    this.descriptionBuilder,
    this.disabledOf,
    this.activeKey,
    this.defaultActiveKey,
    this.onChange,
  });

  /// 选项卡项列表。
  final List<T> items;

  /// 提取唯一标识，默认使用下标。
  final Object Function(T item)? keyOf;

  /// 主标题构建器，未提供时回退为 `Text('$item')`。
  final AntJumboTabsTitleBuilder<T>? titleBuilder;

  /// 描述构建器，返回 null 时不展示描述。
  final AntJumboTabsDescriptionBuilder<T>? descriptionBuilder;

  /// 是否禁用某项。
  final bool Function(T item)? disabledOf;

  /// 受控激活项 key。
  final Object? activeKey;

  /// 非受控默认激活项 key。
  final Object? defaultActiveKey;

  /// 切换回调。
  final ValueChanged<T>? onChange;

  @override
  State<AntJumboTabs<T>> createState() => _AntJumboTabsState<T>();
}

class _AntJumboTabsState<T> extends State<AntJumboTabs<T>> {
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
    final disabled = widget.disabledOf?.call(item) ?? false;
    if (disabled || _keyAt(index) == _currentKey) return;
    if (widget.activeKey == null) {
      setState(() => _internalKey = _keyAt(index));
    }
    widget.onChange?.call(item);
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
              bottom: BorderSide(color: t.colorSplit, width: t.s(0.5)),
            ),
          ),
          child: Row(
            children: [
              for (var i = 0; i < widget.items.length; i++)
                Expanded(
                  child: _JumboItem(
                    title: widget.titleBuilder
                            ?.call(context, widget.items[i], i) ??
                        Text('${widget.items[i]}'),
                    description: widget.descriptionBuilder
                        ?.call(context, widget.items[i], i),
                    active: _keyAt(i) == currentKey,
                    disabled: widget.disabledOf?.call(widget.items[i]) ?? false,
                    colorPrimary: t.colorPrimary,
                    colorText: t.colorText,
                    colorTextSecondary: t.colorTextSecondary,
                    colorTextDisabled: t.colorTextDisabled,
                    colorTextLightSolid: t.colorTextLightSolid,
                    colorFillContent: t.colorFillContent,
                    onTap: () => _handleTap(widget.items[i], i),
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
    required this.title,
    required this.description,
    required this.active,
    required this.disabled,
    required this.colorPrimary,
    required this.colorText,
    required this.colorTextSecondary,
    required this.colorTextDisabled,
    required this.colorTextLightSolid,
    required this.colorFillContent,
    required this.onTap,
  });

  final Widget title;
  final Widget? description;
  final bool active;
  final bool disabled;
  final Color colorPrimary;
  final Color colorText;
  final Color colorTextSecondary;
  final Color colorTextDisabled;
  final Color colorTextLightSolid;
  final Color colorFillContent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final titleColor =
        disabled ? colorTextDisabled : (active ? colorPrimary : colorText);
    final descriptionColor = disabled
        ? colorTextDisabled
        : (active ? colorTextLightSolid : colorTextSecondary);
    final descriptionBackground =
        active && !disabled ? colorPrimary : colorFillContent;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: t.s(12), bottom: t.s(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: t.s(17),
                    // antd-mobile 标题行高 24px
                    height: 24 / 17,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    color: titleColor,
                  ),
                  child: title,
                ),
                if (description != null) ...[
                  SizedBox(height: t.s(2)),
                  // antd-mobile：描述是胶囊标签（底 10px、水平内边距 8px），
                  // 激活时变主色底白字；自定义节点同样套用该胶囊底。
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: t.s(8)),
                    decoration: BoxDecoration(
                      color: descriptionBackground,
                      borderRadius: BorderRadius.circular(t.s(10)),
                    ),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: t.s(13),
                        color: descriptionColor,
                      ),
                      child: description!,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 底部指示条
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: t.s(2),
            width: active ? t.s(20) : 0,
            decoration: BoxDecoration(
              color: active ? colorPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(t.s(1)),
            ),
          ),
          SizedBox(height: t.s(8)),
        ],
      ),
    );
  }
}
