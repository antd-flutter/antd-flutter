# P11. packages 现有包 dart 文件细粒度拆分（R25/R26）

- 状态：`[ ]`
- 目标：按规则 R25/R26 对 packages/ 现有包（antd_color / antd_tokens / antd_theme / antd_icons_flutter）的 dart 文件做细粒度拆分——config/、enum/、types/ 按职责分层，禁止配置/枚举/主体堆在一个文件；每包通过 index.dart（或既有 barrel）统一对外 export。**注意：antd_flutter_plus 主包的重构拆分不在此任务（归 P08），本任务只动 packages/ 下现有包**
- 前置依赖：P05 完成合并（antd_theme 有进行中的 AntResponsive/平台下沉改动，避免冲突）

## 步骤
1. 逐包盘点 dart 文件现状：识别单文件内混合的 配置类/枚举/工具函数/主体逻辑
2. 拆分方案：枚举与形态定义独立成 `enum/<name>_type.dart`；配置类独立 `config/<name>_config.dart`；数据类型独立 types 文件；包内 barrel（index.dart 或既有 <pkg>.dart）统一 export 并保持对外 API 完全向后兼容（import 路径变化属包内私有重组，公开导出面不变）
3. 依赖该包的下游（example/主包/其他包）import 检查：因 barrel 不变，下游原则上零改动；若下游直接 import 了包内具体文件路径则改引 barrel
4. 每包拆分后：flutter analyze 零问题 + flutter test 全量通过（本地已可跑）
5. 逐包提交：`refactor(<pkg>): dart 文件按 R25/R26 细粒度拆分，barrel 统一导出`

## 验收标准
- [ ] 无单文件混合配置/枚举/主体的堆叠结构
- [ ] 每包 index/barrel 统一导出，公开 API 向后兼容（下游零破坏）
- [ ] 四包 analyze 零问题、测试全量通过
- [ ] antd_flutter_plus 主包未被触碰（归 P08）

## 备注
- 拆分粒度以「skill/工具可按文件独立读取」为准绳，过碎（单枚举一文件已达标）与过粗（多职责混居）都避免
- antd_theme 需等 P05 的 AntResponsive/平台文件落地后再拆，避免同文件冲突
