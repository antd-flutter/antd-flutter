import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntUpload(
              onSelectFiles: () async => _mockFiles(1),
              onChange: (file, list) => debugPrint('onChange: ${file.name}'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '默认文件列表',
            child: const AntUpload(
              defaultFileList: [
                AntUploadFile(uid: '1', name: '文档.pdf'),
                AntUploadFile(uid: '2', name: '图片.png'),
                AntUploadFile(
                  uid: '3',
                  name: '上传失败.txt',
                  status: AntUploadStatus.error,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '图片列表',
            child: AntUpload(
              listType: AntUploadListType.picture,
              defaultFileList: const [
                AntUploadFile(
                  uid: '1',
                  name: '风景.jpg',
                  url: 'https://zos.alipayobjects.com/rmsportal/jkjgkEfvpUPVyRjUImniVslZfWPnYuuZ.png',
                ),
              ],
              onSelectFiles: () async => _mockFiles(1, prefix: '照片'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '图片卡片',
            child: AntUpload(
              listType: AntUploadListType.pictureCard,
              defaultFileList: const [
                AntUploadFile(
                  uid: '1',
                  name: '卡片.png',
                  url: 'https://zos.alipayobjects.com/rmsportal/jkjgkEfvpUPVyRjUImniVslZfWPnYuuZ.png',
                ),
              ],
              onSelectFiles: () async => _mockFiles(1, prefix: '卡片'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义上传',
            child: AntUpload(
              uploadButtonText: '点击上传',
              onSelectFiles: () async => _mockFiles(1),
              customRequest: (file, update) async {
                // 模拟上传进度
                for (var i = 0; i <= 100; i += 25) {
                  await Future.delayed(const Duration(milliseconds: 200));
                  update(file.copyWith(
                    status: i >= 100 ? AntUploadStatus.done : AntUploadStatus.uploading,
                    percent: i,
                  ));
                }
              },
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '最大数量限制',
            child: AntUpload(
              maxCount: 2,
              multiple: true,
              uploadButtonText: '最多两个',
              onSelectFiles: () async => _mockFiles(1),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            child: const AntUpload(
              disabled: true,
              defaultFileList: [
                AntUploadFile(uid: '1', name: '只读文件.txt'),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '隐藏文件列表',
            child: AntUpload(
              showUploadList: false,
              uploadButtonText: '不显示列表',
              onSelectFiles: () async => _mockFiles(1),
            ),
          ),
        ],
      ),
    );
  }

  List<AntUploadFile> _mockFiles(int count, {String prefix = '文件'}) {
    return List.generate(count, (i) {
      final id = DateTime.now().millisecondsSinceEpoch + i;
      return AntUploadFile(uid: '$id', name: '$prefix-$id.txt');
    });
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG.r),
        border: Border.all(color: t.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}