# Ant Design 图标清单（antd_icons_flutter）

## 简介

本清单按语义域分组列出 `antd_icons_flutter` 全部图标。图标共 **698 个**，对应 **498 个基础名**：

- **Outlined**（线框）447 个 — TTF 字体模式，常量位于 `AntIcons`，后缀 `Outlined`
- **Filled**（实心）251 个 — TTF 字体模式，常量位于 `AntIcons`，后缀 `Filled`
- **TwoTone**（双色）150 个 — SVG 资产模式，常量位于 `AntIconsTwotone`，后缀 `TwoTone`

同一基础名在不同风格下的 Dart 常量名规则：

```text
基础名 heart  →  AntIcons.heartOutlined / AntIcons.heartFilled / AntIconsTwotone.heartTwoTone
```

表中 `✓` 表示该风格存在对应常量，`—` 表示无。多数基础名仅提供 Outlined 形态；TwoTone 为 antd 官方挑选的 150 个常用子集。

## 使用场景

- **图标选择器 / 设计评审**：按语义域浏览全部可用图标；
- **确定常量名**：先在表中找到基础名，再按后缀规则推导 Dart 常量；
- **评估体积**：Outlined/Filled 打包为单一 TTF 字体（整体打包、不按码点裁剪），TwoTone 为全量 SVG 资产，选用前请结合 `fonts/AntIcons.ttf` 与 `assets/twotone/` 的实际体积权衡。


### 基础操作

共 66 个基础名（Outlined 65 / Filled 14 / TwoTone 13）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `checkSquare` | ✓ | ✓ | ✓ |
| `closeSquare` | ✓ | ✓ | ✓ |
| `minusCircle` | ✓ | ✓ | ✓ |
| `minusSquare` | ✓ | ✓ | ✓ |
| `plusCircle` | ✓ | ✓ | ✓ |
| `plusSquare` | ✓ | ✓ | ✓ |
| `shareAlt` | ✓ | — | — |
| `retweet` | ✓ | — | — |
| `replicate` | — | ✓ | — |
| `check` | ✓ | — | — |
| `close` | ✓ | — | — |
| `plus` | ✓ | — | — |
| `minus` | ✓ | — | — |
| `clear` | ✓ | — | — |
| `edit` | ✓ | ✓ | ✓ |
| `delete` | ✓ | ✓ | ✓ |
| `scissor` | ✓ | — | — |
| `copy` | ✓ | ✓ | ✓ |
| `save` | ✓ | ✓ | ✓ |
| `search` | ✓ | — | — |
| `zoomIn` | ✓ | — | — |
| `zoomOut` | ✓ | — | — |
| `filter` | ✓ | ✓ | ✓ |
| `funnelPlot` | ✓ | ✓ | ✓ |
| `select` | ✓ | — | — |
| `send` | ✓ | — | — |
| `reload` | ✓ | — | — |
| `sync` | ✓ | — | — |
| `loading` | ✓ | — | — |
| `loading3Quarters` | ✓ | — | — |
| `redo` | ✓ | — | — |
| `undo` | ✓ | — | — |
| `rollback` | ✓ | — | — |
| `rotateLeft` | ✓ | — | — |
| `rotateRight` | ✓ | — | — |
| `scan` | ✓ | — | — |
| `drag` | ✓ | — | — |
| `download` | ✓ | — | — |
| `upload` | ✓ | — | — |
| `import` | ✓ | — | — |
| `export` | ✓ | — | — |
| `login` | ✓ | — | — |
| `logout` | ✓ | — | — |
| `enter` | ✓ | — | — |
| `poweroff` | ✓ | — | — |
| `more` | ✓ | — | — |
| `ellipsis` | ✓ | — | — |
| `smallDash` | ✓ | — | — |
| `bars` | ✓ | — | — |
| `menu` | ✓ | — | — |
| `menuFold` | ✓ | — | — |
| `menuUnfold` | ✓ | — | — |
| `toTop` | ✓ | — | — |
| `expand` | ✓ | — | — |
| `expandAlt` | ✓ | — | — |
| `compress` | ✓ | — | — |
| `shrink` | ✓ | — | — |
| `fullscreen` | ✓ | — | — |
| `fullscreenExit` | ✓ | — | — |
| `swap` | ✓ | — | — |
| `swapLeft` | ✓ | — | — |
| `swapRight` | ✓ | — | — |
| `sortAscending` | ✓ | — | — |
| `sortDescending` | ✓ | — | — |
| `rest` | ✓ | ✓ | ✓ |
| `shake` | ✓ | — | — |

