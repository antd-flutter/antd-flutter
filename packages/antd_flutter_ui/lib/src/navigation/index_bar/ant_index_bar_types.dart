/// AntIndexBar 数据类型 — antd-mobile IndexBar 索引栏
library;

import 'package:material_ui/material_ui.dart';

/// 索引栏分组项。
///
/// 对齐 antd-mobile `IndexBar.Panel`：
/// - [index] — 索引标识（必填，如 'A'）；
/// - [title] — 分组标题，默认取 [index]；
/// - [brief] / [briefWidget] — 右侧字母，默认取 [index] 首字符；
/// - [child] — 分组内容。
class AntIndexBarItem {
  const AntIndexBarItem({
    required this.index,
    this.title,
    this.brief,
    this.briefWidget,
    this.child,
  });

  /// 索引标识（如 'A'、'B'）。
  final String index;

  /// 分组标题，默认取 [index]。
  final String? title;

  /// 右侧索引字母，默认取 [index] 首字符。
  final String? brief;

  /// 自定义索引字母 Widget，优先于 [brief]。
  final Widget? briefWidget;

  /// 分组内容。
  final Widget? child;

  /// 分组标题文本。
  String get headerTitle => title ?? index;

  /// 索引字母文本。
  String get briefText => brief ?? (index.isEmpty ? '' : index.substring(0, 1));
}
