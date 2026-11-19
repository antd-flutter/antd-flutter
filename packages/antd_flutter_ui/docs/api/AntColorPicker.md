<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntColorPicker

> 种类：类

```dart
class AntColorPicker
```

颜色选择器组件

## 构造函数

### `AntColorPicker({super.key, this.value, this.defaultValue, this.onChange, this.onChangeComplete, this.disabled = false, this.size = AntColorPickerSize.middle, this.showText = false, this.format = AntColorFormat.hex, this.presets = const [], this.disabledAlpha = false, this.allowClear = false, this.open, this.defaultOpen = false, this.onOpenChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `void Function(String? color)?` | 可选 | — |
| `onChangeComplete` | `void Function(String? color)?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `size` | `AntColorPickerSize` | = AntColorPickerSize.middle | — |
| `showText` | `bool` | = false | — |
| `format` | `AntColorFormat` | = AntColorFormat.hex | — |
| `presets` | `List<AntColorPreset>` | = const [] | — |
| `disabledAlpha` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `open` | `bool?` | 可选 | — |
| `defaultOpen` | `bool` | = false | — |
| `onOpenChange` | `void Function(bool open)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 允许清空 |
| `defaultOpen` | `bool` | 非受控：面板初始是否打开 |
| `defaultValue` | `String?` | 非受控：颜色初始值（hex 格式） |
| `disabled` | `bool` | 是否禁用 |
| `disabledAlpha` | `bool` | 禁用透明度 |
| `format` | `AntColorFormat` | 颜色格式 |
| `onChange` | `void Function(String? color)?` | 颜色变化回调 |
| `onChangeComplete` | `void Function(String? color)?` | 颜色选择完成回调（面板关闭或松手时触发） |
| `onOpenChange` | `void Function(bool open)?` | 面板打开/关闭回调 |
| `open` | `bool?` | 受控：面板是否打开 |
| `presets` | `List<AntColorPreset>` | 预设颜色 |
| `showText` | `bool` | 是否显示颜色文本 |
| `size` | `AntColorPickerSize` | 尺寸 |
| `value` | `String?` | 受控：颜色值（hex 格式，如 '#1677ff'） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntColorPicker>` | — |

