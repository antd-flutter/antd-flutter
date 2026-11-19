/// AntAffix 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 默认距视口顶部触发距离（对齐 antd v6 offsetTop 默认值）。
const double kAntAffixDefaultOffsetTop = 0;

/// 钉住状态标记 key，便于测试定位钉住层。
const Key kAntAffixChildKey = ValueKey<String>('AntAffixChild');

/// 钉住层标记 key，仅钉住时存在（钉在根 Overlay 顶层），便于测试判断钉住状态。
const Key kAntAffixShiftKey = ValueKey<String>('AntAffixShift');

/// 钉住时原布局占位的标记 key。
const Key kAntAffixPlaceholderKey = ValueKey<String>('AntAffixPlaceholder');
