/// antd_qrcode — Ant Design v6 QRCode 独立组件包
///
/// 从主包 antd_flutter_plus 拆分的首个独立组件包（零包内依赖）：
/// - [AntQRCode] — 二维码组件（对齐 antd React QRCode API）
/// - [AntQRCodeErrorLevel] / [AntQRCodeStatus] — 类型定义
///
/// 依赖方向约定：antd_qrcode → antd_theme（+ material_ui），
/// QR 生成引擎（qr_flutter）经组件内中间层隔离，SDK 语义不泄漏到 API。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/qr_code/ant_qr_code.dart';
export 'src/qr_code/ant_qr_code_types.dart';
