<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPresetColors

> 种类：类

```dart
class AntPresetColors
```

Ant Design 预设主色种子值。

与 antd `components/theme/themes/seed.ts` 中的 `presetColors` 一致。
每个常量为该预设色的种子 hex 值，可直接传给 `antGeneratePalette`
或 `AntColor.fromSeed` 生成对应色板。

```dart
final palette = antGeneratePalette(AntPresetColors.blue);
```

## 构造函数

### `AntPresetColors._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `all` | `Map<String, String>` | 所有预设色名 → 种子值映射 |
| `blue` | `String` | — |
| `cyan` | `String` | — |
| `geekblue` | `String` | — |
| `gold` | `String` | — |
| `green` | `String` | — |
| `lime` | `String` | — |
| `magenta` | `String` | — |
| `orange` | `String` | — |
| `pink` | `String` | pink 已废弃，等同 magenta |
| `purple` | `String` | — |
| `red` | `String` | — |
| `volcano` | `String` | — |
| `yellow` | `String` | — |

