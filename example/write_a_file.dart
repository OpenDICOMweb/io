// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/dicom.dart';
import 'package:io/io.dart';

String inputDir = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String outputDir = "C:/odw/sdk/convert/test_output/";

String crf1 = "CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm";
String crf2 = "CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm";

void main() {
  Logger log = new Logger("write_a_file");
  String inPath = inputDir + crf1;
  String outPath = outputDir + crf1;
  Study study;
  String fmtOutput;

  // Read a File
  Filename inFile = new Filename(inPath);
  log.info('Reading file: $inFile');
  Instance instance = inFile.read();

  var fs = new FileSystem('output/dcmfs');
  // Write a File
  DcmFile outFile = fs.file(FileType.dcmInstance, instance.study.uid, instance.series.uid, uid);
  log.info('Writing file: $outFile');
  var ok = fs.w

  Uint8List outBytes = DcmEncoder.encode(instance);
  write

}