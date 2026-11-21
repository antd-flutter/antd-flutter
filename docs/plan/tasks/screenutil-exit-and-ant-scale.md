# 关闭 ScreenUtil 与 AntScale 全局缩放方案（待评审，2026-11-21）

> 状态：**仅方案，未执行**。用户要求先评审：关闭 ScreenUtil、移除其 API 调用，改为 antd 侧统一缩放因子，后续只改因子即可让所有控件（含独立包）动态修正数值。

## 1. 目标与非目标

**目标**
1. 移除 `flutter_screenutil` 依赖与 `AntScreenUtilInit`，组件、测试、示例不再出现 `.w / .h / .sp / .r`。
2. 在 `antd_theme` 中提供统一缩放因子 `AntScale`：改一个因子，所有控件（ui 基础组件 + 16 个独立包 + 示例）的尺寸、字号、圆角、间距同步变化。
3. 组件适配成本极低：大多数控件只需「从主题取 token」或「`t.s(设计值)`」；独立包不需新增依赖（已依赖 antd_theme）。
4. 默认因子 1.0：与当前桌面端视觉一致，单元测试数字基本不变。

**非目标**
- 不引入响应式断点体系重写（AntResponsive 保留，只改因子来源）。
- 不做按轴向（宽/高）分别缩放；不恢复 `.h` 语义（高度缩放）。
- 不在本次改设计稿尺寸本身（设计值仍是 14/40/16/8…）。

## 2. 现状盘点

| 范围 | `.w/.h/.sp/.r` 调用点 | 说明 |
|---|---:|---|
| `example/lib` | 1191 | 主示例全部页面，演示代码大量使用 |
| `packages/antd_flutter_ui` | 705 | 组件库主体 |
| `antd_keyboard` | 84 | 键盘按键尺寸、字号 |
| `antd_picker` | 79 | 滚轮行高、字号 |
| `antd_table` | 61 | 单元格 padding、行高 |
| `antd_calendar` | 60 | 日历单元格 |
| `antd_upload` | 47 | 列表项、缩略图 |
| `antd_transfer` | 37 | 行高、面板 |
| `antd_tree` | 35 | 节点缩进、行高 |
| `antd_theme` | 22 | 初始化与响应式 |
| 其余独立包（floating/carousel/qrcode/color/form/image_viewer/splitter/refresh/tokens/masonry/icons） | ~90 | 零散 |
| **合计** | **2323**（另有 `test/` 少量） | `.w` 1657 / `.h` 240 / `.sp` 309 / `.r` 156 |

依赖与入口：
- `flutter_screenutil` 只出现在 3 个 pubspec：根包、`example`、`antd_theme`；扩展 `.w/.sp/.r` 由 `antd_theme` 转导出，因此所有包都能用。
- `AntScreenUtilInit`（`packages/antd_theme/lib/src/ant_screen_util.dart`）封装 `ScreenUtilInit(designSize: 375×812)`，并内置桌面自适应：逻辑宽度 ≥768 时把 designSize 换成窗口实际尺寸，使桌面因子恒 1；可开启 `allowScaleUp/maxWidth/maxScaleFactor` 超宽放大。
- `AntResponsive` 直接把 `AntScreenUtilInit.scaleFactorNotifier.value` 上报为 `AntLayoutData.scaleFactor`（`ant_responsive.dart:263-281`）。

## 3. 为什么必须退出

1. **双端规则冲突（R38）**：ScreenUtil 因子由「窗口宽度/375」决定，与桌面/移动无关；669 逻辑宽的 iPad 上因子 1.784，Collapse 箭头 12 被放大到 21px，字号却固定 14 —— 同一组件内比例失衡，R38 的「两端各自源码尺寸」不可能成立。
2. **高度因子有害**：`.h` 按窗口高度缩放，240 处的 `.h` 在桌面/横屏会拉出巨大间距；规范已禁止 `.h`，但存量仍在。
3. **缩放语义模糊**：`.w` 同时用于边长、间距、边框、图标；`.sp` 与系统字体缩放叠加；`.r` 与 `.w` 数值不一致，控件内部比例不可推导。
4. **测试与示例失真**：测试不初始化 ScreenUtil 时因子为 1，组件里 `.w` 等于设计值，测试通过；真机因子 1.78 时同一断言全部失效，导致「测试绿、真机崩」。
5. **全局单例不可控**：ScreenUtil 是全局状态，无法为某个子树单独缩放，也无法做多窗口/嵌入场景。

