// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:core/core.dart';

// ignore_for_file: public_member_api_docs

void printIt(Uint8List bytes, int offset, int count) {
  final length = bytes.length;
  final bd = bytes.buffer.asByteData();
  print('length: $length');
  final off = (offset < 0) ? length + offset : offset;
  for (var i = 0; i < count; i += 4) {
    final first = bd.getUint16(off + i);
    final second = bd.getUint16(off + i + 2);
    print('${hex32(first)},${hex32(second)}');
  }
}

void printBytes(TypedData list, int length) {
  print('list.length(${list.lengthInBytes}, length($length)');
  final l32 = list.buffer.asUint32List();
  for (var i = 0; i < 64; i += 16) {
    final out = <int>[];
    for (var j = 0; j < 16; j++) {
      if (i + j >= l32.length) break;
      out.add(l32[i + j]);
    }
    print(out);
  }

  for (var i = l32.length - 64; i < l32.length; i += 16) {
    final out = <int>[];
    for (var j = 0; j < 16; j++) {
      if (i + j >= l32.length) break;
      out.add(l32[i + j]);
    }
    print(out);
  }
}
