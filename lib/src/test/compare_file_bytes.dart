// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:common/logger.dart';
import 'package:io/io.dart';

/// A simple program that compares to files byte by byte.
///
/// There are three cases:
///   1. If the bytes are the same it continues to the next bytes.
///   2. If the bytes are different, but the difference is
///      insignificant (such as different padding characters), it
///      prints a warning message.
///   3. If the difference is significant, it prints out the bytes
///      as lists<int> and [String]s.
///
/// This program could be improved in several ways:
///   * Try to parse both files simultaneously.

String inPath0 = 'C:/odw/test_data/IM-0001-0001.dcm';
String inPath1 = 'C:/odw/sdk/io/example/output/IM-0001-0001.dcm';

final Logger log =
new Logger('compare_file_bytes.dart', watermark:Severity.debug);

/// Compare two files byte by byte and report the first significant difference.
void main(List<String> args) {
  Filename fn0 = new Filename(inPath0);
  Uint8List bytes0 = fn0.file.readAsBytesSync();
  int length0 = bytes0.length;
  log.debug('fn0 read $length0 bytes');

  Filename fn1 = new Filename(inPath1);
  Uint8List bytes1 = fn1.file.readAsBytesSync();
  int length1 = bytes1.length;
  log.debug('fn1 read $length1 bytes');

  int limit = (length0 > length1) ? length1 : length0;

  for (int i = 0; i < limit; i++) {
    if (bytes0[i] == bytes1[i]) continue;
    if (bytes0[i] == 0 && bytes1[i] == 32) {
      log.debug('found Null(0) in f1 and space (" ") in f2');
      continue;
    }
    printDifference(bytes0, bytes1, i, 10, 20);
    break;
  }
}

void printDifference(
    Uint8List bytes0, Uint8List bytes1, int i, int before, int after) {
  for (int j = -10; j < 20; j++, i++) {
    if (bytes0[i] == bytes1[i]) break;
    log.debug('$i: ${bytes0[i]} != ${bytes1[i]}');

    List<String> d0List = [];
    List<String> h0List = [];
    List<String> c0List = [];
    List<String> d1List = [];
    List<String> h1List = [];
    List<String> c1List = [];

    for (int k = 0; k < before; k++) {
      // File 0
      int v0 = bytes0[(i - before) + k];
      d0List.add(v0.toRadixString(10).padLeft(3, ' '));
      h0List.add(v0.toRadixString(16).padLeft(3, ' '));
      c0List.add(new String.fromCharCode(v0).padLeft(3, ' '));
      // File 1
      int v1 = bytes1[(i - before) + k];
      d1List.add(v1.toRadixString(10).padLeft(3, ' '));
      h1List.add(v1.toRadixString(16).padLeft(3, ' '));
      c1List.add(new String.fromCharCode(v1).padLeft(3, ' '));
    }
    // File 0
    int v0 = bytes0[i];
    d0List.add('|${v0.toRadixString(10).padLeft(3, ' ')}|');
    h0List.add('|${v0.toRadixString(16).padLeft(3, ' ')}|');
    c0List.add('|${new String.fromCharCode(v0).padLeft(3, ' ')}|');
    // File 1
    int v1 = bytes1[i];
    d1List.add('|${v1.toRadixString(10).padLeft(3, ' ')}|');
    h1List.add('|${v1.toRadixString(16).padLeft(3, ' ')}|');
    c1List.add('|${new String.fromCharCode(v1).padLeft(3, ' ')}|');

    for (int k = 0; k < after; k++) {
      // File 0
      int v0 = bytes0[(i - after) + k];
      d0List.add(v0.toRadixString(10).padLeft(3, ' '));
      h0List.add(v0.toRadixString(16).padLeft(3, ' '));
      c0List.add(new String.fromCharCode(v0).padLeft(3, ' '));
      // File 1
      int v1 = bytes1[(i - after) + k];
      d1List.add(v1.toRadixString(10).padLeft(3, ' '));
      h1List.add(v1.toRadixString(16).padLeft(3, ' '));
      c1List.add(new String.fromCharCode(v1).padLeft(3, ' '));
    }
  }
}
