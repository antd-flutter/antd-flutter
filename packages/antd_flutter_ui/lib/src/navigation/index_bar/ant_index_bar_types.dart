/// AntIndexBar 数据类型 — antd-mobile IndexBar 索引栏
library;

import 'package:material_ui/material_ui.dart';

/// 索引栏分组项。
class AntIndexBarItem {
  const AntIndexBarItem({
    required this.key,
    this.title,
    this.child,
  });

  /// 索引标识（如 'A'、'B'）。
  final String key;

  /// 分组标题（默认取 [key]）。
  final String? title;

  /// 分组内容。
  final Widget? child;
}