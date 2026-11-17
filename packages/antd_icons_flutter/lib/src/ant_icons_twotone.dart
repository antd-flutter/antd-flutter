// 本文件由 tool/generate.mjs 自动生成，请勿手动修改。
// 源: @ant-design/icons-svg@4.6.0

/// Ant Design TwoTone 双色图标集（SVG 资产路径）。
///
/// 共 150 个双色图标，源 [`@ant-design/icons-svg`](https://github.com/ant-design/ant-design-icons)。
///
/// ## 命名规则
///
/// 与 antd React 版对齐（camelCase + `TwoTone` 后缀）：
/// - `<CheckCircleTwoTone />` → [AntIconsTwotone.checkCircleTwoTone]
///
/// ## 渲染方式
///
/// 常量值为包内 SVG 资产路径（如 `assets/twotone/check-circle.svg`），
/// 经由 [AntdIcon] 组件渲染（内部使用 `flutter_svg` + 运行时双色替换）：
///
/// ```dart
/// AntdIcon(AntIconsTwotone.checkCircleTwoTone)
/// AntdIcon(AntIconsTwotone.heartTwoTone,
///     twoToneColor: Colors.red)
/// ```
///
/// 也可不经过 [AntdIcon]，用 `flutter_svg` 的 `SvgPicture.asset` 直接加载
/// （注意传入 `package: 'antd_icons_flutter'`）：
///
/// ```dart
/// SvgPicture.asset(
///   AntIconsTwotone.checkCircleTwoTone,
///   package: 'antd_icons_flutter',
/// )
/// ```
///
/// ## 资产加载说明
///
/// SVG 文件随包内 `pubspec.yaml` 的 `assets` 声明整体打包，通过
/// `rootBundle` 按需异步加载；自定义 [AntdIcon.twoToneColor] 时首次渲染
/// 有一帧异步等待，且替换结果会按「路径 + 主色 + 次色」缓存。
///
/// ## Tree-shaking 说明
///
/// 与 [AntIcons]（TTF 整字体打包）不同，SVG 资产按文件粒度进入安装包；
/// 但由于资产以目录形式声明，当前版本为全量打包，不做按引用裁剪。
abstract final class AntIconsTwotone {

  // ── TwoTone（双色风格） 150 个 ──────────────────────────

  /// <img src="https://api.iconify.design/ant-design/account-book-twotone.svg?color=%23888" width="16" height="16" alt="account-book" />
  ///
  /// antd React: `accountBookTwoTone`
  static const String accountBookTwoTone = 'assets/twotone/account-book.svg';

  /// <img src="https://api.iconify.design/ant-design/alert-twotone.svg?color=%23888" width="16" height="16" alt="alert" />
  ///
  /// antd React: `alertTwoTone`
  static const String alertTwoTone = 'assets/twotone/alert.svg';

  /// <img src="https://api.iconify.design/ant-design/api-twotone.svg?color=%23888" width="16" height="16" alt="api" />
  ///
  /// antd React: `apiTwoTone`
  static const String apiTwoTone = 'assets/twotone/api.svg';

  /// <img src="https://api.iconify.design/ant-design/appstore-twotone.svg?color=%23888" width="16" height="16" alt="appstore" />
  ///
  /// antd React: `appstoreTwoTone`
  static const String appstoreTwoTone = 'assets/twotone/appstore.svg';

  /// <img src="https://api.iconify.design/ant-design/audio-twotone.svg?color=%23888" width="16" height="16" alt="audio" />
  ///
  /// antd React: `audioTwoTone`
  static const String audioTwoTone = 'assets/twotone/audio.svg';

  /// <img src="https://api.iconify.design/ant-design/bank-twotone.svg?color=%23888" width="16" height="16" alt="bank" />
  ///
  /// antd React: `bankTwoTone`
  static const String bankTwoTone = 'assets/twotone/bank.svg';

  /// <img src="https://api.iconify.design/ant-design/bell-twotone.svg?color=%23888" width="16" height="16" alt="bell" />
  ///
  /// antd React: `bellTwoTone`
  static const String bellTwoTone = 'assets/twotone/bell.svg';

  /// <img src="https://api.iconify.design/ant-design/book-twotone.svg?color=%23888" width="16" height="16" alt="book" />
  ///
  /// antd React: `bookTwoTone`
  static const String bookTwoTone = 'assets/twotone/book.svg';

  /// <img src="https://api.iconify.design/ant-design/box-plot-twotone.svg?color=%23888" width="16" height="16" alt="box-plot" />
  ///
  /// antd React: `boxPlotTwoTone`
  static const String boxPlotTwoTone = 'assets/twotone/box-plot.svg';

  /// <img src="https://api.iconify.design/ant-design/bug-twotone.svg?color=%23888" width="16" height="16" alt="bug" />
  ///
  /// antd React: `bugTwoTone`
  static const String bugTwoTone = 'assets/twotone/bug.svg';

  /// <img src="https://api.iconify.design/ant-design/build-twotone.svg?color=%23888" width="16" height="16" alt="build" />
  ///
  /// antd React: `buildTwoTone`
  static const String buildTwoTone = 'assets/twotone/build.svg';

  /// <img src="https://api.iconify.design/ant-design/bulb-twotone.svg?color=%23888" width="16" height="16" alt="bulb" />
  ///
  /// antd React: `bulbTwoTone`
  static const String bulbTwoTone = 'assets/twotone/bulb.svg';

  /// <img src="https://api.iconify.design/ant-design/calculator-twotone.svg?color=%23888" width="16" height="16" alt="calculator" />
  ///
  /// antd React: `calculatorTwoTone`
  static const String calculatorTwoTone = 'assets/twotone/calculator.svg';

  /// <img src="https://api.iconify.design/ant-design/calendar-twotone.svg?color=%23888" width="16" height="16" alt="calendar" />
  ///
  /// antd React: `calendarTwoTone`
  static const String calendarTwoTone = 'assets/twotone/calendar.svg';

  /// <img src="https://api.iconify.design/ant-design/camera-twotone.svg?color=%23888" width="16" height="16" alt="camera" />
  ///
  /// antd React: `cameraTwoTone`
  static const String cameraTwoTone = 'assets/twotone/camera.svg';

