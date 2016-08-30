// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the   AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:convert/dicom.dart';
import 'package:core/dicom.dart';
import 'package:logger/logger.dart';


String inputDir = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String outputDir = "C:/odw/sdk/io/example/output";

String file1 = inputDir + "CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm";
String file2 = inputDir + "CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm";

List<String> filesList = [file1, file2];

void main() {
  Logger log = Logger.init(level: Level.fine);

  for (String path in filesList) {
    print('Reading file: $path');
    log.config('Reading file: $path');

    Instance instance = readSopInstance(file1);
    print('***patient:\n${instance.patient.format(new Prefixer(depth:5))}');
  }

  print('Active Patients: ${activePatients.stats}');
}

Instance readSopInstance(String path) {
  var file = new File(path);
  Uint8List bytes = file.readAsBytesSync();
  DcmDecoder decoder = new DcmDecoder(bytes);
  return decoder.readSopInstance(file.path);
}
