/// AntFloatingPanelController — 浮动面板程序化控制器（R35）
part of 'ant_floating_panel.dart';

/// 浮动面板控制器内部委托（由 [AntFloatingPanel] State 实现）。
///
/// 控制器对外提供稳定 API，实际定位操作委托给已挂接的面板 State；
/// 未挂接（面板未挂载/已销毁）时调用为安全空操作。
abstract class AntFloatingPanelControllerDelegate {
  /// 吸附到指定索引的锚点（升序，0 为最低）。
  void snapToAnchorAt(int index);

  /// 展开到最高锚点。
  void expand();

  /// 收起到最低锚点。
  void collapse();

  /// 重置到初始位置（最低锚点）。
  void resetToInitial();
}

/// 浮动面板控制器 — 程序化控制面板高度/吸附/展开收起（R35 判定落地）。
///
/// 面板位置（高度比例）是外部可控的浮动语义：通过 [snapToAnchorAt] /
/// [expand] / [collapse] / [resetToInitial] 编程式操作面板，
/// 当前高度比例经 [heightRatio] 读取、[addListener] 监听变化。
///
/// ```dart
/// final controller = AntFloatingPanelController();
/// AntFloatingPanel(controller: controller, child: ...);
/// controller.expand(); // 程序化展开到最高锚点
/// ```
class AntFloatingPanelController extends ChangeNotifier {
  AntFloatingPanelControllerDelegate? _delegate;

  /// 当前面板高度比例（0~1，相对基准高度），未挂接时为 null。
  double? get heightRatio => _heightRatio;
  double? _heightRatio;

  /// 吸附到指定索引的锚点（升序，0 为最低；越界时 clamp 到有效范围）。
  void snapToAnchorAt(int index) => _delegate?.snapToAnchorAt(index);

  /// 展开到最高锚点。
  void expand() => _delegate?.expand();

  /// 收起到最低锚点。
  void collapse() => _delegate?.collapse();

  /// 重置到初始位置（最低锚点，与面板初始态一致）。
  void resetToInitial() => _delegate?.resetToInitial();

  void _attach(AntFloatingPanelControllerDelegate delegate) {
    _delegate = delegate;
  }

  void _detach() {
    _delegate = null;
    _heightRatio = null;
  }

  void _notifyHeight(double ratio) {
    _heightRatio = ratio;
    notifyListeners();
  }
}
