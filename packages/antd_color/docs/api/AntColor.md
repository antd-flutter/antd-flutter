<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntColor

> 种类：类

```dart
class AntColor
```

Ant Design 色板。

封装 antd ColorMap（1-10 步阶）的色板数据，
同时提供 hex 字符串与 Flutter `Color` 两种访问方式。
亮色与暗色主题分别通过 `AntColor.fromSeed` 与 `AntColor.fromSeedDark` 生成，
步阶语义与 antd Token（如 `colorPrimaryBg`、`colorPrimaryHover`）一一对应。

使用场景：从种子色生成主题色板后，按语义取色——
`colorPrimaryBg`（第 1 阶）、`colorPrimaryHover`（第 5 阶）、
`colorPrimary`（第 6 阶）、`colorPrimaryActive`（第 7 阶）等；
需要暗色 Token 映射时优先使用 `AntColor.fromSeedDark`，不要直接复用亮色色板。
亮色主题步阶 8-10 复用第 5-7 阶是 antd 亮色映射的既定行为，非重复计算错误。

```dart
final palette = AntColor.fromSeed('#1677FF');
print(palette.main); // 第 6 阶 hex，如 '#1677ff'
print(palette.mainColor); // 对应的 Flutter Color
print(palette[3]); // 按步阶号取 hex
```

## 构造函数

### `AntColor._(this._palette)`

从已映射的 10 阶色板构造。

`palette` 长度必须为 10，顺序为 antd ColorMap 1-10。

### `AntColor.fromMapped(List<String> mapped)`

直接从 10 阶映射后的色板构造。

`mapped` 必须恰好包含 10 个 hex 字符串，顺序为步阶 1-10；
长度不符时在调试模式触发断言失败。构造后的色板不可修改。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `mapped` | `List<String>` | 可选 | 必须恰好包含 10 个 hex 字符串，顺序为步阶 1-10； 长度不符时在调试模式触发断言失败。构造后的色板不可修改。 |

### `AntColor.fromRawPalette(List<String> raw)`

从原始 generate() 输出直接构造（亮色映射）。

`raw` 为 `antGeneratePalette` 的亮色输出（长度 10），按 antd 亮色映射
规则重排为 1-10 步阶；超出前 7 位的元素被忽略。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `raw` | `List<String>` | 可选 | 为 `antGeneratePalette` 的亮色输出（长度 10），按 antd 亮色映射 规则重排为 1-10 步阶；超出前 7 位的元素被忽略。 |

### `AntColor.fromRawPaletteDark(List<String> raw)`

从原始 generate() 输出直接构造（暗色映射）。

`raw` 为 `antGeneratePalette` 暗色主题（`theme: 'dark'`）的输出，
按antd 暗色映射规则重排为 1-10 步阶。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `raw` | `List<String>` | 可选 | 为 `antGeneratePalette` 暗色主题（`theme: 'dark'`）的输出， 按antd 暗色映射规则重排为 1-10 步阶。 |

### `AntColor.fromSeed(String seedColor)`

从种子色生成亮色主题色板。

`seedColor` 为种子色 hex 字符串（如 `'#1677FF'`），对应 antd 默认主题下
由 `generate()` 亮色输出映射出的 10 阶色板（步阶 8-10 复用第 5-7 阶）。

```dart
final palette = AntColor.fromSeed('#1677FF');
```

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seedColor` | `String` | 可选 | 为种子色 hex 字符串（如 `'#1677FF'`），对应 antd 默认主题下 由 `generate()` 亮色输出映射出的 10 阶色板（步阶 8-10 复用第 5-7 阶）。 |

### `AntColor.fromSeedDark(String seedColor, {String? background})`

从种子色生成暗色主题色板。

`seedColor` 为种子色 hex 字符串；`background` 为暗色背景色 hex 字符串，
传入 `null` 时使用 antd 默认暗色背景 `#141414`。

```dart
final dark = AntColor.fromSeedDark('#1677FF');
```

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seedColor` | `String` | 可选 | 为种子色 hex 字符串；`background` 为暗色背景色 hex 字符串， 传入 `null` 时使用 antd 默认暗色背景 `#141414`。 |
| `background` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_palette` | `List<String>` | 10 阶色板 hex 字符串列表 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |
| `main` | `String` | 主色（第 6 阶），即 antd 的 colorPrimary |
| `mainColor` | `Color` | 主色 Flutter Color |
| `palette` | `List<String>` | 原始色板列表（步阶 1-10 顺序的 hex 字符串，只读视图） |
| `step1` | `String` | 第 1 阶（最浅），对应 antd colorPrimaryBg 等 |
| `step10` | `String` | 第 10 阶（最深），用于文本/图标强调（亮色主题下与第 7 阶同值） |
| `step10Color` | `Color` | 第 10 阶 Flutter Color |
| `step1Color` | `Color` | 第 1 阶 Flutter Color |
| `step2` | `String` | 第 2 阶，对应 antd colorPrimaryBgHover 等浅色背景场景 |
| `step2Color` | `Color` | 第 2 阶 Flutter Color |
| `step3` | `String` | 第 3 阶，对应 antd colorPrimaryBorder 等边框场景 |
| `step3Color` | `Color` | 第 3 阶 Flutter Color |
| `step4` | `String` | 第 4 阶，对应 antd colorPrimaryBorderHover 等边框悬浮场景 |
| `step4Color` | `Color` | 第 4 阶 Flutter Color |
| `step5` | `String` | 第 5 阶，对应 antd colorPrimaryHover 等 |
| `step5Color` | `Color` | 第 5 阶 Flutter Color |
| `step6` | `String` | 第 6 阶（主色），对应 antd colorPrimary 等 |
| `step6Color` | `Color` | 第 6 阶 Flutter Color（主色） |
| `step7` | `String` | 第 7 阶，对应 antd colorPrimaryActive 等激活态场景 |
| `step7Color` | `Color` | 第 7 阶 Flutter Color |
| `step8` | `String` | 第 8 阶，用于深色填充/悬浮态（亮色主题下与第 5 阶同值） |
| `step8Color` | `Color` | 第 8 阶 Flutter Color |
| `step9` | `String` | 第 9 阶，用于更深填充态（亮色主题下与第 6 阶同值） |
| `step9Color` | `Color` | 第 9 阶 Flutter Color |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `[]` | `String` | 按步阶号获取 hex 字符串（1-10） |
| `colorAt` | `Color` | 按步阶号获取 Flutter Color（1-10） |
| `toString` | `String` | — |
| `_listEquals` | `bool` | — |

