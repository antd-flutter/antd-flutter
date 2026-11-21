library;

/// Steps 步骤条演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _StepData {
  const _StepData({this.title, this.description, this.icon});

  final String? title;
  final String? description;
  final Widget? icon;
}

Widget _steps({
  Key? key,
  int current = 0,
  List<_StepData> items = const [],
  AntStepsDirection direction = AntStepsDirection.horizontal,
  AntStepsStatus status = AntStepsStatus.process,
  AntStepsSize size = AntStepsSize.normal,
  ValueChanged<int>? onChange,
}) {
  return AntSteps<_StepData>(
    key: key,
    current: current,
    items: items,
    titleBuilder: (context, item, index) =>
        item.title == null ? null : Text(item.title!),
    descriptionBuilder: (context, item, index) =>
        item.description == null ? null : Text(item.description!),
    iconBuilder: (context, item, index) => item.icon,
    direction: direction,
    status: status,
    size: size,
    onChange: onChange == null ? null : (item) => onChange(items.indexOf(item)),
  );
}

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
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntTitle(title, level: AntTitleLevel.h4),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(
                text: description!,
                type: AntTypographyType.secondary,
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
    return _steps(
      current: 1,
      items: [
        _StepData(title: '已完成', description: '第一步已完成'),
        _StepData(title: '进行中', description: '第二步正在进行'),
        _StepData(title: '待处理', description: '第三步等待处理'),
      ],
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) {
    // material_ui AntSteps 垂直方向内部含 Expanded，在无界高度
    // （SingleChildScrollView）下会溢出抛异常，demo 页加有界高度约束。
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: _steps(
        current: 1,
        direction: AntStepsDirection.vertical,
        items: [
          _StepData(title: '填写信息', description: '填写基本个人信息'),
          _StepData(title: '验证身份', description: '短信验证码验证'),
          _StepData(title: '注册成功', description: '完成注册流程'),
        ],
      ),
    );
  }
}

class _SmallDemo extends StatelessWidget {
  const _SmallDemo();

  @override
  Widget build(BuildContext context) {
    return _steps(
      current: 2,
      size: AntStepsSize.small,
      items: [
        _StepData(title: '第一步'),
        _StepData(title: '第二步'),
        _StepData(title: '第三步'),
        _StepData(title: '第四步'),
      ],
    );
  }
}

class _ErrorDemo extends StatelessWidget {
  const _ErrorDemo();

  @override
  Widget build(BuildContext context) {
    return _steps(
      current: 1,
      status: AntStepsStatus.error,
      items: [
        _StepData(title: '已完成'),
        _StepData(title: '出错了', description: '此步骤发生错误'),
        _StepData(title: '待处理'),
      ],
    );
  }
}

class _IconDemo extends StatelessWidget {
  const _IconDemo();

  @override
  Widget build(BuildContext context) {
    return _steps(
      current: 1,
      items: [
        _StepData(
          title: '登录',
          icon: AntdIcon(AntIcons.loginOutlined, size: 16, color: Colors.blue),
        ),
        _StepData(
          title: '验证',
          icon: AntdIcon(
            AntIcons.safetyCertificateOutlined,
            size: 16,
            color: Colors.blue,
          ),
        ),
        _StepData(
          title: '完成',
          icon: AntdIcon(
            AntIcons.checkCircleOutlined,
            size: 16,
            color: Colors.grey,
          ),
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
        _steps(
          current: _current,
          onChange: (index) => setState(() => _current = index),
          items: const [
            _StepData(title: '选择商品'),
            _StepData(title: '确认订单'),
            _StepData(title: '支付'),
            _StepData(title: '完成'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            AntButton(
              onTap: _current > 0 ? () => setState(() => _current--) : null,
              disabled: _current <= 0,
              child: const Text('上一步'),
            ),
            const SizedBox(width: 8),
            AntButton(
              onTap: _current < 3 ? () => setState(() => _current++) : null,
              disabled: _current >= 3,
              child: const Text('下一步'),
            ),
          ],
        ),
      ],
    );
  }
}
