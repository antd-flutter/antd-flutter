<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPaletteOptions

> 种类：类

```dart
class AntPaletteOptions
```

色板生成选项。

用于控制 `antGeneratePalette` 的主题模式与暗色背景色。

```dart
final opts = AntPaletteOptions(theme: 'dark', backgroundColor: '#000000');
final palette = antGeneratePalette('#1677FF', opts);
```

## 构造函数

### `AntPaletteOptions({this.theme = 'default', this.backgroundColor})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `theme` | `String` | = 'default' | — |
| `backgroundColor` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `backgroundColor` | `String?` | 暗色主题背景色（hex 字符串） |
| `theme` | `String` | 主题模式：dark 为暗色主题，其他值（默认 default）为亮色主题 |

