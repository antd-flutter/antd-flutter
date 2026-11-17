# P04. 清理 CHANGELOG 的 beta 条目

- 状态：`[ ]`
- 目标：CHANGELOG 中不保留任何 beta 更新内容；此后仅正式发布时才写入
- 前置依赖：无（但 beta 期间变更记录需先有去处，见步骤 1）

## 步骤
1. 确认 beta 期间变更记录的去处：已由计划规则承接（任务文档 `docs/plan/tasks/` 内记录变更点），历史 beta 内容随本任务删除
2. 清空 `CHANGELOG.md` 中所有 beta 版本条目（当前 0.1.0-beta.1 ~ 1.0.0-beta.1 全部为 beta 内容），替换为占位说明（如「正式版本更新记录将在此处维护」）
3. 检查根包与 4 个子包 README 的 beta 警告横幅是否需要保留（保留，1.0.0 正式发布时移除）
4. 全文检索确认无遗漏的 beta changelog 引用

## 验收标准
- [ ] `CHANGELOG.md` 不含任何 beta 条目
- [ ] 后续任务不再向 CHANGELOG 写 beta 内容（规则 R4/R5 已在 PLAN.md）

## 备注
- 1.0.0 正式发布时，由总任务按阶段把 beta 期间的变更整理为正式 CHANGELOG 条目（依据各任务文档中的变更点记录）