  /// <img src="https://api.iconify.design/ant-design/car-twotone.svg?color=%23888" width="16" height="16" alt="car" />
  ///
  /// antd React: `carTwoTone`
  static const String carTwoTone = 'assets/twotone/car.svg';

  /// <img src="https://api.iconify.design/ant-design/carry-out-twotone.svg?color=%23888" width="16" height="16" alt="carry-out" />
  ///
  /// antd React: `carryOutTwoTone`
  static const String carryOutTwoTone = 'assets/twotone/carry-out.svg';

  /// <img src="https://api.iconify.design/ant-design/check-circle-twotone.svg?color=%23888" width="16" height="16" alt="check-circle" />
  ///
  /// antd React: `checkCircleTwoTone`
  static const String checkCircleTwoTone = 'assets/twotone/check-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/check-square-twotone.svg?color=%23888" width="16" height="16" alt="check-square" />
  ///
  /// antd React: `checkSquareTwoTone`
  static const String checkSquareTwoTone = 'assets/twotone/check-square.svg';

  /// <img src="https://api.iconify.design/ant-design/ci-twotone.svg?color=%23888" width="16" height="16" alt="ci" />
  ///
  /// antd React: `ciTwoTone`
  static const String ciTwoTone = 'assets/twotone/ci.svg';

  /// <img src="https://api.iconify.design/ant-design/ci-circle-twotone.svg?color=%23888" width="16" height="16" alt="ci-circle" />
  ///
  /// antd React: `ciCircleTwoTone`
  static const String ciCircleTwoTone = 'assets/twotone/ci-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/clock-circle-twotone.svg?color=%23888" width="16" height="16" alt="clock-circle" />
  ///
  /// antd React: `clockCircleTwoTone`
  static const String clockCircleTwoTone = 'assets/twotone/clock-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/close-circle-twotone.svg?color=%23888" width="16" height="16" alt="close-circle" />
  ///
  /// antd React: `closeCircleTwoTone`
  static const String closeCircleTwoTone = 'assets/twotone/close-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/close-square-twotone.svg?color=%23888" width="16" height="16" alt="close-square" />
  ///
  /// antd React: `closeSquareTwoTone`
  static const String closeSquareTwoTone = 'assets/twotone/close-square.svg';

  /// <img src="https://api.iconify.design/ant-design/cloud-twotone.svg?color=%23888" width="16" height="16" alt="cloud" />
  ///
  /// antd React: `cloudTwoTone`
  static const String cloudTwoTone = 'assets/twotone/cloud.svg';

  /// <img src="https://api.iconify.design/ant-design/code-twotone.svg?color=%23888" width="16" height="16" alt="code" />
  ///
  /// antd React: `codeTwoTone`
  static const String codeTwoTone = 'assets/twotone/code.svg';

  /// <img src="https://api.iconify.design/ant-design/compass-twotone.svg?color=%23888" width="16" height="16" alt="compass" />
  ///
  /// antd React: `compassTwoTone`
  static const String compassTwoTone = 'assets/twotone/compass.svg';

  /// <img src="https://api.iconify.design/ant-design/contacts-twotone.svg?color=%23888" width="16" height="16" alt="contacts" />
  ///
  /// antd React: `contactsTwoTone`
  static const String contactsTwoTone = 'assets/twotone/contacts.svg';

  /// <img src="https://api.iconify.design/ant-design/container-twotone.svg?color=%23888" width="16" height="16" alt="container" />
  ///
  /// antd React: `containerTwoTone`
  static const String containerTwoTone = 'assets/twotone/container.svg';

  /// <img src="https://api.iconify.design/ant-design/control-twotone.svg?color=%23888" width="16" height="16" alt="control" />
  ///
  /// antd React: `controlTwoTone`
  static const String controlTwoTone = 'assets/twotone/control.svg';

  /// <img src="https://api.iconify.design/ant-design/copy-twotone.svg?color=%23888" width="16" height="16" alt="copy" />
  ///
  /// antd React: `copyTwoTone`
  static const String copyTwoTone = 'assets/twotone/copy.svg';

  /// <img src="https://api.iconify.design/ant-design/copyright-twotone.svg?color=%23888" width="16" height="16" alt="copyright" />
  ///
  /// antd React: `copyrightTwoTone`
  static const String copyrightTwoTone = 'assets/twotone/copyright.svg';

  /// <img src="https://api.iconify.design/ant-design/copyright-circle-twotone.svg?color=%23888" width="16" height="16" alt="copyright-circle" />
  ///
  /// antd React: `copyrightCircleTwoTone`
  static const String copyrightCircleTwoTone = 'assets/twotone/copyright-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/credit-card-twotone.svg?color=%23888" width="16" height="16" alt="credit-card" />
  ///
  /// antd React: `creditCardTwoTone`
  static const String creditCardTwoTone = 'assets/twotone/credit-card.svg';

  /// <img src="https://api.iconify.design/ant-design/crown-twotone.svg?color=%23888" width="16" height="16" alt="crown" />
  ///
  /// antd React: `crownTwoTone`
  static const String crownTwoTone = 'assets/twotone/crown.svg';

  /// <img src="https://api.iconify.design/ant-design/customer-service-twotone.svg?color=%23888" width="16" height="16" alt="customer-service" />
  ///
  /// antd React: `customerServiceTwoTone`
  static const String customerServiceTwoTone = 'assets/twotone/customer-service.svg';

  /// <img src="https://api.iconify.design/ant-design/dashboard-twotone.svg?color=%23888" width="16" height="16" alt="dashboard" />
  ///
  /// antd React: `dashboardTwoTone`
  static const String dashboardTwoTone = 'assets/twotone/dashboard.svg';

  /// <img src="https://api.iconify.design/ant-design/database-twotone.svg?color=%23888" width="16" height="16" alt="database" />
  ///
  /// antd React: `databaseTwoTone`
  static const String databaseTwoTone = 'assets/twotone/database.svg';

  /// <img src="https://api.iconify.design/ant-design/delete-twotone.svg?color=%23888" width="16" height="16" alt="delete" />
  ///
  /// antd React: `deleteTwoTone`
  static const String deleteTwoTone = 'assets/twotone/delete.svg';

  /// <img src="https://api.iconify.design/ant-design/diff-twotone.svg?color=%23888" width="16" height="16" alt="diff" />
  ///
  /// antd React: `diffTwoTone`
  static const String diffTwoTone = 'assets/twotone/diff.svg';

