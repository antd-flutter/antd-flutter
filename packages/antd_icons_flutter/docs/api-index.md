<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 barrel 变更后重跑 gen-docs 命令 -->

# antd_icons_flutter API 索引

> 自动生成时间：2026-11-17T13:07:22.810386；共 3 个顶层导出。
>
> antd_icons_flutter — Ant Design 图标库
> 
> 850+ 图标，三种风格全覆盖：
> - **Outlined**（线框）447 个 + **Filled**（实心）251 个 — TTF 字体模式
> - **TwoTone**（双色）150 个 — SVG 资产 + flutter_svg 渲染
> 
> 包体积说明：Outlined/Filled 打包为单一 TTF 字体（不按码点裁剪），
> TwoTone 为全量 SVG 资产，详见 [AntIcons] 与 [AntIconsTwotone] 的类级文档。
> 
> 用法：
> ```dart
> // 方式一：统一 AntdIcon 组件（推荐）
> AntdIcon(AntIcons.checkOutlined)
> AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red)
> 
> // 方式二：TTF 图标直接用 Flutter Icon
> Icon(AntIcons.searchOutlined, size: 24, color: Colors.blue)
> ```

## 顶层导出

### 类（3）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntIcons` | 类 | Ant Design 图标集（TTF 字体模式） |
| `AntIconsTwotone` | 类 | Ant Design TwoTone 双色图标集（SVG 资产路径） |
| `AntdIcon` | 类 | Ant Design 统一图标组件 |

## 类 / 枚举成员

### `AntIcons`（700 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `AntIconsTwotone`（151 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `AntdIcon`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | 方法 | — |
| `color` | 字段 | 图标颜色，仅 TTF 字体模式生效 |
| `icon` | 字段 | 图标定义，决定渲染模式 |
| `semanticLabel` | 字段 | 语义标签（无障碍），供屏幕阅读器朗读 |
| `size` | 字段 | 图标尺寸（逻辑像素），默认值因模式而异 |
| `twoToneColor` | 字段 | TwoTone 主色（仅 TwoTone SVG 模式生效） |

