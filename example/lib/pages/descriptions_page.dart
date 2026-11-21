import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _DescData {
  const _DescData({required this.label, this.child, this.span = 1});

  final String label;
  final Widget? child;
  final int span;
}

Widget _descriptions({
  Key? key,
  List<_DescData> items = const [],
  Widget? title,
  Widget? extra,
  int column = 3,
  bool bordered = false,
  AntDescriptionsSize size = AntDescriptionsSize.middle,
  bool colon = true,
  AntDescriptionsLayout layout = AntDescriptionsLayout.horizontal,
}) {
  return AntDescriptions<_DescData>(
    key: key,
    items: items,
    labelBuilder: (context, item, index) => Text(item.label),
    contentBuilder: (context, item, index) => item.child,
    spanOf: (item) => item.span,
    title: title,
    extra: extra,
    column: column,
    bordered: bordered,
    size: size,
    colon: colon,
    layout: layout,
  );
}

class DescriptionsPage extends StatelessWidget {
  const DescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final column = _columnFor(context);
    final items = const [
      _DescData(
        label: '名称',
        child: AntText(text: '张三'),
      ),
      _DescData(
        label: '手机号',
        child: AntText(text: '138****8888'),
      ),
      _DescData(
        label: '城市',
        child: AntText(text: '杭州'),
      ),
      _DescData(
        label: '邮箱',
        child: AntText(text: 'zhangsan@example.com'),
      ),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: _descriptions(items: items, column: column),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带边框',
            theme: theme,
            child: _descriptions(items: items, column: column, bordered: true),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '尺寸',
            theme: theme,
            child: Column(
              children: [
                _descriptions(
                  items: [
                    _DescData(
                      label: '大号',
                      child: AntText(text: 'large'),
                    ),
                  ],
                  size: AntDescriptionsSize.large,
                  bordered: true,
                ),
                SizedBox(height: 12.w),
                _descriptions(
                  items: [
                    _DescData(
                      label: '中号',
                      child: AntText(text: 'middle'),
                    ),
                  ],
                  size: AntDescriptionsSize.middle,
                  bordered: true,
                ),
                SizedBox(height: 12.w),
                _descriptions(
                  items: [
                    _DescData(
                      label: '小号',
                      child: AntText(text: 'small'),
                    ),
                  ],
                  size: AntDescriptionsSize.small,
                  bordered: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '跨列 span',
            theme: theme,
            child: _descriptions(
              column: column,
              bordered: true,
              items: [
                _DescData(
                  label: '产品',
                  child: AntText(text: '云服务器'),
                ),
                _DescData(
                  label: '计费模式',
                  child: AntText(text: '预付费'),
                ),
                _DescData(
                  label: '自动续费',
                  child: AntText(text: '是'),
                ),
                _DescData(
                  label: '配置',
                  child: AntText(
                    text: 'CPU 4 核 / 内存 8G / 磁盘 100G SSD / 带宽 5Mbps',
                  ),
                  span: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '垂直布局',
            theme: theme,
            child: _descriptions(
              items: items,
              column: column,
              layout: AntDescriptionsLayout.vertical,
              bordered: true,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '标题 + 操作区',
            theme: theme,
            child: _descriptions(
              items: [
                _DescData(
                  label: '订单号',
                  child: AntText(text: '202405160001'),
                ),
                _DescData(
                  label: '状态',
                  child: AntText(text: '已支付'),
                ),
                _DescData(
                  label: '金额',
                  child: AntText(text: '¥299.00'),
                ),
                _DescData(
                  label: '支付方式',
                  child: AntText(text: '支付宝'),
                ),
              ],
              title: AntText(text: '订单详情'),
              extra: AntText(text: '编辑'),
              column: column,
              bordered: true,
              colon: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// 按 antd 响应式 demo 的断点选择列数：手机 1 列、平板 2 列、桌面 3 列。
int _columnFor(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 992) return 3;
  if (width >= 576) return 2;
  return 1;
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(
            text: title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
