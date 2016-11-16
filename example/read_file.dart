// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';

String path = 'C:/odw/test_data/IM-0001-0001.dcm';
String outPath = 'C:/odw/sdk/io/example/output/IM-0001-0001.dcm';

void main(List<String> args) {

  Filename fn = new Filename(path);
  Uint8List bytes = fn.file.readAsBytesSync();
  printBytes(bytes, bytes.length);
  Entity e = DcmDecoder.decode(bytes);
  print(e.format(new Formatter(maxDepth: -1)));

}

void printIt(Uint8List bytes, int offset, int count) {
  int length = bytes.length;
  ByteData bd = bytes.buffer.asByteData();
  print('length: $length');
  if (offset < 0) offset = length + offset;
  for (int i = 0; i < count; i += 4) {
    int first = bd.getUint16(offset + i);
    int second = bd.getUint16(offset + i + 2);
    print('${Int.toHex(first)},${Int.toHex(second)}');
  }
}


printBytes(TypedData list, int length) {
  print('list.length(${list.lengthInBytes}, length($length)');
  Uint32List l32 = list.buffer.asUint32List();
  for (int i = 0; i < 64; i += 16) {
    var out = [];
    for (int j = 0; j < 16; j++) {
      if (i + j >= l32.length) break;
      out.add(l32[i + j]);
    }
    print(out);
  }

  for (int i = l32.length - 64; i < l32.length; i += 16) {
    var out = [];
    for (int j = 0; j < 16; j++) {
      if (i + j >= l32.length) break;
      out.add(l32[i + j]);
    }
    print(out);
  }
}



