/// AntFloatingBubbleController — 悬浮气泡程序化控制器（R35）
part of 'ant_floating_bubble.dart';

/// 悬浮气泡控制器内部委托（由 [AntFloatingBubble] State 实现）。
abstract class AntFloatingBubbleControllerDelegate {
  /// 显示气泡。
  void show();

  /// 隐藏气泡（保留位置）。
  void hide();

  /// 移动到指定位置（逻辑像素，未约束时按 [AntFloatingBubble.constraint] 裁剪）。
  void moveTo(Offset pos);

  /// 吸附到父容器指定边缘（水平方向按最近边，垂直方向保持当前 y）。
  void snapToEdge(AntFloatingBubbleEdge edge);

  /// 吸附到最近的水平边缘（左/右）。
  void snapToNearestEdge();

  /// 重置到初始位置（[AntFloatingBubble.initialPos]）。
  void resetPosition();
}

/// 悬浮气泡控制器 — 程序化控制气泡显示/隐藏/位置/边缘吸附（R35 判定落地）。
///
/// 气泡位置与可见性是外部可控的浮动语义：通过 [show] / [hide] /
/// [moveTo] / [snapToEdge] / [snapToNearestEdge] / [resetPosition]
/// 编程式操作气泡，状态经 [visible] / [position] 读取、[addListener] 监听变化。
///
/// ```dart
/// final controller = AntFloatingBubbleController();
/// AntFloatingBubble(controller: controller, child: ...);
/// controller.snapToNearestEdge(); // 吸附到最近左/右边缘
/// ```
class AntFloatingBubbleController extends ChangeNotifier {
  AntFloatingBubbleControllerDelegate? _delegate;

  /// 气泡是否可见，默认 true。
  bool get visible => _visible;
  bool _visible = true;

  /// 当前位置（逻辑像素），未挂接/未上报时为 null。
  Offset? get position => _position;
  Offset? _position;

  /// 显示气泡。
  void show() => _delegate?.show();

  /// 隐藏气泡（保留位置，再次 [show] 时原位显示）。
  void hide() => _delegate?.hide();

  /// 移动到指定位置（逻辑像素，约束在父容器边界内）。
  void moveTo(Offset pos) => _delegate?.moveTo(pos);

  /// 吸附到父容器指定边缘。
  void snapToEdge(AntFloatingBubbleEdge edge) => _delegate?.snapToEdge(edge);

  /// 吸附到最近的水平边缘（左/右，比较当前位置与父容器中线）。
  void snapToNearestEdge() => _delegate?.snapToNearestEdge();

  /// 重置到初始位置（[AntFloatingBubble.initialPos]）。
  void resetPosition() => _delegate?.resetPosition();

  void _attach(AntFloatingBubbleControllerDelegate delegate) {
    _delegate = delegate;
  }

  void _detach() {
    _delegate = null;
    _position = null;
    _visible = true;
  }

  void _notifyVisible(bool value) {
    _visible = value;
    notifyListeners();
  }

  void _notifyPosition(Offset pos) {
    _position = pos;
    notifyListeners();
  }
}
