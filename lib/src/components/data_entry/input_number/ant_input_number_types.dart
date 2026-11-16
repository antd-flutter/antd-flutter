/// AntInputNumber 类型定义
library;

export 'package:antd_flutter_plus/src/components/data_entry/input/ant_input_types.dart'
    show AntInputSize, AntInputStatus;

/// 步进器按钮行为模式
enum AntInputNumberControls {
  /// 默认，上下按钮在右侧
  upDown,
  /// 仅显示上按钮
  up,
  /// 仅显示下按钮
  down,
  /// 不显示按钮
  none,
}