  /// <img src="https://api.iconify.design/ant-design/dislike-twotone.svg?color=%23888" width="16" height="16" alt="dislike" />
  ///
  /// antd React: `dislikeTwoTone`
  static const String dislikeTwoTone = 'assets/twotone/dislike.svg';

  /// <img src="https://api.iconify.design/ant-design/dollar-twotone.svg?color=%23888" width="16" height="16" alt="dollar" />
  ///
  /// antd React: `dollarTwoTone`
  static const String dollarTwoTone = 'assets/twotone/dollar.svg';

  /// <img src="https://api.iconify.design/ant-design/dollar-circle-twotone.svg?color=%23888" width="16" height="16" alt="dollar-circle" />
  ///
  /// antd React: `dollarCircleTwoTone`
  static const String dollarCircleTwoTone = 'assets/twotone/dollar-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/down-circle-twotone.svg?color=%23888" width="16" height="16" alt="down-circle" />
  ///
  /// antd React: `downCircleTwoTone`
  static const String downCircleTwoTone = 'assets/twotone/down-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/down-square-twotone.svg?color=%23888" width="16" height="16" alt="down-square" />
  ///
  /// antd React: `downSquareTwoTone`
  static const String downSquareTwoTone = 'assets/twotone/down-square.svg';

  /// <img src="https://api.iconify.design/ant-design/edit-twotone.svg?color=%23888" width="16" height="16" alt="edit" />
  ///
  /// antd React: `editTwoTone`
  static const String editTwoTone = 'assets/twotone/edit.svg';

  /// <img src="https://api.iconify.design/ant-design/environment-twotone.svg?color=%23888" width="16" height="16" alt="environment" />
  ///
  /// antd React: `environmentTwoTone`
  static const String environmentTwoTone = 'assets/twotone/environment.svg';

  /// <img src="https://api.iconify.design/ant-design/euro-twotone.svg?color=%23888" width="16" height="16" alt="euro" />
  ///
  /// antd React: `euroTwoTone`
  static const String euroTwoTone = 'assets/twotone/euro.svg';

  /// <img src="https://api.iconify.design/ant-design/euro-circle-twotone.svg?color=%23888" width="16" height="16" alt="euro-circle" />
  ///
  /// antd React: `euroCircleTwoTone`
  static const String euroCircleTwoTone = 'assets/twotone/euro-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/exclamation-circle-twotone.svg?color=%23888" width="16" height="16" alt="exclamation-circle" />
  ///
  /// antd React: `exclamationCircleTwoTone`
  static const String exclamationCircleTwoTone = 'assets/twotone/exclamation-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/experiment-twotone.svg?color=%23888" width="16" height="16" alt="experiment" />
  ///
  /// antd React: `experimentTwoTone`
  static const String experimentTwoTone = 'assets/twotone/experiment.svg';

  /// <img src="https://api.iconify.design/ant-design/eye-twotone.svg?color=%23888" width="16" height="16" alt="eye" />
  ///
  /// antd React: `eyeTwoTone`
  static const String eyeTwoTone = 'assets/twotone/eye.svg';

  /// <img src="https://api.iconify.design/ant-design/eye-invisible-twotone.svg?color=%23888" width="16" height="16" alt="eye-invisible" />
  ///
  /// antd React: `eyeInvisibleTwoTone`
  static const String eyeInvisibleTwoTone = 'assets/twotone/eye-invisible.svg';

  /// <img src="https://api.iconify.design/ant-design/file-twotone.svg?color=%23888" width="16" height="16" alt="file" />
  ///
  /// antd React: `fileTwoTone`
  static const String fileTwoTone = 'assets/twotone/file.svg';

  /// <img src="https://api.iconify.design/ant-design/file-add-twotone.svg?color=%23888" width="16" height="16" alt="file-add" />
  ///
  /// antd React: `fileAddTwoTone`
  static const String fileAddTwoTone = 'assets/twotone/file-add.svg';

  /// <img src="https://api.iconify.design/ant-design/file-excel-twotone.svg?color=%23888" width="16" height="16" alt="file-excel" />
  ///
  /// antd React: `fileExcelTwoTone`
  static const String fileExcelTwoTone = 'assets/twotone/file-excel.svg';

  /// <img src="https://api.iconify.design/ant-design/file-exclamation-twotone.svg?color=%23888" width="16" height="16" alt="file-exclamation" />
  ///
  /// antd React: `fileExclamationTwoTone`
  static const String fileExclamationTwoTone = 'assets/twotone/file-exclamation.svg';

  /// <img src="https://api.iconify.design/ant-design/file-image-twotone.svg?color=%23888" width="16" height="16" alt="file-image" />
  ///
  /// antd React: `fileImageTwoTone`
  static const String fileImageTwoTone = 'assets/twotone/file-image.svg';

  /// <img src="https://api.iconify.design/ant-design/file-markdown-twotone.svg?color=%23888" width="16" height="16" alt="file-markdown" />
  ///
  /// antd React: `fileMarkdownTwoTone`
  static const String fileMarkdownTwoTone = 'assets/twotone/file-markdown.svg';

  /// <img src="https://api.iconify.design/ant-design/file-pdf-twotone.svg?color=%23888" width="16" height="16" alt="file-pdf" />
  ///
  /// antd React: `filePdfTwoTone`
  static const String filePdfTwoTone = 'assets/twotone/file-pdf.svg';

  /// <img src="https://api.iconify.design/ant-design/file-ppt-twotone.svg?color=%23888" width="16" height="16" alt="file-ppt" />
  ///
  /// antd React: `filePptTwoTone`
  static const String filePptTwoTone = 'assets/twotone/file-ppt.svg';

  /// <img src="https://api.iconify.design/ant-design/file-text-twotone.svg?color=%23888" width="16" height="16" alt="file-text" />
  ///
  /// antd React: `fileTextTwoTone`
  static const String fileTextTwoTone = 'assets/twotone/file-text.svg';

  /// <img src="https://api.iconify.design/ant-design/file-unknown-twotone.svg?color=%23888" width="16" height="16" alt="file-unknown" />
  ///
  /// antd React: `fileUnknownTwoTone`
  static const String fileUnknownTwoTone = 'assets/twotone/file-unknown.svg';

