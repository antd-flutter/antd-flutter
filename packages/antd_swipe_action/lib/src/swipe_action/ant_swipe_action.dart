/// AntSwipeAction — antd-mobile SwipeAction（滑动操作）的 Flutter 实现
///
/// 交互机制参考 flutter_swipe_action_cell（Apache-2.0，仅参考机制，非代码移植）：
/// - action 层在下、cell 内容层在上滑出（iOS 风格）
/// - 拖拽 1:1 跟随，超过按钮总宽后 rubber-band 弹性阻尼
/// - 松手 fling 速度判定（快甩即开/关）+ 吸附动画（easeOutQuart）
/// - 展开态点击内容收起；方向相关手势识别，与纵向滚动（ListView）不冲突
///
/// API 与 antd-mobile v5 对齐：
/// - [AntSwipeAction.child] — 行内容
/// - [AntSwipeAction.rightActions] — 左滑露出的右侧操作按钮
/// - [AntSwipeAction.leftActions] — 右滑露出的左侧操作按钮
/// - [AntSwipeAction.closeOnAction] — 点击操作后是否自动收起（默认 true）
/// - [AntSwipeAction.actionWidth] — 单个操作按钮宽度（默认 72）
/// - [AntSwipeAction.onOpened]/[AntSwipeAction.onClosed] — 展开/收起回调
///
/// ```dart
/// AntSwipeAction(
///   rightActions: [
///     AntSwipeActionItem(text: '删除', color: theme.colorError, onPressed: () {}),
///   ],
///   child: ListTile(title: Text('左滑试试')),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_swipe_action_types.dart';
export 'ant_swipe_action_types.dart';

// ============================================================
// 常量与测试定位 Key
// ============================================================

/// 内容区 key，便于测试定位行内容容器。
const Key kAntSwipeActionContentKey = Key('__ant_swipe_action_content__');

/// 右侧操作区 key。
const Key kAntSwipeActionRightKey = Key('__ant_swipe_action_right__');

/// 左侧操作区 key。
const Key kAntSwipeActionLeftKey = Key('__ant_swipe_action_left__');

/// 默认单个操作按钮宽度。
const double kAntSwipeActionWidth = 72;

/// 吸附动画时长。
const Duration kAntSwipeActionDuration = Duration(milliseconds: 300);

/// 吸附动画曲线（参考 flutter_swipe_action_cell 的 easeOutQuart）。
const Curve kAntSwipeActionCurve = Curves.easeOutQuart;

/// rubber-band 弹性阻尼系数：超出按钮总宽后，每 1px 手指位移仅拉动 1/9px
/// （与 flutter_swipe_action_cell 的 delta/9 阻尼一致）。
const double kAntSwipeRubberBandFactor = 9;

/// rubber-band 最大过拉距离：超出按钮总宽后最多再多拉 100px。
const double kAntSwipeOverDragLimit = 100;

/// fling 快甩速度阈值（px/s）：松手速度超过该值即按甩动方向开/关。
const double kAntSwipeFlingVelocity = 500;

/// 内容位移超过该距离时忽略内容区指针（露出操作按钮可点）。
const double kAntSwipeContentPointerLimit = 20;

// ============================================================
// 状态机
// ============================================================

/// 滑动单元展开状态机。
enum _SwipePhase {
  /// 收起。
  closed,

  /// 展开动画中。
  opening,

  /// 完全展开。
  open,

  /// 收起动画中。
  closing,
}

// ============================================================
// AntSwipeAction
// ============================================================

/// 滑动操作 — 左滑/右滑行内容露出操作按钮，松手吸附展开或收起。
///
/// 对齐 antd-mobile SwipeAction 组件：
/// - 拖动时内容 1:1 跟随位移，超出按钮总宽进入 rubber-band 弹性阻尼
/// - 松手超过按钮总宽一半自动展开，否则回弹关闭；快甩（fling）直接开/关
/// - 展开态点击内容区域收起；点击操作按钮执行回调并收起
class AntSwipeAction extends StatefulWidget {
  const AntSwipeAction({
    super.key,
    required this.child,
    this.rightActions = const [],
    this.leftActions = const [],
    this.closeOnAction = true,
    this.actionWidth = kAntSwipeActionWidth,
    this.onOpened,
    this.onClosed,
  });

