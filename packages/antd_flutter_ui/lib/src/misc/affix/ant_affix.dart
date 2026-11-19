/// AntAffix — antd React Affix（固钉）的 Flutter 实现
///
/// API 与 antd v6 对齐（简化：仅视口，不支持 target）：
/// - [AntAffix.child] — 需要钉住的内容
/// - [AntAffix.offsetTop] — 距视口顶部的触发距离（默认 0）
/// - [AntAffix.offsetBottom] — 距视口底部的触发距离
/// - [AntAffix.onChange] — 钉住状态变化回调（affixed）
///
/// ```dart
/// AntAffix(
///   offsetTop: 100,
///   onChange: (affixed) => print(affixed),
///   child: const Text('固钉'),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_affix_types.dart';
export 'ant_affix_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntAffix
// ============================================================

/// 固钉 — 将元素钉在可视区域。
///
/// 对齐 antd React Affix 组件（仅视口触发）。
/// 通过监听最近可滚动祖先的滚动位置，在元素越过阈值时将其固定在视口边缘，
/// 返回原位后解除；child 始终保留在原布局流中，占位高度不变，下方内容不跳动。
class AntAffix extends StatefulWidget {
  const AntAffix({
    super.key,
    required this.child,
    this.offsetTop = kAntAffixDefaultOffsetTop,
    this.offsetBottom,
    this.onChange,
  });

  /// 需要钉住的内容。
  final Widget child;

  /// 距视口顶部的触发距离（像素），默认 0。
  final double? offsetTop;

  /// 距视口底部的触发距离（像素）。
  final double? offsetBottom;

  /// 钉住状态变化回调。
  final ValueChanged<bool>? onChange;

  @override
  State<AntAffix> createState() => _AntAffixState();
}

class _AntAffixState extends State<AntAffix> {
  /// 当前垂直位移（钉住时把 child 平移到阈值处）。
  double _shift = 0;

  bool _affixed = false;

  ScrollPosition? _position;

  /// child 原始位置在当前滚动偏移下应处的视口纵坐标（扣除位移）。
  double _originalTop = 0;

  /// 上次记录的滚动偏移，用于把滚动增量换算到原始位置。
  double _lastPixels = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pos = Scrollable.maybeOf(context)?.position;
    if (!identical(pos, _position)) {
      _position?.removeListener(_onScroll);
      _position = pos;
      pos?.addListener(_onScroll);
    }
    // 布局完成后测量初始位置并做首次判定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measure();
      _apply();
    });
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    super.dispose();
  }

  /// 以当前布局为准重新测量原始位置基准。
  void _measure() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    _originalTop = top - _shift;
    _lastPixels = _position?.pixels ?? 0;
  }

  void _onScroll() {
    final pixels = _position?.pixels;
    if (pixels == null) return;
    // 滚动引起的位置变化直接用增量换算，避免依赖尚未完成的布局
    _originalTop -= (pixels - _lastPixels);
    _lastPixels = pixels;
    _apply();
  }

  /// 依据原始位置计算钉住状态与位移。
  void _apply() {
    if (!mounted) return;
    final childHeight = _childHeight;
    final viewportHeight = MediaQuery.sizeOf(context).height;

    double? newShift;
    final offsetTop = widget.offsetTop;
    final offsetBottom = widget.offsetBottom;

    if (offsetTop != null && _originalTop < offsetTop) {
      // 越过顶部阈值：固定到视口顶部 offsetTop 处
      newShift = offsetTop - _originalTop;
    } else if (offsetBottom != null && childHeight != null) {
      final thresholdBottom = viewportHeight - offsetBottom;
      final originalBottom = _originalTop + childHeight;
      if (originalBottom > thresholdBottom) {
        // 越过底部阈值：固定到视口底部 offsetBottom 处
        newShift = thresholdBottom - originalBottom;
      }
    }

    final newAffixed = newShift != null;
    if (newShift != _shift || newAffixed != _affixed) {
      setState(() {
        _shift = newShift ?? 0;
        if (newAffixed != _affixed) {
          _affixed = newAffixed;
          widget.onChange?.call(_affixed);
        }
      });
    }
  }

  double? get _childHeight {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return box.size.height;
  }

  @override
  Widget build(BuildContext context) {
    AntTheme.of(context); // 主题令牌随主题刷新
    final child = KeyedSubtree(
      key: kAntAffixChildKey,
      child: widget.child,
    );

    if (_shift == 0) return child;
    return Transform.translate(
      key: kAntAffixShiftKey,
      offset: Offset(0, _shift),
      child: child,
    );
  }
}