  /// <img src="https://api.iconify.design/ant-design/file-word-twotone.svg?color=%23888" width="16" height="16" alt="file-word" />
  ///
  /// antd React: `fileWordTwoTone`
  static const String fileWordTwoTone = 'assets/twotone/file-word.svg';

  /// <img src="https://api.iconify.design/ant-design/file-zip-twotone.svg?color=%23888" width="16" height="16" alt="file-zip" />
  ///
  /// antd React: `fileZipTwoTone`
  static const String fileZipTwoTone = 'assets/twotone/file-zip.svg';

  /// <img src="https://api.iconify.design/ant-design/filter-twotone.svg?color=%23888" width="16" height="16" alt="filter" />
  ///
  /// antd React: `filterTwoTone`
  static const String filterTwoTone = 'assets/twotone/filter.svg';

  /// <img src="https://api.iconify.design/ant-design/fire-twotone.svg?color=%23888" width="16" height="16" alt="fire" />
  ///
  /// antd React: `fireTwoTone`
  static const String fireTwoTone = 'assets/twotone/fire.svg';

  /// <img src="https://api.iconify.design/ant-design/flag-twotone.svg?color=%23888" width="16" height="16" alt="flag" />
  ///
  /// antd React: `flagTwoTone`
  static const String flagTwoTone = 'assets/twotone/flag.svg';

  /// <img src="https://api.iconify.design/ant-design/folder-twotone.svg?color=%23888" width="16" height="16" alt="folder" />
  ///
  /// antd React: `folderTwoTone`
  static const String folderTwoTone = 'assets/twotone/folder.svg';

  /// <img src="https://api.iconify.design/ant-design/folder-add-twotone.svg?color=%23888" width="16" height="16" alt="folder-add" />
  ///
  /// antd React: `folderAddTwoTone`
  static const String folderAddTwoTone = 'assets/twotone/folder-add.svg';

  /// <img src="https://api.iconify.design/ant-design/folder-open-twotone.svg?color=%23888" width="16" height="16" alt="folder-open" />
  ///
  /// antd React: `folderOpenTwoTone`
  static const String folderOpenTwoTone = 'assets/twotone/folder-open.svg';

  /// <img src="https://api.iconify.design/ant-design/frown-twotone.svg?color=%23888" width="16" height="16" alt="frown" />
  ///
  /// antd React: `frownTwoTone`
  static const String frownTwoTone = 'assets/twotone/frown.svg';

  /// <img src="https://api.iconify.design/ant-design/fund-twotone.svg?color=%23888" width="16" height="16" alt="fund" />
  ///
  /// antd React: `fundTwoTone`
  static const String fundTwoTone = 'assets/twotone/fund.svg';

  /// <img src="https://api.iconify.design/ant-design/funnel-plot-twotone.svg?color=%23888" width="16" height="16" alt="funnel-plot" />
  ///
  /// antd React: `funnelPlotTwoTone`
  static const String funnelPlotTwoTone = 'assets/twotone/funnel-plot.svg';

  /// <img src="https://api.iconify.design/ant-design/gift-twotone.svg?color=%23888" width="16" height="16" alt="gift" />
  ///
  /// antd React: `giftTwoTone`
  static const String giftTwoTone = 'assets/twotone/gift.svg';

  /// <img src="https://api.iconify.design/ant-design/gold-twotone.svg?color=%23888" width="16" height="16" alt="gold" />
  ///
  /// antd React: `goldTwoTone`
  static const String goldTwoTone = 'assets/twotone/gold.svg';

  /// <img src="https://api.iconify.design/ant-design/hdd-twotone.svg?color=%23888" width="16" height="16" alt="hdd" />
  ///
  /// antd React: `hddTwoTone`
  static const String hddTwoTone = 'assets/twotone/hdd.svg';

  /// <img src="https://api.iconify.design/ant-design/heart-twotone.svg?color=%23888" width="16" height="16" alt="heart" />
  ///
  /// antd React: `heartTwoTone`
  static const String heartTwoTone = 'assets/twotone/heart.svg';

  /// <img src="https://api.iconify.design/ant-design/highlight-twotone.svg?color=%23888" width="16" height="16" alt="highlight" />
  ///
  /// antd React: `highlightTwoTone`
  static const String highlightTwoTone = 'assets/twotone/highlight.svg';

  /// <img src="https://api.iconify.design/ant-design/home-twotone.svg?color=%23888" width="16" height="16" alt="home" />
  ///
  /// antd React: `homeTwoTone`
  static const String homeTwoTone = 'assets/twotone/home.svg';

  /// <img src="https://api.iconify.design/ant-design/hourglass-twotone.svg?color=%23888" width="16" height="16" alt="hourglass" />
  ///
  /// antd React: `hourglassTwoTone`
  static const String hourglassTwoTone = 'assets/twotone/hourglass.svg';

  /// <img src="https://api.iconify.design/ant-design/html5-twotone.svg?color=%23888" width="16" height="16" alt="html5" />
  ///
  /// antd React: `html5TwoTone`
  static const String html5TwoTone = 'assets/twotone/html5.svg';

  /// <img src="https://api.iconify.design/ant-design/idcard-twotone.svg?color=%23888" width="16" height="16" alt="idcard" />
  ///
  /// antd React: `idcardTwoTone`
  static const String idcardTwoTone = 'assets/twotone/idcard.svg';

  /// <img src="https://api.iconify.design/ant-design/info-circle-twotone.svg?color=%23888" width="16" height="16" alt="info-circle" />
  ///
  /// antd React: `infoCircleTwoTone`
  static const String infoCircleTwoTone = 'assets/twotone/info-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/insurance-twotone.svg?color=%23888" width="16" height="16" alt="insurance" />
  ///
  /// antd React: `insuranceTwoTone`
  static const String insuranceTwoTone = 'assets/twotone/insurance.svg';

  /// <img src="https://api.iconify.design/ant-design/interaction-twotone.svg?color=%23888" width="16" height="16" alt="interaction" />
  ///
  /// antd React: `interactionTwoTone`
  static const String interactionTwoTone = 'assets/twotone/interaction.svg';

  /// <img src="https://api.iconify.design/ant-design/layout-twotone.svg?color=%23888" width="16" height="16" alt="layout" />
  ///
  /// antd React: `layoutTwoTone`
  static const String layoutTwoTone = 'assets/twotone/layout.svg';

