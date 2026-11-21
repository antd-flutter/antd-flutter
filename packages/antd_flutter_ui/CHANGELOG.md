# Changelog

## 1.0.0

- Initial stable release of `antd_flutter_ui`, the base component layer shared by the Ant Design Flutter suite.
- Component set spanning `basic` (button, typography, flex, grid, layout, space, divider, tooltip, auto center, safe area, footer), `data_entry` (input family, input number, checkbox, radio, switch, slider, rate, stepper, select, auto complete, mentions, color picker, search bar, check list, selector, image uploader), `display` (avatar, badge, card, collapse, descriptions, ellipsis, empty, image, list, page indicator, picker view, popover, popconfirm, dropdown, segmented, statistic, tag, timeline, tour), `feedback` (action sheet, alert, dialog, drawer, error block, loading, mask, message, modal, notice bar, notification, popup, progress, result, result page, skeleton, spin, toast, watermark), `navigation` (anchor, breadcrumb, capsule tabs, index bar, jumbo tabs, menu, app bar, nav bar, pagination, side bar, steps, tab bar, tabs), `general` (float button) and `misc` (affix, app, border beam, config provider).
- Generic data parameters: option-driven widgets accept `List<T>` with `keyOf`, `labelOf`, `labelBuilder`, `itemBuilder` and `childBuilder`, replacing component-specific option models. Legacy option constructors are deprecated and will be removed in 2.0.
- Dual style sources: desktop components follow Ant Design v6, mobile components follow antd-mobile v5.
- `AntScale` sizing system: every component resolves design values through `theme.s(...)`, with fixed factors and screen-derived factors via `AntScale.auto`.
- Shared engines for anchored popup placement and viewport flipping, wheel-picker columns, keyboard hotkeys and calendar grids.
