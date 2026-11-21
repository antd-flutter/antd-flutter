<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_transfer API 文档总览

> 自动生成时间：2026-11-21T23:54:46.689776；共 11 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（2）

| 名称 | 说明 |
| --- | --- |
| [`AntTransfer`](api/AntTransfer.md) | 穿梭框（泛型数据源） |
| [`AntTransferItem`](api/AntTransferItem.md) | 旧版穿梭框数据项 |

## 枚举（1）

| 名称 | 说明 |
| --- | --- |
| [`AntTransferDirection`](api/AntTransferDirection.md) | 穿梭方向 |

## 类型定义（8）

| 名称 | 说明 |
| --- | --- |
| [`AntTransferChildrenOf`](api/AntTransferChildrenOf.md) | 读取子节点 |
| [`AntTransferDescriptionOf`](api/AntTransferDescriptionOf.md) | 读取行描述文本（返回 null 表示无描述） |
| [`AntTransferDisabledOf`](api/AntTransferDisabledOf.md) | 判断数据项是否禁用（树形模式下会向下传递到整个子树） |
| [`AntTransferKeyOf`](api/AntTransferKeyOf.md) | 从数据项提取唯一 key |
| [`AntTransferOnChange`](api/AntTransferOnChange.md) | 穿梭完成回调 |
| [`AntTransferOnSelectChange`](api/AntTransferOnSelectChange.md) | 选中项变化回调，参数为源面板/目标面板的选中 key |
| [`AntTransferSearchTextOf`](api/AntTransferSearchTextOf.md) | 默认搜索使用的纯文本 |
| [`AntTransferTitleBuilder`](api/AntTransferTitleBuilder.md) | 行标题构建器 |