  /// <img src="https://api.iconify.design/ant-design/left-circle-twotone.svg?color=%23888" width="16" height="16" alt="left-circle" />
  ///
  /// antd React: `leftCircleTwoTone`
  static const String leftCircleTwoTone = 'assets/twotone/left-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/left-square-twotone.svg?color=%23888" width="16" height="16" alt="left-square" />
  ///
  /// antd React: `leftSquareTwoTone`
  static const String leftSquareTwoTone = 'assets/twotone/left-square.svg';

  /// <img src="https://api.iconify.design/ant-design/like-twotone.svg?color=%23888" width="16" height="16" alt="like" />
  ///
  /// antd React: `likeTwoTone`
  static const String likeTwoTone = 'assets/twotone/like.svg';

  /// <img src="https://api.iconify.design/ant-design/lock-twotone.svg?color=%23888" width="16" height="16" alt="lock" />
  ///
  /// antd React: `lockTwoTone`
  static const String lockTwoTone = 'assets/twotone/lock.svg';

  /// <img src="https://api.iconify.design/ant-design/mail-twotone.svg?color=%23888" width="16" height="16" alt="mail" />
  ///
  /// antd React: `mailTwoTone`
  static const String mailTwoTone = 'assets/twotone/mail.svg';

  /// <img src="https://api.iconify.design/ant-design/medicine-box-twotone.svg?color=%23888" width="16" height="16" alt="medicine-box" />
  ///
  /// antd React: `medicineBoxTwoTone`
  static const String medicineBoxTwoTone = 'assets/twotone/medicine-box.svg';

  /// <img src="https://api.iconify.design/ant-design/meh-twotone.svg?color=%23888" width="16" height="16" alt="meh" />
  ///
  /// antd React: `mehTwoTone`
  static const String mehTwoTone = 'assets/twotone/meh.svg';

  /// <img src="https://api.iconify.design/ant-design/message-twotone.svg?color=%23888" width="16" height="16" alt="message" />
  ///
  /// antd React: `messageTwoTone`
  static const String messageTwoTone = 'assets/twotone/message.svg';

  /// <img src="https://api.iconify.design/ant-design/minus-circle-twotone.svg?color=%23888" width="16" height="16" alt="minus-circle" />
  ///
  /// antd React: `minusCircleTwoTone`
  static const String minusCircleTwoTone = 'assets/twotone/minus-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/minus-square-twotone.svg?color=%23888" width="16" height="16" alt="minus-square" />
  ///
  /// antd React: `minusSquareTwoTone`
  static const String minusSquareTwoTone = 'assets/twotone/minus-square.svg';

  /// <img src="https://api.iconify.design/ant-design/mobile-twotone.svg?color=%23888" width="16" height="16" alt="mobile" />
  ///
  /// antd React: `mobileTwoTone`
  static const String mobileTwoTone = 'assets/twotone/mobile.svg';

  /// <img src="https://api.iconify.design/ant-design/money-collect-twotone.svg?color=%23888" width="16" height="16" alt="money-collect" />
  ///
  /// antd React: `moneyCollectTwoTone`
  static const String moneyCollectTwoTone = 'assets/twotone/money-collect.svg';

  /// <img src="https://api.iconify.design/ant-design/notification-twotone.svg?color=%23888" width="16" height="16" alt="notification" />
  ///
  /// antd React: `notificationTwoTone`
  static const String notificationTwoTone = 'assets/twotone/notification.svg';

  /// <img src="https://api.iconify.design/ant-design/pause-circle-twotone.svg?color=%23888" width="16" height="16" alt="pause-circle" />
  ///
  /// antd React: `pauseCircleTwoTone`
  static const String pauseCircleTwoTone = 'assets/twotone/pause-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/phone-twotone.svg?color=%23888" width="16" height="16" alt="phone" />
  ///
  /// antd React: `phoneTwoTone`
  static const String phoneTwoTone = 'assets/twotone/phone.svg';

  /// <img src="https://api.iconify.design/ant-design/picture-twotone.svg?color=%23888" width="16" height="16" alt="picture" />
  ///
  /// antd React: `pictureTwoTone`
  static const String pictureTwoTone = 'assets/twotone/picture.svg';

  /// <img src="https://api.iconify.design/ant-design/pie-chart-twotone.svg?color=%23888" width="16" height="16" alt="pie-chart" />
  ///
  /// antd React: `pieChartTwoTone`
  static const String pieChartTwoTone = 'assets/twotone/pie-chart.svg';

  /// <img src="https://api.iconify.design/ant-design/play-circle-twotone.svg?color=%23888" width="16" height="16" alt="play-circle" />
  ///
  /// antd React: `playCircleTwoTone`
  static const String playCircleTwoTone = 'assets/twotone/play-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/play-square-twotone.svg?color=%23888" width="16" height="16" alt="play-square" />
  ///
  /// antd React: `playSquareTwoTone`
  static const String playSquareTwoTone = 'assets/twotone/play-square.svg';

  /// <img src="https://api.iconify.design/ant-design/plus-circle-twotone.svg?color=%23888" width="16" height="16" alt="plus-circle" />
  ///
  /// antd React: `plusCircleTwoTone`
  static const String plusCircleTwoTone = 'assets/twotone/plus-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/plus-square-twotone.svg?color=%23888" width="16" height="16" alt="plus-square" />
  ///
  /// antd React: `plusSquareTwoTone`
  static const String plusSquareTwoTone = 'assets/twotone/plus-square.svg';

  /// <img src="https://api.iconify.design/ant-design/pound-circle-twotone.svg?color=%23888" width="16" height="16" alt="pound-circle" />
  ///
  /// antd React: `poundCircleTwoTone`
  static const String poundCircleTwoTone = 'assets/twotone/pound-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/printer-twotone.svg?color=%23888" width="16" height="16" alt="printer" />
  ///
  /// antd React: `printerTwoTone`
  static const String printerTwoTone = 'assets/twotone/printer.svg';

  /// <img src="https://api.iconify.design/ant-design/profile-twotone.svg?color=%23888" width="16" height="16" alt="profile" />
  ///
  /// antd React: `profileTwoTone`
  static const String profileTwoTone = 'assets/twotone/profile.svg';

  /// <img src="https://api.iconify.design/ant-design/project-twotone.svg?color=%23888" width="16" height="16" alt="project" />
  ///
  /// antd React: `projectTwoTone`
  static const String projectTwoTone = 'assets/twotone/project.svg';

