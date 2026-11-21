# antd_transfer_example

antd_transfer 穿梭框组件演示画廊。

## 覆盖形态

- 基础穿梭（默认双栏、onChange 回调）
- 多选（checkbox 多项勾选 + 批量穿梭）
- 受控模式（targetKeys / selectedKeys 受控）
- 禁用项（disabled 项不可选不可移）
- 多级树形穿梭（TreeTransfer：勾父带子、半选 indeterminate、树形展示、defaultExpandAll）
- 搜索过滤（showSearch + filterOption，含树模式过滤）
- 自定义配置（titles / operations / oneWay 单向）

## 运行

```bash
cd packages/antd_transfer/example
flutter run -d macos   # R35.3 桌面实测
flutter build web      # 演示站构建
```

R35.4：AntResponsiveInit 断点适配（desktop 宽屏双栏 / phone 窄屏单栏），窗口缩放无溢出；AppBar 按钮切换暗色。
