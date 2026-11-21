/// antd_upload example — AntUpload 演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - 画廊模式：侧栏分区 + 分区内容，覆盖 Upload 全部关键形态
///   （基础上传列表、多文件、上传状态（上传中/成功/失败重试）、
///   图片预览、受控操作、自定义 item 渲染）
/// - 按 R16 中间件隔离原则：上传动作经 `onSelectFiles` / `customRequest`
///   回调注入（demo 内模拟），不引入 http/dio 三方依赖。
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:antd_upload/antd_upload.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdUploadGalleryApp());
}

/// 演示图片地址。
const List<String> kDemoImages = [
  'https://picsum.photos/id/1015/600/400',
  'https://picsum.photos/id/1016/600/400',
  'https://picsum.photos/id/1020/600/400',
];

/// 演示分区定义。
class _Section {
  const _Section(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

/// antd 上传画廊根组件。
class AntdUploadGalleryApp extends StatefulWidget {
  const AntdUploadGalleryApp({super.key});

  @override
  State<AntdUploadGalleryApp> createState() => _AntdUploadGalleryAppState();
}

class _AntdUploadGalleryAppState extends State<AntdUploadGalleryApp> {
  bool _isDark = false;

  static final List<_Section> _sections = [
    _Section('基础上传列表', (context) => const _BasicSection()),
    _Section('多文件上传', (context) => const _MultipleSection()),
    _Section('上传状态（上传中/成功/失败重试）', (context) => const _StatusSection()),
    _Section('图片预览', (context) => const _PreviewSection()),
    _Section('受控操作', (context) => const _ControlledSection()),
    _Section('自定义 item 渲染', (context) => const _CustomItemSection()),
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_splitter / antd_image_viewer example：AntTheme 包裹
    // MaterialApp，theme + darkTheme + themeMode 三件套联动。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'AntdUpload Demo',
          debugShowCheckedModeBanner: false,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          theme: AntThemeData.light().toThemeData(),
          darkTheme: AntThemeData.dark().toThemeData(),
          home: DefaultTabController(
            length: _sections.length,
            child: Scaffold(
              backgroundColor: AntTheme.of(context).colorBgLayout,
              appBar: AppBar(
                title: const Text('Upload 文件上传'),
                actions: [
                  IconButton(
                    onPressed: () => setState(() => _isDark = !_isDark),
                    icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    for (final s in _sections) Tab(text: s.title),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  for (final s in _sections) s.builder(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 区块卡片容器。
Widget _sectionCard(BuildContext context, String title, Widget child) {
  final theme = AntTheme.of(context);
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    margin: EdgeInsets.only(bottom: 16.w),
    decoration: BoxDecoration(
      color: theme.colorBgContainer,
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      border: Border.all(color: theme.colorSplit),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
        SizedBox(height: 12.w),
        child,
      ],
    ),
  );
}

Widget _page(BuildContext context, List<Widget> children) => SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(children: children),
    );

/// 模拟文件选择（R16：真实选择由使用方注入，demo 模拟返回）。
Future<List<AntUploadFile>> _pickFiles(List<AntUploadFile> pool, {int count = 1}) async {
  return List<AntUploadFile>.generate(
    count,
    (i) => pool[i % pool.length],
  );
}

/// 模拟上传（R16：真实上传由使用方在 customRequest 注入，demo 模拟进度）。
Future<void> _fakeUpload(
  AntUploadFile file,
  void Function(AntUploadFile updated) updateFile, {
  bool fail = false,
}) async {
  for (var p = 20; p < 100; p += 20) {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    updateFile(file.copyWith(percent: p));
  }
  await Future<void>.delayed(const Duration(milliseconds: 250));
  if (fail) {
    updateFile(file.copyWith(status: AntUploadStatus.error, percent: 0));
  } else {
    updateFile(file.copyWith(status: AntUploadStatus.done, percent: 100));
  }
}

// ── 基础上传列表 ─────────────────────────────────────────
class _BasicSection extends StatelessWidget {
  const _BasicSection();

  static const _pool = [
    AntUploadFile(uid: 'b1', name: '项目需求文档.pdf', size: 1024000),
    AntUploadFile(uid: 'b2', name: '设计稿.sketch', size: 2048000),
    AntUploadFile(uid: 'b3', name: '会议纪要.docx', size: 512000),
  ];

  @override
  Widget build(BuildContext context) {
    return _page(context, [
      _sectionCard(context, '文字列表（默认）', AntUpload(
        uploadButtonText: '上传文件',
        onSelectFiles: () => _pickFiles(_pool),
        customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
      )),
      _sectionCard(context, '图片列表', AntUpload(
        listType: AntUploadListType.picture,
        uploadButtonText: '上传图片',
        onSelectFiles: () => _pickFiles([
          AntUploadFile(
              uid: 'p1',
              name: '风景.jpg',
              url: kDemoImages[0],
              thumbUrl: kDemoImages[0]),
          AntUploadFile(
              uid: 'p2',
              name: '湖泊.jpg',
              url: kDemoImages[1],
              thumbUrl: kDemoImages[1]),
        ]),
        customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
      )),
      _sectionCard(context, '图片卡片 + maxCount=3', AntUpload(
        listType: AntUploadListType.pictureCard,
        maxCount: 3,
        uploadButtonText: '上传',
        onSelectFiles: () => _pickFiles([
          AntUploadFile(
              uid: 'c1',
              name: '山川.jpg',
              url: kDemoImages[2],
              thumbUrl: kDemoImages[2]),
        ]),
        customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
      )),
    ]);
  }
}

// ── 多文件上传 ───────────────────────────────────────────
class _MultipleSection extends StatelessWidget {
  const _MultipleSection();

  static const _pool = [
    AntUploadFile(uid: 'm1', name: '数据集-1.csv', size: 4096000),
    AntUploadFile(uid: 'm2', name: '数据集-2.csv', size: 4096000),
    AntUploadFile(uid: 'm3', name: '数据集-3.csv', size: 4096000),
    AntUploadFile(uid: 'm4', name: '数据集-4.csv', size: 4096000),
  ];

  @override
  Widget build(BuildContext context) {
    return _page(context, [
      _sectionCard(
        context,
        'multiple 多选 + 一次选 3 个',
        AntUpload(
          multiple: true,
          uploadButtonText: '批量上传',
          onSelectFiles: () => _pickFiles(_pool, count: 3),
          customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
        ),
      ),
      _sectionCard(
        context,
        'multiple + maxCount=5',
        AntUpload(
          multiple: true,
          maxCount: 5,
          uploadButtonText: '上传（最多 5 个）',
          onSelectFiles: () => _pickFiles(_pool, count: 4),
          customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
        ),
      ),
    ]);
  }
}

// ── 上传状态（上传中/成功/失败重试） ─────────────────────
class _StatusSection extends StatefulWidget {
  const _StatusSection();

  @override
  State<_StatusSection> createState() => _StatusSectionState();
}

class _StatusSectionState extends State<_StatusSection> {
  List<AntUploadFile> _files = const [];

  static const _pool = [
    AntUploadFile(uid: 's1', name: '会失败的文件.zip', size: 2048000),
    AntUploadFile(uid: 's2', name: '会成功的文件.zip', size: 2048000),
  ];
  int _pickCount = 0;

  Future<void> _request(AntUploadFile file,
      void Function(AntUploadFile) updateFile) async {
    await _fakeUpload(file, updateFile, fail: file.uid == 's1');
  }

  @override
  Widget build(BuildContext context) {
    return _page(context, [
      _sectionCard(
        context,
        '状态流转：上传中（进度）→ 成功 / 失败（点上传按钮依次触发）',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AntUpload(
              fileList: _files,
              onChange: (file, fileList) =>
                  setState(() => _files = fileList),
              onSelectFiles: () async {
                final f = _pool[_pickCount % _pool.length];
                _pickCount++;
                return [f];
              },
              customRequest: _request,
            ),
            SizedBox(height: 8.w),
            Text(
              '说明：第 1、3、5… 次上传模拟失败（error），失败后可移除重新上传；'
              '上传中展示进度百分比与进度条。',
              style: TextStyle(
                fontSize: 12.sp,
                color: AntTheme.of(context).colorTextTertiary,
              ),
            ),
          ],
        ),
      ),
      _sectionCard(
        context,
        '静态状态展示（uploading / done / error）',
        AntUpload(
          defaultFileList: const [
            AntUploadFile(
                uid: 'd1',
                name: '上传中.pdf',
                status: AntUploadStatus.uploading,
                percent: 60),
            AntUploadFile(
                uid: 'd2', name: '已完成.pdf', status: AntUploadStatus.done),
            AntUploadFile(
                uid: 'd3', name: '失败.pdf', status: AntUploadStatus.error),
          ],
          onSelectFiles: () async => const [],
        ),
      ),
    ]);
  }
}

// ── 图片预览 ─────────────────────────────────────────────
class _PreviewSection extends StatefulWidget {
  const _PreviewSection();

  @override
  State<_PreviewSection> createState() => _PreviewSectionState();
}

class _PreviewSectionState extends State<_PreviewSection> {
  String? _previewUrl;

  @override
  Widget build(BuildContext context) {
    return _page(context, [
      _sectionCard(
        context,
        'onPreview 图片预览（点击文件弹出大图）',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AntUpload(
              listType: AntUploadListType.pictureCard,
              maxCount: 3,
              uploadButtonText: '上传',
              onPreview: (file) =>
                  setState(() => _previewUrl = file.url ?? file.thumbUrl),
              onSelectFiles: () => _pickFiles([
                AntUploadFile(
                    uid: 'pv1',
                    name: '风景.jpg',
                    url: kDemoImages[0],
                    thumbUrl: kDemoImages[0]),
                AntUploadFile(
                    uid: 'pv2',
                    name: '湖泊.jpg',
                    url: kDemoImages[1],
                    thumbUrl: kDemoImages[1]),
                AntUploadFile(
                    uid: 'pv3',
                    name: '山川.jpg',
                    url: kDemoImages[2],
                    thumbUrl: kDemoImages[2]),
              ]),
              customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
            ),
            if (_previewUrl != null) ...[
              SizedBox(height: 12.w),
              GestureDetector(
                onTap: () => setState(() => _previewUrl = null),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    _previewUrl!,
                    width: double.infinity,
                    height: 200.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 4.w),
              Text('点击预览图关闭',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AntTheme.of(context).colorTextTertiary)),
            ],
          ],
        ),
      ),
    ]);
  }
}

// ── 受控操作 ─────────────────────────────────────────────
class _ControlledSection extends StatefulWidget {
  const _ControlledSection();

  @override
  State<_ControlledSection> createState() => _ControlledSectionState();
}

class _ControlledSectionState extends State<_ControlledSection> {
  List<AntUploadFile> _files = const [
    AntUploadFile(uid: 'ctl1', name: '受控-报告.pdf', size: 1024000),
  ];
  String _lastAction = '（尚未操作）';

  @override
  Widget build(BuildContext context) {
    return _page(context, [
      _sectionCard(
        context,
        'fileList 受控 + onChange / onRemove / onPreview 回调日志',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AntUpload(
              fileList: _files,
              onChange: (file, fileList) {
                setState(() {
                  _files = fileList;
                  _lastAction =
                      'onChange: ${file.name} (${file.status.name})，列表 ${fileList.length} 项';
                });
              },
              onRemove: (file) async {
                setState(() => _lastAction = 'onRemove: ${file.name} → 允许');
                return true;
              },
              onPreview: (file) =>
                  setState(() => _lastAction = 'onPreview: ${file.name}'),
              uploadButtonText: '受控上传',
              onSelectFiles: () async => [
                AntUploadFile(
                    uid: 'ctl${DateTime.now().millisecondsSinceEpoch}',
                    name: '受控文件-${_files.length + 1}.pdf',
                    size: 1024000),
              ],
              customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
            ),
            SizedBox(height: 12.w),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AntTheme.of(context).colorFillQuaternary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text('回调日志：$_lastAction',
                  style: TextStyle(fontSize: 12.sp)),
            ),
          ],
        ),
      ),
      _sectionCard(
        context,
        'onRemove 拦截（返回 false 阻止删除）',
        AntUpload(
          defaultFileList: const [
            AntUploadFile(uid: 'lock1', name: '锁定文件.pdf'),
          ],
          onRemove: (file) async => false,
          uploadButtonText: '上传',
          onSelectFiles: () async => const [],
        ),
      ),
    ]);
  }
}

// ── 自定义 item 渲染 ─────────────────────────────────────
class _CustomItemSection extends StatelessWidget {
  const _CustomItemSection();

  @override
  Widget build(BuildContext context) {
    return _page(context, [
      _sectionCard(
        context,
        '自定义上传按钮文案与图标',
        AntUpload(
          uploadButtonText: '选择附件',
          uploadButtonIcon: Icons.attach_file,
          onSelectFiles: () async => [
            const AntUploadFile(uid: 'ci1', name: '附件.docx', size: 204800),
          ],
          customRequest: (file, updateFile) => _fakeUpload(file, updateFile),
        ),
      ),
      _sectionCard(
        context,
        '外层自定义包装（卡片化 + 禁用态）',
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AntTheme.of(context).colorFillQuaternary,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('入职材料提交',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14.sp)),
              SizedBox(height: 8.w),
              AntUpload(
                disabled: true,
                defaultFileList: const [
                  AntUploadFile(uid: 'ci-d1', name: '身份证.pdf', size: 1024000),
                ],
                onSelectFiles: () async => const [],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
