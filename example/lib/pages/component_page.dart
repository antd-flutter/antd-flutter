library;

/// 组件展示页 — 根据 snakeName 路由到对应组件演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

import 'auto_center_page.dart';
import 'avatar_page.dart';
import 'affix_page.dart';
import 'app_page.dart';
import 'border_beam_page.dart';
import 'config_provider_page.dart';
import 'loading_page.dart';
import 'swipe_action_page.dart';
import 'action_sheet_page.dart';
import 'dialog_page.dart';
import 'mask_page.dart';
import 'popup_page.dart';
import 'pull_to_refresh_page.dart';
import 'toast_page.dart';
import 'alert_page.dart';
import 'drawer_page.dart';
import 'message_page.dart';
import 'modal_page.dart';
import 'notification_page.dart';
import 'popconfirm_page.dart';
import 'progress_page.dart';
import 'result_page.dart';
import 'skeleton_page.dart';
import 'spin_page.dart';
import 'watermark_page.dart';
import 'ellipsis_page.dart';
import 'floating_bubble_page.dart';
import 'floating_panel_page.dart';
import 'footer_page.dart';
import 'image_viewer_page.dart';
import 'infinite_scroll_page.dart';
import 'page_indicator_page.dart';
import 'calendar_page.dart';
import 'collapse_page.dart';
import 'descriptions_page.dart';
import 'list_page.dart';
import 'table_page.dart';
import 'timeline_page.dart';
import 'tour_page.dart';
import 'tree_page.dart';
import 'carousel_page.dart';
import 'image_page.dart';
import 'popover_page.dart';
import 'qr_code_page.dart';
import 'segmented_page.dart';
import 'tooltip_page.dart';
import 'badge_page.dart';
import 'card_page.dart';
import 'tag_page.dart';
import 'auto_complete_page.dart';
import 'anchor_page.dart';
import 'breadcrumb_page.dart';
import 'button_page.dart';
import 'calendar_picker_page.dart';
import 'capsule_tabs_page.dart';
import 'cascader_page.dart';
import 'cascader_view_page.dart';
import 'checkbox_page.dart';
import 'check_list_page.dart';
import 'color_picker_page.dart';
import 'date_picker_page.dart';
import 'divider_page.dart';
import 'dropdown_page.dart';
import 'empty_page.dart';
import 'flex_page.dart';
import 'float_button_page.dart';
import 'form_page.dart';
import 'grid_page.dart';
import 'icon_page.dart';
import 'image_uploader_page.dart';
import 'index_bar_page.dart';
import 'input_number_page.dart';
import 'input_page.dart';
import 'jumbo_tabs_page.dart';
import 'layout_page.dart';
import 'masonry_page.dart';
import 'mentions_page.dart';
import 'menu_page.dart';
import 'nav_bar_page.dart';
import 'notice_bar_page.dart';
import 'number_keyboard_page.dart';
import 'pagination_page.dart';
import 'passcode_input_page.dart';
import 'picker_page.dart';
import 'rate_page.dart';
import 'radio_page.dart';
import 'safe_area_page.dart';
import 'search_bar_page.dart';
import 'select_page.dart';
import 'selector_page.dart';
import 'side_bar_page.dart';
import 'slider_page.dart';
import 'space_page.dart';
import 'splitter_page.dart';
import 'stepper_page.dart';
import 'steps_page.dart';
import 'switch_page.dart';
import 'tab_bar_page.dart';
import 'tabs_page.dart';
import 'time_picker_page.dart';
import 'transfer_page.dart';
import 'tree_select_page.dart';
import 'upload_page.dart';
import 'virtual_input_page.dart';
import 'typography_page.dart';

class ComponentPage extends StatelessWidget {
  const ComponentPage({super.key, required this.snakeName});

  /// 组件蛇形名（如 "button"），用于路由
  final String snakeName;

