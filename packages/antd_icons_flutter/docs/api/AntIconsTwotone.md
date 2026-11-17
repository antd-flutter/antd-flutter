<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntIconsTwotone

> 种类：类

```dart
class AntIconsTwotone
```

Ant Design TwoTone 双色图标集（SVG 资产路径）。

共 150 个双色图标，源 [`@ant-design/icons-svg`](https://github.com/ant-design/ant-design-icons)。

## 命名规则

与 antd React 版对齐（camelCase + `TwoTone` 后缀）：
- `<CheckCircleTwoTone />` → `AntIconsTwotone.checkCircleTwoTone`

## 渲染方式

常量值为包内 SVG 资产路径（如 `assets/twotone/check-circle.svg`），
经由 `AntdIcon` 组件渲染（内部使用 `flutter_svg` + 运行时双色替换）：

```dart
AntdIcon(AntIconsTwotone.checkCircleTwoTone)
AntdIcon(AntIconsTwotone.heartTwoTone,
    twoToneColor: Colors.red)
```

也可不经过 `AntdIcon`，用 `flutter_svg` 的 `SvgPicture.asset` 直接加载
（注意传入 `package: 'antd_icons_flutter'`）：

```dart
SvgPicture.asset(
  AntIconsTwotone.checkCircleTwoTone,
  package: 'antd_icons_flutter',
)
```

## 资产加载说明

SVG 文件随包内 `pubspec.yaml` 的 `assets` 声明整体打包，通过
`rootBundle` 按需异步加载；自定义 `AntdIcon.twoToneColor` 时首次渲染
有一帧异步等待，且替换结果会按「路径 + 主色 + 次色」缓存。

## Tree-shaking 说明

与 `AntIcons`（TTF 整字体打包）不同，SVG 资产按文件粒度进入安装包；
但由于资产以目录形式声明，当前版本为全量打包，不做按引用裁剪。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `accountBookTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/account-b… |
| `alertTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/alert-two… |
| `apiTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/api-twoto… |
| `appstoreTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/appstore-… |
| `audioTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/audio-two… |
| `bankTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/bank-twot… |
| `bellTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/bell-twot… |
| `bookTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/book-twot… |
| `boxPlotTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/box-plot-… |
| `bugTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/bug-twoto… |
| `buildTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/build-two… |
| `bulbTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/bulb-twot… |
| `calculatorTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/calculato… |
| `calendarTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/calendar-… |
| `cameraTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/camera-tw… |
| `carTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/car-twoto… |
| `carryOutTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/carry-out… |
| `checkCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/check-cir… |
| `checkSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/check-squ… |
| `ciCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/ci-circle… |
| `ciTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/ci-twoton… |
| `clockCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/clock-cir… |
| `closeCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/close-cir… |
| `closeSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/close-squ… |
| `cloudTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/cloud-two… |
| `codeTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/code-twot… |
| `compassTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/compass-t… |
| `contactsTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/contacts-… |
| `containerTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/container… |
| `controlTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/control-t… |
| `copyTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/copy-twot… |
| `copyrightCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/copyright… |
| `copyrightTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/copyright… |
| `creditCardTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/credit-ca… |
| `crownTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/crown-two… |
| `customerServiceTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/customer-… |
| `dashboardTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/dashboard… |
| `databaseTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/database-… |
| `deleteTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/delete-tw… |
| `diffTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/diff-twot… |
| `dislikeTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/dislike-t… |
| `dollarCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/dollar-ci… |
| `dollarTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/dollar-tw… |
| `downCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/down-circ… |
| `downSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/down-squa… |
| `editTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/edit-twot… |
| `environmentTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/environme… |
| `euroCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/euro-circ… |
| `euroTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/euro-twot… |
| `exclamationCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/exclamati… |
| `experimentTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/experimen… |
| `eyeInvisibleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/eye-invis… |
| `eyeTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/eye-twoto… |
| `fileAddTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-add-… |
| `fileExcelTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-exce… |
| `fileExclamationTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-excl… |
| `fileImageTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-imag… |
| `fileMarkdownTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-mark… |
| `filePdfTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-pdf-… |
| `filePptTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-ppt-… |
| `fileTextTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-text… |
| `fileTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-twot… |
| `fileUnknownTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-unkn… |
| `fileWordTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-word… |
| `fileZipTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/file-zip-… |
| `filterTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/filter-tw… |
| `fireTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/fire-twot… |
| `flagTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/flag-twot… |
| `folderAddTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/folder-ad… |
| `folderOpenTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/folder-op… |
| `folderTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/folder-tw… |
| `frownTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/frown-two… |
| `fundTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/fund-twot… |
| `funnelPlotTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/funnel-pl… |
| `giftTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/gift-twot… |
| `goldTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/gold-twot… |
| `hddTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/hdd-twoto… |
| `heartTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/heart-two… |
| `highlightTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/highlight… |
| `homeTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/home-twot… |
| `hourglassTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/hourglass… |
| `html5TwoTone` | `String` | <img src="https://api.iconify.design/ant-design/html5-two… |
| `idcardTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/idcard-tw… |
| `infoCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/info-circ… |
| `insuranceTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/insurance… |
| `interactionTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/interacti… |
| `layoutTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/layout-tw… |
| `leftCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/left-circ… |
| `leftSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/left-squa… |
| `likeTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/like-twot… |
| `lockTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/lock-twot… |
| `mailTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/mail-twot… |
| `medicineBoxTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/medicine-… |
| `mehTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/meh-twoto… |
| `messageTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/message-t… |
| `minusCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/minus-cir… |
| `minusSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/minus-squ… |
| `mobileTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/mobile-tw… |
| `moneyCollectTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/money-col… |
| `notificationTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/notificat… |
| `pauseCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/pause-cir… |
| `phoneTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/phone-two… |
| `pictureTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/picture-t… |
| `pieChartTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/pie-chart… |
| `playCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/play-circ… |
| `playSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/play-squa… |
| `plusCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/plus-circ… |
| `plusSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/plus-squa… |
| `poundCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/pound-cir… |
| `printerTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/printer-t… |
| `profileTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/profile-t… |
| `projectTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/project-t… |
| `propertySafetyTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/property-… |
| `pushpinTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/pushpin-t… |
| `questionCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/question-… |
| `reconciliationTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/reconcili… |
| `redEnvelopeTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/red-envel… |
| `restTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/rest-twot… |
| `rightCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/right-cir… |
| `rightSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/right-squ… |
| `rocketTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/rocket-tw… |
| `safetyCertificateTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/safety-ce… |
| `saveTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/save-twot… |
| `scheduleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/schedule-… |
| `securityScanTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/security-… |
| `settingTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/setting-t… |
| `shopTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/shop-twot… |
| `shoppingTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/shopping-… |
| `skinTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/skin-twot… |
| `slidersTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/sliders-t… |
| `smileTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/smile-two… |
| `snippetsTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/snippets-… |
| `soundTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/sound-two… |
| `starTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/star-twot… |
| `stopTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/stop-twot… |
| `switcherTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/switcher-… |
| `tabletTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/tablet-tw… |
| `tagTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/tag-twoto… |
| `tagsTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/tags-twot… |
| `thunderboltTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/thunderbo… |
| `toolTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/tool-twot… |
| `trademarkCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/trademark… |
| `trophyTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/trophy-tw… |
| `twotoneIcons` | `List<(String name, String path)>` | 全部 TwoTone 图标的 (名称, 资产路径) 枚举列表，共 150 个 |
| `unlockTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/unlock-tw… |
| `upCircleTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/up-circle… |
| `upSquareTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/up-square… |
| `usbTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/usb-twoto… |
| `videoCameraTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/video-cam… |
| `walletTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/wallet-tw… |
| `warningTwoTone` | `String` | <img src="https://api.iconify.design/ant-design/warning-t… |

