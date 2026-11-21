import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 业务模型：照片（业务里常带 id / 上传进度等字段）。
class Photo {
  const Photo(this.id, this.url, {this.status = AntImageUploadStatus.done});

  final String id;
  final String url;
  final AntImageUploadStatus status;
}

String photoUrl(Photo photo) => photo.url;

AntImageUploadStatus photoStatus(Photo photo) => photo.status;

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
            child: AntImageUploader<Photo>(
              urlOf: photoUrl,
              statusOf: photoStatus,
              onPickImage: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: AntText(text: '模拟选图：添加 1 张图片')),
                );
                return [Photo('p1', 'https://picsum.photos/200/200?random=1')];
              },
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '初始图片列表',
            child: const AntImageUploader<Photo>(
              urlOf: photoUrl,
              defaultValue: [
                Photo('p10', 'https://picsum.photos/200/200?r=10'),
                Photo('p11', 'https://picsum.photos/200/200?r=11'),
                Photo('p12', 'https://picsum.photos/200/200?r=12'),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '最大数量限制（3 张）',
            child: AntImageUploader<Photo>(
              maxCount: 3,
              urlOf: photoUrl,
              defaultValue: const [
                Photo('p20', 'https://picsum.photos/200/200?r=20'),
              ],
              onPickImage: () async => const [
                Photo('p21', 'https://picsum.photos/200/200?r=21'),
                Photo('p22', 'https://picsum.photos/200/200?r=22'),
                Photo('p23', 'https://picsum.photos/200/200?r=23'),
              ],
              onCountExceed: (n) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: AntText(text: '超出最大数量 $n 张')));
              },
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '上传状态展示',
            child: const AntImageUploader<Photo>(
              showUpload: false,
              urlOf: photoUrl,
              statusOf: photoStatus,
              defaultValue: [
                Photo(
                  'p30',
                  'https://picsum.photos/200/200?r=30',
                  status: AntImageUploadStatus.uploading,
                ),
                Photo(
                  'p31',
                  'https://picsum.photos/200/200?r=31',
                  status: AntImageUploadStatus.failed,
                ),
                Photo('p32', 'https://picsum.photos/200/200?r=32'),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '不可删除',
            child: const AntImageUploader<Photo>(
              deletable: false,
              showUpload: false,
              urlOf: photoUrl,
              defaultValue: [
                Photo('p40', 'https://picsum.photos/200/200?r=40'),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '每行 3 列',
            child: const AntImageUploader<Photo>(
              columns: 3,
              urlOf: photoUrl,
              defaultValue: [
                Photo('p50', 'https://picsum.photos/200/200?r=50'),
                Photo('p51', 'https://picsum.photos/200/200?r=51'),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: '自定义格子与预览',
            child: AntImageUploader<Photo>(
              urlOf: photoUrl,
              defaultValue: const [
                Photo('p70', 'https://picsum.photos/200/200?r=70'),
              ],
              itemBuilder: (context, photo, index) => Container(
                decoration: BoxDecoration(
                  color: AntTheme.of(context).colorFillSecondary,
                  borderRadius: BorderRadius.circular(
                    AntTheme.of(context).borderRadiusSM.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AntIcons.pictureOutlined, size: 20.w),
                    SizedBox(height: 4.h),
                    Text(photo.id, style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
              ),
              previewBuilder: (context, photo) => Scaffold(
                appBar: AppBar(title: Text('预览 ${photo.id}')),
                backgroundColor: Colors.black,
                body: Center(child: Text(photo.url)),
              ),
            ),
          ),
          SizedBox(height: 12.w),
          _Section(
            title: 'String 列表数据源',
            child: const AntImageUploader<String>(
              defaultValue: [
                'https://picsum.photos/200/200?r=80',
                'https://picsum.photos/200/200?r=81',
              ],
            ),
          ),
          SizedBox(height: 12.w),
          _Section(title: '受控模式', child: _ControlledDemo()),
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
  List<Photo> _items = const [
    Photo('p60', 'https://picsum.photos/200/200?r=60'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntImageUploader<Photo>(
          value: _items,
          urlOf: photoUrl,
          statusOf: photoStatus,
          onPickImage: () async => const [
            Photo('p61', 'https://picsum.photos/200/200?r=61'),
          ],
          onChange: (items) => setState(() => _items = items),
        ),
        SizedBox(height: 8.w),
        AntText(
          text: '当前图片数: ${_items.length}',
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
          AntText(
            text: title,
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
