<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntShadowTokens

> 种类：类

```dart
class AntShadowTokens
```

Ant Design 阴影令牌集。

使用场景：
- 弹出层（Dropdown / Tooltip / Popover / Modal）使用 `boxShadow`；
- Card、Drawer（四个方向）、Tabs 溢出渐隐使用对应方向令牌；
- 暗色主题切换时用暗色阴影基色（`rgba(255, 255, 255, 0.2)`）重新生成。

注意：
- 仅能通过 `AntShadowTokens.generate` 创建，保证所有令牌来自同一基色；
- 颜色生成特意经过 CSS 字符串序列化（而非直接构造 `Color`），以复现
  antd `_formatAlpha` 的两位小数舍入（如暗色 `0.2 × 0.08 → 0.02`），
  请勿改为直接计算；
- `antd_theme` 在装配主题时按亮暗模式自动生成，业务代码一般直接从
  主题读取，无需自行调用 `AntShadowTokens.generate`。

## 构造函数

### `AntShadowTokens._({required this.boxShadow, required this.boxShadowSecondary, required this.boxShadowTertiary, required this.boxShadowPopoverArrow, required this.boxShadowCard, required this.boxShadowDrawerRight, required this.boxShadowDrawerLeft, required this.boxShadowDrawerUp, required this.boxShadowDrawerDown, required this.boxShadowTabsOverflowLeft, required this.boxShadowTabsOverflowRight, required this.boxShadowTabsOverflowTop, required this.boxShadowTabsOverflowBottom})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `boxShadow` | `List<BoxShadow>` | 可选 | — |
| `boxShadowSecondary` | `List<BoxShadow>` | 可选 | — |
| `boxShadowTertiary` | `List<BoxShadow>` | 可选 | — |
| `boxShadowPopoverArrow` | `List<BoxShadow>` | 可选 | — |
| `boxShadowCard` | `List<BoxShadow>` | 可选 | — |
| `boxShadowDrawerRight` | `List<BoxShadow>` | 可选 | — |
| `boxShadowDrawerLeft` | `List<BoxShadow>` | 可选 | — |
| `boxShadowDrawerUp` | `List<BoxShadow>` | 可选 | — |
| `boxShadowDrawerDown` | `List<BoxShadow>` | 可选 | — |
| `boxShadowTabsOverflowLeft` | `List<BoxShadow>` | 可选 | — |
| `boxShadowTabsOverflowRight` | `List<BoxShadow>` | 可选 | — |
| `boxShadowTabsOverflowTop` | `List<BoxShadow>` | 可选 | — |
| `boxShadowTabsOverflowBottom` | `List<BoxShadow>` | 可选 | — |

### `AntShadowTokens.generate(String colorShadow)`

从阴影基色生成阴影令牌集。

与 antd `alias.ts` 一致:
```ts
const shadowBaseColor = new FastColor(mergedToken.colorShadow);
const shadowBaseAlpha = shadowBaseColor.a;
const getShadowColor = (alpha) =>
  shadowBaseColor.clone().setA(shadowBaseAlpha * alpha).toRgbString();
```

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `colorShadow` | `String` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `boxShadow` | `List<BoxShadow>` | 弹出层主阴影 |
| `boxShadowCard` | `List<BoxShadow>` | Card 阴影 |
| `boxShadowDrawerDown` | `List<BoxShadow>` | Drawer 下方阴影 |
| `boxShadowDrawerLeft` | `List<BoxShadow>` | Drawer 左侧阴影 |
| `boxShadowDrawerRight` | `List<BoxShadow>` | Drawer 右侧阴影 |
| `boxShadowDrawerUp` | `List<BoxShadow>` | Drawer 上方阴影 |
| `boxShadowPopoverArrow` | `List<BoxShadow>` | Popover 箭头阴影 |
| `boxShadowSecondary` | `List<BoxShadow>` | 弹出层次级阴影 |
| `boxShadowTabsOverflowBottom` | `List<BoxShadow>` | Tabs 下溢出阴影 |
| `boxShadowTabsOverflowLeft` | `List<BoxShadow>` | Tabs 左溢出阴影 |
| `boxShadowTabsOverflowRight` | `List<BoxShadow>` | Tabs 右溢出阴影 |
| `boxShadowTabsOverflowTop` | `List<BoxShadow>` | Tabs 上溢出阴影 |
| `boxShadowTertiary` | `List<BoxShadow>` | 三级阴影（轻量浮起） |

