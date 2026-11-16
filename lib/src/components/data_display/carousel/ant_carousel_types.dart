/// AntCarousel 类型定义
///
/// 包含指示点位置枚举与外部控制器。
library;

/// 指示点位置 — 对齐 antd `dotPosition`（top/bottom/left/right）。
enum AntCarouselDotPosition {
  /// 顶部。
  top,

  /// 底部（默认）。
  bottom,

  /// 左侧。
  left,

  /// 右侧。
  right,
}

/// 轮播内部状态接口（组件内部实现，外部不应实现）。
abstract class AntCarouselStateApi {
  /// 跳转到指定页。
  void goTo(int index, {bool animate});
}

/// AntCarousel 外部控制器 — 用于 [goTo] 跳转到指定面板。
///
/// ```dart
/// final controller = AntCarouselController();
/// AntCarousel(children: [...], controller: controller);
/// controller.goTo(2);
/// ```
class AntCarouselController {
  AntCarouselStateApi? _state;

  /// 绑定轮播实例（由组件内部调用，外部勿用）。
  void attach(AntCarouselStateApi state) {
    _state = state;
  }

  /// 解绑轮播实例（由组件内部调用，外部勿用）。
  void detach(AntCarouselStateApi state) {
    if (_state == state) _state = null;
  }

  /// 跳转到指定面板 [index]。
  ///
  /// [animate] 为 true 时使用动画过渡（对齐 antd `goTo(slideNumber, dontAnimate)`）。
  void goTo(int index, {bool animate = true}) {
    _state?.goTo(index, animate: animate);
  }
}
