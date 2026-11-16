/// AntPagination — antd React Pagination 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [current] — 当前页码（受控）
/// - [defaultCurrent] — 初始页码（非受控，默认 1）
/// - [total] — 总条数
/// - [pageSize] — 每页条数（受控）
/// - [defaultPageSize] — 初始每页条数（非受控，默认 10）
/// - [showSizeChanger] — 是否显示每页条数切换器
/// - [showQuickJumper] — 是否显示快速跳转输入框
/// - [showTotal] — 是否显示总条数
/// - [simple] — 简单模式
/// - [disabled] — 禁用
/// - [pageSizeOptions] — 每页条数选项
/// - [onChange] — 页码改变回调
/// - [onPageSizeChange] — 每页条数改变回调
library;

import 'dart:math' as math;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ant_pagination_types.dart';

// ============================================================
// AntPagination
// ============================================================

/// 分页 — 采用分页的形式分隔长列表，每次只加载一个页面。
///
/// 对齐 antd React Pagination 组件，支持受控/非受控页码、
/// 每页条数切换、快速跳转、总条数显示和简单模式。
///
/// ```dart
/// AntPagination(
///   total: 100,
///   onChange: (page) => print('page: $page'),
/// )
/// ```
class AntPagination extends StatefulWidget {
  const AntPagination({
    super.key,
    this.current,
    this.defaultCurrent = 1,
    this.total = 0,
    this.pageSize,
    this.defaultPageSize = 10,
    this.showSizeChanger = false,
    this.showQuickJumper = false,
    this.showTotal = false,
    this.simple = false,
    this.disabled = false,
    this.size = AntPaginationSize.normal,
    this.pageSizeOptions = const [10, 20, 50, 100],
    this.onChange,
    this.onPageSizeChange,
  });

  /// 当前页码（受控）。设置后由外部控制页码。
  final int? current;

  /// 初始页码（非受控）。默认 1。
  final int defaultCurrent;

  /// 总条数。
  final int total;

  /// 每页条数（受控）。设置后由外部控制每页条数。
  final int? pageSize;

  /// 初始每页条数（非受控）。默认 10。
  final int defaultPageSize;

  /// 是否显示每页条数切换器。
  final bool showSizeChanger;

  /// 是否显示快速跳转输入框。
  final bool showQuickJumper;

  /// 是否显示总条数。
  final bool showTotal;

  /// 简单模式。只显示前后按钮和当前页/总页数。
  final bool simple;

  /// 是否禁用。
  final bool disabled;

  /// 尺寸。normal 为默认尺寸，small 为小尺寸。
  final AntPaginationSize size;

  /// 每页条数选项。
  final List<int> pageSizeOptions;

  /// 页码改变回调。
  final ValueChanged<int>? onChange;

  /// 每页条数改变回调。
  final ValueChanged<int>? onPageSizeChange;

  @override
  State<AntPagination> createState() => _AntPaginationState();
}

class _AntPaginationState extends State<AntPagination> {
  int _internalCurrent = 1;
  int _internalPageSize = 10;
  final TextEditingController _jumperController = TextEditingController();
  final FocusNode _jumperFocus = FocusNode();

  int get _currentPage =>
      widget.current ?? _internalCurrent;

  int get _currentPageSize =>
      widget.pageSize ?? _internalPageSize;

  int get _totalPages =>
      math.max(1, (widget.total / _currentPageSize).ceil());

  double get _buttonSize =>
      widget.size == AntPaginationSize.small ? 24 : 32;

  bool get _canPrev =>
      !widget.disabled && _currentPage > 1;

  bool get _canNext =>
      !widget.disabled && _currentPage < _totalPages;

  void _goto(int page) {
    final clamped = page.clamp(1, _totalPages);
    if (clamped == _currentPage) return;
    if (widget.current == null) {
      setState(() => _internalCurrent = clamped);
    }
    widget.onChange?.call(clamped);
  }

  void _changePageSize(int size) {
    if (size == _currentPageSize) return;
    if (widget.pageSize == null) {
      setState(() {
        _internalPageSize = size;
        // 调整页码使当前页不超出范围
        _internalCurrent = _internalCurrent.clamp(1, math.max(1, (widget.total / size).ceil()));
      });
    }
    widget.onPageSizeChange?.call(size);
  }

  @override
  void initState() {
    super.initState();
    _internalCurrent = widget.defaultCurrent;
    _internalPageSize = widget.defaultPageSize;
  }

  @override
  void dispose() {
    _jumperController.dispose();
    _jumperFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    if (widget.simple) {
      return _buildSimple(theme);
    }
    return _buildNormal(theme);
  }

  // ------------------------------------------------------------
  // 简单模式
  // ------------------------------------------------------------

