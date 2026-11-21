<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# kAntMobileOverlayDefaultMaxWidth

> 种类：常量

```dart
const double kAntMobileOverlayDefaultMaxWidth
```

移动端特有弹层组件的桌面端默认宽度上限（逻辑像素）。

移动端特有弹层（Dialog / ActionSheet / Popup / Toast 等）在桌面端
不应随超宽视口无限拉伸，统一以移动端默认宽度（375）封顶、弹层对齐居中。

