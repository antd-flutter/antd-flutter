/// AntButton type → [color, variant] 解析器
///
/// 精确移植 antd `buttonHelpers.tsx` 的 `transformNodeProps` /
/// `ButtonTypeMap` 逻辑：
/// - type 映射到默认的 [color, variant]
/// - `danger=true` 时 color 强制为 danger
/// - `ghost=true` 且 variant=solid 时 variant 变为 outlined
library;

import 'ant_button_types.dart';

/// type → 默认 [color, variant] 映射表。
///
/// 与 antd `ButtonTypeMap` 完全一致：
/// ```
/// default → [default, outlined]
/// primary → [primary, solid]
/// dashed  → [default, dashed]
/// link    → [link,     link]
/// text    → [default,  text]
/// ```
const Map<AntButtonType, (AntButtonColor, AntButtonVariant)> _buttonTypeMap = {
  AntButtonType.normal: (AntButtonColor.normal, AntButtonVariant.outlined),
  AntButtonType.primary: (AntButtonColor.primary, AntButtonVariant.solid),
  AntButtonType.dashed: (AntButtonColor.normal, AntButtonVariant.dashed),
  AntButtonType.link: (AntButtonColor.link, AntButtonVariant.link),
  AntButtonType.text: (AntButtonColor.normal, AntButtonVariant.text),
};

/// 解析结果：有效的 color + variant。
class AntButtonVariantResult {
  const AntButtonVariantResult({
    required this.color,
    required this.variant,
  });

  /// 最终生效的颜色语义。
  final AntButtonColor color;

  /// 最终生效的变体。
  final AntButtonVariant variant;
}

/// 根据 type / color / danger / ghost 解析最终生效的 color + variant。
///
/// 规则（与 antd `buttonHelpers.tsx` 一致）：
/// 1. 若显式传了 [color]（非 null），使用传入值；否则取 type 映射的 color。
/// 2. 若 [danger] 为 true，color 强制改为 [AntButtonColor.danger]。
/// 3. variant：取 type 映射的 variant（antd v6 中 variant 也可显式传入，
///    此处以 type 映射为准，显式 variant 由调用方覆盖）。
/// 4. 若 [ghost] 为 true 且 variant 为 solid，variant 变为 outlined
///    （ghost solid = 透明背景描边，与 outlined 行为一致）。
AntButtonVariantResult resolveButtonVariant({
  required AntButtonType type,
  AntButtonColor? color,
  AntButtonVariant? variant,
  bool danger = false,
  bool ghost = false,
}) {
  final mapped = _buttonTypeMap[type] ??
      const (AntButtonColor.normal, AntButtonVariant.outlined);

  var resolvedColor = color ?? mapped.$1;
  var resolvedVariant = variant ?? mapped.$2;

  // danger 强制 color = danger
  if (danger) {
    resolvedColor = AntButtonColor.danger;
  }

  // ghost + solid → outlined（antd: ghost 的 solid 变体退化为 outlined）
  if (ghost && resolvedVariant == AntButtonVariant.solid) {
    resolvedVariant = AntButtonVariant.outlined;
  }

  return AntButtonVariantResult(
    color: resolvedColor,
    variant: resolvedVariant,
  );
}
