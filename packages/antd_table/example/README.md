# antd_table example

antd_table 组件演示画廊，覆盖全部高级用法：基础表格、排序、筛选、固定列、固定表头、行选择、合并单元格、展开行、树形数据、分页、汇总行、分组表头。

## 运行

```bash
cd packages/antd_table/example
flutter pub get
flutter run -d macos   # 或其他平台
```

## R35 适配

- R35.4：AntResponsiveInit + AntResponsive 断点布局（lg+ 宽屏双栏 Wrap，窄屏单栏 Column），暗色切换 + 窗口缩放无溢出。
- R35.3：macOS 真机验证通过（表格渲染 / 排序 / 筛选 / 固定列交互）。
