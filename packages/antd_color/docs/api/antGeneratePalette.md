<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGeneratePalette

> 种类：函数

```dart
List<String> antGeneratePalette(Object color, [AntPaletteOptions? opts])
```

从单一种子色生成 10 阶色板。

与 `@ant-design/colors` 的 `generate` 函数行为完全一致：
前 5 阶在种子色基础上提升亮度、降低饱和度（浅色），
第 6 阶为种子色本身，后 4 阶降低亮度（深色）。

`color` 为种子色，支持 hex 字符串（如 `'#1677FF'`）、
`rgb()/hsl()/hsv()` 字符串或任意 `AntFastColor` 可接受的输入。
`opts` 为可选的 `AntPaletteOptions`，用于指定暗色主题及背景色。

返回长度为 10 的 hex 字符串列表，索引 0-9 对应 antd 的 palette 1-10
（索引 0 最浅，索引 9 最深）。无法解析的输入按黑色种子处理，不抛出异常。

注意：阶梯常量（色相 / 饱和度 / 明度步长）与 antd `generate` 逐位对齐，
请勿"顺手优化"，否则会破坏与 antd Web 端色板的一致性；
灰度种子（饱和度为 0）生成时饱和度保持不变，色板为同色系明度渐变。
需要带语义的包装（主色 / hover / active）时，使用 `AntColor`。

```dart
final light = antGeneratePalette('#1677FF');
print(light[5]); // 主色 '#1677ff'

final dark = antGeneratePalette(
  '#1677FF',
  AntPaletteOptions(theme: 'dark'),
);
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `color` | `Object` | 可选 | 为种子色，支持 hex 字符串（如 `'#1677FF'`）、 `rgb()/hsl()/hsv()` 字符串或任意 `AntFastColor` 可接受的输入。 |
| `opts` | `AntPaletteOptions?` | 可选 | 为可选的 `AntPaletteOptions`，用于指定暗色主题及背景色。 |

返回 `List<String>`。

