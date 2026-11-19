/// AntSplitter — antd React Splitter 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [AntSplitter] — 可拖拽分隔面板容器
///   - [AntSplitter.layout] — 布局方向（horizontal / vertical）
///   - [AntSplitter.lazy] — 懒模式（拖拽释放时才更新尺寸）
///   - [AntSplitter.onResize] — 面板尺寸变化回调
///   - [AntSplitter.onResizeStart] — 拖拽开始回调
///   - [AntSplitter.onResizeEnd] — 拖拽结束回调
///   - [AntSplitter.onCollapse] — 折叠/展开回调
///   - [AntSplitter.onDraggerDoubleClick] — 双击拖拽器回调
/// - [AntSplitterPanel] — 面板
///   - [AntSplitterPanel.defaultSize] — 初始尺寸（逻辑像素）
///   - [AntSplitterPanel.size] — 受控尺寸（逻辑像素）
///   - [AntSplitterPanel.min] / [AntSplitterPanel.max] — 尺寸约束
///   - [AntSplitterPanel.resizable] — 是否可拖拽调整（默认 true）
///   - [AntSplitterPanel.collapsible] — 是否可折叠
///
/// 尺寸令牌：splitBarSize = 2，splitBarDraggableSize = 20。
library;

import 'dart:math' as math;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_splitter_types.dart';

/// 分割线显示宽度（逻辑像素）。
const double _kSplitBarSize = 2;

/// 可拖拽区域宽度（逻辑像素）。
const double _kSplitBarDraggableSize = 20;

/// 折叠按钮图标尺寸（逻辑像素）。
const double _kCollapseIconSize = 14;

// ============================================================
// AntSplitter
// ============================================================

/// 可拖拽分隔面板 — 自由拖拽调整各区域大小的分隔布局。
///
/// 对齐 antd React Splitter 组件，面板只能通过 [AntSplitterPanel] 提供。
///
/// ```dart
/// AntSplitter(
///   children: [
///     AntSplitterPanel(defaultSize: 200, child: Text('左')),
///     AntSplitterPanel(child: Text('右')),
///   ],
/// )
/// ```
class AntSplitter extends StatefulWidget {
  const AntSplitter({
    super.key,
    this.layout = AntSplitterLayout.horizontal,
    this.lazy = false,
    this.children = const [],
    this.onResize,
    this.onResizeStart,
    this.onResizeEnd,
    this.onCollapse,
    this.onDraggerDoubleClick,
  });

  /// 布局方向。默认 horizontal。
  final AntSplitterLayout layout;

  /// 懒模式。为 true 时拖拽过程中不更新面板尺寸，释放时才更新。
  final bool lazy;

  /// 面板列表。只支持 [AntSplitterPanel]。
  final List<AntSplitterPanel> children;

  /// 面板尺寸变化回调，参数为各面板当前尺寸（逻辑像素）。
  final ValueChanged<List<double>>? onResize;

  /// 拖拽开始前回调。
  final ValueChanged<List<double>>? onResizeStart;

  /// 拖拽结束回调。
  final ValueChanged<List<double>>? onResizeEnd;

  /// 折叠/展开回调。
  final AntSplitterCollapseCallback? onCollapse;

  /// 双击拖拽器回调，参数为拖拽器索引（位于面板 index 与 index+1 之间）。
  final ValueChanged<int>? onDraggerDoubleClick;

  @override
  State<AntSplitter> createState() => _AntSplitterState();
}

class _AntSplitterState extends State<AntSplitter> {
  /// 各面板当前尺寸（逻辑像素，未缩放）。
  List<double>? _sizes;

  /// 各面板折叠前的尺寸快照（用于展开时恢复）。
  List<double>? _sizesBeforeCollapse;

  /// 各面板折叠状态。
  late List<bool> _collapsed;

  /// lazy 模式下拖拽过程中的预览尺寸。
  List<double>? _lazySizes;

  /// 双击检测:上次 pan 开始时间。
  DateTime? _lastPanStartTime;

  /// 双击检测:上次 pan 开始的拖拽器索引。
  int? _lastPanStartDraggerIndex;

  @override
  void initState() {
    super.initState();
    _collapsed = List.generate(widget.children.length, (_) => false);
  }