  /// <img src="https://api.iconify.design/ant-design/property-safety-twotone.svg?color=%23888" width="16" height="16" alt="property-safety" />
  ///
  /// antd React: `propertySafetyTwoTone`
  static const String propertySafetyTwoTone = 'assets/twotone/property-safety.svg';

  /// <img src="https://api.iconify.design/ant-design/pushpin-twotone.svg?color=%23888" width="16" height="16" alt="pushpin" />
  ///
  /// antd React: `pushpinTwoTone`
  static const String pushpinTwoTone = 'assets/twotone/pushpin.svg';

  /// <img src="https://api.iconify.design/ant-design/question-circle-twotone.svg?color=%23888" width="16" height="16" alt="question-circle" />
  ///
  /// antd React: `questionCircleTwoTone`
  static const String questionCircleTwoTone = 'assets/twotone/question-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/reconciliation-twotone.svg?color=%23888" width="16" height="16" alt="reconciliation" />
  ///
  /// antd React: `reconciliationTwoTone`
  static const String reconciliationTwoTone = 'assets/twotone/reconciliation.svg';

  /// <img src="https://api.iconify.design/ant-design/red-envelope-twotone.svg?color=%23888" width="16" height="16" alt="red-envelope" />
  ///
  /// antd React: `redEnvelopeTwoTone`
  static const String redEnvelopeTwoTone = 'assets/twotone/red-envelope.svg';

  /// <img src="https://api.iconify.design/ant-design/rest-twotone.svg?color=%23888" width="16" height="16" alt="rest" />
  ///
  /// antd React: `restTwoTone`
  static const String restTwoTone = 'assets/twotone/rest.svg';

  /// <img src="https://api.iconify.design/ant-design/right-circle-twotone.svg?color=%23888" width="16" height="16" alt="right-circle" />
  ///
  /// antd React: `rightCircleTwoTone`
  static const String rightCircleTwoTone = 'assets/twotone/right-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/right-square-twotone.svg?color=%23888" width="16" height="16" alt="right-square" />
  ///
  /// antd React: `rightSquareTwoTone`
  static const String rightSquareTwoTone = 'assets/twotone/right-square.svg';

  /// <img src="https://api.iconify.design/ant-design/rocket-twotone.svg?color=%23888" width="16" height="16" alt="rocket" />
  ///
  /// antd React: `rocketTwoTone`
  static const String rocketTwoTone = 'assets/twotone/rocket.svg';

  /// <img src="https://api.iconify.design/ant-design/safety-certificate-twotone.svg?color=%23888" width="16" height="16" alt="safety-certificate" />
  ///
  /// antd React: `safetyCertificateTwoTone`
  static const String safetyCertificateTwoTone = 'assets/twotone/safety-certificate.svg';

  /// <img src="https://api.iconify.design/ant-design/save-twotone.svg?color=%23888" width="16" height="16" alt="save" />
  ///
  /// antd React: `saveTwoTone`
  static const String saveTwoTone = 'assets/twotone/save.svg';

  /// <img src="https://api.iconify.design/ant-design/schedule-twotone.svg?color=%23888" width="16" height="16" alt="schedule" />
  ///
  /// antd React: `scheduleTwoTone`
  static const String scheduleTwoTone = 'assets/twotone/schedule.svg';

  /// <img src="https://api.iconify.design/ant-design/security-scan-twotone.svg?color=%23888" width="16" height="16" alt="security-scan" />
  ///
  /// antd React: `securityScanTwoTone`
  static const String securityScanTwoTone = 'assets/twotone/security-scan.svg';

  /// <img src="https://api.iconify.design/ant-design/setting-twotone.svg?color=%23888" width="16" height="16" alt="setting" />
  ///
  /// antd React: `settingTwoTone`
  static const String settingTwoTone = 'assets/twotone/setting.svg';

  /// <img src="https://api.iconify.design/ant-design/shop-twotone.svg?color=%23888" width="16" height="16" alt="shop" />
  ///
  /// antd React: `shopTwoTone`
  static const String shopTwoTone = 'assets/twotone/shop.svg';

  /// <img src="https://api.iconify.design/ant-design/shopping-twotone.svg?color=%23888" width="16" height="16" alt="shopping" />
  ///
  /// antd React: `shoppingTwoTone`
  static const String shoppingTwoTone = 'assets/twotone/shopping.svg';

  /// <img src="https://api.iconify.design/ant-design/skin-twotone.svg?color=%23888" width="16" height="16" alt="skin" />
  ///
  /// antd React: `skinTwoTone`
  static const String skinTwoTone = 'assets/twotone/skin.svg';

  /// <img src="https://api.iconify.design/ant-design/sliders-twotone.svg?color=%23888" width="16" height="16" alt="sliders" />
  ///
  /// antd React: `slidersTwoTone`
  static const String slidersTwoTone = 'assets/twotone/sliders.svg';

  /// <img src="https://api.iconify.design/ant-design/smile-twotone.svg?color=%23888" width="16" height="16" alt="smile" />
  ///
  /// antd React: `smileTwoTone`
  static const String smileTwoTone = 'assets/twotone/smile.svg';

  /// <img src="https://api.iconify.design/ant-design/snippets-twotone.svg?color=%23888" width="16" height="16" alt="snippets" />
  ///
  /// antd React: `snippetsTwoTone`
  static const String snippetsTwoTone = 'assets/twotone/snippets.svg';

  /// <img src="https://api.iconify.design/ant-design/sound-twotone.svg?color=%23888" width="16" height="16" alt="sound" />
  ///
  /// antd React: `soundTwoTone`
  static const String soundTwoTone = 'assets/twotone/sound.svg';

  /// <img src="https://api.iconify.design/ant-design/star-twotone.svg?color=%23888" width="16" height="16" alt="star" />
  ///
  /// antd React: `starTwoTone`
  static const String starTwoTone = 'assets/twotone/star.svg';

  /// <img src="https://api.iconify.design/ant-design/stop-twotone.svg?color=%23888" width="16" height="16" alt="stop" />
  ///
  /// antd React: `stopTwoTone`
  static const String stopTwoTone = 'assets/twotone/stop.svg';

  /// <img src="https://api.iconify.design/ant-design/switcher-twotone.svg?color=%23888" width="16" height="16" alt="switcher" />
  ///
  /// antd React: `switcherTwoTone`
  static const String switcherTwoTone = 'assets/twotone/switcher.svg';

