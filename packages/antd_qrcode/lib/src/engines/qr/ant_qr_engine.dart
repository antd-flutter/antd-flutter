/// QR 生成引擎中间层（自研封装，零三方依赖）
///
/// 下方 [AntQrMatrix] 是我们对内部吸收的 qr 引擎源码（engines/qr/ 目录，
/// 来源 package:qr 3.0.3，BSD-3-Clause）的私有封装接口：
/// 组件层只感知 [AntQrMatrix] / [AntQrErrorCorrectLevel]，
/// qr 引擎原始 API（QrCode/QrImage 等）不经包 barrel 导出，语义不泄漏。
library;

import 'error_correct_level.dart' as engine;
import 'qr_code.dart' as engine;
import 'qr_image.dart' as engine;

/// 二维码纠错等级（引擎层枚举，与组件层枚举经中间层映射）。
abstract final class AntQrErrorCorrectLevel {
  /// 低（7% 纠错）
  static const int l = engine.QrErrorCorrectLevel.L;

  /// 中（15% 纠错）
  static const int m = engine.QrErrorCorrectLevel.M;

  /// 四分之一（25% 纠错）
  static const int q = engine.QrErrorCorrectLevel.Q;

  /// 高（30% 纠错）
  static const int h = engine.QrErrorCorrectLevel.H;
}

/// QR 矩阵 — 由内容 + 纠错等级生成的模块网格（自绘渲染输入）。
class AntQrMatrix {
  AntQrMatrix._(
    this._image,
    this.moduleCount,
    this.typeNumber,
    this.errorCorrectLevel,
    this.maskPattern,
  );

  /// 根据内容与纠错等级生成 QR 矩阵（版本自动选择）。
  factory AntQrMatrix.fromData({
    required String data,
    required int errorCorrectLevel,
  }) {
    final code = engine.QrCode.fromData(
      data: data,
      errorCorrectLevel: errorCorrectLevel,
    );
    final image = engine.QrImage(code);
    return AntQrMatrix._(
      image,
      image.moduleCount,
      code.typeNumber,
      code.errorCorrectLevel,
      image.maskPattern,
    );
  }

  final engine.QrImage _image;

  /// 模块数（每边 N×N）。
  final int moduleCount;

  /// QR 版本号（1-40，模块数 = version * 4 + 17）。
  final int typeNumber;

  /// 纠错等级常量（[AntQrErrorCorrectLevel]）。
  final int errorCorrectLevel;

  /// 掩码模式（0-7）。
  final int maskPattern;

  /// 指定模块是否为深色（true = 绘制前景色方块）。
  bool isDark(int row, int col) => _image.isDark(row, col);
}
