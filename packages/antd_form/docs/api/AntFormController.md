<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFormController

> 种类：类

```dart
class AntFormController
```

表单控制器，管理字段值、错误与校验。

通过 `AntForm.controller` 传入表单后，可用它编程式读写字段值、
触发校验、提交或重置表单。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_errors` | `Map<String, String?>` | — |
| `_initialValues` | `Map<String, dynamic>` | — |
| `_rules` | `Map<String, List<AntFormFieldRule>>` | — |
| `_submitHandler` | `VoidCallback?` | — |
| `_values` | `Map<String, dynamic>` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hasErrors` | `bool` | 是否存在校验错误 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_registerField` | `void` | 注册字段（由 AntFormItem.didChangeDependencies 调用） |
| `_setInitialValues` | `void` | 设置初始值（由 AntForm.initState 调用） |
| `_unregisterField` | `void` | 注销字段 |
| `_validateField` | `String?` | 校验单个字段 |
| `_validateFieldValue` | `String?` | — |
| `clearErrors` | `void` | 清除全部错误 |
| `getError` | `String?` | 获取字段错误文案 |
| `getErrors` | `Map<String, String>` | 获取全部错误（仅含未通过的字段） |
| `getValue` | `dynamic` | 获取字段值 |
| `getValues` | `Map<String, dynamic>` | 获取全部字段值（副本） |
| `reset` | `void` | 重置表单（恢复初始值并清除错误） |
| `setValue` | `void` | 设置字段值 validate 为 true 时同步触发该字段校验 |
| `submit` | `void` | 提交表单（触发校验，通过回调 onFinish，失败回调 onFinishFailed） |
| `validate` | `Future<bool>` | 校验全部字段，返回是否全部通过 |

