# palette.md — 色板生成 API

`antGeneratePalette` 精确移植 `@ant-design/colors` 的 `generate` 函数，从单一种子色生成 10 阶色板（浅→深），并支持暗色主题映射。算法与 antd 官方色板生成完全对齐，适用于动态主题色与暗色主题场景。

## 使用场景

- 用户自定义主题色后生成整套色阶（如标签、徽标、进度条的背景/边框/文字色）；
- 暗色主题下重新映射色板；
- 批量生成 antd 全部预设色的色板。

## API 一览

### `antGeneratePalette`

```dart
List<String> antGeneratePalette(Object color, [AntPaletteOptions? opts])
```

从单一种子色生成 10 阶色板。

**参数**

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `color` | `Object` | 必填 | 种子色，支持 hex 字符串（如 `'#1677FF'`）、`rgb()/hsl()/hsv()` 字符串或 `AntFastColor` 可接受的任意输入 |
| `opts` | `AntPaletteOptions?` | `null` | 可选配置，指定暗色主题及背景色 |

**返回值**

`List<String>` — 长度恒为 10 的 hex 字符串列表，索引 0-9 对应 antd palette 1-10（索引 0 最浅，索引 9 最深，索引 5 即主色）。

**异常**

无法解析的输入按黑色种子处理并正常返回，不抛出异常。

### `AntPaletteOptions`

色板生成选项。

| 字段 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `theme` | `String` | `'default'` | 主题模式：`'dark'` 为暗色主题，其他值为亮色主题 |
| `backgroundColor` | `String?` | `null` | 暗色主题背景色（hex 字符串）；`null` 时使用 antd 默认值 `'#141414'`。仅在 `theme` 为 `'dark'` 时生效 |

### `AntPresetColors`

Ant Design 预设主色种子值，与 antd `seed.ts` 中的 `presetColors` 一致。均为 `static const String`。

| 常量 | 值 | 常量 | 值 |
| --- | --- | --- | --- |
| `blue` | `#1677FF` | `volcano` | `#FA541C` |
| `purple` | `#722ED1` | `orange` | `#FA8C16` |
| `cyan` | `#13C2C2` | `gold` | `#FAAD14` |
| `green` | `#52C41A` | `yellow` | `#FADB14` |
| `magenta` | `#EB2F96` | `lime` | `#A0D911` |
| `pink` | `#EB2F96` | `geekblue` | `#2F54EB` |
| `red` | `#F5222D` | — | — |

另有 `static const Map<String, String> all`：色名 → 种子值映射（`pink` 为废弃别名，等同 `magenta`，仍保留在 `all` 中）。

### `antGeneratePresetPalettes`

```dart
Map<String, List<String>> antGeneratePresetPalettes({
  bool dark = false,
  String? darkBackground,
})
```

生成全部预设色的色板。

**参数**

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `dark` | `bool` | `false` | `true` 时生成暗色主题色板 |
| `darkBackground` | `String?` | `null` | 暗色背景色，`null` 时使用 `'#141414'` |

**返回值**

`Map<String, List<String>>` — 键为色名，每个值为 10 阶色板（索引 0-9 对应 antd palette 1-10）。

## 代码示例

### 亮色色板

```dart
final palette = antGeneratePalette('#1677FF');
print(palette[0]); // 最浅（palette-1）
print(palette[5]); // 主色 '#1677ff'
print(palette[9]); // 最深（palette-10）
```

### 暗色色板

```dart
final dark = antGeneratePalette(
  '#1677FF',
  AntPaletteOptions(theme: 'dark'),
);
// 或自定义背景色
final darkOnBlack = antGeneratePalette(
  '#1677FF',
  AntPaletteOptions(theme: 'dark', backgroundColor: '#000000'),
);
```

### 预设色批量生成

```dart
final all = antGeneratePresetPalettes();
print(all['blue']![5]); // '#1677ff'

final allDark = antGeneratePresetPalettes(dark: true);
```

## 注意事项

1. **算法对齐**：色相按色相区间（60-240 与其余区间）分别正向/负向偏移，饱和度与明度按固定阶梯增减，与 `@ant-design/colors` 逐位对齐；不要调整步长常量，否则会破坏与 antd 的一致性。
2. **暗色映射**：暗色主题通过「亮色色板与背景色按比例混合」实现，混合比例表与 antd `_darkColorMap` 一致；背景色变化会整体影响暗色色板的观感。
3. **索引语义**：返回列表的索引 0-9 直接对应 antd palette 1-10；若需要带语义的包装（主色/hover/active 等），请使用 [`AntColor`](parse.md)。
4. **灰色种子**：饱和度为 0 的灰度色生成时饱和度保持不变，色板为同色系明度渐变。
