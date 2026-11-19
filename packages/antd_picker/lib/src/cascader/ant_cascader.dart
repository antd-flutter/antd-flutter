/// AntCascader — antd React Cascader 的 Flutter 实现
///
/// API 与 antd React Cascader 对齐：
/// - [options] — 级联选项树
/// - [value] / [defaultValue] — 受控/非受控值（路径数组）
/// - [onChange] — 值变化回调
/// - [placeholder] / [disabled] / [allowClear] / [size]
/// - [changeOnSelect] — 允许选择任意层级
/// - [expandTrigger] — click / hover 展开子菜单
///
/// ```dart
/// AntCascader(
///   options: [
///     AntCascaderOption(value: 'zj', label: '浙江', children: [
///       AntCascaderOption(value: 'hz', label: '杭州', children: [
///         AntCascaderOption(value: 'xh', label: '西湖'),
///       ]),
///     ]),
///   ],
///   onChange: (path) => print(path),
/// )
/// ```
library;

import 'ant_cascader_types.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

export 'ant_cascader_types.dart';

// ============================================================
// AntCascader
// ============================================================

/// 级联选择组件。
///
/// 从一组关联层级数据中进行选择，如省/市/区。
class AntCascader extends StatefulWidget {
  const AntCascader({
    super.key,
    this.options = const [],
    this.value,
    this.defaultValue,
    this.onChange,
    this.placeholder,
    this.disabled = false,
    this.allowClear = false,
    this.changeOnSelect = false,
    this.size = AntCascaderSize.middle,
    this.expandTrigger = AntCascaderExpandTrigger.click,
  });

  /// 级联选项树
  final List<AntCascaderOption> options;

  /// 受控值（路径数组，如 ['zj', 'hz', 'xh']）
  final List<String>? value;

  /// 非受控默认值
  final List<String>? defaultValue;

  /// 值变化回调
  final ValueChanged<List<String>>? onChange;

  /// 占位文本
  final String? placeholder;

  /// 是否禁用
  final bool disabled;

  /// 是否显示清除按钮
  final bool allowClear;

  /// 允许选择任意层级（否则仅叶子节点触发 onChange）
  final bool changeOnSelect;

  /// 尺寸
  final AntCascaderSize size;

  /// 次级菜单展开触发方式
  final AntCascaderExpandTrigger expandTrigger;

  @override
  State<AntCascader> createState() => _AntCascaderState();
}

