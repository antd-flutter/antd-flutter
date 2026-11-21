# antd_masonry example

Ant Design v6 Masonry 瀑布流组件演示画廊（antd_masonry 独立包 example，五件套之一）。

## 运行

```bash
cd packages/antd_masonry/example
flutter pub get
flutter run -d macos   # 或 -d chrome
```

## 演示覆盖（关键形态）

- **基础瀑布流**：贪心最短列分配、columns 列数
- **随机高度列表**：随机高度自动均衡、responsiveColumns 响应式列数（R35.4 断点适配）
- **跨列 span**：AntMasonryItem span 跨列（span 2 / span 3 整行）
- **动态添加（增量加载）**：加载/清空按钮 setState 受控刷新（R35 判定：无 Controller）
- **AntSliverMasonry sliver 变体**（R33 强制项）：CustomScrollView + pinned SliverAppBar 组合、sliver span 跨列

## 多平台适配（R35.4）

- AntResponsiveInit + AntLayoutData：desktop 宽屏双栏 Wrap / phone 窄屏单栏 Column，窗口缩放无溢出
- 暗色模式：AppBar 按钮联动 AntTheme + themeMode
- 全平台支持：android / ios / web / windows / macos / linux（org com.antdflutter）
