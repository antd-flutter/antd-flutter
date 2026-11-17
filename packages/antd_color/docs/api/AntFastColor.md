<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFastColor

> 种类：类

```dart
class AntFastColor
```

高性能颜色操作类，支持 RGB / HSV / HSL 互转及 darken / lighten / mix 等操作。

与 `@ant-design/fast-color` 的 `FastColor` 行为完全一致。
所有 setter 与颜色变换方法均返回新实例，原实例不可变地保留。

使用场景：
- hover / active 态颜色的派生（`darken`、`lighten`）；
- 颜色混合与色调调整（`mix`、`tint`、`shade`）；
- 半透明色在不透明背景上的等效合成（`onBackground`）；
- RGB / HSV / HSL 互转及各类格式化输出。

注意：
- 跨模块共享时建议只使用返回值链式调用，不要直接修改 `r` / `g` / `b` / `a` 字段；
- `AntFastColor.fromString` 对无法识别的输入静默回退为黑色，
  严格场景请自行校验输入格式；
- 输出字符串的 alpha 按两位小数精度序列化（如 `0.5`、`0.25`），
  以保证与 Web 端表现一致。

```dart
final color = AntFastColor('#1677ff');
print(color.toHexString()); // '#1677ff'
print(color.darken(10).toHexString()); // 加深后的 hex
print(color.isDark()); // false
```

## 构造函数

### `AntFastColor(Object input)`

便捷工厂：自动判断输入类型，等同于 `AntFastColor.of`。

`input` 可为 `String`（hex/rgb/hsl/hsv）、`AntRgb`、`AntHsl`、
`AntHsv` 或 `AntFastColor`。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `input` | `Object` | 可选 | 可为 `String`（hex/rgb/hsl/hsv）、`AntRgb`、`AntHsl`、 |

### `AntFastColor.fromColor(AntFastColor other)`

从另一个 `AntFastColor` 拷贝构造（含 HSV/HSL 缓存）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `other` | `AntFastColor` | 可选 | — |

### `AntFastColor.fromHsl(double h, double s, double l, [double? alpha])`

从 HSL 值构造。

`h` 为色相（0-360，越界自动取模），`s` 为 HSL 饱和度（0-1），
`l` 为亮度（0-1），`alpha` 为透明度（0-1，`null` 时为 1）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `h` | `double` | 可选 | 为色相（0-360，越界自动取模），`s` 为 HSL 饱和度（0-1）， |
| `s` | `double` | 可选 | — |
| `l` | `double` | 可选 | 为亮度（0-1），`alpha` 为透明度（0-1，`null` 时为 1）。 |
| `alpha` | `double?` | 可选 | — |

### `AntFastColor.fromHsv(double h, double s, double v, [double? alpha])`

从 HSV 值构造。

`h` 为色相（0-360，越界自动取模），`s` 为 HSV 饱和度（0-1），
`v` 为明度（0-1），`alpha` 为透明度（0-1，`null` 时为 1）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `h` | `double` | 可选 | 为色相（0-360，越界自动取模），`s` 为 HSV 饱和度（0-1）， |
| `s` | `double` | 可选 | — |
| `v` | `double` | 可选 | 为明度（0-1），`alpha` 为透明度（0-1，`null` 时为 1）。 |
| `alpha` | `double?` | 可选 | — |

### `AntFastColor.fromRgb(int r, int g, int b, [double? alpha])`

从 RGB 值构造。

`r`、`g`、`b` 为 0-255 通道值，超出范围时被钳位到边界；
`alpha` 为 0-1 透明度，超出范围时钳位，传入 `null` 时为 1（不透明）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `r` | `int` | 可选 | 、`g`、`b` 为 0-255 通道值，超出范围时被钳位到边界； |
| `g` | `int` | 可选 | — |
| `b` | `int` | 可选 | — |
| `alpha` | `double?` | 可选 | 为 0-1 透明度，超出范围时钳位，传入 `null` 时为 1（不透明）。 |

### `AntFastColor.fromString(String input)`

从 hex / rgb / hsl / hsv 字符串构造。

