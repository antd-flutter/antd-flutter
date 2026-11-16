/// AntIndexBar — antd-mobile IndexBar 索引栏的 Flutter 实现
///
/// API 与 antd-mobile IndexBar 对齐：
/// - [items] — 分组项列表（key 作为索引字母）
/// - [onChange] — 索引切换回调
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_index_bar_types.dart';

// ============================================================
// AntIndexBar
// ============================================================

/// 索引栏 — 通讯录式字母索引导航。
///
/// 对齐 antd-mobile IndexBar 组件，右侧竖排索引字母，
/// 支持点击与垂直拖动选择，选中时中央显示字母提示气泡。
///
/// ```dart
/// AntIndexBar(
///   items: [
///     AntIndexBarItem(key: 'A', child: Text('A 组内容')),
///     AntIndexBarItem(key: 'B', child: Text('B 组内容')),
///   ],
///   onChange: (key) => print(key),
/// )
/// ```
class AntIndexBar extends StatefulWidget {
  const AntIndexBar({
    super.key,
    required this.items,
    this.onChange,
  });

  /// 分组项列表。
  final List<AntIndexBarItem> items;

  /// 索引切换回调。
  final ValueChanged<String>? onChange;

  @override
  State<AntIndexBar> createState() => _AntIndexBarState();
}

class _AntIndexBarState extends State<AntIndexBar> {
  /// 当前选中索引（null = 无选中）。
  int? _activeIndex;

  /// 是否显示中央提示气泡。
  bool _showBubble = false;

  /// 气泡自动隐藏定时器。
  Timer? _bubbleTimer;

  /// 每个索引字母的 GlobalKey，用于精确命中检测。
  final List<GlobalKey> _letterKeys = [];

  @override
  void dispose() {
    _bubbleTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AntIndexBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _letterKeys.clear();
    }
  }

  GlobalKey _keyFor(int index) {
    while (_letterKeys.length <= index) {
      _letterKeys.add(GlobalKey());
    }
    return _letterKeys[index];
  }

  void _select(int index) {
    if (index < 0 || index >= widget.items.length) return;
    if (index == _activeIndex && _showBubble) return;

    setState(() {
      _activeIndex = index;
      _showBubble = true;
    });
    widget.onChange?.call(widget.items[index].key);

    _bubbleTimer?.cancel();
    _bubbleTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _showBubble = false);
      }
    });
  }

  /// 根据全局 y 坐标，遍历字母 RenderBox 找到命中索引。
  int _indexFromGlobalY(double globalY) {
    for (int i = 0; i < widget.items.length && i < _letterKeys.length; i++) {
      final box =
          _letterKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero);
      if (globalY >= pos.dy - 4 && globalY < pos.dy + box.size.height + 4) {
        return i;
      }
    }
    // 未命中：找最近的
    int? nearest;
    double minDist = double.infinity;
    for (int i = 0; i < widget.items.length && i < _letterKeys.length; i++) {
      final box =
          _letterKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero);
      final center = pos.dy + box.size.height / 2;
      final dist = (globalY - center).abs();
      if (dist < minDist) {
        minDist = dist;
        nearest = i;
      }
    }
    return nearest ?? _activeIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);

    return Stack(
      children: [
        // 左侧分组内容
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in widget.items) ...[
              if (item.title != null || item.key.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.w,
                  ),
                  color: t.colorBgLayout,
                  child: Text(
                    item.title ?? item.key,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: t.colorTextSecondary,
                    ),
                  ),
                ),
              if (item.child != null) item.child!,
            ],
          ],
        ),

        // 右侧索引条
        Positioned(
          right: 2.w,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              _select(_indexFromGlobalY(details.globalPosition.dy));
            },
            onVerticalDragStart: (details) {
              _select(_indexFromGlobalY(details.globalPosition.dy));
            },
            onVerticalDragUpdate: (details) {
              _select(_indexFromGlobalY(details.globalPosition.dy));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.w),
              decoration: BoxDecoration(
                color: t.colorBgContainer.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < widget.items.length; i++)
                    _IndexLetter(
                      key: _keyFor(i),
                      letter: widget.items[i].key,
                      active: i == _activeIndex,
                      colorPrimary: t.colorPrimary,
                      colorTextSecondary: t.colorTextSecondary,
                    ),
                ],
              ),
            ),
          ),
        ),

        // 中央提示气泡
        if (_showBubble && _activeIndex != null)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: t.colorBgContainer.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.items[_activeIndex!].key,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: t.colorPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ============================================================
// 内部：索引字母
// ============================================================

class _IndexLetter extends StatelessWidget {
  const _IndexLetter({
    super.key,
    required this.letter,
    required this.active,
    required this.colorPrimary,
    required this.colorTextSecondary,
  });

  final String letter;
  final bool active;
  final Color colorPrimary;
  final Color colorTextSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          color: active ? colorPrimary : colorTextSecondary,
        ),
      ),
    );
  }
}