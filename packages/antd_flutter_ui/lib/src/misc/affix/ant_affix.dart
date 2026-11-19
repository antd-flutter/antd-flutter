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
import 'package:flutter/scheduler.dart';
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
  /// 全局钉住注册中心（按钉住先后排序）。
  ///
  /// 同一固定线（同 mode 同 offset 值）上的多个钉住元素顺序堆叠：
  /// 后钉的排在先钉的下方（top 模式）/上方（bottom 模式），
  /// 任一解除时同线元素重新计算补位。
  /// 注意：antd React 多个同线 Affix 是直接重叠的（无顺序处理），
  /// 顺序堆叠为本实现的增强行为。
  static final List<_AntAffixState> _pinOrder = <_AntAffixState>[];

  bool _affixed = false;

  OverlayEntry? _overlayEntry;

  ScrollPosition? _position;

  /// child 原始位置在当前滚动偏移下应处的视口纵坐标。
  double _originalTop = 0;

  /// 原始位置的全局横坐标与尺寸（钉住层按原位对齐）。
  double _left = 0;
  double _width = 0;
  double _height = 0;

  /// 钉住时固定在视口上的纵坐标（含同线堆叠偏移；bottom 模式为换算的 top）。
  double _pinnedTop = 0;

  /// bottom 模式钉住时距视口底部的距离（含同线堆叠偏移）。
  double _pinnedBottom = 0;

  /// 当前钉住方向：true = 底部钉住（offsetBottom 模式）。
  bool _pinToBottom = false;

  /// 降级模式（无 Overlay 祖先）下的原位平移量。
  double _fallbackShift = 0;

  /// 是否处于无 Overlay 祖先的降级模式。
  bool _fallbackWithoutOverlay = false;

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
    if (_pinOrder.remove(this)) {
      _notifySameLinePeers();
    }
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
      _pinToBottom = false;
    } else if (offsetBottom != null) {
      final thresholdBottom = viewportHeight - offsetBottom;
      final originalBottom = _originalTop + _height;
      if (originalBottom > thresholdBottom) {
        // 越过底部阈值：固定到视口底部 offsetBottom 处（元素底缘贴 offsetBottom 线）
        pinnedTop = thresholdBottom - _height;
        _pinToBottom = true;
      }
    }

    final newAffixed = pinnedTop != null;
    if (newAffixed == _affixed) {
      if (pinnedTop != null) {
        _pinnedTop = pinnedTop;
        _fallbackShift = _pinnedTop - _originalTop;
      }
      return;
    }
    // 捕获本次判定的目标状态，避免延迟提交时读到重算结果
    final targetPinnedTop = pinnedTop;
    void commit() {
      if (!mounted) return;
      setState(() {
        _affixed = newAffixed;
        if (targetPinnedTop != null) {
          _pinnedTop = targetPinnedTop;
          _fallbackShift = targetPinnedTop - _originalTop;
          // 注册进钉住顺序表（zIndex：后钉的 Overlay 后插入，绘制在更上层）
          _pinOrder.remove(this);
          _pinOrder.add(this);
        } else {
          _fallbackShift = 0;
          // 注销并让同线钉住元素上移/下移补位
          if (_pinOrder.remove(this)) {
            _notifySameLinePeers();
          }
        }
        widget.onChange?.call(_affixed);
      });
      // Overlay 增删统一延迟到帧末执行：避免滚动/布局阶段同步改动 Overlay
      // 触发 markNeedsBuild during build；帧末同步还能拿到最终布局测量值。
      _scheduleOverlaySync();
    }

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks) {
      // 处于 build/layout 阶段（如布局中触发的滚动），推迟到帧末提交
      WidgetsBinding.instance.addPostFrameCallback((_) => commit());
    } else {
      commit();
    }
  }

  /// 本元素当前固定线的 offset 值（钉住状态下必有对应 offset）。
  double get _lineOffset => _pinToBottom ? (widget.offsetBottom ?? 0) : (widget.offsetTop ?? 0);

  /// 依据钉住注册序计算本元素在同一条固定线上的堆叠槽位。
  ///
  /// top 模式：top = offsetTop + 前置同线元素累计高度（后钉的排在下方）；
  /// bottom 模式：bottom = offsetBottom + 前置同线元素累计高度（后钉的排在上方）。
  void _computeSlot() {
    var acc = 0.0;
    for (final peer in _pinOrder) {
      if (identical(peer, this)) break;
      if (peer._pinToBottom == _pinToBottom && peer._lineOffset == _lineOffset) {
        acc += peer._height;
      }
    }
    if (_pinToBottom) {
      _pinnedBottom = _lineOffset + acc;
      _pinnedTop = MediaQuery.sizeOf(context).height - _pinnedBottom - _height;
    } else {
      _pinnedTop = _lineOffset + acc;
    }
  }

  /// 通知同线钉住元素重新计算槽位补位（延迟帧末，避免 dispose/build 期改动）。
  void _notifySameLinePeers() {
    final edge = _pinToBottom;
    final offset = _lineOffset;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      for (final peer in List<_AntAffixState>.of(_pinOrder)) {
        if (peer._pinToBottom == edge && peer._lineOffset == offset) {
          peer._reposition();
        }
      }
    });
  }

  /// 重新计算槽位并刷新钉住层位置（补位）。
  void _reposition() {
    if (!mounted || !_affixed) return;
    _computeSlot();
    _fallbackShift = _pinnedTop - _originalTop;
    _overlayEntry?.markNeedsBuild();
  }

  /// 帧末同步 Overlay 钉住层与钉住状态一致。
  ///
  /// 无 Overlay 祖先（Overlay.maybeOf 为 null）时降级为原位 Transform 平移，
  /// 不崩溃；恢复有 Overlay 的环境后自动回到 Overlay 顶层钉住。
  void _scheduleOverlaySync() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_affixed && _overlayEntry == null) {
        final overlay = Overlay.maybeOf(context, rootOverlay: true);
        _measure();
        if (overlay == null) {
          // 降级模式：原位 Transform 平移（仍受滚动容器裁剪，但保证不崩溃）
          _computeSlot();
          setState(() {
            _fallbackWithoutOverlay = true;
            _fallbackShift = _pinnedTop - _originalTop;
          });
          return;
        }
        _fallbackWithoutOverlay = false;
        _computeSlot();
        _overlayEntry = OverlayEntry(
          builder: (_) => _pinToBottom
              ? Positioned(
                  bottom: _pinnedBottom,
                  left: _left,
                  width: _width,
                  child: KeyedSubtree(
                    key: kAntAffixShiftKey,
                    child: KeyedSubtree(
                      key: kAntAffixChildKey,
                      child: widget.child,
                    ),
                  ),
                )
              : Positioned(
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
        overlay.insert(_overlayEntry!);
      } else if (!_affixed && _overlayEntry != null) {
        _removeOverlay();
      }
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void _removeOverlay() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
    }
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
    if (_fallbackWithoutOverlay) {
      // 无 Overlay 祖先的降级模式：原位 Transform 平移（仍受滚动容器裁剪，
      // 但保证不崩溃；固定语义尽力而为）
      return Transform.translate(
        key: kAntAffixShiftKey,
        offset: Offset(0, _fallbackShift),
        child: KeyedSubtree(
          key: kAntAffixChildKey,
          child: widget.child,
        ),
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