`input` 支持以下格式（允许前导/尾随空白）：
- hex：`#1677ff`、`1677ff`、`#fff`、`#rrggbbaa`；
- `rgb(r,g,b)` / `rgba(r,g,b,a)`，分量支持百分比；
- `hsl(h,s%,l%)` / `hsla(...)`；
- `hsv(h,s%,v%)` / `hsb(...)`。

不支持预设色名（如 `red`）；无法识别的输入保持全零黑、alpha 为 1。
便捷写法可使用 `AntFastColor.of`。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `input` | `String` | 可选 | 支持以下格式（允许前导/尾随空白）： - hex：`#1677ff`、`1677ff`、`#fff`、`#rrggbbaa`； - `rgb(r,g,b)` / `rgba(r,g,b,a)`，分量支持百分比； - `hsl(h,s%,l%)` / `hsla(...)`； - `hsv(h,s%,v%)` / `hsb(...)`。 |

### `AntFastColor.of(Object input)`

通用工厂：自动判断输入类型。

`input` 可为 `String`、`AntRgb`、`AntHsl`、`AntHsv` 或 `AntFastColor`；
其他类型抛出 `ArgumentError`。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `input` | `Object` | 可选 | 可为 `String`、`AntRgb`、`AntHsl`、`AntHsv` 或 `AntFastColor`； 其他类型抛出 `ArgumentError`。 |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_h` | `double?` | — |
| `_hslS` | `double?` | — |
| `_hsvS` | `double?` | — |
| `_l` | `double?` | — |
| `_max` | `int?` | — |
| `_min` | `int?` | — |
| `_v` | `double?` | — |
| `a` | `double` | 透明度 (0-1) |
| `b` | `int` | 蓝色通道 (0-255) |
| `g` | `int` | 绿色通道 (0-255) |
| `r` | `int` | 红色通道 (0-255) |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | 判断颜色是否相等 |
| `_cloneWith` | `AntFastColor` | — |
| `_fromHexString` | `void` | — |
| `_fromHsl` | `void` | — |
| `_fromHslString` | `void` | — |
| `_fromHsv` | `void` | — |
| `_fromHsvString` | `void` | — |
| `_fromRgbString` | `void` | — |
| `_getMax` | `int` | — |
| `_getMin` | `int` | — |
| `clone` | `AntFastColor` | 克隆 |
| `darken` | `AntFastColor` | 降低亮度 |
| `getBrightness` | `double` | 感知明亮度 (0-255)，非 HSB 的 B |
| `getHslSaturation` | `double` | HSL 饱和度 (0-1) |
| `getHsvSaturation` | `double` | HSV 饱和度 (0-1) |
| `getHue` | `double` | 色相 (0-360) |
| `getLightness` | `double` | HSL 亮度 (0-1) |
| `getLuminance` | `double` | 感知亮度 (0-1)，WCAG 相对亮度 |
| `getValue` | `double` | HSV 明度 (0-1) |
| `isDark` | `bool` | 是否为深色 |
| `isLight` | `bool` | 是否为浅色 |
| `lighten` | `AntFastColor` | 提升亮度 |
| `mix` | `AntFastColor` | 与另一个颜色混合 |
| `onBackground` | `AntFastColor` | 在背景色上合成（alpha blending） |
| `setA` | `AntFastColor` | 返回修改透明度后的新实例 |
| `setB` | `AntFastColor` | 返回修改蓝色通道后的新实例 |
| `setG` | `AntFastColor` | 返回修改绿色通道后的新实例 |
| `setR` | `AntFastColor` | 返回修改红色通道后的新实例 |
| `shade` | `AntFastColor` | 与纯黑混合 |
| `tint` | `AntFastColor` | 与纯白混合 |
| `toHexString` | `String` | 输出 hex 字符串 #rrggbb |
| `toHsl` | `AntHsl` | 输出 HSL 对象 |
| `toHslString` | `String` | 输出 HSL CSS 字符串 |
| `toHsv` | `AntHsv` | 输出 HSV 对象 |
| `toRgb` | `AntRgb` | 输出 RGB 对象 |
| `toRgbString` | `String` | 输出 RGB CSS 字符串 rgb(r,g,b) 或 rgba(r,g,b,a) |
| `toString` | `String` | — |
| `_formatAlpha` | `String` | — |

