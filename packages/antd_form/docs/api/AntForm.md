<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntForm

> 种类：类

```dart
class AntForm
```

表单容器组件。

通过 `AntFormItem` 组合表单字段，通过 `controller` 管理表单数据。

## 构造函数

### `AntForm({super.key, this.controller, this.initialValues, this.onFinish, this.onFinishFailed, this.layout = AntFormLayout.vertical, this.labelWidth, this.disabled = false, required this.children})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `controller` | `AntFormController?` | 可选 | — |
| `initialValues` | `Map<String, dynamic>?` | 可选 | — |
| `onFinish` | `ValueChanged<Map<String, dynamic>>?` | 可选 | — |
| `onFinishFailed` | `ValueChanged<Map<String, String>>?` | 可选 | — |
| `layout` | `AntFormLayout` | = AntFormLayout.vertical | — |
| `labelWidth` | `double?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `children` | `List<Widget>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<Widget>` | 表单子项 |
| `controller` | `AntFormController?` | 表单控制器（传入后可通过它编程式操作表单） |
| `disabled` | `bool` | 是否禁用全部表单项 |
| `initialValues` | `Map<String, dynamic>?` | 表单初始值 |
| `labelWidth` | `double?` | 水平布局下标签宽度 |
| `layout` | `AntFormLayout` | 表单布局 |
| `onFinish` | `ValueChanged<Map<String, dynamic>>?` | 校验通过后的提交回调 |
| `onFinishFailed` | `ValueChanged<Map<String, String>>?` | 校验失败的回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntForm>` | — |
| `controllerOf` | `AntFormController?` | 获取给定 context 最近的上层 AntFormController |

