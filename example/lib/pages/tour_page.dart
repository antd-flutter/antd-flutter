import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  final GlobalKey _target1 = GlobalKey();
  final GlobalKey _target2 = GlobalKey();
  final GlobalKey _target3 = GlobalKey();
  final GlobalKey _target4 = GlobalKey();
  final GlobalKey _target5 = GlobalKey();
  final GlobalKey _target6 = GlobalKey();
  final GlobalKey _target7 = GlobalKey();

  bool _basicOpen = false;
  bool _placementOpen = false;
  bool _noMaskOpen = false;
  bool _noArrowOpen = false;
  bool _controlledOpen = false;
  int _controlledCurrent = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final titleStyle = TextStyle(
      fontSize: 14.sp,
      color: theme.colorText,
    );
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '三步引导',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      key: _target1,
                      padding: EdgeInsets.all(12.w),
                      color: theme.colorPrimaryBg,
                      child: Text('目标一', style: titleStyle),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      key: _target2,
                      padding: EdgeInsets.all(12.w),
                      color: theme.colorSuccessBg,
                      child: Text('目标二', style: titleStyle),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      key: _target3,
                      padding: EdgeInsets.all(12.w),
                      color: theme.colorWarningBg,
                      child: Text('目标三', style: titleStyle),
                    ),
                    SizedBox(width: 12.w),
                    AntButton(
                      onTap: () => setState(() => _basicOpen = true),
                      child: const Text('开始引导'),
                    ),
                  ],
                ),
                AntTour(
                  open: _basicOpen,
                  steps: [
                    AntTourStep(
                      target: _target1,
                      title: '上传文件',
                      description: '点击这里选择需要上传的文件',
                    ),
                    AntTourStep(
                      target: _target2,
                      title: '处理进度',
                      description: '文件处理进度在这里展示',
                      placement: AntTourPlacement.rightCenter,
                    ),
                    AntTourStep(
                      target: _target3,
                      title: '导出结果',
                      description: '处理完成后可在此导出结果',
                      placement: AntTourPlacement.bottomCenter,
                    ),
                  ],
                  onClose: () => setState(() => _basicOpen = false),
                  onFinish: () => setState(() => _basicOpen = false),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义 placement',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      key: _target4,
                      padding: EdgeInsets.all(12.w),
                      color: theme.colorInfoBg,
                      child: Text('右侧引导', style: titleStyle),
                    ),
                    SizedBox(width: 12.w),
                    AntButton(
                      onTap: () => setState(() => _placementOpen = true),
                      child: const Text('卡片出现在右侧'),
                    ),
                    AntTour(
                      open: _placementOpen,
                      steps: [
                        AntTourStep(
                          target: _target4,
                          title: 'rightCenter',
                          description: '引导卡片固定出现在目标元素右侧',
                          placement: AntTourPlacement.rightCenter,
                        ),
                      ],
                      onClose: () => setState(() => _placementOpen = false),
                      onFinish: () => setState(() => _placementOpen = false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '无遮罩',
            theme: theme,
            child: Row(
              children: [
                Container(
                  key: _target5,
                  padding: EdgeInsets.all(12.w),
                  color: theme.colorFillAlter,
                  child: Text('无遮罩目标', style: titleStyle),
                ),
                SizedBox(width: 12.w),
                AntButton(
                  onTap: () => setState(() => _noMaskOpen = true),
                  child: const Text('无遮罩引导'),
                ),
                AntTour(
                  open: _noMaskOpen,
                  mask: false,
                  steps: [
                    AntTourStep(
                      target: _target5,
                      title: '无遮罩引导',
                      description: '不显示挖孔遮罩，只展示引导卡片',
                      placement: AntTourPlacement.bottomRight,
                    ),
                  ],
                  onClose: () => setState(() => _noMaskOpen = false),
                  onFinish: () => setState(() => _noMaskOpen = false),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '无箭头',
            theme: theme,
            child: Row(
              children: [
                Container(
                  key: _target6,
                  padding: EdgeInsets.all(12.w),
                  color: theme.colorErrorBg,
                  child: Text('无箭头目标', style: titleStyle),
                ),
                SizedBox(width: 12.w),
                AntButton(
                  onTap: () => setState(() => _noArrowOpen = true),
                  child: const Text('无箭头引导'),
                ),
                AntTour(
                  open: _noArrowOpen,
                  arrow: false,
                  steps: [
                    AntTourStep(
                      target: _target6,
                      title: '无箭头引导',
                      description: '引导卡片不带箭头指向目标',
                    ),
                  ],
                  onClose: () => setState(() => _noArrowOpen = false),
                  onFinish: () => setState(() => _noArrowOpen = false),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '受控 current',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      key: _target7,
                      padding: EdgeInsets.all(12.w),
                      color: theme.colorPrimaryBg,
                      child: Text('受控引导目标', style: titleStyle),
                    ),
                    SizedBox(width: 12.w),
                    AntButton(
                      onTap: () => setState(() {
                        _controlledCurrent = 0;
                        _controlledOpen = true;
                      }),
                      child: const Text('受控引导'),
                    ),
                    SizedBox(width: 12.w),
                    AntButton(
                      onTap: () => setState(() {
                        _controlledCurrent =
                            (_controlledCurrent + 1).clamp(0, 1);
                      }),
                      child: const Text('外部切到下一步'),
                    ),
                  ],
                ),
                AntTour(
                  open: _controlledOpen,
                  current: _controlledCurrent,
                  steps: [
                    AntTourStep(
                      target: _target7,
                      title: '受控第一步',
                      description: '当前步索引由外部状态控制',
                    ),
                    AntTourStep(
                      title: '受控第二步',
                      description: '无 target 时卡片全屏居中',
                    ),
                  ],
                  onStepChange: (index) =>
                      setState(() => _controlledCurrent = index),
                  onClose: () => setState(() => _controlledOpen = false),
                  onFinish: () => setState(() => _controlledOpen = false),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '跳过按钮',
            theme: theme,
            child: Text(
              '引导卡片底部始终提供「跳过」按钮，点击触发 onClose 回调关闭引导；'
              '设置 maskClosable: true 时点击遮罩也可关闭。',
              style: titleStyle,
            ),
          ),
        ],
      ),
    );
  }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorTextHeading,
          ),
        ),
        SizedBox(height: 12.w),
        child,
      ],
    );
  }
}
