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

final log = new Logger('FileCompare',  watermark: Severity.config);

class FileCompareResult {
  Filename infile;
  Filename outfile;
  bool sameLength;
  bool hasProblems;
  List<FileByteDiff> diffs;

  FileCompareResult(
      this.infile, this.outfile, this.sameLength, this.hasProblems, this.diffs);

  String get lengthMsg =>
      (sameLength) ? "Equal lengths" : '** Different Lengths';

  String get fmtDiffs {
    var out = 'Differences';
    for (FileByteDiff d in diffs) out += '$d';
    return out;
  }

  @override
  String toString() => '''
File comparison result:
  in: $infile
  out: $outfile
  $lengthMsg

  ''';
}

class FileByteDiff {
  int pos;
  String type;
  int byte0;
  int byte1;
  String info;

  FileByteDiff(this.pos, this.type, this.byte0, this.byte1, this.info);

  @override
  String toString() => '    $pos: $type, byte0($byte0), byte1($byte1)\n $info';
}

/// Compare two files byte by byte and report the first significant difference.
FileCompareResult compareFiles(String path0, String path1,
    [Logger log, watermark= Severity.config]) {
  final List<FileByteDiff> diffs = [];
  final maxProblems = 3;
  bool hasProblems = false;
  bool contiguous = false;
  log.watermark = watermark;

  log.down;
  Filename fn0 = new Filename(path0);
  Uint8List bytes0 = fn0.file.readAsBytesSync();
  int length0 = bytes0.length;
  log.debug('fn0 read $length0 bytes');

  Filename fn1 = new Filename(path1);
  Uint8List bytes1 = fn1.file.readAsBytesSync();
  int length1 = bytes1.length;
  log.debug('fn1 read $length1 bytes');
  bool isLengthEqual = (length0 == length1);

  log.down;
  int limit = (length0 > length1) ? length1 : length0;
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
      diffs.add(new FileByteDiff(i, "Null/Space", byte0, byte1, ""));
      log.debug('Found $s0($byte0) in f0 and $s1($byte1) in f1');
      contiguous = true;
      continue;
    }
    //Test for uppercase & lowercase
    if (byte0 == toLowercaseChar(byte1)) {
      diffs.add(new FileByteDiff(
          i, "Lower To Upper case", byte0, byte1, '$s0($byte0), $s1($byte1)'));
      log.debug('Found Uppercase "$s0" ($byte0) in f0 and "$s1"($byte1) in f1');
      contiguous = true;
      continue;
    }
    //Test for uppercase & lowercase
    if (byte0 == toUppercaseChar(byte1)) {
      diffs.add(new FileByteDiff(
          i, "Upper To Lower case", byte0, byte1, '$s0($byte0), $s1($byte1)'));
      log.debug('Found Lowercase "$s0" ($byte0) in f0 and "$s1"($byte1) in f1');
      contiguous = true;
      continue;
    }
    if (!contiguous && diffs.length < maxProblems) {
      var problem = _foundProblem(bytes0, bytes1, i, 20, 20);
      diffs.add(new FileByteDiff(i, "Problem", byte0, byte1, problem));
      hasProblems == true;
    }
    contiguous = true;
    //log.fatal("Stop");
  }
  log.up;

  if (diffs.length != 0) {
    var result =
        new FileCompareResult(fn0, fn1, isLengthEqual, hasProblems, diffs);
    if (hasProblems) {
      log.debug('**** File are different and have problems');
    } else {
      log.debug('** Warning Files are different but result is correct');
    }
    log.up;
    log.debug(result);
    return result;
  }
  log.debug('Files are identical');
  log.up;
  return null;
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

String _foundProblem(
    Uint8List bytes0, Uint8List bytes1, int i, int before, int after) {
  var out = 'Found a Problem at index $i\n';
  out += '  $i: ${bytes0[i]} != ${bytes1[i]}\n';

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

  out += ' k: $count';
  out += ' i: $index';
  out += 'D0: $dec0';
  out += 'D1: $dec1';
  out += 'H0: $hex0';
  out += 'H1: $hex1';
  out += 'C0: $char0';
  out += 'C1: $char1';
  return out;
}