### 方向与箭头

共 42 个基础名（Outlined 42 / Filled 12 / TwoTone 8）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `arrowUp` | ✓ | — | — |
| `arrowDown` | ✓ | — | — |
| `arrowLeft` | ✓ | — | — |
| `arrowRight` | ✓ | — | — |
| `caretUp` | ✓ | ✓ | — |
| `caretDown` | ✓ | ✓ | — |
| `caretLeft` | ✓ | ✓ | — |
| `caretRight` | ✓ | ✓ | — |
| `up` | ✓ | — | — |
| `down` | ✓ | — | — |
| `left` | ✓ | — | — |
| `right` | ✓ | — | — |
| `upCircle` | ✓ | ✓ | ✓ |
| `downCircle` | ✓ | ✓ | ✓ |
| `leftCircle` | ✓ | ✓ | ✓ |
| `rightCircle` | ✓ | ✓ | ✓ |
| `upSquare` | ✓ | ✓ | ✓ |
| `downSquare` | ✓ | ✓ | ✓ |
| `leftSquare` | ✓ | ✓ | ✓ |
| `rightSquare` | ✓ | ✓ | ✓ |
| `doubleLeft` | ✓ | — | — |
| `doubleRight` | ✓ | — | — |
| `verticalLeft` | ✓ | — | — |
| `verticalRight` | ✓ | — | — |
| `verticalAlignTop` | ✓ | — | — |
| `verticalAlignMiddle` | ✓ | — | — |
| `verticalAlignBottom` | ✓ | — | — |
| `alignLeft` | ✓ | — | — |
| `alignCenter` | ✓ | — | — |
| `alignRight` | ✓ | — | — |
| `columnHeight` | ✓ | — | — |
| `columnWidth` | ✓ | — | — |
| `lineHeight` | ✓ | — | — |
| `picLeft` | ✓ | — | — |
| `picCenter` | ✓ | — | — |
| `picRight` | ✓ | — | — |
| `radiusUpleft` | ✓ | — | — |
| `radiusUpright` | ✓ | — | — |
| `radiusBottomleft` | ✓ | — | — |
| `radiusBottomright` | ✓ | — | — |
| `radiusSetting` | ✓ | — | — |
| `arrowsAlt` | ✓ | — | — |

### 状态与反馈

共 37 个基础名（Outlined 37 / Filled 30 / TwoTone 30）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `exception` | ✓ | — | — |
| `mail` | ✓ | ✓ | ✓ |
| `phone` | ✓ | ✓ | ✓ |
| `checkCircle` | ✓ | ✓ | ✓ |
| `closeCircle` | ✓ | ✓ | ✓ |
| `exclamation` | ✓ | — | — |
| `exclamationCircle` | ✓ | ✓ | ✓ |
| `info` | ✓ | — | — |
| `infoCircle` | ✓ | ✓ | ✓ |
| `question` | ✓ | — | — |
| `questionCircle` | ✓ | ✓ | ✓ |
| `warning` | ✓ | ✓ | ✓ |
| `alert` | ✓ | ✓ | ✓ |
| `bell` | ✓ | ✓ | ✓ |
| `notification` | ✓ | ✓ | ✓ |
| `message` | ✓ | ✓ | ✓ |
| `comment` | ✓ | — | — |
| `customerService` | ✓ | ✓ | ✓ |
| `like` | ✓ | ✓ | ✓ |
| `dislike` | ✓ | ✓ | ✓ |
| `star` | ✓ | ✓ | ✓ |
| `heart` | ✓ | ✓ | ✓ |
| `smile` | ✓ | ✓ | ✓ |
| `meh` | ✓ | ✓ | ✓ |
| `frown` | ✓ | ✓ | ✓ |
| `fire` | ✓ | ✓ | ✓ |
| `crown` | ✓ | ✓ | ✓ |
| `trophy` | ✓ | ✓ | ✓ |
| `thunderbolt` | ✓ | ✓ | ✓ |
| `flag` | ✓ | ✓ | ✓ |
| `pushpin` | ✓ | ✓ | ✓ |
| `clockCircle` | ✓ | ✓ | ✓ |
| `hourglass` | ✓ | ✓ | ✓ |
| `history` | ✓ | — | — |
| `eye` | ✓ | ✓ | ✓ |
| `eyeInvisible` | ✓ | ✓ | ✓ |
| `block` | ✓ | — | — |