  /// <img src="https://api.iconify.design/ant-design/tablet-twotone.svg?color=%23888" width="16" height="16" alt="tablet" />
  ///
  /// antd React: `tabletTwoTone`
  static const String tabletTwoTone = 'assets/twotone/tablet.svg';

  /// <img src="https://api.iconify.design/ant-design/tag-twotone.svg?color=%23888" width="16" height="16" alt="tag" />
  ///
  /// antd React: `tagTwoTone`
  static const String tagTwoTone = 'assets/twotone/tag.svg';

  /// <img src="https://api.iconify.design/ant-design/tags-twotone.svg?color=%23888" width="16" height="16" alt="tags" />
  ///
  /// antd React: `tagsTwoTone`
  static const String tagsTwoTone = 'assets/twotone/tags.svg';

  /// <img src="https://api.iconify.design/ant-design/thunderbolt-twotone.svg?color=%23888" width="16" height="16" alt="thunderbolt" />
  ///
  /// antd React: `thunderboltTwoTone`
  static const String thunderboltTwoTone = 'assets/twotone/thunderbolt.svg';

  /// <img src="https://api.iconify.design/ant-design/tool-twotone.svg?color=%23888" width="16" height="16" alt="tool" />
  ///
  /// antd React: `toolTwoTone`
  static const String toolTwoTone = 'assets/twotone/tool.svg';

  /// <img src="https://api.iconify.design/ant-design/trademark-circle-twotone.svg?color=%23888" width="16" height="16" alt="trademark-circle" />
  ///
  /// antd React: `trademarkCircleTwoTone`
  static const String trademarkCircleTwoTone = 'assets/twotone/trademark-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/trophy-twotone.svg?color=%23888" width="16" height="16" alt="trophy" />
  ///
  /// antd React: `trophyTwoTone`
  static const String trophyTwoTone = 'assets/twotone/trophy.svg';

  /// <img src="https://api.iconify.design/ant-design/unlock-twotone.svg?color=%23888" width="16" height="16" alt="unlock" />
  ///
  /// antd React: `unlockTwoTone`
  static const String unlockTwoTone = 'assets/twotone/unlock.svg';

  /// <img src="https://api.iconify.design/ant-design/up-circle-twotone.svg?color=%23888" width="16" height="16" alt="up-circle" />
  ///
  /// antd React: `upCircleTwoTone`
  static const String upCircleTwoTone = 'assets/twotone/up-circle.svg';

  /// <img src="https://api.iconify.design/ant-design/up-square-twotone.svg?color=%23888" width="16" height="16" alt="up-square" />
  ///
  /// antd React: `upSquareTwoTone`
  static const String upSquareTwoTone = 'assets/twotone/up-square.svg';

  /// <img src="https://api.iconify.design/ant-design/usb-twotone.svg?color=%23888" width="16" height="16" alt="usb" />
  ///
  /// antd React: `usbTwoTone`
  static const String usbTwoTone = 'assets/twotone/usb.svg';

  /// <img src="https://api.iconify.design/ant-design/video-camera-twotone.svg?color=%23888" width="16" height="16" alt="video-camera" />
  ///
  /// antd React: `videoCameraTwoTone`
  static const String videoCameraTwoTone = 'assets/twotone/video-camera.svg';

  /// <img src="https://api.iconify.design/ant-design/wallet-twotone.svg?color=%23888" width="16" height="16" alt="wallet" />
  ///
  /// antd React: `walletTwoTone`
  static const String walletTwoTone = 'assets/twotone/wallet.svg';

  /// <img src="https://api.iconify.design/ant-design/warning-twotone.svg?color=%23888" width="16" height="16" alt="warning" />
  ///
  /// antd React: `warningTwoTone`
  static const String warningTwoTone = 'assets/twotone/warning.svg';

