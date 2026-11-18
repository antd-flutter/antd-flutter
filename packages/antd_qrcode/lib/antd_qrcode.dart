/// antd_qrcode — Ant Design v6 QRCode 独立组件包
///
/// 从主包 antd_flutter_plus 拆分的首个独立组件包（零包内依赖）：
/// - [AntQRCode] — 二维码组件（对齐 antd React QRCode API）
/// - [AntQRCodeErrorLevel] / [AntQRCodeStatus] — 类型定义
///
/// 依赖方向约定：antd_qrcode → antd_theme（+ material_ui），
/// QR 生成引擎源码已吸收进包内（src/engines/qr/，来源 package:qr 3.0.3，
/// BSD-3-Clause），组件经中间层访问，引擎原始 API 不对外导出。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/qr_code/ant_qr_code.dart';
export 'src/qr_code/ant_qr_code_types.dart';