### 安全与认证

共 11 个基础名（Outlined 11 / Filled 6 / TwoTone 6）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `lock` | ✓ | ✓ | ✓ |
| `unlock` | ✓ | ✓ | ✓ |
| `safety` | ✓ | — | — |
| `safetyCertificate` | ✓ | ✓ | ✓ |
| `propertySafety` | ✓ | ✓ | ✓ |
| `securityScan` | ✓ | ✓ | ✓ |
| `audit` | ✓ | — | — |
| `insurance` | ✓ | ✓ | ✓ |
| `verified` | ✓ | — | — |
| `key` | ✓ | — | — |
| `issuesClose` | ✓ | — | — |

### 文件与文档

共 47 个基础名（Outlined 47 / Filled 25 / TwoTone 23）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `fileMarkdown` | ✓ | ✓ | ✓ |
| `file` | ✓ | ✓ | ✓ |
| `fileAdd` | ✓ | ✓ | ✓ |
| `fileDone` | ✓ | — | — |
| `fileExcel` | ✓ | ✓ | ✓ |
| `fileWord` | ✓ | ✓ | ✓ |
| `filePdf` | ✓ | ✓ | ✓ |
| `filePpt` | ✓ | ✓ | ✓ |
| `fileImage` | ✓ | ✓ | ✓ |
| `fileJpg` | ✓ | — | — |
| `fileGif` | ✓ | — | — |
| `fileZip` | ✓ | ✓ | ✓ |
| `fileText` | ✓ | ✓ | ✓ |
| `fileProtect` | ✓ | — | — |
| `fileSearch` | ✓ | — | — |
| `fileSync` | ✓ | — | — |
| `fileExclamation` | ✓ | ✓ | ✓ |
| `fileUnknown` | ✓ | ✓ | ✓ |
| `folder` | ✓ | ✓ | ✓ |
| `folderAdd` | ✓ | ✓ | ✓ |
| `folderOpen` | ✓ | ✓ | ✓ |
| `folderView` | ✓ | — | — |
| `paperClip` | ✓ | — | — |
| `snippets` | ✓ | ✓ | ✓ |
| `profile` | ✓ | ✓ | ✓ |
| `form` | ✓ | — | — |
| `book` | ✓ | ✓ | ✓ |
| `read` | ✓ | ✓ | — |
| `solution` | ✓ | — | — |
| `reconciliation` | ✓ | ✓ | ✓ |
| `carryOut` | ✓ | ✓ | ✓ |
| `schedule` | ✓ | ✓ | ✓ |
| `calendar` | ✓ | ✓ | ✓ |
| `signature` | ✓ | ✓ | — |
| `accountBook` | ✓ | ✓ | ✓ |
| `table` | ✓ | — | — |
| `borderlessTable` | ✓ | — | — |
| `mergeCells` | ✓ | — | — |
| `splitCells` | ✓ | — | — |
| `insertRowAbove` | ✓ | — | — |
| `insertRowBelow` | ✓ | — | — |
| `insertRowLeft` | ✓ | — | — |
| `insertRowRight` | ✓ | — | — |
| `deleteRow` | ✓ | — | — |
| `deleteColumn` | ✓ | — | — |
| `orderedList` | ✓ | — | — |
| `unorderedList` | ✓ | — | — |

### 文本与样式

