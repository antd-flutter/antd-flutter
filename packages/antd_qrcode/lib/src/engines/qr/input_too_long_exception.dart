// Copyright 2014, the Dart QR project authors. All rights reserved.
//
// 本文件来源 package:qr 3.0.3（https://pub.dev/packages/qr），BSD-3-Clause License（见包根 LICENSE-THIRD-PARTY.md）。
// 改造吸收（R30）：作为 antd_qrcode 包内私有引擎源码，不经包 barrel 导出原始 API。

class InputTooLongException implements Exception {
  final int providedInput;
  final int inputLimit;
  final String message;

  factory InputTooLongException(int providedInput, int inputLimit) {
    final message = 'Input too long. $providedInput > $inputLimit';

    return InputTooLongException._internal(providedInput, inputLimit, message);
  }

  InputTooLongException._internal(
    this.providedInput,
    this.inputLimit,
    this.message,
  );

  @override
  String toString() => 'QrInputTooLongException: $message';
}
