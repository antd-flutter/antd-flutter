<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# showAntModal

> 种类：函数

```dart
Future<bool?> showAntModal(BuildContext context, {String? title, Widget? content, String okText = kAntModalDefaultOkText, String cancelText = kAntModalDefaultCancelText, VoidCallback? onOk, VoidCallback? onCancel, bool confirmLoading = false, Object? footer = _defaultFooter, double width = kAntModalDefaultWidth, bool maskClosable = true, bool closable = true, bool centered = true})
```

弹出确认风格的对话框，返回用户选择（true 确认 / false 取消 / null 被移除）。

```dart
final ok = await showAntModal(
  context,
  title: '删除确认',
  content: const Text('确定要删除这条记录吗？'),
);
```

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `context` | `BuildContext` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `content` | `Widget?` | 可选 | — |
| `okText` | `String` | = kAntModalDefaultOkText | — |
| `cancelText` | `String` | = kAntModalDefaultCancelText | — |
| `onOk` | `VoidCallback?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |
| `confirmLoading` | `bool` | = false | — |
| `footer` | `Object?` | = _defaultFooter | — |
| `width` | `double` | = kAntModalDefaultWidth | — |
| `maskClosable` | `bool` | = true | — |
| `closable` | `bool` | = true | — |
| `centered` | `bool` | = true | — |

返回 `Future<bool?>`。