共 10 个基础名（Outlined 10 / Filled 2 / TwoTone 1）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `bold` | ✓ | — | — |
| `italic` | ✓ | — | — |
| `underline` | ✓ | — | — |
| `strikethrough` | ✓ | — | — |
| `fontColors` | ✓ | — | — |
| `bgColors` | ✓ | — | — |
| `fontSize` | ✓ | — | — |
| `formatPainter` | ✓ | ✓ | — |
| `highlight` | ✓ | ✓ | ✓ |
| `dash` | ✓ | — | — |

### 数据与图表

共 44 个基础名（Outlined 44 / Filled 10 / TwoTone 10）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `lineChart` | ✓ | — | — |
| `barChart` | ✓ | — | — |
| `pieChart` | ✓ | ✓ | ✓ |
| `dotChart` | ✓ | — | — |
| `areaChart` | ✓ | — | — |
| `heatMap` | ✓ | — | — |
| `boxPlot` | ✓ | ✓ | ✓ |
| `radarChart` | ✓ | — | — |
| `dashboard` | ✓ | ✓ | ✓ |
| `fund` | ✓ | ✓ | ✓ |
| `fundProjectionScreen` | ✓ | — | — |
| `fundView` | ✓ | — | — |
| `rise` | ✓ | — | — |
| `fall` | ✓ | — | — |
| `stock` | ✓ | — | — |
| `calculator` | ✓ | ✓ | ✓ |
| `percentage` | ✓ | — | — |
| `number` | ✓ | — | — |
| `fieldBinary` | ✓ | — | — |
| `fieldNumber` | ✓ | — | — |
| `fieldString` | ✓ | — | — |
| `fieldTime` | ✓ | — | — |
| `function` | ✓ | — | — |
| `consoleSql` | ✓ | — | — |
| `database` | ✓ | ✓ | ✓ |
| `cluster` | ✓ | — | — |
| `partition` | ✓ | — | — |
| `gateway` | ✓ | — | — |
| `deploymentUnit` | ✓ | — | — |
| `oneToOne` | ✓ | — | — |
| `nodeIndex` | ✓ | — | — |
| `nodeExpand` | ✓ | — | — |
| `nodeCollapse` | ✓ | — | — |
| `subnode` | ✓ | — | — |
| `sisternode` | ✓ | — | — |
| `apartment` | ✓ | — | — |
| `branches` | ✓ | — | — |
| `fork` | ✓ | — | — |
| `group` | ✓ | — | — |
| `ungroup` | ✓ | — | — |
| `api` | ✓ | ✓ | ✓ |
| `interaction` | ✓ | ✓ | ✓ |
| `diff` | ✓ | ✓ | ✓ |
| `experiment` | ✓ | ✓ | ✓ |

### 云端与设备

共 22 个基础名（Outlined 21 / Filled 7 / TwoTone 6）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `cloud` | ✓ | ✓ | ✓ |
| `cloudUpload` | ✓ | — | — |
| `cloudDownload` | ✓ | — | — |
| `cloudSync` | ✓ | — | — |
| `cloudServer` | ✓ | — | — |
| `global` | ✓ | — | — |
| `wifi` | ✓ | — | — |
| `signal` | — | ✓ | — |
| `link` | ✓ | — | — |
| `disconnect` | ✓ | — | — |
| `aliyun` | ✓ | — | — |
| `antCloud` | ✓ | — | — |
| `hdd` | ✓ | ✓ | ✓ |
| `desktop` | ✓ | — | — |
| `laptop` | ✓ | — | — |
| `mobile` | ✓ | ✓ | ✓ |
| `tablet` | ✓ | ✓ | ✓ |
| `monitor` | ✓ | — | — |
| `printer` | ✓ | ✓ | ✓ |
| `usb` | ✓ | ✓ | ✓ |
| `qrcode` | ✓ | — | — |
| `barcode` | ✓ | — | — |

### 用户与团队

