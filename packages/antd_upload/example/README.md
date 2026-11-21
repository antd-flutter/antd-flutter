# antd_upload example

AntUpload 组件演示画廊（全平台：Android / iOS / macOS / Web / Windows / Linux）。

## 运行

```bash
flutter pub get
flutter run -d macos   # 或 -d chrome / 其他已连接设备
```

## 覆盖形态

| Tab | 形态 |
| --- | --- |
| 基础上传列表 | 文字列表 / 图片列表 / 图片卡片 + maxCount |
| 多文件上传 | multiple 多选 + maxCount 截断 |
| 上传状态 | 上传中（进度）→ 成功 / 失败重试，静态三态展示 |
| 图片预览 | onPreview 点击文件弹出大图 |
| 受控操作 | fileList 受控 + onChange / onRemove / onPreview 回调日志 + onRemove 拦截 |
| 自定义 item 渲染 | 自定义按钮文案图标 / 卡片化包装 / 禁用态 |

## 说明

按 R16 中间件隔离原则，上传动作经 `onSelectFiles` / `customRequest` 回调注入，demo 内模拟文件选择与上传进度，不引入 http/dio 三方依赖。