  @override
  Widget build(BuildContext context) {
    switch (snakeName) {
      case 'avatar':
        return const AvatarPage();
      case 'affix':
        return const AffixPage();
      case 'app':
        return const AppPage();
      case 'border_beam':
        return const BorderBeamPage();
      case 'config_provider':
        return const ConfigProviderPage();
      case 'loading':
        return const LoadingPage();
      case 'swipe_action':
        return const SwipeActionPage();
      case 'action_sheet':
        return const ActionSheetPage();
      case 'dialog':
        return const DialogPage();
      case 'mask':
        return const MaskPage();
      case 'popup':
        return const PopupPage();
      case 'pull_to_refresh':
        return const PullToRefreshPage();
      case 'toast':
        return const ToastPage();
      case 'alert':
        return const AlertPage();
      case 'drawer':
        return const DrawerPage();
      case 'message':
        return const MessagePage();
      case 'modal':
        return const ModalPage();
      case 'notification':
        return const NotificationPage();
      case 'popconfirm':
        return const PopconfirmPage();
      case 'progress':
        return const ProgressPage();
      case 'result':
        return const ResultPage();
      case 'skeleton':
        return const SkeletonPage();
      case 'spin':
        return const SpinPage();
      case 'watermark':
        return const WatermarkPage();
      case 'ellipsis':
        return const EllipsisPage();
      case 'floating_bubble':
        return const FloatingBubblePage();
      case 'floating_panel':
        return const FloatingPanelPage();
      case 'footer':
        return const FooterPage();
      case 'image_viewer':
        return const ImageViewerPage();
      case 'infinite_scroll':
        return const InfiniteScrollPage();
      case 'page_indicator':
        return const PageIndicatorPage();
      case 'calendar':
        return const CalendarPage();
      case 'carousel':
        return const CarouselPage();
      case 'collapse':
        return const CollapsePage();
      case 'descriptions':
        return const DescriptionsPage();
      case 'list':
        return const ListPage();
      case 'table':
        return const TablePage();
      case 'timeline':
        return const TimelinePage();
      case 'tour':
        return const TourPage();
      case 'tree':
        return const TreePage();
      case 'image':
        return const ImagePage();
      case 'popover':
        return const PopoverPage();
      case 'qr_code':
        return const QRCodePage();
      case 'segmented':
        return const SegmentedPage();
      case 'tooltip':
        return const TooltipPage();
      case 'badge':
        return const BadgePage();
      case 'card':
        return const CardPage();
      case 'tag':
        return const TagPage();
      case 'auto_center':
        return const AutoCenterPage();
      case 'auto_complete':
        return const AutoCompletePage();
      case 'anchor':
        return const AnchorPage();
      case 'breadcrumb':
        return const BreadcrumbPage();
      case 'button':
        return const ButtonPage();
      case 'calendar_picker':
        return const CalendarPickerPage();
      case 'capsule_tabs':
        return const CapsuleTabsPage();
      case 'cascader':
        return const CascaderPage();
      case 'cascader_view':
        return const CascaderViewPage();
      case 'checkbox':
        return const CheckboxPage();
      case 'check_list':
        return const CheckListPage();
      case 'color_picker':
        return const ColorPickerPage();
      case 'date_picker':
        return const DatePickerPage();
      case 'divider':
        return const DividerPage();
      case 'dropdown':
        return const DropdownPage();
      case 'empty':
        return const EmptyPage();
      case 'flex':
        return const FlexPage();
      case 'form':
        return const FormPage();
      case 'float_button':
        return const FloatButtonPage();
      case 'grid':
        return const GridPage();
      case 'icon':
        return const IconPage();
      case 'image_uploader':
        return const ImageUploaderPage();
      case 'index_bar':
        return const IndexBarPage();
      case 'input':
        return const InputPage();
      case 'input_number':
        return const InputNumberPage();
      case 'jumbo_tabs':
        return const JumboTabsPage();
      case 'layout':
        return const LayoutPage();
      case 'masonry':
        return const MasonryPage();
      case 'mentions':
        return const MentionsPage();
      case 'menu':
        return const MenuPage();
      case 'nav_bar':
        return const NavBarPage();
      case 'notice_bar':
        return const NoticeBarPage();
      case 'number_keyboard':
        return const NumberKeyboardPage();
      case 'pagination':
        return const PaginationPage();
      case 'passcode_input':
        return const PasscodeInputPage();
      case 'picker':
        return const PickerPage();
      case 'rate':
        return const RatePage();
      case 'radio':
        return const RadioPage();
      case 'safe_area':
        return const SafeAreaPage();
      case 'search_bar':
        return const SearchBarPage();
      case 'select':
        return const SelectPage();
      case 'selector':
        return const SelectorPage();
      case 'side_bar':
        return const SideBarPage();
      case 'slider':
        return const SliderPage();
      case 'space':
        return const SpacePage();
      case 'splitter':
        return const SplitterPage();
      case 'stepper':
        return const StepperPage();
      case 'steps':
        return const StepsPage();
      case 'switch':
        return const SwitchPage();
      case 'tab_bar':
        return const TabBarPage();
      case 'tabs':
        return const TabsPage();
      case 'time_picker':
        return const TimePickerPage();
      case 'transfer':
        return const TransferPage();
      case 'tree_select':
        return const TreeSelectPage();
      case 'upload':
        return const UploadPage();
      case 'virtual_input':
        return const VirtualInputPage();
      case 'typography':
        return const TypographyPage();
      default:
        return _PlaceholderPage(snakeName: snakeName);
    }
  }
}

/// 未实现组件的占位页
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.snakeName});

  final String snakeName;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Center(
      child: AntSpace(
        direction: AntSpaceDirection.vertical,
        align: AntSpaceAlign.center,
        size: const AntSpaceSize.middle(),
        children: [
          Icon(AntIcons.toolOutlined, size: 64, color: theme.colorTextQuaternary),
          Text(snakeName,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: theme.colorTextHeading)),
          Text('该组件正在开发中，敬请期待',
              style: TextStyle(fontSize: 14, color: theme.colorTextQuaternary)),
        ],
      ),
    );
  }
}