共 13 个基础名（Outlined 13 / Filled 3 / TwoTone 2）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `usergroupAdd` | ✓ | — | — |
| `usergroupDelete` | ✓ | — | — |
| `user` | ✓ | — | — |
| `userAdd` | ✓ | — | — |
| `userDelete` | ✓ | — | — |
| `userSwitch` | ✓ | — | — |
| `team` | ✓ | — | — |
| `contacts` | ✓ | ✓ | ✓ |
| `idcard` | ✓ | ✓ | ✓ |
| `man` | ✓ | — | — |
| `woman` | ✓ | — | — |
| `robot` | ✓ | ✓ | — |
| `translation` | ✓ | — | — |

### 媒体与影音

共 22 个基础名（Outlined 22 / Filled 18 / TwoTone 11）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `gift` | ✓ | ✓ | ✓ |
| `picture` | ✓ | ✓ | ✓ |
| `videoCamera` | ✓ | ✓ | ✓ |
| `videoCameraAdd` | ✓ | — | — |
| `audio` | ✓ | ✓ | ✓ |
| `audioMuted` | ✓ | — | — |
| `sound` | ✓ | ✓ | ✓ |
| `muted` | ✓ | ✓ | — |
| `playCircle` | ✓ | ✓ | ✓ |
| `playSquare` | ✓ | ✓ | ✓ |
| `pause` | ✓ | — | — |
| `pauseCircle` | ✓ | ✓ | ✓ |
| `stop` | ✓ | ✓ | ✓ |
| `forward` | ✓ | ✓ | — |
| `backward` | ✓ | ✓ | — |
| `fastForward` | ✓ | ✓ | — |
| `fastBackward` | ✓ | ✓ | — |
| `stepForward` | ✓ | ✓ | — |
| `stepBackward` | ✓ | ✓ | — |
| `camera` | ✓ | ✓ | ✓ |
| `gif` | ✓ | — | — |
| `switcher` | ✓ | ✓ | ✓ |

### 金融与支付

共 17 个基础名（Outlined 15 / Filled 12 / TwoTone 10）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `dollar` | ✓ | — | ✓ |
| `dollarCircle` | ✓ | ✓ | ✓ |
| `euro` | ✓ | — | ✓ |
| `euroCircle` | ✓ | ✓ | ✓ |
| `pound` | ✓ | — | — |
| `poundCircle` | ✓ | ✓ | ✓ |
| `wallet` | ✓ | ✓ | ✓ |
| `creditCard` | ✓ | ✓ | ✓ |
| `payCircle` | ✓ | ✓ | — |
| `redEnvelope` | ✓ | ✓ | ✓ |
| `transaction` | ✓ | — | — |
| `moneyCollect` | ✓ | ✓ | ✓ |
| `gold` | ✓ | ✓ | ✓ |
| `golden` | — | ✓ | — |
| `alipay` | ✓ | — | — |
| `alipayCircle` | ✓ | ✓ | — |
| `alipaySquare` | — | ✓ | — |

### 位置与出行

共 20 个基础名（Outlined 20 / Filled 16 / TwoTone 15）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `environment` | ✓ | ✓ | ✓ |
| `compass` | ✓ | ✓ | ✓ |
| `car` | ✓ | ✓ | ✓ |
| `truck` | ✓ | ✓ | — |
| `rocket` | ✓ | ✓ | ✓ |
| `home` | ✓ | ✓ | ✓ |
| `bank` | ✓ | ✓ | ✓ |
| `shop` | ✓ | ✓ | ✓ |
| `shopping` | ✓ | ✓ | ✓ |
| `shoppingCart` | ✓ | — | — |
| `container` | ✓ | ✓ | ✓ |
| `deliveredProcedure` | ✓ | — | — |
| `build` | ✓ | ✓ | ✓ |
| `tool` | ✓ | ✓ | ✓ |
| `setting` | ✓ | ✓ | ✓ |
| `sliders` | ✓ | ✓ | ✓ |
| `layout` | ✓ | ✓ | ✓ |
| `skin` | ✓ | ✓ | ✓ |
| `holder` | ✓ | — | — |
| `aim` | ✓ | — | — |

### 开发与代码

