// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:io/io.dart';
import 'package:system/server.dart';

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

/// Compare two files byte by byte and report the first significant difference.
void main(List<String> args) {
  Server.initialize(name: 'compare_file_bytes.dart', level: Level.info0);

  final fn0 = new Filename(inPath0);
  final bytes0 = fn0.file.readAsBytesSync();
  final length0 = bytes0.length;
  log.debug('fn0 read $length0 bytes');

  final fn1 = new Filename(inPath1);
  final bytes1 = fn1.file.readAsBytesSync();
  final length1 = bytes1.length;
  log.debug('fn1 read $length1 bytes');

  final limit = (length0 > length1) ? length1 : length0;

  for (var i = 0; i < limit; i++) {
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
    Uint8List bytes0, Uint8List bytes1, int index, int before, int after) {
  var i = index;
  for (var j = -10; j < 20; j++, i++) {
    if (bytes0[i] == bytes1[i]) break;
    log.debug('$i: ${bytes0[i]} != ${bytes1[i]}');

    final d0List = <String>[];
    final h0List = <String>[];
    final c0List = <String>[];
    final d1List = <String>[];
    final h1List = <String>[];
    final c1List = <String>[];

    for (var k = 0; k < before; k++) {
      // File 0
      final v0 = bytes0[(i - before) + k];
      d0List.add(v0.toRadixString(10).padLeft(3, ' '));
      h0List.add(v0.toRadixString(16).padLeft(3, ' '));
      c0List.add(new String.fromCharCode(v0).padLeft(3, ' '));
      // File 1
      final v1 = bytes1[(i - before) + k];
      d1List.add(v1.toRadixString(10).padLeft(3, ' '));
      h1List.add(v1.toRadixString(16).padLeft(3, ' '));
      c1List.add(new String.fromCharCode(v1).padLeft(3, ' '));
    }
    // File 0
    final v0 = bytes0[i];
    d0List.add('|${v0.toRadixString(10).padLeft(3, ' ')}|');
    h0List.add('|${v0.toRadixString(16).padLeft(3, ' ')}|');
    c0List.add('|${new String.fromCharCode(v0).padLeft(3, ' ')}|');
    // File 1
    final v1 = bytes1[i];
    d1List.add('|${v1.toRadixString(10).padLeft(3, ' ')}|');
    h1List.add('|${v1.toRadixString(16).padLeft(3, ' ')}|');
    c1List.add('|${new String.fromCharCode(v1).padLeft(3, ' ')}|');

    for (var k = 0; k < after; k++) {
      // File 0
      final v0 = bytes0[(i - after) + k];
      d0List.add(v0.toRadixString(10).padLeft(3, ' '));
      h0List.add(v0.toRadixString(16).padLeft(3, ' '));
      c0List.add(new String.fromCharCode(v0).padLeft(3, ' '));
      // File 1
      final v1 = bytes1[(i - after) + k];
      d1List.add(v1.toRadixString(10).padLeft(3, ' '));
      h1List.add(v1.toRadixString(16).padLeft(3, ' '));
      c1List.add(new String.fromCharCode(v1).padLeft(3, ' '));
    }
  }
}