  Widget _buildSimple(AntThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavButton(theme, Icons.chevron_left, _canPrev, () => _goto(_currentPage - 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$_currentPage/$_totalPages',
            style: TextStyle(fontSize: theme.fontSize, color: theme.colorText),
          ),
        ),
        _buildNavButton(theme, Icons.chevron_right, _canNext, () => _goto(_currentPage + 1)),
      ],
    );
  }

  // ------------------------------------------------------------
  // 标准模式
  // ------------------------------------------------------------

  Widget _buildNormal(AntThemeData theme) {
    final children = <Widget>[];

    if (widget.showTotal) {
      children.add(_buildTotalText(theme));
      children.add(const SizedBox(width: 16));
    }

    children.add(
      _buildNavButton(theme, Icons.chevron_left, _canPrev, () => _goto(_currentPage - 1)),
    );

    final pages = _generatePages(_currentPage, _totalPages);
    for (final page in pages) {
      if (page < 0) {
        children.add(_buildEllipsis(theme, page));
      } else {
        children.add(_buildPageButton(theme, page));
      }
    }

    children.add(
      _buildNavButton(theme, Icons.chevron_right, _canNext, () => _goto(_currentPage + 1)),
    );

    if (widget.showSizeChanger) {
      children.add(const SizedBox(width: 8));
      children.add(_buildSizeChanger(theme));
    }

    if (widget.showQuickJumper) {
      children.add(const SizedBox(width: 16));
      children.add(_buildQuickJumper(theme));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  Widget _buildTotalText(AntThemeData theme) {
    return Text(
      '共 ${widget.total} 条',
      style: TextStyle(fontSize: theme.fontSize, color: theme.colorTextSecondary),
    );
  }

  Widget _buildNavButton(
    AntThemeData theme,
    IconData icon,
    bool enabled,
    VoidCallback onTap,
  ) {
    return _buildButtonContainer(
      theme: theme,
      enabled: enabled,
      onTap: onTap,
      child: Icon(
        icon,
        size: theme.fontSizeIcon,
        color: enabled ? theme.colorTextSecondary : theme.colorTextDisabled,
      ),
    );
  }

  Widget _buildPageButton(AntThemeData theme, int page) {
    final isCurrent = page == _currentPage;
    return _buildButtonContainer(
      theme: theme,
      enabled: !widget.disabled && !isCurrent,
      onTap: () => _goto(page),
      background: isCurrent ? theme.colorPrimary : Colors.transparent,
      child: Text(
        '$page',
        style: TextStyle(
          fontSize: theme.fontSize,
          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
          color: widget.disabled
              ? theme.colorTextDisabled
              : (isCurrent ? Colors.white : theme.colorTextSecondary),
        ),
      ),
    );
  }

  Widget _buildEllipsis(AntThemeData theme, int marker) {
    final jump = marker == -1 ? -5 : 5;
    return _buildButtonContainer(
      theme: theme,
      enabled: !widget.disabled,
      onTap: () => _goto((_currentPage + jump).clamp(1, _totalPages)),
      child: Icon(
        Icons.more_horiz,
        size: theme.fontSizeIcon,
        color: widget.disabled
            ? theme.colorTextDisabled
            : theme.colorTextSecondary,
      ),
    );
  }

  Widget _buildButtonContainer({
    required AntThemeData theme,
    required bool enabled,
    required VoidCallback onTap,
    required Widget child,
    Color background = Colors.transparent,
  }) {
    final size = _buttonSize;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildSizeChanger(AntThemeData theme) {
    // 确保当前 pageSize 在选项中
    final options = List<int>.from(widget.pageSizeOptions);
    if (!options.contains(_currentPageSize)) {
      options.add(_currentPageSize);
      options.sort();
    }

    return Container(
      height: _buttonSize,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorBorder),
        borderRadius: BorderRadius.circular(theme.borderRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _currentPageSize,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: theme.fontSizeIcon,
            color: theme.colorTextTertiary,
          ),
          style: TextStyle(fontSize: theme.fontSize, color: theme.colorText),
          items: options
              .map((size) => DropdownMenuItem(
                    value: size,
                    child: Text('$size 条/页'),
                  ))
              .toList(),
          onChanged: widget.disabled
              ? null
              : (value) {
                  if (value != null) _changePageSize(value);
                },
        ),
      ),
    );
  }

  Widget _buildQuickJumper(AntThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '跳至',
          style: TextStyle(fontSize: theme.fontSize, color: theme.colorTextSecondary),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          height: _buttonSize,
          child: TextField(
            controller: _jumperController,
            focusNode: _jumperFocus,
            enabled: !widget.disabled,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(fontSize: theme.fontSize, color: theme.colorText),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.borderRadius),
                borderSide: BorderSide(color: theme.colorBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.borderRadius),
                borderSide: BorderSide(color: theme.colorBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.borderRadius),
                borderSide: BorderSide(color: theme.colorPrimary),
              ),
            ),
            onSubmitted: (value) {
              final page = int.tryParse(value);
              if (page != null) _goto(page);
              _jumperController.clear();
              _jumperFocus.unfocus();
            },
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '页',
          style: TextStyle(fontSize: theme.fontSize, color: theme.colorTextSecondary),
        ),
      ],
    );
  }

  /// 生成页码列表。负值表示省略号（-1 左侧，-2 右侧）。
  List<int> _generatePages(int current, int totalPages) {
    if (totalPages <= 7) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final pages = <int>[1];

    if (current > 4) {
      pages.add(-1); // 左省略号
    }

    final start = math.max(2, current - 2);
    final end = math.min(totalPages - 1, current + 2);
    for (var i = start; i <= end; i++) {
      pages.add(i);
    }

    if (current < totalPages - 3) {
      pages.add(-2); // 右省略号
    }

    pages.add(totalPages);
    return pages;
  }
}