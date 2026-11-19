/// AntTransfer 穿梭框
///
/// 双栏穿梭选择组件，将数据项在左右面板间移动。
///
/// 对齐 antd React Transfer 组件，支持：
/// - [dataSource] / [targetKeys] / [selectedKeys]
/// - [onChange] / [onSelectChange]
/// - [titles] / [operations] / [disabled] / [showSearch] / [oneWay]
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_transfer_types.dart';

export 'ant_transfer_types.dart';

/// 穿梭框
class AntTransfer extends StatefulWidget {
  const AntTransfer({
    super.key,
    required this.dataSource,
    this.targetKeys,
    this.defaultTargetKeys = const [],
    this.selectedKeys,
    this.defaultSelectedKeys = const [],
    this.onChange,
    this.onSelectChange,
    this.titles = const ['Source', 'Target'],
    this.operations = const ['', ''],
    this.disabled = false,
    this.showSearch = false,
    this.oneWay = false,
    this.filterOption,
    this.height,
  });

  /// 数据源，包含全部数据项
  final List<AntTransferItem> dataSource;

  /// 受控：右侧面板项的 key 列表
  final List<String>? targetKeys;

  /// 非受控：右侧面板项的 key 列表初始值
  final List<String> defaultTargetKeys;

  /// 受控：已选中项的 key 列表
  final List<String>? selectedKeys;

  /// 非受控：已选中项的 key 列表初始值
  final List<String> defaultSelectedKeys;

  /// 项在两面板间移动后的回调
  /// 参数依次为：移动后的 targetKeys、移动方向、被移动的 keys
  final void Function(List<String> targetKeys, AntTransferDirection direction, List<String> moveKeys)?
      onChange;

  /// 选中项变化时的回调
  /// 参数依次为：源面板选中 keys、目标面板选中 keys
  final void Function(List<String> sourceSelectedKeys, List<String> targetSelectedKeys)?
      onSelectChange;

  /// 左右面板标题，默认 ['Source', 'Target']
  final List<String> titles;

  /// 中间操作按钮文案，默认 ['', '']（使用箭头图标）
  final List<String> operations;

  /// 是否整体禁用
  final bool disabled;

  /// 是否显示搜索框
  final bool showSearch;

  /// 是否为单向模式（仅可移至右侧，不可移回）
  final bool oneWay;

  /// 自定义搜索过滤函数，返回 true 表示保留
  final bool Function(String inputValue, AntTransferItem item)? filterOption;

  /// 列表区域高度
  final double? height;

  @override
  State<AntTransfer> createState() => _AntTransferState();
}

class _AntTransferState extends State<AntTransfer> {
  late List<String> _targetKeys;
  late List<String> _sourceSelectedKeys;
  late List<String> _targetSelectedKeys;
  String _sourceSearchText = '';
  String _targetSearchText = '';

  @override
  void initState() {
    super.initState();
    _targetKeys = List<String>.from(
        widget.targetKeys ?? widget.defaultTargetKeys,);
    _sourceSelectedKeys = <String>[];
    _targetSelectedKeys = <String>[];
    // 初始选中状态由 defaultSelectedKeys 分配到对应面板
    for (final key in widget.defaultSelectedKeys) {
      if (_targetKeys.contains(key)) {
        _targetSelectedKeys.add(key);
      } else {
        _sourceSelectedKeys.add(key);
      }
    }
  }

  @override
  void didUpdateWidget(AntTransfer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetKeys != null) {
      final newKeys = widget.targetKeys!;
      if (!_listEquals(_targetKeys, newKeys)) {
        _targetKeys = List<String>.from(newKeys);
      }
    }
    if (widget.selectedKeys != null) {
      final newSelected = widget.selectedKeys!;
      final newSource = newSelected.where((k) => !_targetKeys.contains(k)).toList();
      final newTarget = newSelected.where((k) => _targetKeys.contains(k)).toList();
      if (!_listEquals(_sourceSelectedKeys, newSource)) {
        _sourceSelectedKeys = newSource;
      }
      if (!_listEquals(_targetSelectedKeys, newTarget)) {
        _targetSelectedKeys = newTarget;
      }
    }
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  List<String> get _currentTargetKeys =>
      widget.targetKeys ?? _targetKeys;