  /// 行内容。
  final Widget child;

  /// 左滑露出的右侧操作按钮。
  final List<AntSwipeActionItem> rightActions;

  /// 右滑露出的左侧操作按钮。
  final List<AntSwipeActionItem> leftActions;

  /// 点击操作按钮后是否自动收起（默认 true）。
  final bool closeOnAction;

  /// 单个操作按钮宽度（默认 72）。
  final double actionWidth;

  /// 展开回调（side 标识展开侧，动画完成时触发）。
  final ValueChanged<String>? onOpened;

  /// 收起回调（动画完成时触发）。
  final VoidCallback? onClosed;

  @override
  State<AntSwipeAction> createState() => _AntSwipeActionState();

  /// 松手吸附决策（纯函数，便于单测 fling 分支——测试环境
  /// [DragEndDetails.velocity] 恒为 0，无法通过手势产生真实速度）。
  ///
  /// fling 速度优先：快速左甩（velocity < -[flingVelocity]）有右侧按钮即
  /// 展开，否则收起；快速右甩对称。无 fling 时超过按钮总宽一半展开。
  @visibleForTesting
  static ({double target, bool open}) resolveSnapTarget({
    required double velocity,
    required double offset,
    required bool hasRight,
    required bool hasLeft,
    required double rightTotal,
    required double leftTotal,
    double flingVelocity = kAntSwipeFlingVelocity,
  }) {
    final bool trailing = offset < 0;
    double target = 0;
    bool open = false;
    if (velocity < -flingVelocity) {
      if (hasRight) {
        target = -rightTotal;
        open = true;
      }
    } else if (velocity > flingVelocity) {
      if (hasLeft) {
        target = leftTotal;
        open = true;
      }
    } else if (trailing && offset <= -rightTotal / 2) {
      target = -rightTotal;
      open = true;
    } else if (!trailing && offset >= leftTotal / 2) {
      target = leftTotal;
      open = true;
    }
    return (target: target, open: open);
  }
}

