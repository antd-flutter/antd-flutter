# Third-Party Licenses — antd_refresh

本包（`packages/antd_refresh`）包含对以下第三方开源项目的完整移植复刻：

## easy_refresh

- **来源**：https://pub.dev/packages/easy_refresh （v3.5.0，仓库
  https://github.com/xuelongqy/flutter_easy_refresh ，tag `v3.5.0`）
- **License**：MIT License
- **版权声明**：Copyright (c) 2021 xuelongqy
- **移植范围**：`lib/` 全量（内核：`ErIndicatorNotifier` 状态机 /
  `_ErScrollPhysics` 物理层 / `ErScrollBehavior` / Header-Footer 协议 /
  `ErRefreshController`；样式：classic、material、bezier、cupertino、phoenix、
  taurus、delivery 全部指示器）。
- **改动**：
  - 类名/公开符号加 `Er` 前缀（命名空间隔离，避免与原包冲突）；
  - 移除未被任何样式引用的 `src/painter/paths_painter.dart`（连带去除
    `path_drawing` 依赖）；
  - 每个源文件头部保留原 MIT 版权声明并注明移植来源。

### MIT License（原文）

```
MIT License

Copyright (c) 2021 xuelongqy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
