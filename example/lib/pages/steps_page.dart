library;

/// Steps 步骤条演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class StepsPage extends StatelessWidget {
  const StepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '水平步骤条，current 指定当前步骤'),
          _BasicDemo(),
          _Section(title: '垂直布局', description: 'direction=vertical，适合窄屏场景'),
          _VerticalDemo(),
          _Section(title: '小尺寸', description: 'size=small，圆圈和文字更小'),
          _SmallDemo(),
          _Section(title: '错误状态', description: 'status=error，当前步骤标记为错误'),
          _ErrorDemo(),
          _Section(title: '自定义图标', description: '每项可设置 icon 替换默认圆圈内容'),
          _IconDemo(),
          _Section(title: '可点击切换', description: '设置 onChange 后可点击步骤切换'),
          _ClickableDemo(),
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
          Text(title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
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
    return const AntSteps(
      current: 1,
      items: [
        AntStepsItem(title: '已完成', description: '第一步已完成'),
        AntStepsItem(title: '进行中', description: '第二步正在进行'),
        AntStepsItem(title: '待处理', description: '第三步等待处理'),
      ],
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) {
    return const AntSteps(
      current: 1,
      direction: AntStepsDirection.vertical,
      items: [
        AntStepsItem(title: '填写信息', description: '填写基本个人信息'),
        AntStepsItem(title: '验证身份', description: '短信验证码验证'),
        AntStepsItem(title: '注册成功', description: '完成注册流程'),
      ],
    );
  }
}

class _SmallDemo extends StatelessWidget {
  const _SmallDemo();

  @override
  Widget build(BuildContext context) {
    return const AntSteps(
      current: 2,
      size: AntStepsSize.small,
      items: [
        AntStepsItem(title: '第一步'),
        AntStepsItem(title: '第二步'),
        AntStepsItem(title: '第三步'),
        AntStepsItem(title: '第四步'),
      ],
    );
  }
}

class _ErrorDemo extends StatelessWidget {
  const _ErrorDemo();

  @override
  Widget build(BuildContext context) {
    return const AntSteps(
      current: 1,
      status: AntStepsStatus.error,
      items: [
        AntStepsItem(title: '已完成'),
        AntStepsItem(title: '出错了', description: '此步骤发生错误'),
        AntStepsItem(title: '待处理'),
      ],
    );
  }
}

class _IconDemo extends StatelessWidget {
  const _IconDemo();

  @override
  Widget build(BuildContext context) {
    return const AntSteps(
      current: 1,
      items: [
        AntStepsItem(
          title: '登录',
          icon: Icon(Icons.login, size: 16, color: Colors.blue),
        ),
        AntStepsItem(
          title: '验证',
          icon: Icon(Icons.security, size: 16, color: Colors.blue),
        ),
        AntStepsItem(
          title: '完成',
          icon: Icon(Icons.check_circle_outline, size: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ClickableDemo extends StatefulWidget {
  const _ClickableDemo();

  @override
  State<_ClickableDemo> createState() => _ClickableDemoState();
}

class _ClickableDemoState extends State<_ClickableDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntSteps(
          current: _current,
          onChange: (index) => setState(() => _current = index),
          items: const [
            AntStepsItem(title: '选择商品'),
            AntStepsItem(title: '确认订单'),
            AntStepsItem(title: '支付'),
            AntStepsItem(title: '完成'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: _current > 0
                  ? () => setState(() => _current--)
                  : null,
              child: const Text('上一步'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _current < 3
                  ? () => setState(() => _current++)
                  : null,
              child: const Text('下一步'),
            ),
          ],
        ),
      ],
    );
  }
}