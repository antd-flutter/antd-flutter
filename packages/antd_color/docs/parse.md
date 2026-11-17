# parse.md — 颜色解析与色板包装 API

本部分包含两个入口：`antParseColor` 负责 CSS 颜色字符串到 Flutter `Color` 的解析；`AntColor` 是 10 阶色板的语义化包装，同时提供 hex 字符串与 Flutter `Color` 两种访问方式，步阶语义与 antd Token 一一对应。

## 使用场景

- 将设计稿/后端下发的 CSS 颜色值直接转为 Flutter `Color`；
- 从种子色生成主题色板后，按 `colorPrimaryBg`（第 1 阶）、`colorPrimaryHover`（第 5 阶）、`colorPrimary`（第 6 阶）、`colorPrimaryActive`（第 7 阶）等语义取色；
- 支持亮色与暗色两套主题。

## API 一览

### `antParseColor`

```dart
Color antParseColor(String cssColor)
```

解析 CSS 颜色字符串为 Flutter `Color`。

**参数**

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `cssColor` | `String` | 必填 | 待解析字符串，支持 `#rgb`、`#rrggbb`、`#rrggbbaa`（可省略 `#`）、`rgb(r,g,b)`、`rgba(r,g,b,a)`；前导/尾随空白被忽略 |

**返回值**

`Color` — 解析结果。`#rrggbbaa` 格式的第 1 个字节作为 alpha（`00` 为全透明）。

**异常**

不抛出异常；格式无法识别或通道缺失时返回不透明黑色（`#000000`）作为兜底值。

### `AntColor`

Ant Design 色板包装类，封装 antd ColorMap（1-10 步阶）。

**构造**

| 工厂构造函数 | 参数 | 说明 |
| --- | --- | --- |
| `AntColor.fromSeed(seedColor)` | `String seedColor` | 从种子色生成亮色主题色板（步阶 8-10 复用第 5-7 阶，与 antd 亮色映射一致） |
| `AntColor.fromSeedDark(seedColor, {background})` | `String seedColor`、`String? background` | 从种子色生成暗色主题色板；`background` 为 `null` 时使用 `'#141414'` |
| `AntColor.fromRawPalette(raw)` | `List<String> raw` | 从 `antGeneratePalette` 亮色输出直接构造（按亮色映射重排） |
| `AntColor.fromRawPaletteDark(raw)` | `List<String> raw` | 从 `antGeneratePalette` 暗色输出直接构造（按暗色映射重排） |
| `AntColor.fromMapped(mapped)` | `List<String> mapped` | 从已映射的 10 阶色板构造；长度必须为 10（调试模式断言），构造后只读 |

**步阶访问（hex）**

| 成员 | 说明 |
| --- | --- |
| `step1` | 第 1 阶（最浅），对应 `colorPrimaryBg` |
| `step2` | 第 2 阶，对应 `colorPrimaryBgHover` |
| `step3` | 第 3 阶，对应 `colorPrimaryBorder` |
| `step4` | 第 4 阶，对应 `colorPrimaryBorderHover` |
| `step5` | 第 5 阶，对应 `colorPrimaryHover` |
| `step6` / `main` | 第 6 阶（主色），对应 `colorPrimary` |
| `step7` | 第 7 阶，对应 `colorPrimaryActive` |
| `step8`-`step10` | 深色填充/强调态（亮色主题下分别为第 5-7 阶同值） |
| `operator [](step)` | 按步阶号（1-10）取 hex；越界抛出 `RangeError` |
| `palette` | 步阶 1-10 顺序的 hex 列表（只读视图） |

**步阶访问（Flutter `Color`）**

`step1Color`-`step10Color`、`mainColor`、`colorAt(step)` 与上表一一对应，返回 `Color` 类型。

**运算符与相等性**

- `==` / `hashCode`：按 10 阶 hex 列表逐位比较。

## 代码示例

### 解析 CSS 颜色

```dart
final primary = antParseColor('#1677FF'); // Color(0xFF1677FF)
final semi = antParseColor('rgba(22, 119, 255, 0.5)');
final invalid = antParseColor('not-a-color'); // 不透明黑色兜底
```

### 亮色主题色板

```dart
final palette = AntColor.fromSeed('#1677FF');
print(palette.main); // 主色 hex
print(palette.mainColor); // 主色 Color
print(palette.step1); // colorPrimaryBg 对应色
print(palette[3]); // 按步阶号取 hex
```

### 暗色主题色板

```dart
final dark = AntColor.fromSeedDark('#1677FF');
final darkCustom = AntColor.fromSeedDark('#1677FF', background: '#000000');
```

### 常见组合：从色板派生主题

```dart
final palette = AntColor.fromSeed(AntPresetColors.blue);

final primary = palette.mainColor;
final hover = palette.step5Color; // 按钮悬浮态
final active = palette.step7Color; // 按钮激活态
final bg = palette.step1Color; // 浅色背景
final borderColor = palette.step3Color; // 边框
```

## 注意事项

1. **亮色映射特性**：`AntColor.fromSeed` 的步阶 8、9、10 分别复用第 5、6、7 阶色值，这是 antd 亮色映射的既定行为，不是重复计算错误。
2. **解析容错**：`antParseColor` 失败时静默返回黑色，便于容错但可能掩盖格式错误；对外部输入建议先做格式校验或对比解析结果。
3. **`fromMapped` 长度约束**：长度不为 10 时在调试模式触发断言，release 模式下越界访问会抛出 `RangeError`。
4. **暗色主题**：需要暗色 Token 映射时优先使用 `fromSeedDark` / `fromRawPaletteDark`，不要直接复用亮色色板。
