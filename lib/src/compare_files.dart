// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
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

final log = new Logger('FileCompare', logLevel: Level.info);

/// Compare two files byte by byte and report the first significant difference.
List<List> compareFiles(String path0, String path1, [logLevel = Level.info]) {
  log.logLevel = logLevel;
  final List<List> result = [];
  bool hasProblems = false;
  bool contiguous = false;

  log.down;
  Filename fn0 = new Filename(path0);
  Uint8List bytes0 = fn0.file.readAsBytesSync();
  int length0 = bytes0.length;
  log.debug('fn0 read $length0 bytes');

  Filename fn1 = new Filename(path1);
  Uint8List bytes1 = fn1.file.readAsBytesSync();
  int length1 = bytes1.length;
  log.debug('fn1 read $length1 bytes');

  result.add(["length", bytes0.length, bytes1.length]);
  int limit = (length0 > length1) ? length1 : length0;

  log.down;
  for (int i = 0; i < limit; i++) {
    int byte0 = bytes0[i];
    int byte1 = bytes1[i];
    if (byte0 == byte1) {
      contiguous = false;
      continue;
    }
    String s0 = new String.fromCharCode(byte0);
    String s1 = new String.fromCharCode(byte1);
    if ((byte0 == 0 && byte1 == 32) || (byte0 == 32 && byte1 == 0)) {
      result.add(["Null/Space", i, byte0, byte1, '$s0($byte0)', '$s1($byte1)']);
      log.debug('Found $s0($byte0) in f0 and $s1($byte1) in f1');
      contiguous = true;
      continue;
    }
    //Test for uppercase & lowercase
    if (byte0 == toLowercaseChar(byte1)) {
      result.add(["Lower To Upper case", i, byte0, byte1, '$s0($byte0)', '$s1($byte1)']);
      log.debug('Found Uppercase "$s0" ($byte0) in f0 and "$s1"($byte1) in f1');
      contiguous = true;
      continue;
    }
    //Test for uppercase & lowercase
    if (byte0 == toUppercaseChar(byte1)) {
      result.add(["Upper To Lower case", i, byte0, byte1, '$s0($byte0)', '$s1($byte1)']);
      log.debug('Found Lowercase "$s0" ($byte0) in f0 and "$s1"($byte1) in f1');
      contiguous = true;
      continue;
    }
    if (!contiguous) {
      log.logLevel = Level.debug;
      result.add(["Problem", i, byte0, byte1, '$s0($byte0)', '$s1($byte1)']);
      _foundProblem(bytes0, bytes1, i, 20, 20);
      hasProblems == true;
      log.logLevel = Level.info;
    }
    contiguous = true;
    //log.fatal("Stop");
  }
  log.up;

  if (result.length == 1) {
    log.debug('Files are identical');
    log.up;
    return [];
  } else if (hasProblems) {
    log.debug('**** File are different and have problems');
    log.debug(resultToString(result));
    log.up;
    return result;
  } else {
    log.debug('Warning Files are different but result is correct');
    log.debug(resultToString(result));
    log.up;
    return result;
  }
}

String resultToString(List<List> result) {
  String out = 'compareFiles Result:\n';
  for (List v in result) {
    var v0 = '${v[0]}'.padLeft(3, ' ');
    var v1 = '${v[1]}'.padLeft(3, ' ');
    out += '${v[0]}: $v0, $v1';
  }
  return out;
}

String _charToString(int c) {
  if (c < 127 && isVisibleChar(c)) {
    return new String.fromCharCode(c).padLeft(4, ' ');
  } else {
    return '    ';
  }
}

String _toDecimal(int i) => i.toRadixString(10).padLeft(4, ' ');
String _toHex(int i) => i.toRadixString(16).padLeft(2, "0").padLeft(4, ' ');


void _foundProblem(Uint8List bytes0, Uint8List bytes1, int i, int before, int after) {
  log.error('Found a Problem at index $i');
  log.error('$i: ${bytes0[i]} != ${bytes1[i]}');

  List<String> count = [];
  List<String> index = [];
  List<String> dec0 = [];
  List<String> hex0 = [];
  List<String> char0 = [];
  List<String> dec1 = [];
  List<String> hex1 = [];
  List<String> char1 = [];

  var begin = i - before;
  var end = i;
  for (int j = 0, k = begin; k < end; j++, k++) {
    // File 0
    int v0 = bytes0[k];
    count.add(_toDecimal(j));
    index.add(_toDecimal(k));
    dec0.add(_toDecimal(v0));
    hex0.add(_toHex(v0));
    char0.add(_charToString(v0));
    // File 1
    int v1 = bytes1[k];
    dec1.add(_toDecimal(v1));
    hex1.add(_toHex(v1));
    char1.add(_charToString(v1));
  }
  // File 0
  int v0 = bytes0[i];
  count.add('| ${_toDecimal(before)}|');
  index.add('| ${_toDecimal(i)}|');
  dec0.add('| ${_toDecimal(v0)}|');
  hex0.add('| ${_toHex(v0)}|');
  char0.add('| ${_charToString(v0)}|');
  // File 1
  int v1 = bytes1[i];
  dec1.add('| ${_toDecimal(v1)}|');
  hex1.add('| ${_toHex(v1)}|');
  char1.add('| ${_charToString(v1)}|');

  begin = i + 1;
  end = begin + after;
  for (int j = before + 1, k = begin; k < end; j++, k++) {
    // File 0
    int v0 = bytes0[k];
    count.add(_toDecimal(j));
    index.add(_toDecimal(k));
    dec0.add(_toDecimal(v0));
    hex0.add(_toHex(v0));
    char0.add(_charToString(v0));

    // c0List.add(new String.fromCharCode(v0).padLeft(3, ' '));

    // File 1
    int v1 = bytes1[k];
    dec1.add(_toDecimal(v1));
    hex1.add(_toHex(v1));
    char1.add(_charToString(v1));
  }

  log.debug(' k: $count');
  log.debug(' i: $index');
  log.debug('D0: $dec0');
  log.debug('D1: $dec1');
  log.debug('H0: $hex0');
  log.debug('H1: $hex1');
  log.debug('C0: $char0');
  log.debug('C1: $char1');
}


