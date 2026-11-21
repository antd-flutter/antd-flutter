/// antd_upload — Ant Design v6 Upload 独立组件包（表单录入类，无 sliver 依赖）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntUpload] — 文件上传组件（文字/图片/图片卡片列表、多选、maxCount、受控/非受控）
/// - [AntUploadFile] — 上传文件信息
/// - [AntUploadStatus] — 上传状态（uploading / done / error / removed）
/// - [AntUploadListType] — 列表展示类型（text / picture / pictureCard）
/// - [AntUploadProgressInfo] — 上传进度信息
///
/// 依赖方向约定：antd_upload → antd_theme（+ material_ui），
/// 不依赖其他独立组件包；上传动作经 R16 中间件隔离原则抽象为
/// [AntUpload.customRequest] / [AntUpload.onSelectFiles] 回调注入，
/// 由使用方实现真实上传逻辑，包内不引入 http/dio 三方依赖。
/// 上传为表单录入类组件（非滚动场景），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/upload/ant_upload.dart';
export 'src/upload/ant_upload_types.dart';
