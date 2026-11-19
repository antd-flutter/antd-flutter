/// AntErrorBlock 类型定义 — 对齐 antd-mobile v5 ErrorBlock 的配置项
library;

/// ErrorBlock 错误块状态。
enum AntErrorBlockStatus {
  /// 默认 — 一般错误提示。
  defaultStatus,

  /// 空数据 — 列表/内容为空。
  empty,

  /// 断网 — 网络连接异常。
  disconnected,

  /// 繁忙 — 系统繁忙。
  busy;

  /// 状态对应的默认标题（对齐 antd-mobile v5 中文文案）。
  String get defaultTitle {
    switch (this) {
      case AntErrorBlockStatus.defaultStatus:
        return '常见问题提示';
      case AntErrorBlockStatus.empty:
        return '暂无数据';
      case AntErrorBlockStatus.disconnected:
        return '网络出现问题';
      case AntErrorBlockStatus.busy:
        return '系统繁忙';
    }
  }

  /// 状态对应的默认描述文案。
  String get defaultDescription {
    switch (this) {
      case AntErrorBlockStatus.defaultStatus:
        return '有可能是系统问题，请稍后重试';
      case AntErrorBlockStatus.empty:
        return '点击刷新试试';
      case AntErrorBlockStatus.disconnected:
        return '点击刷新试试';
      case AntErrorBlockStatus.busy:
        return '点击刷新试试';
    }
  }
}
