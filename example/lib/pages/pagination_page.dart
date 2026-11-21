library;

/// Pagination 分页演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class PaginationPage extends StatelessWidget {
  const PaginationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: 'total 指定总条数，默认每页 10 条'),
          _BasicDemo(),
          _Section(title: '显示总条数', description: 'showTotal=true，左侧显示总条数'),
          _ShowTotalDemo(),
          _Section(
            title: '每页条数切换',
            description: 'showSizeChanger=true，右侧显示条数切换器',
          ),
          _SizeChangerDemo(),
          _Section(title: '快速跳转', description: 'showQuickJumper=true，输入页码快速跳转'),
          _QuickJumperDemo(),
          _Section(title: '完整功能', description: '总条数 + 条数切换 + 快速跳转'),
          _FullDemo(),
          _Section(title: '简单模式', description: 'simple=true，只显示前后按钮和当前页/总页数'),
          _SimpleDemo(),
          _Section(title: '受控模式', description: 'current 受控，由外部状态管理页码'),
          _ControlledDemo(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return AntPagination(
      total: 100,
      onChange: (page) => _showToast(context, '跳转到第 $page 页'),
    );
  }
}

class _ShowTotalDemo extends StatelessWidget {
  const _ShowTotalDemo();

  @override
  Widget build(BuildContext context) {
    return AntPagination(
      total: 85,
      showTotal: true,
      onChange: (page) => _showToast(context, '跳转到第 $page 页'),
    );
  }
}

class _SizeChangerDemo extends StatelessWidget {
  const _SizeChangerDemo();

  @override
  Widget build(BuildContext context) {
    return AntPagination(
      total: 200,
      showSizeChanger: true,
      onChange: (page) => _showToast(context, '跳转到第 $page 页'),
      onPageSizeChange: (size) => _showToast(context, '每页 $size 条'),
    );
  }
}

class _QuickJumperDemo extends StatelessWidget {
  const _QuickJumperDemo();

  @override
  Widget build(BuildContext context) {
    return AntPagination(
      total: 500,
      showQuickJumper: true,
      onChange: (page) => _showToast(context, '跳转到第 $page 页'),
    );
  }
}

class _FullDemo extends StatelessWidget {
  const _FullDemo();

  @override
  Widget build(BuildContext context) {
    return AntPagination(
      total: 500,
      showTotal: true,
      showSizeChanger: true,
      showQuickJumper: true,
      onChange: (page) => _showToast(context, '跳转到第 $page 页'),
      onPageSizeChange: (size) => _showToast(context, '每页 $size 条'),
    );
  }
}

class _SimpleDemo extends StatelessWidget {
  const _SimpleDemo();

  @override
  Widget build(BuildContext context) {
    return AntPagination(
      total: 100,
      simple: true,
      onChange: (page) => _showToast(context, '跳转到第 $page 页'),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntPagination(
          current: _current,
          total: 100,
          onChange: (page) => setState(() => _current = page),
        ),
        const SizedBox(height: 8),
        Text('当前页：$_current', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

void _showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
}
