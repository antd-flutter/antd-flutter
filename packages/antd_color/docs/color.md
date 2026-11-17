# color.md — 颜色操作 API

`AntFastColor` 是颜色操作的核心工具类，精确移植 `@ant-design/fast-color` v3 的 `FastColor`，保证各运算结果与 antd 源码逐一断言对齐。所有 setter 与变换方法均返回新实例，原实例不被修改。

## 使用场景

- hover / active 态颜色的派生（`darken`、`lighten`）；
- 颜色混合与色调调整（`mix`、`tint`、`shade`）；
- 半透明色在不透明背景上的等效合成（`onBackground`）；
- RGB / HSV / HSL 互转及各类格式化输出。

## AntFastColor

### 构造

| 构造函数 | 参数 | 说明 |
| --- | --- | --- |
| `AntFastColor.fromString(input)` | `String input` | 从 hex / `rgb()` / `hsl()` / `hsv()` 字符串构造；hex 支持 `#1677ff`、`1677ff`、`#fff`、`#rrggbbaa`。不支持预设色名，无法识别的输入为全零黑、alpha=1 |
| `AntFastColor.fromRgb(r, g, b, [alpha])` | `int r, g, b`（0-255）、`double? alpha`（0-1） | 通道值超出范围时钳位；`alpha` 为 `null` 时为 1 |
| `AntFastColor.fromHsl(h, s, l, [alpha])` | `double h`（0-360，越界取模）、`s`/`l`（0-1）、`double? alpha` | 从 HSL 值构造 |
| `AntFastColor.fromHsv(h, s, v, [alpha])` | `double h`（0-360，越界取模）、`s`/`v`（0-1）、`double? alpha` | 从 HSV 值构造 |
| `AntFastColor.fromColor(other)` | `AntFastColor other` | 拷贝构造（含 HSV/HSL 缓存） |
| `AntFastColor(input)` / `AntFastColor.of(input)` | `Object input` | 自动判断输入类型（`String`/`AntRgb`/`AntHsl`/`AntHsv`/`AntFastColor`）；其他类型抛出 `ArgumentError` |

### 可变字段

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `r` | `int` | 红色通道（0-255） |
| `g` | `int` | 绿色通道（0-255） |
| `b` | `int` | 蓝色通道（0-255） |
| `a` | `double` | 透明度（0-1） |

### Setter（返回新实例）

| 方法 | 返回值 | 说明 |
| --- | --- | --- |
| `setR(value)` | `AntFastColor` | 修改红色通道（0-255，越界钳位） |
| `setG(value)` | `AntFastColor` | 修改绿色通道（0-255，越界钳位） |
| `setB(value)` | `AntFastColor` | 修改蓝色通道（0-255，越界钳位） |
| `setA(value)` | `AntFastColor` | 修改透明度（0-1，越界钳位） |

### Getter / 查询方法

| 方法 | 返回值 | 说明 |
| --- | --- | --- |
| `getLuminance()` | `double` | WCAG 相对亮度（0-1），可用于文字对比度判断 |
| `getHue()` | `double` | 色相（0-360） |
| `getHsvSaturation()` | `double` | HSV 饱和度（0-1） |
| `getHslSaturation()` | `double` | HSL 饱和度（0-1） |
| `getLightness()` | `double` | HSL 亮度（0-1） |
| `getValue()` | `double` | HSV 明度（0-1） |
| `getBrightness()` | `double` | 感知明亮度（0-255），非 HSB 的 B |
| `isDark()` | `bool` | 明亮度 < 128 时为深色 |
| `isLight()` | `bool` | 明亮度 ≥ 128 时为浅色 |

### 颜色变换