## 4. 方案总览（三层）

```
业务层  AntTheme(theme: AntThemeData.light(scale: AntScale.auto(context)))
          │
主题层  AntThemeData.scale（唯一因子）── 构造时乘进 seed：fontSize/controlHeight/borderRadius/size/lineWidth…
          │                                   └→ 派生的全部 token（字号阶梯、控件高、间距、圆角）自动跟随
组件层  t.s(12)（零散设计值） / t.fontSize、t.padding（token，已缩放）
```

- **只在 seed 乘一次**：`AntThemeData` 的 70+ 个尺寸 getter 全部来自 seed 与派生函数，因子进 seed 后无需逐个改。
- **零散数值用 `t.s(v)`**：组件里那些 16/12/8/2 的设计值统一走 `t.s()`，读一次主题、无全局单例。
- **独立包天然支持**：包已依赖 `antd_theme`，`t.s()` 与 token 直接可用；不需要每个包实现缩放。

## 5. AntScale API 草案

```dart
/// 统一缩放因子：所有设计值 × factor。
@immutable
class AntScale {
  const AntScale(this.factor) : assert(factor > 0);
  final double factor;

  static const none = AntScale(1);

  /// 按屏幕短边自动推导（移动端）；桌面恒 1。
  factory AntScale.auto(
    BuildContext context, {
    double base = 390,
    double min = 0.9,
    double max = 1.2,
  }) {
    if (AntPlatform.isDesktop) return none;
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    return AntScale((shortest / base).clamp(min, max));
  }

  /// 设计值 → 实际值（组件内唯一入口）。
  double call(num designValue) => designValue * factor;

  AntScale copyWith({double? factor}) => AntScale(factor ?? this.factor);
}
```

主题侧：

```dart
AntThemeData.light({AntSeedToken? seed, AntScale scale = AntScale.none});
// 内部：seed = seed.scaledBy(scale.factor)（新增 AntSeedToken.scaledBy 只乘数值种子）
double get scale => _scale.factor;
double s(num designValue) => designValue * scale;
```

用法：

```dart
// 全局（main.dart）
AntTheme(
  theme: AntThemeData.light(scale: const AntScale(1.0)), // 或 AntScale.auto(context)
  child: MaterialApp(...),
)

// 组件内（替换 12.w / 14.sp / 8.r）
final t = AntTheme.of(context);
padding: EdgeInsets.all(t.s(12)),
fontSize: t.s(14),
borderRadius: BorderRadius.circular(t.s(8)),
```

## 6. 迁移步骤与工作量

| 阶段 | 内容 | 影响面 | 预估 |
|---|---|---|---|
| P0 | `antd_theme` 新增 `AntScale`、`AntSeedToken.scaledBy`、`AntThemeData.scale/s()`；`AntScreenUtilInit` 改为 deprecated 空壳（仅透传 builder，不初始化 ScreenUtil）；新增缩放测试（1.0 与 1.25 两档） | 1 包，无行为变化 | 0.5 天 |
| P1 | codemod `antd_flutter_ui` lib：`123.w` → `t.s(123)`；无 `t` 的 build 里补 `AntTheme.of(context)`；token 已覆盖的重复值顺手收敛到 token | 705 处 / ~90 文件 | 1 天 + 修测试 |
| P2 | 独立包 16 个 + keyboard/picker/table/calendar 等：同 codemod，逐包 analyze/test | 549 处 / ~20 包 | 1–1.5 天 |
| P3 | `example/lib`（1191 处）+ 各包 example main（`AntScreenUtilInit` 移除，改 `AntTheme(scale:)`） | 1191 处 / 110 页 | 1 天（机械） |
| P4 | 删除 `flutter_screenutil` 依赖（根/example/antd_theme）、删除 `ant_screen_util.dart`、`AntResponsive` 改用 `AntScale`、全库 grep 清零 `.w/.h/.sp/.r` | 3 个 pubspec + 2 文件 + 回归 | 0.5 天 |
| P5 | 全量回归：21 包 analyze/test、root example analyze/test、双端真机截图（1.0 / 1.15 各一组） | — | 0.5 天 |

