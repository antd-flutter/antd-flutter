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
/// 对齐 antd React Affix 组件（仅视口触发）：监听最近可滚动祖先的滚动位置，
/// 元素越过阈值时把 child 移入根 [Overlay] 以 `Positioned` 固定在视口边缘
/// （脱离滚动容器的裁剪与页头遮挡，antd 的 fixed 定位语义），
/// 原布局处保留等宽高等大占位，下方内容不跳动；滚回原位后解除。
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
  bool _affixed = false;

  OverlayEntry? _overlayEntry;

  ScrollPosition? _position;

  /// child 原始位置在当前滚动偏移下应处的视口纵坐标。
  double _originalTop = 0;

  /// 原始位置的全局横坐标与尺寸（钉住层按原位对齐）。
  double _left = 0;
  double _width = 0;
  double _height = 0;

  /// 钉住时固定在视口上的纵坐标（offsetTop 或底部阈值换算）。
  double _pinnedTop = 0;

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
    _removeOverlay();
    _position?.removeListener(_onScroll);
    super.dispose();
  }

  /// 以当前布局为准重新测量原始位置与尺寸基准。
  void _measure() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final origin = box.localToGlobal(Offset.zero);
    _originalTop = origin.dy;
    _left = origin.dx;
    _width = box.size.width;
    _height = box.size.height;
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

  /// 依据原始位置计算钉住状态；钉住时 child 移入 Overlay 固定在视口边缘。
  void _apply() {
    if (!mounted) return;

    final offsetTop = widget.offsetTop;
    final offsetBottom = widget.offsetBottom;
    final viewportHeight = MediaQuery.sizeOf(context).height;

    double? pinnedTop;
    if (offsetTop != null && _originalTop < offsetTop) {
      // 越过顶部阈值：固定到视口顶部 offsetTop 处
      pinnedTop = offsetTop;
    } else if (offsetBottom != null) {
      final thresholdBottom = viewportHeight - offsetBottom;
      final originalBottom = _originalTop + _height;
      if (originalBottom > thresholdBottom) {
        // 越过底部阈值：固定到视口底部 offsetBottom 处
        pinnedTop = thresholdBottom - _height;
      }
    }

    final newAffixed = pinnedTop != null;
    if (newAffixed == _affixed) {
      if (newAffixed) _pinnedTop = pinnedTop;
      return;
    }
    setState(() {
      _affixed = newAffixed;
      if (pinnedTop != null) {
        _pinnedTop = pinnedTop;
        _insertOverlay();
      } else {
        _removeOverlay();
      }
      widget.onChange?.call(_affixed);
    });
  }

  /// 把 child 以 Positioned 形式挂到根 Overlay（脱离滚动裁剪与页头遮挡）。
  void _insertOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: _pinnedTop,
        left: _left,
        width: _width,
        child: KeyedSubtree(
          key: kAntAffixShiftKey,
          child: KeyedSubtree(
            key: kAntAffixChildKey,
            child: widget.child,
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    AntTheme.of(context); // 主题令牌随主题刷新

    if (!_affixed) {
      return KeyedSubtree(
        key: kAntAffixChildKey,
        child: widget.child,
      );
    }
    // 钉住时原位保留等尺寸占位，下方内容不跳动
    return SizedBox(
      key: kAntAffixPlaceholderKey,
      width: _width,
      height: _height,
    );
  }
}