共 40 个基础名（Outlined 33 / Filled 25 / TwoTone 9）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `anthropic` | — | ✓ | — |
| `claude` | — | ✓ | — |
| `macCommand` | ✓ | ✓ | — |
| `product` | ✓ | ✓ | — |
| `project` | ✓ | ✓ | ✓ |
| `medicineBox` | ✓ | ✓ | ✓ |
| `code` | ✓ | ✓ | ✓ |
| `bug` | ✓ | ✓ | ✓ |
| `pullRequest` | ✓ | — | — |
| `merge` | ✓ | ✓ | — |
| `html5` | ✓ | ✓ | ✓ |
| `javaScript` | ✓ | — | — |
| `java` | ✓ | — | — |
| `python` | ✓ | — | — |
| `ruby` | ✓ | — | — |
| `dotNet` | ✓ | — | — |
| `github` | ✓ | ✓ | — |
| `gitlab` | ✓ | ✓ | — |
| `codeSandbox` | ✓ | — | — |
| `codeSandboxCircle` | — | ✓ | — |
| `codeSandboxSquare` | — | ✓ | — |
| `codepen` | ✓ | — | — |
| `codepenCircle` | ✓ | ✓ | — |
| `codepenSquare` | — | ✓ | — |
| `kubernetes` | ✓ | — | — |
| `docker` | ✓ | — | — |
| `chrome` | ✓ | ✓ | — |
| `windows` | ✓ | ✓ | — |
| `android` | ✓ | ✓ | — |
| `apple` | ✓ | ✓ | — |
| `linux` | ✓ | — | — |
| `ie` | ✓ | — | — |
| `ieCircle` | — | ✓ | — |
| `ieSquare` | — | ✓ | — |
| `ci` | ✓ | — | ✓ |
| `ciCircle` | ✓ | ✓ | ✓ |
| `control` | ✓ | ✓ | ✓ |
| `bulb` | ✓ | ✓ | ✓ |
| `coffee` | ✓ | — | — |
| `harmonyOS` | ✓ | — | — |

### 品牌与生态

共 89 个基础名（Outlined 49 / Filled 65 / TwoTone 1）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `weibo` | ✓ | — | — |
| `weiboCircle` | ✓ | ✓ | — |
| `weiboSquare` | ✓ | ✓ | — |
| `alibaba` | ✓ | — | — |
| `aliwangwang` | ✓ | ✓ | — |
| `antDesign` | ✓ | — | — |
| `amazon` | ✓ | — | — |
| `amazonCircle` | — | ✓ | — |
| `amazonSquare` | — | ✓ | — |
| `appstore` | ✓ | ✓ | ✓ |
| `appstoreAdd` | ✓ | — | — |
| `baidu` | ✓ | — | — |
| `behance` | ✓ | — | — |
| `behanceCircle` | — | ✓ | — |
| `behanceSquare` | ✓ | ✓ | — |
| `bilibili` | ✓ | ✓ | — |
| `dingding` | ✓ | — | — |
| `dingtalk` | ✓ | — | — |
| `dingtalkCircle` | — | ✓ | — |
| `dingtalkSquare` | — | ✓ | — |
| `discord` | ✓ | ✓ | — |
| `dribbble` | ✓ | — | — |
| `dribbbleCircle` | — | ✓ | — |
| `dribbbleSquare` | ✓ | ✓ | — |
| `dropbox` | ✓ | — | — |
| `dropboxCircle` | — | ✓ | — |
| `dropboxSquare` | — | ✓ | — |
| `elevenLabs` | — | ✓ | — |
| `facebook` | ✓ | ✓ | — |
| `gemini` | — | ✓ | — |
| `google` | ✓ | — | — |
| `googleCircle` | — | ✓ | — |
| `googleSquare` | — | ✓ | — |
| `googlePlus` | ✓ | — | — |
| `googlePlusCircle` | — | ✓ | — |
| `googlePlusSquare` | — | ✓ | — |
| `huggingFace` | — | ✓ | — |
| `instagram` | ✓ | ✓ | — |
| `line` | ✓ | — | — |
| `linkedin` | ✓ | ✓ | — |
| `mastodon` | — | ✓ | — |
| `medium` | ✓ | — | — |
| `mediumCircle` | — | ✓ | — |
| `mediumSquare` | — | ✓ | — |
| `mediumWorkmark` | ✓ | — | — |
| `meta` | — | ✓ | — |
| `mistral` | — | ✓ | — |
| `netflix` | — | ✓ | — |
| `ollama` | — | ✓ | — |
| `openAI` | ✓ | ✓ | — |
| `perplexity` | — | ✓ | — |
| `pinterest` | ✓ | ✓ | — |
| `qq` | ✓ | — | — |
| `qqCircle` | — | ✓ | — |
| `qqSquare` | — | ✓ | — |
| `reddit` | ✓ | — | — |
| `redditCircle` | — | ✓ | — |
| `redditSquare` | — | ✓ | — |
| `sketch` | ✓ | — | — |
| `sketchCircle` | — | ✓ | — |
| `sketchSquare` | — | ✓ | — |
| `skype` | ✓ | ✓ | — |
| `slack` | ✓ | — | — |
| `slackCircle` | — | ✓ | — |
| `slackSquare` | ✓ | ✓ | — |
| `snapchat` | — | ✓ | — |
| `spotify` | ✓ | ✓ | — |
| `taobao` | ✓ | — | — |
| `taobaoCircle` | ✓ | ✓ | — |
| `taobaoSquare` | — | ✓ | — |
| `telegram` | — | ✓ | — |
| `threads` | — | ✓ | — |
| `tikTok` | ✓ | ✓ | — |
| `twitch` | ✓ | ✓ | — |
| `twitter` | ✓ | — | — |
| `twitterCircle` | — | ✓ | — |
| `twitterSquare` | — | ✓ | — |
| `wechat` | ✓ | ✓ | — |
| `wechatWork` | ✓ | ✓ | — |
| `whatsApp` | ✓ | — | — |
| `x` | ✓ | ✓ | — |
| `yahoo` | ✓ | ✓ | — |
| `youtube` | ✓ | ✓ | — |
| `yuque` | ✓ | ✓ | — |
| `zhihu` | ✓ | — | — |
| `zhihuCircle` | — | ✓ | — |
| `zhihuSquare` | — | ✓ | — |
| `deepSeek` | — | ✓ | — |
| `qwen` | — | ✓ | — |