合计约 **4–5 个工作日**，可与其它修复并行推进（按包拆分提交，任何一阶段可回滚）。

## 7. 迁移细节与约定

1. **统一替换规则**
   - `.w` → `t.s(v)`；`.h` → `t.s(v)`（不再有高度轴向）；
   - `.sp` → `t.s(v)`（字号跟随同一因子；系统字体缩放仍由 `MediaQuery.textScaler` 叠加，属无障碍设置，不冲突）；
   - `.r` → `t.s(v)`；边框 1 → `t.s(1)` 或保留 1（发丝线建议固定 1，避免亚像素）。
2. **不允许新增扩展方法**：不保留 `.w/.sp/.r` 别名，避免「换皮不换语义」；所有调用点必须显式 `t.s()`，可 grep 审计。
3. **token 优先**：能用 `t.padding / t.fontSize / t.borderRadius / t.controlHeight` 的地方优先 token，不在组件里复制设计值。
4. **默认值**：`AntThemeData.light()` 的 `scale` 默认 `AntScale.none`（=1.0），保证现有测试与桌面像素不变；移动端示例与正式接入方显式传 `AntScale.auto` 或自定义因子。
5. **测试**：既有断言在 1.0 下不变；新增「scale 1.25 时 Button 高度 40→50、Tabs 高度 40→50、Table 行高按比例」等 3–4 条代表性断言，避免全量双倍测试维护。
6. **独立包边界**：不引入包级缩放配置；同一 `AntTheme` 下所有包共享因子；确有更紧凑需求时，由使用方在局部子树覆盖 `AntTheme`（天然可行）。

## 8. 风险与回滚

| 风险 | 说明 | 缓解 |
|---|---|---|
| codemod 破坏 const 上下文 | `const SizedBox(height: 16.w)` 类写法替换后不能 const | codemod 后 `dart fix` + analyze 兜底；按包小步提交 |
| 视觉回归 | 移动端字号从 14×1.784=25 回到 14×1.0 或 14×1.15，明显变小 | 默认 1.0 与桌面一致；移动端示例传 `AntScale.auto` 再看效果 |
| 平板上过小/过大 | auto 因子按短边 390 基准 clamp 0.9–1.2 | 因子可业务覆盖；文档给出推荐区间 |
| 遗漏调用点 | 2323 处，手工易漏 | grep gate：`\.(w|h|sp|r)\b` 在 CI/脚本中必须为 0（注释除外） |
| 示例视觉变化 | 110 个示例页布局按新因子重排 | 示例本就是演示，允许；按页截图抽查 6–8 页 |

回滚：P0–P3 各自独立提交，`git revert` 单阶段即可；`flutter_screenutil` 依赖在 P4 前不动，随时可退回。

## 9. 待评审决策（需要用户拍板）

1. **默认因子**：默认 1.0 + 业务显式传（推荐，可预测）；还是移动端默认 `AntScale.auto`（≈短边/390，clamp 0.9–1.2）？
2. **auto 基准**：以短边 390（当前设计稿 375×812 的近似）为准可以吗？还是直接用 375？
3. **是否保留 `.w/.sp/.r` 兼容别名一个版本**？推荐不保留（彻底清零，便于审计），但会一次性影响所有下游示例。
4. **字体是否跟随同一因子**（推荐是），无障碍系统字体缩放是否继续叠加（推荐叠加）？
5. **桌面超宽放大**（原 `allowScaleUp/maxScaleFactor`）是否还需要？推荐取消，改为业务手动设置 factor（例如 4K 下传 1.25）。

## 10. 验收标准（执行后）

- `grep -rE "\.(w|h|sp|r)\b" --include=*.dart packages/*/lib example/lib test` 结果为 0（注释/字符串除外）。
- 三个 pubspec 不再含 `flutter_screenutil`；`flutter pub deps` 无该包。
- 全库 analyze 无问题；21 包 + root example 测试全绿。
- 同一示例页在 `scale: 1.0` 与 `scale: 1.25` 下截图，所有控件（含独立包组件）等比变化，无单点错位。
