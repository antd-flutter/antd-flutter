// Copyright (c) 2021 xuelongqy (easy_refresh authors)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// 来源：easy_refresh v3.5.0 (https://pub.dev/packages/easy_refresh)，MIT License。
// 完整移植复刻到 antd_refresh 包，类名加 Er 前缀以隔离命名空间。
import 'package:material_ui/material_ui.dart';
import 'package:path_drawing/path_drawing.dart';

/// Paths paint.
class ErPathsPaint extends StatefulWidget {
  /// String to Path.
  static List<Path> parserPaths(List<String> paths) {
    final pathList = <Path>[];
    for (final item in paths) {
      pathList.add(parseSvgPathData(item));
    }
    return pathList;
  }

  /// Paths in String format.
  final List<String> paths;

  /// The color corresponding to each path.
  final List<Color> colors;

  /// Drawing width, proportional scaling.
  final double? width;

  /// Drawing height, proportional scaling.
  final double? height;

  const ErPathsPaint({
    super.key,
    required this.paths,
    required this.colors,
    this.width,
    this.height,
  });

  @override
  State<ErPathsPaint> createState() => _PathsPaintState();
}

class _PathsPaintState extends State<ErPathsPaint> {
  late List<Path> _paths;
  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();
    _update();
  }

  /// Update paths and size.
  void _update() {
    _paths = ErPathsPaint.parserPaths(widget.paths);
    Path combinePath = _paths.first;
    for (int i = 1; i < _paths.length; i++) {
      combinePath = Path.combine(PathOperation.union, combinePath, _paths[i]);
    }
    final bounds = combinePath.getBounds();
    _width = bounds.width;
    _height = bounds.height;
  }

  @override
  void didUpdateWidget(covariant ErPathsPaint oldWidget) {
    if (oldWidget.paths != widget.paths) {
      _update();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double? sx;
    double? sy;
    if (widget.width != null && widget.height != null) {
      sx = widget.width! / _width;
      sy = widget.height! / _height;
    } else if (widget.width != null) {
      sx = widget.width! / _width;
    } else if (widget.height != null) {
      sx = widget.height! / _height;
    }
    double width = _width * (sx ?? 1);
    double height = _height * (sy ?? sx ?? 1);
    return CustomPaint(
      painter: ErPathsPainter(
        paths: _paths,
        colors: widget.colors,
        sx: sx,
        sy: sy,
      ),
      size: Size(width, height),
    );
  }
}

/// Paths painter.
class ErPathsPainter extends CustomPainter {
  ErPathsPainter({
    required this.paths,
    required this.colors,
    this.sx,
    this.sy,
  });

  /// Paths.
  final List<Path> paths;

  /// The color corresponding to each path.
  final List<Color> colors;

  /// Width scaling.
  final double? sx;

  /// Height scaling.
  final double? sy;

  @override
  bool shouldRepaint(ErPathsPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (sx != null) {
      canvas.scale(sx!, sy);
    }
    for (int i = 0; i < paths.length; i++) {
      final path = paths[i];
      final color = colors[i];
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool hitTest(Offset position) =>
      paths.any((element) => element.contains(position));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErPathsPainter &&
          runtimeType == other.runtimeType &&
          paths == other.paths &&
          colors == other.colors &&
          sx == other.sx &&
          sy == other.sy;

  @override
  int get hashCode =>
      paths.hashCode ^ colors.hashCode ^ sx.hashCode ^ sy.hashCode;
}
