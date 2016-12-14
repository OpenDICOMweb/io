// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';
import 'package:io/src/compare_files.dart';

//String inPath = 'C:/odw/test_data/IM-0001-0001.dcm';
String inPath = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';
String outPath = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/'
    '2.16.840.1.114255.1870665029.949635505.39523.169/output.dcm';

String in1 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/"
    "2.16.840.1.114255.1870665029.949635505.39523.169/"
    "2.16.840.1.114255.1870665029.949635505.25169.170.dcm";

String in2 = 'C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/2.16.840'
    '.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.10220.175.dcm';

String out1 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/"
    "2.16.840.1.114255.1870665029.949635505.39523.169/"
    "output.dcm";

final log = new Logger("read_write_file", logLevel: Level.info);

void main(List<String> args) {
  Filename fn = new Filename(in2);
  log.info('reading: $fn');
  Uint8List bytes = fn.file.readAsBytesSync();
  log.info('read ${bytes.length} bytes');
  Instance instance0 = DcmDecoder.decode(new DSSource(bytes, fn.path));
  log.info(instance0.format(new Formatter(maxDepth: -1)));

  log.info('0070 0080 ${instance0.dataset.lookup(0x00700080)}');
  log.info('0070 0081 ${instance0.dataset.lookup(0x00700081)}');

  // Write a File
  Filename fnOut = new Filename.withType(out1, FileSubtype.part10);
  fnOut.writeSync(instance0);

  // Now read the file we just wrote.
  Filename result = new Filename(out1);

  log.info('Re-reading: $result');
  bytes = result.readAsBytesSync();
  log.info('read ${bytes.length} bytes');
  Instance instance1 = DcmDecoder.decode(new DSSource(bytes, fn.path));
  log.info(instance1.format(new Formatter(maxDepth: -1)));

  // Compare Datasets
  log.logLevel = Level.info;
  var comparitor = new DatasetComparitor(instance0.dataset, instance1.dataset);
  comparitor.result;
  if (comparitor.hasDifference) {
    log.info('Result: ${comparitor.bad}');
    throw "stop";
  }

  log.logLevel = Level.debug;
  // Compare input and output
  log.info('Comparing Bytes:');
  log.down;
  log.info('Original: ${fn.path}');
  log.info('Result: ${result.path}');
  List<List> out = compareFiles(fn.path, result.path);
  log.info('$out');
  log.up;
}
