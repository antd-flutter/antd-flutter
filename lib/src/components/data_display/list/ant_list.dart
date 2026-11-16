/// AntList — antd React List 的 Flutter 实现
///
/// API 与 antd React List 对齐：
/// - [dataSource] / [renderItem] — 数据源与条目构建（ListView.builder 懒加载）
/// - [header] / [footer] — 头部 / 底部
/// - [size] — 尺寸（默认 middle）
/// - [bordered] — 是否有边框
/// - [split] — 是否显示分割线
/// - [loading] — 加载态
/// - [pageSize] — 内部分页（可选）
/// - 空数据显示 [AntEmpty]
///
/// ```dart
/// AntList(
///   dataSource: ['条目一', '条目二'],
///   renderItem: (item) => AntListItem(content: Text(item)),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:antd_flutter_plus/src/components/data_display/empty/ant_empty.dart';
import 'package:antd_flutter_plus/src/components/data_display/list/ant_list_types.dart';
export 'package:antd_flutter_plus/src/components/data_display/list/ant_list_types.dart';
import 'package:flutter/material.dart';

// ============================================================
// AntListItem
// ============================================================

/// 列表条目 — 主内容 / 右侧 extra / 操作组。
class AntListItem extends StatelessWidget {
  const AntListItem({
    super.key,
    required this.content,
    this.extra,
    this.actions,
    this.onTap,
  });

  /// 主内容。
  final Widget content;

  /// 右侧附加内容。
  final Widget? extra;

  /// 操作组（底部横向排列）。
  final List<AntListAction>? actions;

  /// 条目点击回调。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    Widget mainRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: content),
        if (extra != null) ...[
          SizedBox(width: theme.marginSM),
          extra!,
        ],
      ],
    );

    if (onTap != null) {
      mainRow = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: mainRow,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: theme.paddingSM,
        horizontal: theme.padding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainRow,
          if (actions != null && actions!.isNotEmpty) ...[
            SizedBox(height: theme.marginXS),
            Row(
              children: [
                for (var i = 0; i < actions!.length; i++) ...[
                  if (i > 0) SizedBox(width: theme.marginLG),
                  GestureDetector(
                    onTap: actions![i].onTap,
                    behavior: HitTestBehavior.opaque,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: theme.fontSizeSM,
                        color: theme.colorPrimary,
                      ),
                      child: actions![i].child,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// AntList
// ============================================================

/// 列表 — 通用数据列表。
///
/// 对齐 antd React List 组件。
class AntList<T> extends StatefulWidget {
  const AntList({
    super.key,
    required this.dataSource,
    required this.renderItem,
    this.header,
    this.footer,
    this.size = AntListSize.middle,
    this.bordered = false,
    this.split = true,
    this.loading = false,
    this.pageSize,
    this.empty,
    this.itemKey,
  });

  /// 数据源。
  final List<T> dataSource;

  /// 条目构建函数。
  final AntListItem Function(T item, int index) renderItem;

  /// 头部。
  final Widget? header;

  /// 底部。
  final Widget? footer;

  /// 尺寸。
  final AntListSize size;

  /// 是否有边框。
  final bool bordered;

  /// 是否显示分割线。
  final bool split;

  /// 是否加载中。
  final bool loading;

  /// 每页条数（传值后启用内部分页，初始展示第一页）。
  final int? pageSize;

  /// 自定义空状态（默认 [AntEmpty]）。
  final Widget? empty;

  /// 条目 key 提取函数。
  final String Function(T item, int index)? itemKey;

  @override
  State<AntList<T>> createState() => _AntListState<T>();
}

class _AntListState<T> extends State<AntList<T>> {
  int _page = 1;

  bool get _hasPaging =>
      widget.pageSize != null && widget.pageSize! > 0 && widget.dataSource.length > widget.pageSize!;

  int get _pageCount => (widget.dataSource.length / widget.pageSize!).ceil();

  List<T> get _visibleItems {
    if (!_hasPaging) return widget.dataSource;
    final start = (_page - 1) * widget.pageSize!;
    final end = (start + widget.pageSize!).clamp(0, widget.dataSource.length);
    return widget.dataSource.sublist(start, end);
  }

  void _gotoPage(int page) {
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    if (widget.loading) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: theme.paddingLG),
        decoration: _outerDecoration(theme),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (widget.dataSource.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: theme.paddingLG),
        decoration: _outerDecoration(theme),
        child: widget.empty ?? const AntEmpty(),
      );
    }

    final items = _visibleItems;

    return Container(
      width: double.infinity,
      decoration: _outerDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.header != null) _buildBlock(theme, widget.header!, bottomBorder: widget.split),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final listItem = widget.renderItem(item, index);
                final key = widget.itemKey?.call(item, index) ?? '${index + (_page - 1) * (widget.pageSize ?? 0)}';
                return Container(
                  key: ValueKey<String>('list_item_$key'),
                  decoration: BoxDecoration(
                    border: widget.split && index < items.length - 1
                        ? Border(bottom: BorderSide(color: theme.colorSplit))
                        : null,
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(fontSize: _itemFontSize(theme)),
                    child: listItem,
                  ),
                );
              },
            ),
          ),
          if (widget.footer != null || _hasPaging)
            _buildFooter(theme),
        ],
      ),
    );
  }

  Widget _buildBlock(
    AntThemeData theme,
    Widget content, {
    required bool bottomBorder,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: theme.paddingSM,
        horizontal: theme.padding,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: bottomBorder
              ? BorderSide(color: theme.colorSplit)
              : BorderSide.none,
        ),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: theme.fontSizeLG,
          fontWeight: FontWeight.w500,
          color: theme.colorTextHeading,
        ),
        child: content,
      ),
    );
  }

  Widget _buildFooter(AntThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: theme.paddingSM,
        horizontal: theme.padding,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: widget.split
              ? BorderSide(color: theme.colorSplit)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.footer != null)
            DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: theme.fontSizeLG,
                fontWeight: FontWeight.w500,
                color: theme.colorTextHeading,
              ),
              child: widget.footer!,
            ),
          if (_hasPaging) ...[
            SizedBox(height: theme.marginXS),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var p = 1; p <= _pageCount; p++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: theme.marginXXS),
                    child: GestureDetector(
                      onTap: () => _gotoPage(p),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        key: ValueKey<String>('list_page_$p'),
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.paddingXS,
                          vertical: theme.paddingXXS,
                        ),
                        decoration: BoxDecoration(
                          color: p == _page ? theme.colorPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(theme.borderRadiusSM),
                        ),
                        child: Text(
                          '$p',
                          style: TextStyle(
                            fontSize: theme.fontSizeSM,
                            color: p == _page ? Colors.white : theme.colorText,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  double _itemFontSize(AntThemeData theme) {
    switch (widget.size) {
      case AntListSize.large:
        return theme.fontSizeLG;
      case AntListSize.small:
        return theme.fontSizeSM;
      case AntListSize.middle:
        return theme.fontSize;
    }
  }

  BoxDecoration _outerDecoration(AntThemeData theme) {
    return BoxDecoration(
      color: theme.colorBgContainer,
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      border: widget.bordered
          ? Border.all(color: theme.colorBorderSecondary, width: 1)
          : null,
    );
  }
}
