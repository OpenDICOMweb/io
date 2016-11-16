// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:io/io.dart';

String inPath0 = 'C:/odw/test_data/IM-0001-0001.dcm';

String inPath1 = 'C:/odw/sdk/io/example/output/IM-0001-0001.dcm';

void main(List<String> args) {

  Filename fn0 = new Filename(inPath0);
  Uint8List bytes0 = fn0.file.readAsBytesSync();
  int length0 = bytes0.length;
  print('fn0 read $length0 bytes');

  Filename fn1 = new Filename(inPath1);
  Uint8List bytes1 = fn1.file.readAsBytesSync();
  int length1 = bytes1.length;
  print('fn1 read $length1 bytes');

  int limit = (length0 > length1) ? length1 : length0;

  /*
  Uint8List foo = new Uint8List(160);
  Uint8L     ist bar = new Uint8List(160);
  for(int i = 0; i < 50; i++) {
    foo[i] = bytes0[128 + i];
    bar[i] = bytes1[128 + i];
  }
  print(foo);
  print(bar);
  */
  for(int i = 0; i < limit; i++) {
    if (bytes0[i] == bytes1[i]) continue;
    if (bytes0[i] == 0 && bytes1[i] == 32) {
      print('found Null(0) in f1 and space (" ") in f2');
      continue;
    }
    for(int j = -10; j < 20; j++, i++) {
      if (bytes0[i] == bytes1[i]) break;
      print('$i: ${bytes0[i]} != ${bytes1[i]}');

      Uint8List s = new Uint8List(30);
      for(int k = 0; k < 30; k++) {
        s[k] = bytes0[(i - 10)+k];
      }
      print('     $s');
      for(int k = 0; k < 30; k++) {
        s[k] = bytes1[(i - 10)+k];
      }
      print('     $s');
      s = new Uint8List(30);
      for(int k = 0; k < 30; k++) {
        s[k] = (bytes0[(i - 10)+k] + 32);
      }
      String ss = new String.fromCharCodes(s);
      print('     $ss');
      for(int k = 0; k < 30; k++) {
        s[k] = bytes1[(i - 10)+k] + 32;
      }
      ss = new String.fromCharCodes(s);
      print('     $ss');
      if (j == 19) throw "end";
    }
  }
}



