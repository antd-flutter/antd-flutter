/// 滚轮选择引擎 — 多列滚轮的单列渲染与选中项定位。
///
/// 由 antd_picker 全族消费；P08 拆分时自主包
/// `data_entry/picker/ant_picker_view.dart` 的 `_WheelColumn` 上移共享化
/// （原私有实现改为公开引擎组件，逻辑与视觉行为保持不变）。
library;

import 'package:antd_flutter_ui/src/engines/wheel_column_model.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

/// 单列滚轮引擎组件 — 基于 CupertinoPicker 的 iOS 风格滚轮。
///
/// 职责：按 [column] 渲染选项、经 [controller] 定位选中项、
/// 滚动停止时通过 [onSelected] 回报选中索引；样式（字号/文字色/分割线）
/// 由调用方注入，引擎自身不读主题。
class WheelPickerColumn extends StatelessWidget {
  const WheelPickerColumn({
    super.key,
    required this.column,
    required this.controller,
    required this.itemHeight,
    required this.fontSize,
    required this.colorText,
    required this.onSelected,
  });

  /// 列数据。
  final AntPickerColumn column;

  /// 滚轮滚动控制器（选中项定位）。
  final FixedExtentScrollController controller;

  /// 单项高度。
  final double itemHeight;

  /// 选项文字字号。
  final double fontSize;

  /// 选项文字颜色。
  final Color colorText;

  /// 选中项索引变化回调。
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: itemHeight,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: Colors.black.withValues(alpha: 0.04),
      ),
      onSelectedItemChanged: onSelected,
      children: column.map((item) {
        return Center(
          child: Text(
            item.label,
            style: TextStyle(
              fontSize: fontSize,
              color: colorText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
