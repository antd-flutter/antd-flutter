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
library;

import 'dart:math' as math;
import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/physics.dart' as physics;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'src/painter/paths_painter.dart';

part 'src/easy_refresh.dart';
part 'src/physics/scroll_physics.dart';
part 'src/notifier/indicator_notifier.dart';
part 'src/behavior/scroll_behavior.dart';
part 'src/indicator/indicator.dart';
part 'src/indicator/header/header.dart';
part 'src/indicator/header/header_locator.dart';
part 'src/indicator/footer/footer.dart';
part 'src/indicator/footer/footer_locator.dart';
part 'src/controller/controller.dart';
part 'src/styles/classic/header/classic_header.dart';
part 'src/styles/classic/footer/classic_footer.dart';
part 'src/styles/classic/classic_indicator.dart';
part 'src/styles/material/material_indicator.dart';
part 'src/styles/material/header/material_header.dart';
part 'src/styles/material/footer/material_footer.dart';
part 'src/styles/bezier/bezier_background.dart';
part 'src/styles/bezier/bezier_indicator.dart';
part 'src/styles/bezier/bezier_circle_indicator.dart';
part 'src/styles/bezier/spin/hour_glass.dart';
part 'src/styles/bezier/header/bezier_header.dart';
part 'src/styles/bezier/header/bezier_circle_header.dart';
part 'src/styles/bezier/footer/bezier_footer.dart';
part 'src/styles/phoenix/phoenix_indicator.dart';
part 'src/styles/phoenix/header/phoenix_header.dart';
part 'src/styles/phoenix/footer/phoenix_footer.dart';
part 'src/styles/taurus/taurus_indicator.dart';
part 'src/styles/taurus/header/taurus_header.dart';
part 'src/styles/taurus/footer/taurus_footer.dart';
part 'src/styles/delivery/delivery_indicator.dart';
part 'src/styles/delivery/header/delivery_header.dart';
part 'src/styles/delivery/footer/delivery_footer.dart';
part 'src/styles/cupertino/cupertino_indicator.dart';
part 'src/styles/cupertino/cupertino_activity_indicator.dart';
part 'src/styles/cupertino/header/cupertino_header.dart';
part 'src/styles/cupertino/footer/cupertino_footer.dart';