  @override
  void didUpdateWidget(AntSplitter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _sizes = null;
      _sizesBeforeCollapse = null;
      _collapsed = List.generate(widget.children.length, (_) => false);
    } else {
      // 同步受控尺寸
      final sizes = _sizes;
      if (sizes != null) {
        // 修改前记录可用总量（sizes 总和 = 可用空间）
        final total = sizes.reduce((a, b) => a + b);
        var hasControlledChange = false;
        for (var i = 0; i < widget.children.length; i++) {
          final controlled = widget.children[i].size;
          if (controlled != null &&
              !_collapsed[i] &&
              controlled != sizes[i]) {
            sizes[i] = controlled;
            hasControlledChange = true;
          }
        }
        if (hasControlledChange) {
          // 受控面板变化后，未受控面板平分剩余空间
          var controlledTotal = 0.0;
          final uncontrolled = <int>[];
          for (var i = 0; i < widget.children.length; i++) {
            if (widget.children[i].size != null) {
              controlledTotal += sizes[i];
            } else if (!_collapsed[i]) {
              uncontrolled.add(i);
            }
          }
          if (uncontrolled.isNotEmpty) {
            final remaining =
                (total - controlledTotal).clamp(0, double.infinity);
            final share = remaining / uncontrolled.length;
            for (final i in uncontrolled) {
              sizes[i] = share;
            }
          }
        }
      }
    }
  }

  /// 缩放因子：1 逻辑像素对应的渲染像素数。
  double get _scale => 1.0.w;

  /// 面板最小尺寸（逻辑像素）。
  double _minOf(AntSplitterPanel panel) => panel.min ?? 0;

  /// 面板最大尺寸（逻辑像素）。
  double _maxOf(AntSplitterPanel panel) => panel.max ?? double.infinity;

  /// 初始化面板尺寸（逻辑像素）。
  List<double> _initSizes(double totalLogical) {
    final panels = widget.children;
    final n = panels.length;
    if (n == 0) return [];

    // 扣除拖拽器占用空间（逻辑像素）
    final draggerTotal = _kSplitBarDraggableSize * (n - 1);
    final available = (totalLogical - draggerTotal).clamp(0, double.infinity);

    final sizes = List<double>.filled(n, 0);
    var allocated = 0.0;
    final unspecified = <int>[];

    for (var i = 0; i < n; i++) {
      if (_collapsed[i]) {
        continue;
      }
      final controlled = panels[i].size;
      final def = controlled ?? panels[i].defaultSize;
      if (def != null) {
        sizes[i] = def.clamp(_minOf(panels[i]), _maxOf(panels[i]));
        allocated += sizes[i];
      } else {
        unspecified.add(i);
      }
    }

    // 未指定尺寸的面板平分剩余空间
    if (unspecified.isNotEmpty) {
      final remaining = (available - allocated).clamp(0, double.infinity);
      final share = remaining / unspecified.length;
      for (final i in unspecified) {
        sizes[i] = share.clamp(_minOf(panels[i]), _maxOf(panels[i]));
      }
    }

    return sizes;
  }

  // ----------------------------------------------------------
  // 拖拽处理
  // ----------------------------------------------------------

  void _handleDragStart(int draggerIndex) {
    // 双击检测:两次 pan 开始间隔小于 300ms 视为双击。
    // 折叠按钮的 tap 不会触发 onPanStart（tap 赢得竞技场），
    // 因此在折叠按钮上快速点击不会被误判为双击。
    final now = DateTime.now();
    if (_lastPanStartDraggerIndex == draggerIndex &&
        _lastPanStartTime != null &&
        now.difference(_lastPanStartTime!) <
            const Duration(milliseconds: 300)) {
      _handleDoubleClick(draggerIndex);
      _lastPanStartTime = null;
      _lastPanStartDraggerIndex = null;
      return;
    }
    _lastPanStartTime = now;
    _lastPanStartDraggerIndex = draggerIndex;
    widget.onResizeStart?.call(List.unmodifiable(_sizes!));
  }

  void _handleDragUpdate(int draggerIndex, double renderDelta) {
    // 真正拖拽时清除双击检测状态
    _lastPanStartTime = null;
    _lastPanStartDraggerIndex = null;

    final sizes = List<double>.from(_sizes!);
    final leftIdx = draggerIndex;
    final rightIdx = draggerIndex + 1;

    // 折叠或不可调整的面板不参与拖拽
    if (_collapsed[leftIdx] || _collapsed[rightIdx]) return;
    if (!widget.children[leftIdx].resizable ||
        !widget.children[rightIdx].resizable) {
      return;
    }

    // 渲染像素增量转逻辑像素增量
    final scale = _scale;
    final delta = scale > 0 ? renderDelta / scale : renderDelta;

    final leftMin = _minOf(widget.children[leftIdx]);
    final rightMin = _minOf(widget.children[rightIdx]);
    final leftMax = _maxOf(widget.children[leftIdx]);
    final rightMax = _maxOf(widget.children[rightIdx]);

    // 计算受约束的实际增量
    double actual;
    if (delta > 0) {
      final maxGrow = leftMax - sizes[leftIdx];
      final maxShrink = sizes[rightIdx] - rightMin;
      actual = math.min(delta, math.min(maxGrow, maxShrink));
    } else {
      final maxShrink = sizes[leftIdx] - leftMin;
      final maxGrow = rightMax - sizes[rightIdx];
      actual = -math.min(-delta, math.min(maxShrink, maxGrow));
    }

    sizes[leftIdx] += actual;
    sizes[rightIdx] -= actual;

    if (widget.lazy) {
      _lazySizes = sizes;
    } else {
      setState(() => _sizes = sizes);
    }
    widget.onResize?.call(List.unmodifiable(sizes));
  }

  void _handleDragEnd() {
    if (widget.lazy && _lazySizes != null) {
      setState(() {
        _sizes = _lazySizes;
        _lazySizes = null;
      });
    }
    widget.onResizeEnd?.call(List.unmodifiable(_sizes!));
  }

  // ----------------------------------------------------------
  // 折叠处理
  // ----------------------------------------------------------

  /// 折叠/展开面板 [index]。
  void _toggleCollapse(int index) {
    final sizes = List<double>.from(_sizes!);
    final wasCollapsed = _collapsed[index];

    if (wasCollapsed) {
      // 展开：恢复折叠前尺寸，从相邻面板借用空间
      final target = _sizesBeforeCollapse?[index] ?? _averageSize(sizes);
      var needed = target;
      needed = _borrowFromNeighbors(sizes, index, needed, forward: true);
      needed = _borrowFromNeighbors(sizes, index, needed, forward: false);
      sizes[index] = target - needed;
    } else {
      // 折叠：记录尺寸，释放空间给相邻面板。
      // 若其余面板已全部折叠（再释放会无处可去，且无法再展开），
      // 先自动展开相邻面板（对齐 antd：两端不可同时保持折叠）。
      var othersAllCollapsed = true;
      for (var i = 0; i < widget.children.length && othersAllCollapsed; i++) {
        if (i != index && !_collapsed[i]) othersAllCollapsed = false;
      }
      if (othersAllCollapsed && widget.children.length > 1) {
        final neighbor =
            index + 1 < widget.children.length ? index + 1 : index - 1;
        final freed = sizes[index];
        sizes[index] = 0;
        // 自动展开相邻面板并恢复其折叠前尺寸（不超可用空间）——
        // 先还原两面板布局，用户可继续操作（不直接撑到最大）。
        final restoreTarget =
            (_sizesBeforeCollapse?[neighbor] ?? _averageSize(sizes))
                .clamp(0.0, freed);
        sizes[neighbor] = restoreTarget;
        _collapsed[neighbor] = false;
      } else {
        _sizesBeforeCollapse = List<double>.from(sizes);
        final freed = sizes[index];
        sizes[index] = 0;
        // 释放空间全部转交给最近的一个未折叠面板（相邻侧优先，完全撑开），
        // 只转交一次，防止双侧各收一份导致溢出。
        var remaining = _giveToNeighbor(sizes, index, freed, forward: true);
        _giveToNeighbor(sizes, index, remaining, forward: false);
      }
    }

    setState(() {
      _collapsed[index] = !wasCollapsed;
      _sizes = sizes;
    });

    widget.onCollapse?.call(
      List.unmodifiable(_collapsed),
      List.unmodifiable(sizes),
    );
  }

  /// 计算未折叠面板的平均尺寸。
  double _averageSize(List<double> sizes) {
    final active = sizes.where((s) => s > 0).toList();
    if (active.isEmpty) return 0;
    return active.reduce((a, b) => a + b) / active.length;
  }

  /// 从相邻面板借用空间，返回仍需借用的量。
  double _borrowFromNeighbors(
    List<double> sizes,
    int index,
    double needed, {
    required bool forward,
  }) {
    final n = widget.children.length;
    if (forward) {
      for (var i = index + 1; i < n && needed > 0; i++) {
        if (!_collapsed[i] && widget.children[i].resizable) {
          final canGive = sizes[i] - _minOf(widget.children[i]);
          final give = math.min(needed, canGive);
          sizes[i] -= give;
          needed -= give;
        }
      }
    } else {
      for (var i = index - 1; i >= 0 && needed > 0; i--) {
        if (!_collapsed[i] && widget.children[i].resizable) {
          final canGive = sizes[i] - _minOf(widget.children[i]);
          final give = math.min(needed, canGive);
          sizes[i] -= give;
          needed -= give;
        }
      }
    }
    return needed;
  }

  /// 将释放的空间分配给相邻面板。
  double _giveToNeighbor(
    List<double> sizes,
    int index,
    double amount, {
    required bool forward,
  }) {
    if (amount <= 0) return 0;
    final n = widget.children.length;
    if (forward) {
      for (var i = index + 1; i < n; i++) {
        if (!_collapsed[i]) {
          sizes[i] += amount;
          return 0;
        }
      }
    } else {
      for (var i = index - 1; i >= 0; i--) {
        if (!_collapsed[i]) {
          sizes[i] += amount;
          return 0;
        }
      }
    }
    return amount;
  }

  // ----------------------------------------------------------
  // 双击重置
  // ----------------------------------------------------------

  void _handleDoubleClick(int draggerIndex) {
    widget.onDraggerDoubleClick?.call(draggerIndex);

    final sizes = List<double>.from(_sizes!);
    final leftIdx = draggerIndex;
    final rightIdx = draggerIndex + 1;
    final leftPanel = widget.children[leftIdx];
    final rightPanel = widget.children[rightIdx];

    // 展开折叠的面板
    if (_collapsed[leftIdx]) {
      _collapsed[leftIdx] = false;
    }
    if (_collapsed[rightIdx]) {
      _collapsed[rightIdx] = false;
    }

    final leftDefault = leftPanel.defaultSize ?? leftPanel.size;
    final rightDefault = rightPanel.defaultSize ?? rightPanel.size;
    final available = sizes[leftIdx] + sizes[rightIdx];

    if (leftDefault != null && rightDefault != null) {
      final total = leftDefault + rightDefault;
      if (total > 0 && total <= available) {
        sizes[leftIdx] = leftDefault;
        sizes[rightIdx] = rightDefault;
      } else if (total > available) {
        sizes[leftIdx] = available * leftDefault / total;
        sizes[rightIdx] = available * rightDefault / total;
      }
    } else if (leftDefault != null) {
      sizes[leftIdx] = leftDefault.clamp(0, available);
      sizes[rightIdx] = available - sizes[leftIdx];
    } else if (rightDefault != null) {
      sizes[rightIdx] = rightDefault.clamp(0, available);
      sizes[leftIdx] = available - sizes[rightIdx];
    }

    setState(() => _sizes = sizes);
    widget.onResize?.call(List.unmodifiable(sizes));
  }

  // ----------------------------------------------------------
  // build
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final isHorizontal = widget.layout == AntSplitterLayout.horizontal;
    final n = widget.children.length;

    if (n == 0) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalRender =
            isHorizontal ? constraints.maxWidth : constraints.maxHeight;

        // 初始化尺寸（build 阶段直接赋值，不调 setState）
        if (_sizes == null || _sizes!.length != n) {
          final scale = _scale;
          final totalLogical = scale > 0 ? totalRender / scale : totalRender;
          _sizes = _initSizes(totalLogical);
        }

        // 交叉轴 extent（水平布局取高度、垂直布局取宽度），
        // 折叠按钮交叉居中用；无界时取 0（贴顶/贴左）。
        final crossExtent =
            isHorizontal ? constraints.maxHeight : constraints.maxWidth;
        final crossCenter =
            crossExtent.isFinite ? crossExtent / 2 : 0.0;
        final sizes = _sizes!;
        final children = <Widget>[];
        // 折叠按钮命中框（44x44）：必须放在外层 Stack 上才能覆盖分割条以外的
        // 面板边缘区域——Clip.none 只允许绘制溢出，命中测试仍受父级 RenderBox
        // 尺寸约束（paint overflow ≠ hit test overflow），放在 20px 宽的分割条
        // Stack 内时超出部分点击无效。
        final collapseHitBoxes = <Widget>[];
        var axisOffset = 0.0;

        for (var i = 0; i < n; i++) {
          final panelSize = (sizes[i] * _scale).clamp(0, totalRender).toDouble();
          children.add(
            isHorizontal
                ? SizedBox(
                    key: ValueKey('ant_splitter_panel_$i'),
                    width: panelSize,
                    child: widget.children[i].child ?? const SizedBox.shrink(),
                  )
                : SizedBox(
                    key: ValueKey('ant_splitter_panel_$i'),
                    height: panelSize,
                    child: widget.children[i].child ?? const SizedBox.shrink(),
                  ),
          );
          axisOffset += panelSize;

          if (i < n - 1) {
            final dragSizeRender = _kSplitBarDraggableSize.w;
            final draggerCenter = axisOffset + dragSizeRender / 2;
            children.add(_buildDragger(theme, i, isHorizontal));
            collapseHitBoxes.addAll(
              _buildCollapseHitBoxes(
                theme,
                i,
                isHorizontal,
                draggerCenter: draggerCenter,
                crossCenter: crossCenter,
                containerLength: totalRender,
              ),
            );
            axisOffset += dragSizeRender;
          }
        }

        final layout = isHorizontal
            ? Row(children: children)
            : Column(children: children);

        if (collapseHitBoxes.isEmpty) return layout;

        // 外层 Stack 尺寸 = 整个 Splitter 区域，命中框 Positioned 在此层，
        // 分割条外（面板边缘 ±22px）的点击可达。
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: layout),
            ...collapseHitBoxes,
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // 拖拽器 & 折叠按钮
  // ----------------------------------------------------------

  /// 构建拖拽器（位于面板 draggerIndex 与 draggerIndex+1 之间）。
  Widget _buildDragger(AntThemeData theme, int draggerIndex, bool isHorizontal) {
    final leftPanel = widget.children[draggerIndex];
    final rightPanel = widget.children[draggerIndex + 1];
    final leftCollapsed = _collapsed[draggerIndex];
    final rightCollapsed = _collapsed[draggerIndex + 1];

    final canResize = leftPanel.resizable &&
        rightPanel.resizable &&
        !leftCollapsed &&
        !rightCollapsed;

    final barSize = _kSplitBarSize.w;
    final dragSize = _kSplitBarDraggableSize.w;

    return GestureDetector(
      key: ValueKey('ant_splitter_dragger_$draggerIndex'),
      onPanStart: canResize ? (_) => _handleDragStart(draggerIndex) : null,
      onPanUpdate: canResize
          ? (details) => _handleDragUpdate(
                draggerIndex,
                isHorizontal ? details.delta.dx : details.delta.dy,
              )
          : null,
      onPanEnd: canResize ? (_) => _handleDragEnd() : null,
      child: MouseRegion(
          cursor: canResize
              ? (isHorizontal
                  ? SystemMouseCursors.resizeColumn
                  : SystemMouseCursors.resizeRow)
              : MouseCursor.uncontrolled,
          child: Container(
            width: isHorizontal ? dragSize : null,
            height: isHorizontal ? null : dragSize,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 分割线
                Container(
                  width: isHorizontal ? barSize : null,
                  height: isHorizontal ? null : barSize,
                  color: theme.colorSplit,
                ),
              ],
            ),
          ),
        ),
    );
  }

  /// 构建折叠按钮命中框（44x44，位于外层 Stack，覆盖分割条两侧面板边缘）。
  ///
  /// 表现形式：按钮组**精确居中于对应分割条**——单按钮时按钮中心 == 分割条
  /// 中心；双按钮时按钮组（并排）的组中心 == 分割条中心，按钮骑在分割线上。
  /// 沿轴位置钳制在容器内（相邻面板折叠为 0 后分割线贴边仍可点）。
  /// 命中测试依赖父级 RenderBox 尺寸，故必须挂在外层 Stack 而非分割条内部。
  List<Widget> _buildCollapseHitBoxes(
    AntThemeData theme,
    int draggerIndex,
    bool isHorizontal, {
    required double draggerCenter,
    required double crossCenter,
    required double containerLength,
  }) {
    final hit = 44.0.w;
    final boxes = <Widget>[];

    // 按钮组沿轴起点：组宽 = 可折叠按钮数 × hit，组中心对齐分割条中心。
    final startOffset = widget.children[draggerIndex].collapsible &&
            widget.children[draggerIndex + 1].collapsible
        ? draggerCenter - hit
        : draggerCenter - hit / 2;

    Widget buildBox(int panelIndex, bool isStart) {
      // 组内沿轴偏移：start 在左（上），end 在右（下）；钳制在容器内。
      final along = (isStart ? startOffset : startOffset + hit)
          .clamp(0.0, containerLength - hit);
      final cross = crossCenter - hit / 2;
      return Positioned(
        left: isHorizontal ? along : cross,
        top: isHorizontal ? cross : along,
        width: isHorizontal ? hit : null,
        height: isHorizontal ? null : hit,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: _buildCollapseButton(
            theme,
            draggerIndex,
            panelIndex,
            isHorizontal,
            isStart: isStart,
          ),
        ),
      );
    }

    // 面板已折叠时隐藏其按钮（避免折叠贴边后两按钮重叠），
    // 仅保留展开侧按钮：点击它折叠本侧会自动展开对侧。
    // 但对侧不可折叠时保留折叠侧按钮（否则无任何途径恢复）。
    final otherCollapsible = widget.children[draggerIndex].collapsible &&
        widget.children[draggerIndex + 1].collapsible;
    final showStart = widget.children[draggerIndex].collapsible &&
        (!_collapsed[draggerIndex] || !otherCollapsible);
    final showEnd = widget.children[draggerIndex + 1].collapsible &&
        (!_collapsed[draggerIndex + 1] || !otherCollapsible);
    if (showStart) {
      boxes.add(buildBox(draggerIndex, true));
    }
    if (showEnd) {
      boxes.add(buildBox(draggerIndex + 1, false));
    }
    return boxes;
  }

  /// 构建折叠按钮。
  Widget _buildCollapseButton(
    AntThemeData theme,
    int draggerIndex,
    int panelIndex,
    bool isHorizontal, {
    required bool isStart,
  }) {
    final isCollapsed = _collapsed[panelIndex];

    // 确定图标方向
    final IconData icon;
    if (isHorizontal) {
      if (isStart) {
        // 左面板：折叠→左箭头，展开→右箭头
        icon = isCollapsed ? AntIcons.rightOutlined : AntIcons.leftOutlined;
      } else {
        // 右面板：折叠→右箭头，展开→左箭头
        icon = isCollapsed ? AntIcons.leftOutlined : AntIcons.rightOutlined;
      }
    } else {
      if (isStart) {
        // 上面板：折叠→上箭头，展开→下箭头
        icon = isCollapsed ? AntIcons.downOutlined : AntIcons.upOutlined;
      } else {
        // 下面板：折叠→下箭头，展开→上箭头
        icon = isCollapsed ? AntIcons.upOutlined : AntIcons.downOutlined;
      }
    }

    final btnSize = _kCollapseIconSize.w * 1.6;
    // 触控区域最小 44x44（Material 触控规范）：命中框大于视觉按钮，
    // 视觉按钮居中绘制，允许溢出分割条（配合 Stack clipBehavior: Clip.none）。
    const hitTarget = 44.0;

    return GestureDetector(
      key: ValueKey('ant_splitter_collapse_${draggerIndex}_$panelIndex'),
      behavior: HitTestBehavior.opaque,
      onTap: () => _toggleCollapse(panelIndex),
      child: SizedBox(
        width: hitTarget.w,
        height: hitTarget.w,
        child: Center(
          child: Container(
            width: btnSize,
            height: btnSize,
            decoration: BoxDecoration(
              color: theme.colorBgContainer,
              border: Border.all(color: theme.colorSplit),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: AntdIcon(
              icon,
              size: _kCollapseIconSize.sp,
              color: theme.colorTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// AntSplitterPanel
// ============================================================

/// 分隔面板 — AntSplitter 的子面板。
///
/// 对齐 antd React Splitter.Panel 组件，须在 [AntSplitter] 内使用。
///
/// ```dart
/// AntSplitterPanel(
///   defaultSize: 200,
///   min: 100,
///   max: 400,
///   child: Text('面板内容'),
/// )
/// ```
class AntSplitterPanel extends StatelessWidget {
  const AntSplitterPanel({
    super.key,
    this.defaultSize,
    this.size,
    this.min,
    this.max,
    this.resizable = true,
    this.collapsible = false,
    this.child,
  });

  /// 初始面板尺寸（逻辑像素）。为 null 时平分剩余空间。
  final double? defaultSize;

  /// 受控面板尺寸（逻辑像素）。非 null 时由外部控制。
  final double? size;

  /// 最小尺寸（逻辑像素）。
  final double? min;

  /// 最大尺寸（逻辑像素）。
  final double? max;

  /// 是否可拖拽调整尺寸。默认 true。
  final bool resizable;

  /// 是否可折叠。为 true 时相邻拖拽器上显示折叠按钮。
  final bool collapsible;

  /// 子元素。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return child ?? const SizedBox.shrink();
  }
}