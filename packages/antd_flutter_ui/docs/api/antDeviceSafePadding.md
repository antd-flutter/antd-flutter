<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antDeviceSafePadding

> 种类：函数

```dart
EdgeInsets antDeviceSafePadding()
```

设备真实安全区 insets（取根视图 MediaQuery.padding）。

Overlay 弹层的 builder context 处于页面 SafeArea 之下时，
`MediaQuery.paddingOf`/`viewPaddingOf` 可能已被消费/覆盖为 0，
导致真机（刘海屏）上弹层被摄像头/状态栏遮挡；本方法直接读根视图
MediaQuery，返回未经消费的设备真实安全区，屏级弹层统一使用。

## 返回值

返回 `EdgeInsets`。