  List<String> get _currentSourceSelectedKeys =>
      widget.selectedKeys == null ? _sourceSelectedKeys : _sourceSelectedKeys;

  List<String> get _currentTargetSelectedKeys =>
      widget.selectedKeys == null ? _targetSelectedKeys : _targetSelectedKeys;

  List<AntTransferItem> get _sourceItems => widget.dataSource
      .where((item) => !_currentTargetKeys.contains(item.key))
      .toList();

  List<AntTransferItem> get _targetItems => widget.dataSource
      .where((item) => _currentTargetKeys.contains(item.key))
      .toList();

  List<AntTransferItem> _filterItems(
      List<AntTransferItem> items, String searchText,) {
    if (searchText.isEmpty) return items;
    final filter = widget.filterOption;
    if (filter != null) {
      return items
          .where((item) => filter(searchText, item))
          .toList();
    }
    final lower = searchText.toLowerCase();
    return items.where((item) {
      if (item.title.toLowerCase().contains(lower)) return true;
      if (item.description != null &&
          item.description!.toLowerCase().contains(lower)) {
        return true;
      }
      return false;
    }).toList();
  }

  void _toggleSourceItem(String key, bool checked) {
    if (widget.selectedKeys != null) {
      widget.onSelectChange?.call(
        checked
            ? [..._sourceSelectedKeys, key]
            : _sourceSelectedKeys.where((k) => k != key).toList(),
        _targetSelectedKeys,
      );
      return;
    }
    setState(() {
      if (checked) {
        _sourceSelectedKeys.add(key);
      } else {
        _sourceSelectedKeys.remove(key);
      }
    });
    widget.onSelectChange?.call(
      List<String>.from(_sourceSelectedKeys),
      List<String>.from(_targetSelectedKeys),
    );
  }

  void _toggleTargetItem(String key, bool checked) {
    if (widget.selectedKeys != null) {
      widget.onSelectChange?.call(
        _sourceSelectedKeys,
        checked
            ? [..._targetSelectedKeys, key]
            : _targetSelectedKeys.where((k) => k != key).toList(),
      );
      return;
    }
    setState(() {
      if (checked) {
        _targetSelectedKeys.add(key);
      } else {
        _targetSelectedKeys.remove(key);
      }
    });
    widget.onSelectChange?.call(
      List<String>.from(_sourceSelectedKeys),
      List<String>.from(_targetSelectedKeys),
    );
  }

  void _toggleAllSource(bool checked) {
    final selectableItems =
        _filterItems(_sourceItems, _sourceSearchText)
            .where((item) => !item.disabled)
            .toList();
    final keys = selectableItems.map((item) => item.key).toList();
    if (widget.selectedKeys != null) {
      widget.onSelectChange?.call(
        checked ? keys : <String>[],
        _targetSelectedKeys,
      );
      return;
    }
    setState(() {
      if (checked) {
        _sourceSelectedKeys = keys;
      } else {
        _sourceSelectedKeys.clear();
      }
    });
    widget.onSelectChange?.call(
      List<String>.from(_sourceSelectedKeys),
      List<String>.from(_targetSelectedKeys),
    );
  }

  void _toggleAllTarget(bool checked) {
    final selectableItems =
        _filterItems(_targetItems, _targetSearchText)
            .where((item) => !item.disabled)
            .toList();
    final keys = selectableItems.map((item) => item.key).toList();
    if (widget.selectedKeys != null) {
      widget.onSelectChange?.call(
        _sourceSelectedKeys,
        checked ? keys : <String>[],
      );
      return;
    }
    setState(() {
      if (checked) {
        _targetSelectedKeys = keys;
      } else {
        _targetSelectedKeys.clear();
      }
    });
    widget.onSelectChange?.call(
      List<String>.from(_sourceSelectedKeys),
      List<String>.from(_targetSelectedKeys),
    );
  }

