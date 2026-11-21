import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const AntdUiExampleApp());

/// Minimal gallery that demonstrates the core `antd_flutter_ui` widgets.
class AntdUiExampleApp extends StatelessWidget {
  const AntdUiExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AntTheme(
      data: AntThemeData.light(),
      child: const MaterialApp(
        title: 'antd_flutter_ui example',
        home: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('antd_flutter_ui')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AntSpace(
          direction: AntSpaceDirection.vertical,
          children: [
            const AntDivider(child: Text('Buttons')),
            AntSpace(
              wrap: true,
              children: [
                AntButton(
                  type: AntButtonType.primary,
                  child: const Text('Primary'),
                  onTap: () => setState(() => _count++),
                ),
                const AntButton(child: Text('Default')),
                const AntButton(
                  type: AntButtonType.dashed,
                  child: Text('Dashed'),
                ),
                const AntButton(danger: true, child: Text('Danger')),
              ],
            ),
            const AntDivider(child: Text('Tags')),
            const AntSpace(
              wrap: true,
              children: [
                AntTag(child: 'Tag A'),
                AntTag(child: 'Tag B'),
              ],
            ),
            const AntDivider(child: Text('Counter')),
            Text('Tapped $_count time(s)'),
          ],
        ),
      ),
    );
  }
}
