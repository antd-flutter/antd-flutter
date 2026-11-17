/// AntButton 枚举定义
///
/// 与 antd React 版 Button API 对齐（camelCase 参数 + PascalCase Widget）。
library;

/// 按钮类型（antd `type` 属性）。
///
/// 对应 antd v6 的 5 种 button type，每种映射到默认的 [AntButtonColor] +
/// [AntButtonVariant] 组合（详见 [AntButtonVariantResolver]）。
enum AntButtonType {
  /// 默认按钮 → color=default, variant=outlined
  normal,

  /// 主按钮 → color=primary, variant=solid
  primary,

  /// 虚线按钮 → color=default, variant=dashed
  dashed,

  /// 链接按钮 → color=link, variant=link
  link,

  /// 文本按钮 → color=default, variant=text
  text,
}

/// 按钮颜色语义（antd v6 `color` 属性）。
///
/// `default` 使用中性色；`primary`/`danger` 使用主题色令牌；
/// `link` 使用链接色令牌（colorLink 体系，仅 type=link 使用）；
/// 预设色（blue/purple/…）使用 [AntButtonPresetColors] 生成的色板。
enum AntButtonColor {
  /// 中性色（文本色/边框色体系）
  normal,

  /// 主题主色
  primary,

  /// 危险色
  danger,

  /// 链接色（colorLink 体系，type=link 默认色）
  link,

  // ---- 预设色 ----
  blue,
  purple,
  cyan,
  green,
  magenta,
  red,
  orange,
  yellow,
  volcano,
  geekblue,
  gold,
  lime,
}

/// 按钮变体（antd v6 `variant` 属性）。
///
/// 决定按钮的填充方式（背景/边框/文字颜色的组合规则）。
enum AntButtonVariant {
  /// 描边：背景=容器色，边框=色基，文字=色基
  outlined,

  /// 虚线描边：同 outlined 但边框为虚线
  dashed,

  /// 实心：背景=色基，边框透明，文字=浅色
  solid,

  /// 填充：背景=色浅阶，边框透明，文字=色基
  filled,

  /// 纯文本：背景透明，文字=色基
  text,

  /// 链接：背景透明，文字=链接色
  link,
}

/// 按钮形状（antd `shape` 属性）。
enum AntButtonShape {
  /// 默认：小圆角
  normal,

  /// 圆形：正圆（宽高一致，borderRadius=50%）
  circle,

  /// 圆角：全圆角（borderRadius=控件高度/2）
  round,

  /// 方角：无圆角（borderRadius=0）
  square,
}

/// 按钮尺寸（antd `size` 属性）。
enum AntButtonSize {
  /// 大号
  large,

  /// 中号（默认）
  middle,

  /// 小号
  small,
}

/// 图标位置（antd `iconPlacement` 属性）。
enum AntButtonIconPlacement {
  /// 图标在文字前方
  start,

  /// 图标在文字后方
  end,
}
