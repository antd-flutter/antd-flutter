<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 barrel 变更后重跑 gen-docs 命令 -->

# antd_color API 索引

> 自动生成时间：2026-11-17T13:07:19.169882；共 10 个顶层导出。
>
> antd_color — Ant Design v6 颜色系统
> 
> 精确移植 `@ant-design/fast-color` v3，提供：
> - [AntFastColor] — 颜色操作（明暗、混合、透明度等）
> - [antGeneratePalette] — antd 10 阶色板生成算法
> - [AntColor] — 色板包装，同时提供 hex 与 Flutter [Color] 访问
> - [antParseColor] — CSS 颜色字符串 → Flutter Color
> 
> 文件按 R25/R26 细粒度分层：
> - `src/types/` — 纯数据类型（AntHsv / AntHsl / AntRgb）
> - `src/config/` — 配置类（AntPaletteOptions）
> - 主体实现 — ant_fast_color / ant_color_palette / ant_color 等

## 顶层导出

### 类（7）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntColor` | 类 | Ant Design 色板 |
| `AntFastColor` | 类 | 高性能颜色操作类，支持 RGB / HSV / HSL 互转及 darken / lighten / mix 等操作 |
| `AntHsl` | 类 | HSL 颜色模型值 |
| `AntHsv` | 类 | HSV 颜色模型值 |
| `AntPaletteOptions` | 类 | 色板生成选项 |
| `AntPresetColors` | 类 | Ant Design 预设主色种子值 |
| `AntRgb` | 类 | RGB 颜色模型值 |

### 函数（3）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `antGeneratePalette` | 函数 | 从单一种子色生成 10 阶色板 |
| `antGeneratePresetPalettes` | 函数 | 生成所有预设色板 |
| `antParseColor` | 函数 | 解析 CSS 颜色字符串为 Flutter Color |

## 类 / 枚举成员

### `AntColor`（34 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `AntPresetColors`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntPresetColors._` | 构造 | — |
| `all` | 静态属性 | 所有预设色名 → 种子值映射 |
| `blue` | 静态属性 | — |
| `cyan` | 静态属性 | — |
| `geekblue` | 静态属性 | — |
| `gold` | 静态属性 | — |
| `green` | 静态属性 | — |
| `lime` | 静态属性 | — |
| `magenta` | 静态属性 | — |
| `orange` | 静态属性 | — |
| `pink` | 静态属性 | pink 已废弃，等同 magenta |
| `purple` | 静态属性 | — |
| `red` | 静态属性 | — |
| `volcano` | 静态属性 | — |
| `yellow` | 静态属性 | — |

### `AntFastColor`（39 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `AntPaletteOptions`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `backgroundColor` | 字段 | 暗色主题背景色（hex 字符串） |
| `theme` | 字段 | 主题模式：dark 为暗色主题，其他值（默认 default）为亮色主题 |

### `AntHsv`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `a` | 字段 | 透明度（0-1），默认 1 |
| `h` | 字段 | 色相（0-360） |
| `s` | 字段 | HSV 饱和度（0-1） |
| `v` | 字段 | 明度（0-1） |

### `AntHsl`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `a` | 字段 | 透明度（0-1），默认 1 |
| `h` | 字段 | 色相（0-360） |
| `l` | 字段 | 亮度（0-1） |
| `s` | 字段 | HSL 饱和度（0-1） |

### `AntRgb`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `a` | 字段 | 透明度（0-1），默认 1 |
| `b` | 字段 | 蓝色通道（0-255） |
| `g` | 字段 | 绿色通道（0-255） |
| `r` | 字段 | 红色通道（0-255） |

