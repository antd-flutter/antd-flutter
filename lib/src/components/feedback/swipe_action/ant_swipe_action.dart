/// AntSwipeAction — antd-mobile SwipeAction（滑动操作）的 Flutter 实现
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
const Duration kAntSwipeActionDuration = Duration(milliseconds: 250);

// ============================================================
// AntSwipeAction
// ============================================================

/// 滑动操作 — 左滑/右滑行内容露出操作按钮，松手吸附展开或收起。
///
/// 对齐 antd-mobile SwipeAction 组件：拖动时按钮跟随位移，松手超过
/// 按钮总宽一半自动展开，否则回弹关闭；点击操作按钮执行回调并收起。
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

  /// 展开回调（side 标识展开侧）。
  final ValueChanged<String>? onOpened;

  /// 收起回调。
  final VoidCallback? onClosed;

  @override
  State<AntSwipeAction> createState() => _AntSwipeActionState();
}

class _AntSwipeActionState extends State<AntSwipeAction>
    with SingleTickerProviderStateMixin {
  /// 当前位移：正值为右移（露出左侧按钮），负值为左移（露出右侧按钮）。
  double _offset = 0;

  late final AnimationController _snapController = AnimationController(
    vsync: this,
    duration: kAntSwipeActionDuration,
  );

  Animation<double>? _snapAnimation;

  double get _rightTotal => widget.rightActions.length * widget.actionWidth;

  double get _leftTotal => widget.leftActions.length * widget.actionWidth;

  @override
  void initState() {
    super.initState();
    _snapController.addListener(_handleSnapTick);
  }

  @override
  void dispose() {
    _snapController.removeListener(_handleSnapTick);
    _snapController.dispose();
    super.dispose();
  }

  void _handleSnapTick() {
    final anim = _snapAnimation;
    if (anim == null) return;
    setState(() => _offset = anim.value);
  }

  /// 吸附到目标位移。
  void _snapTo(double target, {bool opened = false}) {
    _snapAnimation = Tween<double>(begin: _offset, end: target).animate(
      CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic),
    );
    _snapController.forward(from: 0);
    if (opened) {
      widget.onOpened?.call(target < 0 ? 'right' : 'left');
    } else {
      widget.onClosed?.call();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = (_offset + details.delta.dx)
          .clamp(-_rightTotal, _leftTotal.toDouble());
    });
  }

  /// 松手吸附：超过按钮总宽一半展开，否则收起。
  void _handleDragEnd(DragEndDetails details) {
    final double velocity = details.velocity.pixelsPerSecond.dx;
    double target = 0;
    bool opened = false;
    if (velocity < -500) {
      target = -_rightTotal;
      opened = true;
    } else if (velocity > 500) {
      target = _leftTotal;
      opened = true;
    } else if (_offset <= -_rightTotal / 2) {
      target = -_rightTotal;
      opened = true;
    } else if (_offset >= _leftTotal / 2) {
      target = _leftTotal;
      opened = true;
    }
    _snapTo(target, opened: opened);
  }

  /// 点击操作按钮：执行回调，[AntSwipeAction.closeOnAction] 为 true 时收起。
  void _handleActionPress(AntSwipeActionItem item) {
    if (item.disabled) return;
    item.onPressed?.call();
    if (widget.closeOnAction) _snapTo(0);
  }

  /// 构建一侧操作按钮组。
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final bool hasRight = widget.rightActions.isNotEmpty;
    final bool hasLeft = widget.leftActions.isNotEmpty;

    return ClipRect(
      child: Stack(
        children: [
          // 内容层（跟随拖动位移，位于下层）
          GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: Container(
              key: kAntSwipeActionContentKey,
              color: theme.colorBgContainer,
              child: Transform.translate(
                offset: Offset(_offset, 0),
                child: widget.child,
              ),
            ),
          ),
          // 操作按钮层（内容滑走后露出，收起态忽略指针保证内容可点）
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: _offset <= 0,
              child: Transform.translate(
                offset: Offset(_offset - _leftTotal, 0),
                child: hasLeft
                    ? _buildActions(
                        theme,
                        widget.leftActions,
                        key: kAntSwipeActionLeftKey,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          PositionedDirectional(
            end: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: _offset >= 0,
              child: Transform.translate(
                offset: Offset(-_offset - _rightTotal, 0),
                child: hasRight
                    ? _buildActions(
                        theme,
                        widget.rightActions,
                        key: kAntSwipeActionRightKey,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}