class _AntCascaderState extends State<AntCascader>
    with PopupContentRefresher<AntCascader> {
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _open = false;

  /// 当前展开的路径（选中项列表，用于面板高亮与展开）
  List<AntCascaderOption> _activePath = [];

  /// 已确认选中的路径（用于触发器显示）
  List<String>? _internalValue;

  List<String> get _currentValue => widget.value ?? _internalValue ?? [];

  double get _height {
    switch (widget.size) {
      case AntCascaderSize.large:
        return 40;
      case AntCascaderSize.small:
        return 24;
      case AntCascaderSize.middle:
        return 32;
    }
  }

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
    _syncActivePath();
  }

  @override
  void didUpdateWidget(covariant AntCascader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _syncActivePath();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  /// 根据当前值同步 _activePath
  void _syncActivePath() {
    final path = _currentValue;
    if (path.isEmpty) {
      _activePath = [];
      return;
    }
    _activePath = _findPathByValue(path) ?? [];
  }

  /// 根据值路径查找选项路径
  List<AntCascaderOption>? _findPathByValue(List<String> values) {
    List<AntCascaderOption>? search(
      List<AntCascaderOption> options,
      int depth,
    ) {
      if (depth >= values.length) return [];
      for (final opt in options) {
        if (opt.value == values[depth]) {
          if (depth == values.length - 1) return [opt];
          final sub =
              opt.children != null ? search(opt.children!, depth + 1) : null;
          if (sub != null) return [opt, ...sub];
          return [opt];
        }
      }
      return null;
    }

    return search(widget.options, 0);
  }

  /// 获取显示文本：路径标签用 " / " 连接
  String get _displayText {
    if (_activePath.isEmpty) return '';
    return _activePath.map((o) => o.label).join(' / ');
  }

  void _showOverlay() {
    if (_open || widget.disabled) return;
    final t = AntTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _CascaderOverlay(
        fieldKey: _fieldKey,
        themeData: t,
        options: widget.options,
        activePath: _activePath,
        expandTrigger: widget.expandTrigger,
        changeOnSelect: widget.changeOnSelect,
        onPathChange: _onPathChange,
        onConfirm: _onConfirm,
        onConfirmKeepOpen: _onConfirmKeepOpen,
        onDismiss: _removeOverlay,
      ),
    );
    popupContentEntry = _overlayEntry;
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    popupContentEntry = null;
    _overlayEntry = null;
    if (_open) setState(() => _open = false);
  }

  /// 面板中路径变化（高亮/展开子菜单）
  void _onPathChange(List<AntCascaderOption> path) {
    setState(() => _activePath = path);
    _updateOverlay();
  }

  /// 确认选择（点击叶子节点或 changeOnSelect 时点击任意节点）
  void _onConfirm(List<AntCascaderOption> path) {
    final values = path.map((o) => o.value).toList();
    setState(() {
      _internalValue = values;
      _activePath = path;
    });
    widget.onChange?.call(values);
    _removeOverlay();
  }

  /// 确认选择但保持面板打开（changeOnSelect 模式下点击非叶子节点）
  void _onConfirmKeepOpen(List<AntCascaderOption> path) {
    final values = path.map((o) => o.value).toList();
    setState(() {
      _internalValue = values;
    });
    widget.onChange?.call(values);
  }

  void _updateOverlay() {
    // 面板路径变化经基座 PopupContentRefresher 原地重建（markNeedsBuild），
    // 不 remove+insert —— 避免 AntPopupOverlay 重挂载重放出泡动画
    refreshPopupContent();
  }

  void _clear() {
    setState(() {
      _internalValue = [];
      _activePath = [];
    });
    widget.onChange?.call([]);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final fontSize =
        widget.size == AntCascaderSize.small ? t.fontSizeSM : t.fontSize;
    final showClear =
        widget.allowClear && _currentValue.isNotEmpty && !widget.disabled;

    return GestureDetector(
      key: _fieldKey,
      onTap: widget.disabled ? null : (_open ? _removeOverlay : _showOverlay),
      child: Container(
        height: _height.h,
        padding: EdgeInsets.symmetric(
          horizontal: (widget.size == AntCascaderSize.small ? 7 : 12).w,
        ),
        decoration: BoxDecoration(
          color:
              widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
          border: Border.all(
            color: _open ? t.colorPrimary : t.colorBorder,
            width: _open ? t.controlOutlineWidth : 1,
          ),
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _displayText.isNotEmpty
                    ? _displayText
                    : (widget.placeholder ?? ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  color: _displayText.isNotEmpty
                      ? (widget.disabled ? t.colorTextDisabled : t.colorText)
                      : t.colorTextPlaceholder,
                ),
              ),
            ),
            if (showClear)
              GestureDetector(
                onTap: _clear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Icon(
                    Icons.cancel,
                    size: 14.sp,
                    color: t.colorTextQuaternary,
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Icon(
                  _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 14.sp,
                  color: t.colorTextQuaternary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _CascaderOverlay — 多列级联面板
// ============================================================

class _CascaderOverlay extends StatelessWidget {
  const _CascaderOverlay({
    required this.fieldKey,
    required this.themeData,
    required this.options,
    required this.activePath,
    required this.expandTrigger,
    required this.changeOnSelect,
    required this.onPathChange,
    required this.onConfirm,
    required this.onConfirmKeepOpen,
    required this.onDismiss,
  });

  final GlobalKey fieldKey;
  final AntThemeData themeData;
  final List<AntCascaderOption> options;
  final List<AntCascaderOption> activePath;
  final AntCascaderExpandTrigger expandTrigger;
  final bool changeOnSelect;
  final ValueChanged<List<AntCascaderOption>> onPathChange;
  final ValueChanged<List<AntCascaderOption>> onConfirm;
  final ValueChanged<List<AntCascaderOption>> onConfirmKeepOpen;
  final VoidCallback onDismiss;

  /// 构建面板列：根据 activePath 展开层级
  List<List<AntCascaderOption>> get _columns {
    final cols = <List<AntCascaderOption>>[options];
    for (final active in activePath) {
      if (active.children != null && active.children!.isNotEmpty) {
        cols.add(active.children!);
      } else {
        break;
      }
    }
    return cols;
  }

  void _handleOptionTap(
    List<AntCascaderOption> colOptions,
    int indexInCol,
    int colIndex,
  ) {
    final option = colOptions[indexInCol];
    if (option.disabled) return;

    // 构建新路径：取 activePath 前 colIndex 项 + 当前选项
    final newPath = [...activePath.take(colIndex), option];

    if (option.isLeaf) {
      // 叶子节点 → 确认选择并关闭面板
      onConfirm(newPath);
    } else if (changeOnSelect) {
      // 非叶子 + changeOnSelect → 确认选择但保持面板打开，继续展开子菜单
      onConfirmKeepOpen(newPath);
      onPathChange(newPath);
    } else {
      // 非叶子 → 仅展开子菜单
      onPathChange(newPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = themeData;
    final cols = _columns;

    // 弹层基座：位置计算/边界翻转夹回/点击外部关闭统一走 AntPopupOverlay
    return AntPopupOverlay(
      targetKey: fieldKey,
      placement: AntPopupPlacement.bottomLeft,
      onDismiss: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxHeight: 256.h),
          decoration: BoxDecoration(
            color: t.colorBgContainer,
            borderRadius: BorderRadius.circular(t.borderRadiusLG),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var colIndex = 0; colIndex < cols.length; colIndex++)
                _buildColumn(cols[colIndex], colIndex, t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(
    List<AntCascaderOption> colOptions,
    int colIndex,
    AntThemeData t,
  ) {
    final activeInCol =
        colIndex < activePath.length ? activePath[colIndex] : null;

    return Container(
      width: 140.w,
      constraints: BoxConstraints(maxHeight: 256.h),
      decoration: BoxDecoration(
        border: Border(
          right: colIndex < _columns.length - 1
              ? BorderSide(color: t.colorSplit, width: 1)
              : BorderSide.none,
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: colOptions.length,
        itemBuilder: (context, index) {
          final option = colOptions[index];
          final isActive = activeInCol?.value == option.value;

          return _CascaderOptionTile(
            option: option,
            isActive: isActive,
            fontSize: t.fontSize,
            colorText: t.colorText,
            colorTextDisabled: t.colorTextDisabled,
            colorPrimary: t.colorPrimary,
            colorFillSecondary: t.colorFillSecondary,
            expandTrigger: expandTrigger,
            onTap: () => _handleOptionTap(colOptions, index, colIndex),
            onHover:
                option.isLeaf || expandTrigger == AntCascaderExpandTrigger.click
                    ? null
                    : () => _handleOptionTap(colOptions, index, colIndex),
          );
        },
      ),
    );
  }
}

// ============================================================
// _CascaderOptionTile — 单个选项条目
// ============================================================

class _CascaderOptionTile extends StatefulWidget {
  const _CascaderOptionTile({
    required this.option,
    required this.isActive,
    required this.fontSize,
    required this.colorText,
    required this.colorTextDisabled,
    required this.colorPrimary,
    required this.colorFillSecondary,
    required this.expandTrigger,
    required this.onTap,
    this.onHover,
  });

  final AntCascaderOption option;
  final bool isActive;
  final double fontSize;
  final Color colorText;
  final Color colorTextDisabled;
  final Color colorPrimary;
  final Color colorFillSecondary;
  final AntCascaderExpandTrigger expandTrigger;
  final VoidCallback onTap;
  final VoidCallback? onHover;

  @override
  State<_CascaderOptionTile> createState() => _CascaderOptionTileState();
}

class _CascaderOptionTileState extends State<_CascaderOptionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.option.disabled;
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (widget.onHover != null) widget.onHover!();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: disabled ? null : widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          color: disabled
              ? widget.colorFillSecondary.withValues(alpha: 0.3)
              : widget.isActive
                  ? widget.colorPrimary.withValues(alpha: 0.06)
                  : _isHovered
                      ? widget.colorFillSecondary
                      : null,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: widget.fontSize.sp,
                    color: disabled
                        ? widget.colorTextDisabled
                        : widget.isActive
                            ? widget.colorPrimary
                            : widget.colorText,
                  ),
                ),
              ),
              if (!widget.option.isLeaf)
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 14.sp,
                  color: widget.colorTextDisabled,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
