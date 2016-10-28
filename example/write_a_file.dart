// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/dicom.dart';
import 'package:logger/logger.dart';

String inputDir = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String outputDir = "C:/odw/sdk/convert/test_output/";

String crf1 = "CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm";
String crf2 = "CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm";

void main() {
  Logger log = new Logger("write_a_file", Level.debug);
  String inPath = inputDir + crf1;
  String outPath = outputDir + crf1;
  Study study;
  String fmtOutput;

  // Read a File
  File inFile = new File(inPath);
  log.info('Reading file: $inFile');
  Uint8List bytes = inFile.readAsBytesSync();
  print('length= ${bytes.length}');

  DcmDecoder decoder = new DcmDecoder(bytes);
  Instance instance = decoder.readSopInstance();
  //print(study);
  //fmt = new Format();
  //fmtOutput = fmt.study(study);
  // print(fmtOutput);

  // Write a File
  log.level = Level.config;
  File outFile = new File(outPath);
  log.info('Writing file: $outFile');

  DcmEncoder encode = new DcmEncoder(bytes.length + 1024);
  encode.writeSopInstance(instance);
  print('writeIndex: ${encode.writeIndex}');

  var outBytes = encode.bytes.buffer.asUint8List(0, encode.writeIndex);
  print('out length: ${bytes.length}');
  outFile.writeAsBytesSync(outBytes);

  //print(study);

  fmtOutput = study.format(new Formatter());
  print(fmtOutput);
}