/// Ant Design 阴影令牌。
///
/// 精确移植 antd `alias.ts` 中的 boxShadow 生成公式，
/// 将 CSS box-shadow 字符串转换为 Flutter [BoxShadow] 列表。
library;

import 'package:flutter/painting.dart';

import 'package:antd_color/antd_color.dart';

/// 阴影层描述。
class _ShadowLayer {
  final double dx;
  final double dy;
  final double blur;
  final double spread;
  final Color color;

  const _ShadowLayer(this.dx, this.dy, this.blur, this.spread, this.color);
}

/// Ant Design 阴影令牌集。
class AntShadowTokens {
  /// 弹出层主阴影。
  final List<BoxShadow> boxShadow;

  /// 弹出层次级阴影。
  final List<BoxShadow> boxShadowSecondary;

  /// 三级阴影（轻量浮起）。
  final List<BoxShadow> boxShadowTertiary;

  /// Popover 箭头阴影。
  final List<BoxShadow> boxShadowPopoverArrow;

  /// Card 阴影。
  final List<BoxShadow> boxShadowCard;

  /// Drawer 右侧阴影。
  final List<BoxShadow> boxShadowDrawerRight;

  /// Drawer 左侧阴影。
  final List<BoxShadow> boxShadowDrawerLeft;

  /// Drawer 上方阴影。
  final List<BoxShadow> boxShadowDrawerUp;

  /// Drawer 下方阴影。
  final List<BoxShadow> boxShadowDrawerDown;

  /// Tabs 左溢出阴影。
  final List<BoxShadow> boxShadowTabsOverflowLeft;

  /// Tabs 右溢出阴影。
  final List<BoxShadow> boxShadowTabsOverflowRight;

  /// Tabs 上溢出阴影。
  final List<BoxShadow> boxShadowTabsOverflowTop;

  /// Tabs 下溢出阴影。
  final List<BoxShadow> boxShadowTabsOverflowBottom;

  const AntShadowTokens._({
    required this.boxShadow,
    required this.boxShadowSecondary,
    required this.boxShadowTertiary,
    required this.boxShadowPopoverArrow,
    required this.boxShadowCard,
    required this.boxShadowDrawerRight,
    required this.boxShadowDrawerLeft,
    required this.boxShadowDrawerUp,
    required this.boxShadowDrawerDown,
    required this.boxShadowTabsOverflowLeft,
    required this.boxShadowTabsOverflowRight,
    required this.boxShadowTabsOverflowTop,
    required this.boxShadowTabsOverflowBottom,
  });

  /// 从阴影基色生成阴影令牌集。
  ///
  /// 与 antd `alias.ts` 一致:
  /// ```ts
  /// const shadowBaseColor = new FastColor(mergedToken.colorShadow);
  /// const shadowBaseAlpha = shadowBaseColor.a;
  /// const getShadowColor = (alpha) =>
  ///   shadowBaseColor.clone().setA(shadowBaseAlpha * alpha).toRgbString();
  /// ```
  factory AntShadowTokens.generate(String colorShadow) {
    final base = AntFastColor.of(colorShadow);
    final baseAlpha = base.a;

    // 与 antd 一致：setA(baseAlpha * alpha).toRgbString() 再解析为 Color，
    // 确保 _formatAlpha 两位小数精度对齐（如 dark: 0.2*0.08=0.016 → 0.02）
    Color shadowColor(double alpha) {
      return antParseColor(
        base.clone().setA(baseAlpha * alpha).toRgbString(),
      );
    }

    List<BoxShadow> layers(List<_ShadowLayer> ls) {
      return ls
          .map((l) => BoxShadow(
                offset: Offset(l.dx, l.dy),
                blurRadius: l.blur,
                spreadRadius: l.spread,
                color: l.color,
              ),)
          .toList();
    }

    // ---- boxShadow / boxShadowSecondary / boxShadowDrawerUp ----
    final popup = layers([
      _ShadowLayer(0, 6, 16, 0, shadowColor(0.08)),
      _ShadowLayer(0, 3, 6, -4, shadowColor(0.12)),
      _ShadowLayer(0, 9, 28, 8, shadowColor(0.05)),
    ]);

    // ---- boxShadowTertiary ----
    final tertiary = layers([
      _ShadowLayer(0, 1, 2, 0, shadowColor(0.05)),
      _ShadowLayer(0, 1, 6, -1, shadowColor(0.03)),
      _ShadowLayer(0, 2, 4, 0, shadowColor(0.03)),
    ]);

    // ---- boxShadowPopoverArrow ----
    final popoverArrow = layers([
      _ShadowLayer(2, 2, 5, 0, shadowColor(0.05)),
    ]);

    // ---- boxShadowCard ----
    final card = layers([
      _ShadowLayer(0, 1, 2, -2, shadowColor(0.16)),
      _ShadowLayer(0, 3, 6, 0, shadowColor(0.12)),
      _ShadowLayer(0, 5, 12, 4, shadowColor(0.09)),
    ]);

    // ---- Drawer 方向阴影 ----
    final drawerRight = layers([
      _ShadowLayer(-6, 0, 16, 0, shadowColor(0.08)),
      _ShadowLayer(-3, 0, 6, -4, shadowColor(0.12)),
      _ShadowLayer(-9, 0, 28, 8, shadowColor(0.05)),
    ]);

    final drawerLeft = layers([
      _ShadowLayer(6, 0, 16, 0, shadowColor(0.08)),
      _ShadowLayer(3, 0, 6, -4, shadowColor(0.12)),
      _ShadowLayer(9, 0, 28, 8, shadowColor(0.05)),
    ]);

    final drawerUp = popup;

    final drawerDown = layers([
      _ShadowLayer(0, -6, 16, 0, shadowColor(0.08)),
      _ShadowLayer(0, -3, 6, -4, shadowColor(0.12)),
      _ShadowLayer(0, -9, 28, 8, shadowColor(0.05)),
    ]);

    // ---- Tabs 溢出阴影（inset）----
    // Flutter BoxShadow 不支持 inset，用普通阴影近似（边缘渐隐效果）
    final tabsLeft = layers([
      _ShadowLayer(10, 0, 8, -8, shadowColor(0.08)),
    ]);
    final tabsRight = layers([
      _ShadowLayer(-10, 0, 8, -8, shadowColor(0.08)),
    ]);
    final tabsTop = layers([
      _ShadowLayer(0, 10, 8, -8, shadowColor(0.08)),
    ]);
    final tabsBottom = layers([
      _ShadowLayer(0, -10, 8, -8, shadowColor(0.08)),
    ]);

    return AntShadowTokens._(
      boxShadow: popup,
      boxShadowSecondary: popup,
      boxShadowTertiary: tertiary,
      boxShadowPopoverArrow: popoverArrow,
      boxShadowCard: card,
      boxShadowDrawerRight: drawerRight,
      boxShadowDrawerLeft: drawerLeft,
      boxShadowDrawerUp: drawerUp,
      boxShadowDrawerDown: drawerDown,
      boxShadowTabsOverflowLeft: tabsLeft,
      boxShadowTabsOverflowRight: tabsRight,
      boxShadowTabsOverflowTop: tabsTop,
      boxShadowTabsOverflowBottom: tabsBottom,
    );
  }
}