| 方法 | 参数 | 返回值 | 说明 |
| --- | --- | --- | --- |
| `darken([amount])` | `double amount`（0-100，默认 10） | `AntFastColor` | 降低亮度；与 fast-color 一致，使用 HSV 饱和度作为 HSL 饱和度传入 |
| `lighten([amount])` | `double amount`（0-100，默认 10） | `AntFastColor` | 提升亮度；饱和度处理同上 |
| `mix(input, [amount])` | `Object input`（同 `of`）、`double amount`（0-100，默认 50） | `AntFastColor` | 颜色混合；0 为本色，100 为完全取 `input` |
| `tint([amount])` | `double amount`（默认 10） | `AntFastColor` | 与纯白混合 |
| `shade([amount])` | `double amount`（默认 10） | `AntFastColor` | 与纯黑混合 |
| `onBackground(background)` | `Object background`（同 `of`） | `AntFastColor` | alpha blending 合成到背景色上的等效色 |
| `clone()` | — | `AntFastColor` | 克隆 |

### 格式化输出

| 方法 | 返回值 | 说明 |
| --- | --- | --- |
| `toHexString()` | `String` | `#rrggbb`；alpha < 1 时为 `#rrggbbaa` |
| `toRgbString()` | `String` | `rgb(r,g,b)`；alpha ≠ 1 时为 `rgba(r,g,b,a)`（alpha 两位小数精度，与 JS 一致） |
| `toHslString()` | `String` | `hsl(h,s%,l%)`；alpha ≠ 1 时为 `hsla(...)` |
| `toRgb()` | `AntRgb` | RGB 值对象 |
| `toHsl()` | `AntHsl` | HSL 值对象 |
| `toHsv()` | `AntHsv` | HSV 值对象 |

### 运算符

- `==` / `hashCode`：按 `r`、`g`、`b`、`a` 四通道比较。

## AntRgb / AntHsl / AntHsv

颜色模型值对象，均可直接传给 `AntFastColor.of`。

| 字段 | AntRgb | AntHsl | AntHsv |
| --- | --- | --- | --- |
| `h`（色相 0-360） | — | ✔ | ✔ |
| `s`（饱和度 0-1） | — | ✔ | ✔ |
| `l`（亮度 0-1） | — | ✔ | — |
| `v`（明度 0-1） | — | — | ✔ |
| `r`/`g`/`b`（0-255） | ✔ | — | — |
| `a`（透明度 0-1，默认 1） | ✔ | ✔ | ✔ |

## 代码示例

### 基础构造与输出

```dart
final color = AntFastColor('#1677ff');
print(color.toHexString()); // '#1677ff'
print(color.toRgbString()); // 'rgb(22,119,255)'
print(color.isDark()); // false
```

### 派生 hover / active 色

```dart
final base = AntFastColor('#1677ff');
final hover = base.lighten(10); // 常用于 hover 态
final active = base.darken(10); // 常用于 active 态
```

### 混合与透明合成

```dart
final mixed = AntFastColor('#1677ff').mix('#ffffff', 20);
final opaque = AntFastColor.fromRgb(22, 119, 255, 0.5)
    .onBackground('#141414'); // 半透明色在不透明背景上的等效色
```

### 自动类型判断

```dart
final a = AntFastColor.of('#1677ff');
final b = AntFastColor.of(const AntRgb(r: 22, g: 119, b: 255));
final c = AntFastColor.of(const AntHsl(h: 210, s: 0.9, l: 0.54));
print(a == b); // true
```

## 注意事项

1. **与 antd 对齐**：`darken`/`lighten` 使用 HSV 饱和度而非 HSL 饱和度参与计算，这是有意保持与 `@ant-design/fast-color` 行为一致，不要"修复"该差异。
2. **不可变用法**：setter 与变换方法返回新实例，链式调用不会污染原实例；但 `r`/`g`/`b`/`a` 字段本身是可变的，跨模块共享时建议只用返回值。
3. **输入容错**：`fromString` 对无法识别的输入静默回退为黑色，不抛出异常；严格场景请自行校验输入格式。
4. **alpha 精度**：`toRgbString` 中 alpha 按 JS 的两位小数精度输出（如 `0.5`、`0.25`），以保证与 Web 端表现一致。
