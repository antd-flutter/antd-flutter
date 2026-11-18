# antd_theme

Ant Design v6 theme system for Flutter — 主题数据、主题注入、响应式断点与屏幕适配，基于 `antd_tokens` 与 `antd_color` 构建。

## 安装

```yaml
dependencies:
  antd_theme: ^1.0.0
```

## 用法

```dart
import 'package:antd_theme/antd_theme.dart';

// ── 主题数据 ─────────────────────────────────────────────
final light = AntThemeData.light(); // 与 antd 默认值一致
final dark = AntThemeData.dark();
final custom = AntThemeData.fromSeed(
  const AntSeedToken(colorPrimary: '#722ed1', borderRadius: 8),
);

Container(
  color: light.colorBgContainer,
  padding: EdgeInsets.all(light.padding),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: light.fontSizeLG, color: light.colorText),
  ),
);

// ── 主题注入 ─────────────────────────────────────────────
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(
    home: AntThemeBuilder(builder: (context, theme) {
      return Scaffold(
        backgroundColor: theme.colorBgLayout,
        body: Center(child: Text('Themed!', style: TextStyle(color: theme.colorPrimary))),
      );
    }),
  ),
);

// ── 响应式断点 ───────────────────────────────────────────
final bp = AntBreakpoint.of(context);
if (bp >= AntBreakpoint.md) {
  // ≥768 布局
}
if (AntBreakpoints.isDown(context, AntBreakpoint.sm)) {
  // <576 移动端布局
}
if (AntBreakpoints.isBetween(context, AntBreakpoint.md, AntBreakpoint.lg)) {
  // 768 ≤ width < 992
}

// ── 屏幕适配 ─────────────────────────────────────────────
AntScreenUtilInit(
  builder: (context, child) => AntTheme(
    data: AntThemeData.light(),
    child: MaterialApp(...),
  ),
);
// 使用 .w / .sp / .r 扩展（不支持 .h）
SizedBox(width: 100.w);
Text('Hello', style: TextStyle(fontSize: 14.sp));
```

## 文档

- [API 文档总览](docs/api-index.md)

## License

MIT License，详见 [LICENSE](LICENSE)。
