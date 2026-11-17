<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antGeneratePresetPalettes

> 种类：函数

```dart
Map<String, List<String>> antGeneratePresetPalettes({bool dark = false, String? darkBackground})
```

生成所有预设色板。

`dark` 为 `true` 时生成暗色主题色板；`darkBackground` 为暗色背景色，
`null` 时使用 antd 默认暗色背景 `#141414`。

返回 `Map<String, List<String>>`，键为色名，每个值为 10 阶色板
（索引 0-9 对应 antd palette 1-10）。

```dart
final all = antGeneratePresetPalettes();
print(all['blue']![5]); // '#1677ff'
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `dark` | `bool` | = false | 为 `true` 时生成暗色主题色板；`darkBackground` 为暗色背景色， `null` 时使用 antd 默认暗色背景 `#141414`。 |
| `darkBackground` | `String?` | 可选 | — |

返回 `Map<String, List<String>>`。