class _AntSwipeActionState extends State<AntSwipeAction>
    with SingleTickerProviderStateMixin {
  /// 当前位移：正值为右移（露出左侧按钮），负值为左移（露出右侧按钮）。
  double _offset = 0;

  /// 展开状态机相位。
  _SwipePhase _phase = _SwipePhase.closed;

  /// 本次拖动展开的一侧（true = 左滑露出右侧按钮）。
  bool? _draggingTrailing;

  /// 是否处于手指拖拽中（暂停状态机判定）。
  bool _dragging = false;

  late final AnimationController _snapController = AnimationController(
    vsync: this,
    duration: kAntSwipeActionDuration,
  );

  Animation<double>? _snapAnimation;

  double get _rightTotal => widget.rightActions.length * widget.actionWidth;

  double get _leftTotal => widget.leftActions.length * widget.actionWidth;

  bool get _hasRight => widget.rightActions.isNotEmpty;

  bool get _hasLeft => widget.leftActions.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _snapController.addStatusListener(_handleSnapStatus);
    _snapController.addListener(_handleSnapTick);
  }

  @override
  void dispose() {
    _snapController
      ..removeStatusListener(_handleSnapStatus)
      ..removeListener(_handleSnapTick)
      ..dispose();
    super.dispose();
  }

  void _handleSnapTick() {
    final anim = _snapAnimation;
    if (anim == null) return;
    setState(() => _offset = anim.value);
  }

  /// 吸附动画结束后推进状态机并触发回调。
  void _handleSnapStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (_phase == _SwipePhase.opening) {
      setState(() {
        _phase = _SwipePhase.open;
        _offset = _snapAnimation?.value ?? _offset;
      });
      widget.onOpened?.call(_draggingTrailing == false ? 'left' : 'right');
    } else if (_phase == _SwipePhase.closing) {
      setState(() {
        _phase = _SwipePhase.closed;
        _offset = 0;
        _draggingTrailing = null;
      });
      widget.onClosed?.call();
    }
  }

  /// 吸附到目标位移（[open] = true 展开，false 收起）。
  void _snapTo(double target, {required bool open}) {
    _snapAnimation = Tween<double>(begin: _offset, end: target).animate(
      CurvedAnimation(parent: _snapController, curve: kAntSwipeActionCurve),
    );
    setState(() => _phase = open ? _SwipePhase.opening : _SwipePhase.closing);
    _snapController.forward(from: 0);
  }

  // ------------------------------------------------------------
  // 手势
  // ------------------------------------------------------------

  void _handleDragStart(DragStartDetails details) {
    // 手指按下即接管：打断进行中的吸附动画（参考 flutter_swipe_action_cell）
    if (_snapController.isAnimating) _snapController.stop();
    _dragging = true;
    _draggingTrailing = _offset == 0 ? null : _offset < 0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double dx = details.delta.dx;
    // 方向锁定：本次拖动期间只朝一侧展开
    if (_draggingTrailing == null && dx != 0) {
      _draggingTrailing = dx < 0;
    }
    setState(() {
      if (_draggingTrailing ?? true) {
        // 左滑露出右侧按钮；无右侧按钮时不产生位移
        if (_hasRight) {
          // rubber-band（对齐 flutter_swipe_action_cell 逐事件语义）：
          // 已超按钮总宽且继续同向拖 → delta/9 阻尼；否则 1:1 跟随；
          // 越界超出 max+100 硬夹
          if (-_offset > _rightTotal && dx < 0) {
            _offset += dx / kAntSwipeRubberBandFactor;
          } else {
            _offset += dx;
          }
          if (_offset < -(_rightTotal + kAntSwipeOverDragLimit)) {
            _offset = -(_rightTotal + kAntSwipeOverDragLimit);
          }
        }
      } else {
        if (_hasLeft) {
          if (_offset > _leftTotal && dx > 0) {
            _offset += dx / kAntSwipeRubberBandFactor;
          } else {
            _offset += dx;
          }
          if (_offset > _leftTotal + kAntSwipeOverDragLimit) {
            _offset = _leftTotal + kAntSwipeOverDragLimit;
          }
        }
      }
      // 越界无对应侧按钮时位移归零（modifyOffsetIfOverScrolled 语义），
      // 保证展开态反向拖过中线不会错位显示另一侧
      if (!_hasLeft && _offset > 0) _offset = 0;
      if (!_hasRight && _offset < 0) _offset = 0;
    });
  }

  /// 松手吸附：fling 速度优先（快甩即开/关），其次超过按钮总宽一半展开。
  void _handleDragEnd(DragEndDetails details) {
    _dragging = false;
    final ({double target, bool open}) result =
        AntSwipeAction.resolveSnapTarget(
      velocity: details.velocity.pixelsPerSecond.dx,
      offset: _offset,
      hasRight: _hasRight,
      hasLeft: _hasLeft,
      rightTotal: _rightTotal,
      leftTotal: _leftTotal,
    );
    _snapTo(result.target, open: result.open);
  }

  /// 展开态点击内容区域：收起（参考 flutter_swipe_action_cell 的 tap-to-close）。
  void _handleTap() {
    if (_dragging || _snapController.isAnimating) return;
    if (_offset != 0) _snapTo(0, open: false);
  }

  /// 点击操作按钮：执行回调，[AntSwipeAction.closeOnAction] 为 true 时收起。
  void _handleActionPress(AntSwipeActionItem item) {
    if (item.disabled) return;
    item.onPressed?.call();
    if (widget.closeOnAction) _snapTo(0, open: false);
  }

  // ------------------------------------------------------------
  // 构建
  // ------------------------------------------------------------

  /// 构建一侧操作按钮组（固定贴边，位于内容层之下，内容滑走后露出）。
  Widget _buildActions(
    AntThemeData theme,
    List<AntSwipeActionItem> actions, {
    required Key key,
  }) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final AntSwipeActionItem item in actions)
          SizedBox(
            width: widget.actionWidth,
            // 禁用按钮也声明点击（no-op），避免命中穿透到组件级 tap-to-close
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: item.disabled ? () {} : null,
              child: Material(
                color: item.color ?? theme.colorPrimary,
                child: InkWell(
                  onTap: item.disabled ? null : () => _handleActionPress(item),
                  child: Center(
                    child: Text(
                      item.text,
                      style: TextStyle(
                        fontSize: theme.fontSize,
                        color: Colors.white.withValues(
                          alpha: item.disabled ? 0.45 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final bool showTrailing = _offset < 0 && _hasRight;
    final bool showLeading = _offset > 0 && _hasLeft;

    return ClipRect(
      child: RawGestureDetector(
        behavior: HitTestBehavior.opaque,
        gestures: <Type, GestureRecognizerFactory>{
          // 展开态点击内容收起
          TapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
            () => TapGestureRecognizer(),
            (instance) => instance.onTap = _offset != 0 ? _handleTap : null,
          ),
          // 方向相关拖拽：只识别当前可展开方向，纵向滚动不受影响
          _SwipeActionDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                  _SwipeActionDragGestureRecognizer>(
            () => _SwipeActionDragGestureRecognizer(),
            (instance) => instance
              ..canDragToLeft = _hasRight
              ..canDragToRight = _hasLeft
              ..isActionShowing = _offset != 0
              ..onStart = _handleDragStart
              ..onUpdate = _handleDragUpdate
              ..onEnd = _handleDragEnd,
          ),
        },
        child: Stack(
          children: [
            // action 层（在下，贴边固定，被滑出的内容遮住）
            if (showLeading)
              PositionedDirectional(
                start: 0,
                top: 0,
                bottom: 0,
                child: _buildActions(
                  theme,
                  widget.leftActions,
                  key: kAntSwipeActionLeftKey,
                ),
              ),
            if (showTrailing)
              PositionedDirectional(
                end: 0,
                top: 0,
                bottom: 0,
                child: _buildActions(
                  theme,
                  widget.rightActions,
                  key: kAntSwipeActionRightKey,
                ),
              ),
            // 内容层（在上，滑出露出操作按钮；大幅位移时整层忽略指针，
            // 让点击穿透到操作按钮或组件级 tap-to-close）
            IgnorePointer(
              ignoring: _offset.abs() > kAntSwipeContentPointerLimit,
              child: Container(
                key: kAntSwipeActionContentKey,
                color: theme.colorBgContainer,
                child: Transform.translate(
                  offset: Offset(_offset, 0),
                  transformHitTests: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 方向相关手势识别器
// ============================================================

/// 方向相关的水平拖拽识别器（机制参考 flutter_swipe_action_cell）：
///
/// 仅当当前可朝该方向展开（或已有操作按钮露出）时才处理指针事件，
/// 其余方向的事件直接丢弃，保证嵌入 ListView 时纵向滚动不被横滑抢占、
/// 反向拖动也不会误触发展开。
class _SwipeActionDragGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  /// 是否可以向左拖（露出右侧按钮）。
  bool canDragToLeft = false;

  /// 是否可以向右拖（露出左侧按钮）。
  bool canDragToRight = false;

  /// 是否已有操作按钮露出（露出时允许任意方向拖动）。
  bool isActionShowing = false;

  @override
  void handleEvent(PointerEvent event) {
    final double delta = event.delta.dx;
    if (isActionShowing ||
        (canDragToLeft && delta < 0) ||
        (canDragToRight && delta > 0) ||
        delta == 0) {
      super.handleEvent(event);
    }
  }
}