  /// 全部 TwoTone 图标的 (名称, 资产路径) 枚举列表，共 150 个。
  static const List<(String name, String path)> twotoneIcons = [
    ('accountBookTwoTone', accountBookTwoTone),
    ('alertTwoTone', alertTwoTone),
    ('apiTwoTone', apiTwoTone),
    ('appstoreTwoTone', appstoreTwoTone),
    ('audioTwoTone', audioTwoTone),
    ('bankTwoTone', bankTwoTone),
    ('bellTwoTone', bellTwoTone),
    ('bookTwoTone', bookTwoTone),
    ('boxPlotTwoTone', boxPlotTwoTone),
    ('bugTwoTone', bugTwoTone),
    ('buildTwoTone', buildTwoTone),
    ('bulbTwoTone', bulbTwoTone),
    ('calculatorTwoTone', calculatorTwoTone),
    ('calendarTwoTone', calendarTwoTone),
    ('cameraTwoTone', cameraTwoTone),
    ('carTwoTone', carTwoTone),
    ('carryOutTwoTone', carryOutTwoTone),
    ('checkCircleTwoTone', checkCircleTwoTone),
    ('checkSquareTwoTone', checkSquareTwoTone),
    ('ciTwoTone', ciTwoTone),
    ('ciCircleTwoTone', ciCircleTwoTone),
    ('clockCircleTwoTone', clockCircleTwoTone),
    ('closeCircleTwoTone', closeCircleTwoTone),
    ('closeSquareTwoTone', closeSquareTwoTone),
    ('cloudTwoTone', cloudTwoTone),
    ('codeTwoTone', codeTwoTone),
    ('compassTwoTone', compassTwoTone),
    ('contactsTwoTone', contactsTwoTone),
    ('containerTwoTone', containerTwoTone),
    ('controlTwoTone', controlTwoTone),
    ('copyTwoTone', copyTwoTone),
    ('copyrightTwoTone', copyrightTwoTone),
    ('copyrightCircleTwoTone', copyrightCircleTwoTone),
    ('creditCardTwoTone', creditCardTwoTone),
    ('crownTwoTone', crownTwoTone),
    ('customerServiceTwoTone', customerServiceTwoTone),
    ('dashboardTwoTone', dashboardTwoTone),
    ('databaseTwoTone', databaseTwoTone),
    ('deleteTwoTone', deleteTwoTone),
    ('diffTwoTone', diffTwoTone),
    ('dislikeTwoTone', dislikeTwoTone),
    ('dollarTwoTone', dollarTwoTone),
    ('dollarCircleTwoTone', dollarCircleTwoTone),
    ('downCircleTwoTone', downCircleTwoTone),
    ('downSquareTwoTone', downSquareTwoTone),
    ('editTwoTone', editTwoTone),
    ('environmentTwoTone', environmentTwoTone),
    ('euroTwoTone', euroTwoTone),
    ('euroCircleTwoTone', euroCircleTwoTone),
    ('exclamationCircleTwoTone', exclamationCircleTwoTone),
    ('experimentTwoTone', experimentTwoTone),
    ('eyeTwoTone', eyeTwoTone),
    ('eyeInvisibleTwoTone', eyeInvisibleTwoTone),
    ('fileTwoTone', fileTwoTone),
    ('fileAddTwoTone', fileAddTwoTone),
    ('fileExcelTwoTone', fileExcelTwoTone),
    ('fileExclamationTwoTone', fileExclamationTwoTone),
    ('fileImageTwoTone', fileImageTwoTone),
    ('fileMarkdownTwoTone', fileMarkdownTwoTone),
    ('filePdfTwoTone', filePdfTwoTone),
    ('filePptTwoTone', filePptTwoTone),
    ('fileTextTwoTone', fileTextTwoTone),
    ('fileUnknownTwoTone', fileUnknownTwoTone),
    ('fileWordTwoTone', fileWordTwoTone),
    ('fileZipTwoTone', fileZipTwoTone),
    ('filterTwoTone', filterTwoTone),
    ('fireTwoTone', fireTwoTone),
    ('flagTwoTone', flagTwoTone),
    ('folderTwoTone', folderTwoTone),
    ('folderAddTwoTone', folderAddTwoTone),
    ('folderOpenTwoTone', folderOpenTwoTone),
    ('frownTwoTone', frownTwoTone),
    ('fundTwoTone', fundTwoTone),
    ('funnelPlotTwoTone', funnelPlotTwoTone),
    ('giftTwoTone', giftTwoTone),
    ('goldTwoTone', goldTwoTone),
    ('hddTwoTone', hddTwoTone),
    ('heartTwoTone', heartTwoTone),
    ('highlightTwoTone', highlightTwoTone),
    ('homeTwoTone', homeTwoTone),
    ('hourglassTwoTone', hourglassTwoTone),
    ('html5TwoTone', html5TwoTone),
    ('idcardTwoTone', idcardTwoTone),
    ('infoCircleTwoTone', infoCircleTwoTone),
    ('insuranceTwoTone', insuranceTwoTone),
    ('interactionTwoTone', interactionTwoTone),
    ('layoutTwoTone', layoutTwoTone),
    ('leftCircleTwoTone', leftCircleTwoTone),
    ('leftSquareTwoTone', leftSquareTwoTone),
    ('likeTwoTone', likeTwoTone),
    ('lockTwoTone', lockTwoTone),
    ('mailTwoTone', mailTwoTone),
    ('medicineBoxTwoTone', medicineBoxTwoTone),
    ('mehTwoTone', mehTwoTone),
    ('messageTwoTone', messageTwoTone),
    ('minusCircleTwoTone', minusCircleTwoTone),
    ('minusSquareTwoTone', minusSquareTwoTone),
    ('mobileTwoTone', mobileTwoTone),
    ('moneyCollectTwoTone', moneyCollectTwoTone),
    ('notificationTwoTone', notificationTwoTone),
    ('pauseCircleTwoTone', pauseCircleTwoTone),
    ('phoneTwoTone', phoneTwoTone),
    ('pictureTwoTone', pictureTwoTone),
    ('pieChartTwoTone', pieChartTwoTone),
    ('playCircleTwoTone', playCircleTwoTone),
    ('playSquareTwoTone', playSquareTwoTone),
    ('plusCircleTwoTone', plusCircleTwoTone),
    ('plusSquareTwoTone', plusSquareTwoTone),
    ('poundCircleTwoTone', poundCircleTwoTone),
    ('printerTwoTone', printerTwoTone),
    ('profileTwoTone', profileTwoTone),
    ('projectTwoTone', projectTwoTone),
    ('propertySafetyTwoTone', propertySafetyTwoTone),
    ('pushpinTwoTone', pushpinTwoTone),
    ('questionCircleTwoTone', questionCircleTwoTone),
    ('reconciliationTwoTone', reconciliationTwoTone),
    ('redEnvelopeTwoTone', redEnvelopeTwoTone),
    ('restTwoTone', restTwoTone),
    ('rightCircleTwoTone', rightCircleTwoTone),
    ('rightSquareTwoTone', rightSquareTwoTone),
    ('rocketTwoTone', rocketTwoTone),
    ('safetyCertificateTwoTone', safetyCertificateTwoTone),
    ('saveTwoTone', saveTwoTone),
    ('scheduleTwoTone', scheduleTwoTone),
    ('securityScanTwoTone', securityScanTwoTone),
    ('settingTwoTone', settingTwoTone),
    ('shopTwoTone', shopTwoTone),
    ('shoppingTwoTone', shoppingTwoTone),
    ('skinTwoTone', skinTwoTone),
    ('slidersTwoTone', slidersTwoTone),
    ('smileTwoTone', smileTwoTone),
    ('snippetsTwoTone', snippetsTwoTone),
    ('soundTwoTone', soundTwoTone),
    ('starTwoTone', starTwoTone),
    ('stopTwoTone', stopTwoTone),
    ('switcherTwoTone', switcherTwoTone),
    ('tabletTwoTone', tabletTwoTone),
    ('tagTwoTone', tagTwoTone),
    ('tagsTwoTone', tagsTwoTone),
    ('thunderboltTwoTone', thunderboltTwoTone),
    ('toolTwoTone', toolTwoTone),
    ('trademarkCircleTwoTone', trademarkCircleTwoTone),
    ('trophyTwoTone', trophyTwoTone),
    ('unlockTwoTone', unlockTwoTone),
    ('upCircleTwoTone', upCircleTwoTone),
    ('upSquareTwoTone', upSquareTwoTone),
    ('usbTwoTone', usbTwoTone),
    ('videoCameraTwoTone', videoCameraTwoTone),
    ('walletTwoTone', walletTwoTone),
    ('warningTwoTone', warningTwoTone),
  ];
}
