// Copyright 2014, the Dart QR project authors. All rights reserved.
//
// 本文件来源 package:qr 3.0.3（https://pub.dev/packages/qr），BSD-3-Clause License（见包根 LICENSE-THIRD-PARTY.md）。
// 改造吸收（R30）：作为 antd_qrcode 包内私有引擎源码，不经包 barrel 导出原始 API。

// ignore: avoid_classes_with_only_static_members
class QrErrorCorrectLevel {
  static const int L = 1;
  static const int M = 0;
  static const int Q = 3;
  static const int H = 2;

  // thesee *are* in order of lowest to highest quality...I think
  // all I know for sure: you can create longer messages w/ item N than N+1
  // I assume this correcsponds to more error correction for N+1
  static const List<int> levels = [L, M, Q, H];

  static String getName(int level) => switch (level) {
        L => 'Low',
        M => 'Medium',
        Q => 'Quartile',
        H => 'High',
        _ => throw ArgumentError('level $level not supported')
      };
}
