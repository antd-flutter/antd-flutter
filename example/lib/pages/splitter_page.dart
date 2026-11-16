library;

/// Splitter 分割面板演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class SplitterPage extends StatelessWidget {
  const SplitterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本用法', description: '拖拽分割线调整左右面板大小'),
          _BasicDemo(),
          _Section(title: '垂直布局', description: 'layout: vertical，上下分割面板'),
          _VerticalDemo(),
          _Section(title: '三面板', description: '多个面板嵌套分割线'),
          _ThreePanelDemo(),
          _Section(title: '折叠面板', description: 'collapsible 开启折叠按钮，点击收起/展开'),
          _CollapseDemo(),
          _Section(title: '受控模式', description: 'size 控制面板尺寸，外部更新自动同步'),
          _ControlledDemo(),
          _Section(title: '双击重置', description: '设置 defaultSize 后双击分割线恢复默认'),
          _DoubleTapDemo(),
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

/// 面板内容占位
Widget _panelContent(String label, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      border: Border.all(color: color.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(8),
    ),
    alignment: Alignment.center,
    child: Text(label, style: TextStyle(color: color)),
  );
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: AntSplitter(
        children: [
          AntSplitterPanel(child: _panelContent('面板 A', Colors.blue)),
          AntSplitterPanel(child: _panelContent('面板 B', Colors.green)),
        ],
      ),
    );
  }
}

class _VerticalDemo extends StatelessWidget {
  const _VerticalDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: AntSplitter(
        layout: AntSplitterLayout.vertical,
        children: [
          AntSplitterPanel(child: _panelContent('上方面板', Colors.orange)),
          AntSplitterPanel(child: _panelContent('下方面板', Colors.purple)),
        ],
      ),
    );
  }
}

class _ThreePanelDemo extends StatelessWidget {
  const _ThreePanelDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: AntSplitter(
        children: [
          AntSplitterPanel(child: _panelContent('面板 A', Colors.blue)),
          AntSplitterPanel(child: _panelContent('面板 B', Colors.green)),
          AntSplitterPanel(child: _panelContent('面板 C', Colors.teal)),
        ],
      ),
    );
  }
}

class _CollapseDemo extends StatelessWidget {
  const _CollapseDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: AntSplitter(
        children: [
          AntSplitterPanel(
            collapsible: true,
            child: _panelContent('可折叠 A', Colors.blue),
          ),
          AntSplitterPanel(
            collapsible: true,
            child: _panelContent('可折叠 B', Colors.green),
          ),
        ],
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  double _sizeA = 300;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          AntSpace(
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _sizeA = 200),
                child: const Text('A=200'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => _sizeA = 400),
                child: const Text('A=400'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AntSplitter(
              children: [
                AntSplitterPanel(
                  size: _sizeA,
                  child: _panelContent('受控面板 A', Colors.blue),
                ),
                AntSplitterPanel(
                  child: _panelContent('自适应面板 B', Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoubleTapDemo extends StatelessWidget {
  const _DoubleTapDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: AntSplitter(
        children: [
          AntSplitterPanel(
            defaultSize: 200,
            child: _panelContent('面板 A（默认 200）', Colors.blue),
          ),
          AntSplitterPanel(
            defaultSize: 580,
            child: _panelContent('面板 B（默认 580）', Colors.green),
          ),
        ],
      ),
    );
  }
}