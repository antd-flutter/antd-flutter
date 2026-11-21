<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarMobileCellRender

> 种类：类型定义

```dart
typedef AntCalendarMobileCellRender
```

移动端整格包裹渲染回调（C3 新增，antd-mobile `cellRender` 包裹语义）。

与桌面替换式 `AntCalendarCellRender` 不同：本回调接收已渲染好的默认
单元格 `oriNode`，在其外层包裹装饰/布局后返回（返回的 Widget 仍由组件
统一处理点击）。默认渲染链为 renderDate → renderLabel → 默认内容，
最后再用本回调包裹整格。

