/// AntBorderBeam 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 默认边框宽度。
const double kAntBorderBeamDefaultSize = 3;

/// 默认动画周期（秒）。
const int kAntBorderBeamDefaultDurationSeconds = 6;

/// 流光段占边框周长的比例。
const double kAntBorderBeamLengthRatio = 0.25;

/// 边框标记 key，便于测试定位 CustomPaint。
const Key kAntBorderBeamPaintKey = ValueKey<String>('AntBorderBeamPaint');
