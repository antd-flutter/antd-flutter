# gen-docs 文档生成命令

> 触发词：生成文档/gen-docs/文档校验

## 用途

一条命令完成 packages 各包的双轨文档机械部分：`dart doc` HTML 产出、公开 API 索引生成（`docs/api-index.md`）、人工文档与实际导出 API 的一致性校验。

## 用法

```bash
./scripts/gen_docs.sh                      # 全部包：dart doc + api-index 生成 + 一致性校验
./scripts/gen_docs.sh --pkg antd_tokens    # 指定单包
./scripts/gen_docs.sh --check-only         # 仅一致性校验，不生成文件（校验失败退出码 1）
```

Windows：`scripts\gen_docs.bat`（参数一致，内部转发 ps1）。

## 产出

- 各包 `doc/api/`：dart doc HTML（已 gitignore）
- 各包 `docs/api-index.md`：按分类分组的公开 API 表（名称/类型/`///` 首句摘要），与源码机械同步

## 一致性校验

- 比对 barrel 实际导出的公开 API（PascalCase `Ant*`）与人工 `docs/*.md` 中覆盖的 API
- 输出「缺失」（新 API 未写人工文档）与「多余」（文档提及但不存在）清单
- 校验不通过退出码 1，可作本地检查或 CI 步骤

## 边界与注意事项

- 核心 extractor：`scripts/gen_docs_extract.dart`（package:analyzer 解析 barrel 传递导出，含 show/hide 组合器）
- 一致性校验仅提示缺失/多余，**不自动改写人工内容**；简介/场景/注意事项等非机械部分必须人工撰写
- 无人工 docs/*.md 的包自动跳过一致性校验（如 antd_theme 建立人工文档后自动生效）
- Windows 端 .ps1 已按与 .sh 逐段一致实现，本机无 pwsh 未运行验证，异常时优先对照 .sh 排查