  void _moveToTarget() {
    final moveKeys = _sourceSelectedKeys
        .where((k) => !_currentTargetKeys.contains(k))
        .toList();
    if (moveKeys.isEmpty) return;
    final newTargetKeys = [..._currentTargetKeys, ...moveKeys];
    if (widget.targetKeys == null) {
      setState(() {
        _targetKeys = newTargetKeys;
        _sourceSelectedKeys.clear();
      });
    } else {
      setState(() {
        _sourceSelectedKeys.clear();
      });
    }
    widget.onChange?.call(
      newTargetKeys,
      AntTransferDirection.right,
      moveKeys,
    );
  }

  void _moveToSource() {
    if (widget.oneWay) return;
    final moveKeys = _targetSelectedKeys
        .where((k) => _currentTargetKeys.contains(k))
        .toList();
    if (moveKeys.isEmpty) return;
    final newTargetKeys = _currentTargetKeys
        .where((k) => !moveKeys.contains(k))
        .toList();
    if (widget.targetKeys == null) {
      setState(() {
        _targetKeys = newTargetKeys;
        _targetSelectedKeys.clear();
      });
    } else {
      setState(() {
        _targetSelectedKeys.clear();
      });
    }
    widget.onChange?.call(
      newTargetKeys,
      AntTransferDirection.left,
      moveKeys,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final panelHeight = widget.height ?? 240.h;

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _TransferPanel(
              title: widget.titles.isNotEmpty ? widget.titles.first : 'Source',
              items: _filterItems(_sourceItems, _sourceSearchText),
              totalItems: _sourceItems,
              selectedKeys: _currentSourceSelectedKeys,
              searchText: _sourceSearchText,
              showSearch: widget.showSearch,
              disabled: widget.disabled,
              height: panelHeight,
              theme: t,
              onSearch: widget.showSearch
                  ? (text) => setState(() => _sourceSearchText = text)
                  : null,
              onToggleItem: _toggleSourceItem,
              onToggleAll: _toggleAllSource,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: panelHeight / 2 - 32.h),
                _OperationButton(
                  icon: widget.operations.isNotEmpty && widget.operations[0].isNotEmpty
                      ? null
                      : Icons.keyboard_double_arrow_right,
                  label: widget.operations.isNotEmpty && widget.operations[0].isNotEmpty
                      ? widget.operations[0]
                      : null,
                  enabled: !widget.disabled && _sourceSelectedKeys.isNotEmpty,
                  onTap: _moveToTarget,
                  theme: t,
                ),
                SizedBox(height: 8.h),
                if (!widget.oneWay) ...[
                  _OperationButton(
                    icon: widget.operations.length > 1 && widget.operations[1].isNotEmpty
                        ? null
                        : Icons.keyboard_double_arrow_left,
                    label: widget.operations.length > 1 && widget.operations[1].isNotEmpty
                        ? widget.operations[1]
                        : null,
                    enabled: !widget.disabled && _targetSelectedKeys.isNotEmpty,
                    onTap: _moveToSource,
                    theme: t,
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _TransferPanel(
              title: widget.titles.length > 1 ? widget.titles[1] : 'Target',
              items: _filterItems(_targetItems, _targetSearchText),
              totalItems: _targetItems,
              selectedKeys: _currentTargetSelectedKeys,
              searchText: _targetSearchText,
              showSearch: widget.showSearch,
              disabled: widget.disabled,
              height: panelHeight,
              theme: t,
              onSearch: widget.showSearch
                  ? (text) => setState(() => _targetSearchText = text)
                  : null,
              onToggleItem: _toggleTargetItem,
              onToggleAll: _toggleAllTarget,
            ),
          ),
        ],
      ),
    );
  }
}

/// 单个穿梭面板
class _TransferPanel extends StatelessWidget {
  const _TransferPanel({
    required this.title,
    required this.items,
    required this.totalItems,
    required this.selectedKeys,
    required this.searchText,
    required this.showSearch,
    required this.disabled,
    required this.height,
    required this.theme,
    this.onSearch,
    required this.onToggleItem,
    required this.onToggleAll,
  });

