<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# antIsDesktopViewport

> 种类：函数

```dart
bool antIsDesktopViewport(BuildContext context)
```

桌面端视口判定（最短边 ≥ 600 逻辑像素）。

`kAntMobileOverlayDefaultMaxWidth` 宽度封顶**只在桌面端视口生效**；
手机/移动端保持组件原生宽度（全宽贴边），平板及以上按桌面端封顶。

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `context` | `BuildContext` | 可选 | — |

返回 `bool`。