### 其他

共 18 个基础名（Outlined 18 / Filled 6 / TwoTone 5）。

| 基础名 | Outlined | Filled | TwoTone |
| --- | :---: | :---: | :---: |
| `border` | ✓ | — | — |
| `borderBottom` | ✓ | — | — |
| `borderTop` | ✓ | — | — |
| `borderLeft` | ✓ | — | — |
| `borderRight` | ✓ | — | — |
| `borderHorizontal` | ✓ | — | — |
| `borderInner` | ✓ | — | — |
| `borderOuter` | ✓ | — | — |
| `borderVerticle` | ✓ | — | — |
| `trademark` | ✓ | — | — |
| `trademarkCircle` | ✓ | ✓ | ✓ |
| `copyright` | ✓ | — | ✓ |
| `copyrightCircle` | ✓ | ✓ | ✓ |
| `tag` | ✓ | ✓ | ✓ |
| `tags` | ✓ | ✓ | ✓ |
| `sun` | ✓ | ✓ | — |
| `moon` | ✓ | ✓ | — |
| `inbox` | ✓ | — | — |
## 注意事项

1. **后缀即风格**：使用时务必带上风格后缀（`Outlined`/`Filled`/`TwoTone`），不存在无后缀的基础常量。
2. **TwoTone 需经 SVG 渲染**：`AntIconsTwotone` 常量值为资产路径，须通过 `AntdIcon`（或 `SvgPicture.asset` + `package: 'antd_icons_flutter'`）渲染，自定义主色用 `twoToneColor`；`color` 参数对 TwoTone 不生效。
3. **全量清单检索**：代码侧可用 `AntIcons.outlinedIcons` / `AntIcons.filledIcons` / `AntIconsTwotone.twotoneIcons` 三个枚举列表（`(name, icon)` 记录）动态遍历，无需硬编码。
4. **视觉预览**：完整可视化图标库见 [Icon Gallery](https://antd-flutter.github.io/antd-flutter/icons/)，支持搜索与 TwoTone 取色预览。
