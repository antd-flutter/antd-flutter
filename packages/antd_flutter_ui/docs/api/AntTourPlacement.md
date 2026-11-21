<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTourPlacement

> 种类：枚举

```dart
enum AntTourPlacement
```

引导卡片相对于目标元素的位置（对齐 antd v6 Tour placement）。

- 居中：`center`（无 target 时也使用居中）
- 上：`topLeft` / `topCenter` / `topRight`
- 下：`bottomLeft` / `bottomCenter` / `bottomRight`
- 左：`leftTop` / `leftCenter` / `leftBottom`
- 右：`rightTop` / `rightCenter` / `rightBottom`

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `center` | 屏幕居中（无 target 时默认） |
| `topLeft` | 上方，左对齐 |
| `topCenter` | 上方，水平居中 |
| `topRight` | 上方，右对齐 |
| `bottomLeft` | 下方，左对齐 |
| `bottomCenter` | 下方，水平居中（默认） |
| `bottomRight` | 下方，右对齐 |
| `leftTop` | 左侧，顶部对齐 |
| `leftCenter` | 左侧，垂直居中 |
| `leftBottom` | 左侧，底部对齐 |
| `rightTop` | 右侧，顶部对齐 |
| `rightCenter` | 右侧，垂直居中 |
| `rightBottom` | 右侧，底部对齐 |

