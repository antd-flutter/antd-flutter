import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ImageUploaderPage extends StatelessWidget {
  const ImageUploaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Section(
            title: '基础用法',
            child: AntImageUploader(
              onPickImage: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('模拟选图：添加 1 张图片')),
                );
                return [
                  const AntImageUploadItem(
                    url: 'https://picsum.photos/200/200?random=1',
                  ),
                ];
              },
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '初始图片列表',
            child: const AntImageUploader(
              defaultValue: [
                AntImageUploadItem(url: 'https://picsum.photos/200/200?r=10'),
                AntImageUploadItem(url: 'https://picsum.photos/200/200?r=11'),
                AntImageUploadItem(url: 'https://picsum.photos/200/200?r=12'),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '最大数量限制（3 张）',
            child: AntImageUploader(
              maxCount: 3,
              defaultValue: const [
                AntImageUploadItem(url: 'https://picsum.photos/200/200?r=20'),
              ],
              onPickImage: () async {
                return [
                  const AntImageUploadItem(
                    url: 'https://picsum.photos/200/200?r=21',
                  ),
                  const AntImageUploadItem(
                    url: 'https://picsum.photos/200/200?r=22',
                  ),
                  const AntImageUploadItem(
                    url: 'https://picsum.photos/200/200?r=23',
                  ),
                ];
              },
              onCountExceed: (n) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('超出最大数量 $n 张')),
                );
              },
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '上传状态展示',
            child: const AntImageUploader(
              showUpload: false,
              defaultValue: [
                AntImageUploadItem(
                  url: 'https://picsum.photos/200/200?r=30',
                  status: AntImageUploadStatus.uploading,
                ),
                AntImageUploadItem(
                  url: 'https://picsum.photos/200/200?r=31',
                  status: AntImageUploadStatus.failed,
                ),
                AntImageUploadItem(
                  url: 'https://picsum.photos/200/200?r=32',
                  status: AntImageUploadStatus.done,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '不可删除',
            child: const AntImageUploader(
              deletable: false,
              showUpload: false,
              defaultValue: [
                AntImageUploadItem(url: 'https://picsum.photos/200/200?r=40'),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '每行 3 列',
            child: const AntImageUploader(
              columns: 3,
              defaultValue: [
                AntImageUploadItem(url: 'https://picsum.photos/200/200?r=50'),
                AntImageUploadItem(url: 'https://picsum.photos/200/200?r=51'),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '受控模式',
            child: _ControlledDemo(),
          ),
        ],
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  List<AntImageUploadItem> _items = const [
    AntImageUploadItem(url: 'https://picsum.photos/200/200?r=60'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntImageUploader(
          value: _items,
          onPickImage: () async => [
            const AntImageUploadItem(
              url: 'https://picsum.photos/200/200?r=61',
            ),
          ],
          onChange: (items) => setState(() => _items = items),
        ),
        SizedBox(height: 8.w),
        Text(
          '当前图片数: ${_items.length}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AntTheme.of(context).colorTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.w),
        border: Border.all(color: theme.colorSplit, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
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