  final String title;
  final List<AntTransferItem> items;
  final List<AntTransferItem> totalItems;
  final List<String> selectedKeys;
  final String searchText;
  final bool showSearch;
  final bool disabled;
  final double height;
  final AntThemeData theme;
  final ValueChanged<String>? onSearch;
  final void Function(String key, bool checked) onToggleItem;
  final void Function(bool checked) onToggleAll;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final allChecked = _isAllChecked(items, selectedKeys);
    final selectedCount = selectedKeys.length;

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: t.colorSplit),
        borderRadius: BorderRadius.circular(t.borderRadius.r),
      ),
      child: Column(
        children: [
          // 标题栏 + 全选
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: t.colorSplit)),
            ),
            child: Row(
              children: [
                AntCheckbox(
                  checked: allChecked,
                  disabled: disabled || items.every((i) => i.disabled),
                  onChange: onToggleAll,
                  child: const SizedBox.shrink(),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: t.fontSizeSM.sp,
                      color: t.colorText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '$selectedCount/${totalItems.length}',
                  style: TextStyle(
                    fontSize: t.fontSizeSM.sp,
                    color: t.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          // 搜索框
          if (showSearch)
            Padding(
              padding: EdgeInsets.all(8.w),
              child: SizedBox(
                height: t.controlHeightSM.h,
                child: TextField(
                  enabled: !disabled,
                  onChanged: onSearch,
                  style: TextStyle(fontSize: t.fontSizeSM.sp),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 0,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 16.r,
                      color: t.colorTextTertiary,
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: t.fontSizeSM.sp,
                      color: t.colorTextPlaceholder,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(t.borderRadius.r),
                      borderSide: BorderSide(color: t.colorBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(t.borderRadius.r),
                      borderSide: BorderSide(
                        color: t.colorPrimary,
                        width: t.controlOutlineWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // 列表区域
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'No data',
                      style: TextStyle(
                        fontSize: t.fontSizeSM.sp,
                        color: t.colorTextQuaternary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final checked = selectedKeys.contains(item.key);
                      return _TransferItemTile(
                        item: item,
                        checked: checked,
                        disabled: disabled,
                        theme: t,
                        onTap: () =>
                            onToggleItem(item.key, !checked),
                      );
                    },
                  ),
          ),
          // 底部
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: t.colorSplit)),
            ),
            child: Row(
              children: [
                Text(
                  '$selectedCount selected',
                  style: TextStyle(
                    fontSize: t.fontSizeSM.sp,
                    color: t.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isAllChecked(
      List<AntTransferItem> filteredItems, List<String> selectedKeys,) {
    final selectable =
        filteredItems.where((item) => !item.disabled).toList();
    if (selectable.isEmpty) return false;
    return selectable.every((item) => selectedKeys.contains(item.key));
  }
}

/// 数据项行
class _TransferItemTile extends StatelessWidget {
  const _TransferItemTile({
    required this.item,
    required this.checked,
    required this.disabled,
    required this.theme,
    required this.onTap,
  });

  final AntTransferItem item;
  final bool checked;
  final bool disabled;
  final AntThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final isDisabled = disabled || item.disabled;
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.h,
        ),
        child: Row(
          children: [
            AntCheckbox(
              checked: checked,
              disabled: isDisabled,
              onChange: isDisabled ? null : (_) => onTap(),
              child: const SizedBox.shrink(),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: t.fontSizeSM.sp,
                  color: isDisabled
                      ? t.colorTextDisabled
                      : t.colorText,
                ),
              ),
            ),
            if (item.description != null)
              Text(
                item.description!,
                style: TextStyle(
                  fontSize: t.fontSizeSM.sp,
                  color: t.colorTextTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 中间操作按钮
class _OperationButton extends StatelessWidget {
  const _OperationButton({
    this.icon,
    this.label,
    required this.enabled,
    required this.onTap,
    required this.theme,
  });

  final IconData? icon;
  final String? label;
  final bool enabled;
  final VoidCallback onTap;
  final AntThemeData theme;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: enabled ? t.colorPrimary : t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius.r),
        ),
        child: Center(
          child: label != null
              ? Text(
                  label!,
                  style: TextStyle(
                    fontSize: t.fontSizeSM.sp,
                    color: enabled ? Colors.white : t.colorTextDisabled,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Icon(
                  icon,
                  size: 18.r,
                  color: enabled ? Colors.white : t.colorTextDisabled,
                ),
        ),
      ),
    );
  }
}