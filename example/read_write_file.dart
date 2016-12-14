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

String in3 = "C:/odw/sdk/io/example/input/1.2.840.113696.596650.500.5347264.20120723195848/2.16.840.1.114255.1870665029.949635505.39523.169/2.16.840.1.114255.1870665029.949635505.25169.170.dcm";

String out3 = "C:/odw/sdk/io/example/output/2.16.840.1.114255.1870665029.949635505.25169.170.dcm";

String outX = "C:/odw/sdk/io/example/output/foo.dcm";

final log = new Logger("read_write_file", logLevel: Level.info);

void main(List<String> args) {
  Filename fn = new Filename(in3);
  log.info('reading: $fn');
  Uint8List bytes0 = fn.file.readAsBytesSync();
  log.info('read ${bytes0.length} bytes');
  Instance instance0 = DcmDecoder.decode(new DSSource(bytes0, fn.path));
  log.info(instance0);
  log.debug(instance0.format(new Formatter(maxDepth: -1)));

  log.info('0070 0010 ${instance0.dataset.lookup(0x00700010)}');
  log.info('0070 0011 ${instance0.dataset.lookup(0x00700011)}');
  log.info('0070 0010 ${instance0.dataset.lookup(0x00700010)}');
  log.info('0070 0014 ${instance0.dataset.lookup(0x00700014)}');

  // Write a File

  Filename fnOut = new Filename.withType(outX, FileSubtype.part10);
  fnOut.writeSync(instance0);

  // Now read the file we just wrote.
  //Filename result = new Filename(fnOut);

  log.info('Re-reading: $fnOut');
  Uint8List bytes1 = fnOut.readAsBytesSync();
  log.info('read ${bytes1.length} bytes');
  Instance instance1 = DcmDecoder.decode(new DSSource(bytes1, fn.path));
  log.info(instance1);
  log.debug(instance1.format(new Formatter(maxDepth: -1)));

  // Compare Datasets
  log.logLevel = Level.info;
  var comparitor = new DatasetComparitor(instance0.dataset, instance1.dataset);
  comparitor.run;
  if (comparitor.hasDifference) {
    log.info('Result: ${comparitor.bad}');
    throw "stop";
  }

  log.logLevel = Level.debug;
  // Compare input and output
  log.info('Comparing Bytes:');
  log.down;
  log.info('Original: ${fn.path}');
  log.info('Result: ${fnOut.path}');
  List<List> out = compareFiles(fn.path, fnOut.path);
  log.info('$out');
  log.up;
}
