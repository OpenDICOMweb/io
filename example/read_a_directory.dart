// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:convert/dicom.dart';
import 'package:core/dicom.dart';
import 'package:logger/logger.dart';

String inputDir0 = "C:/odw/test_data/sfd/CR_and_RF/Patient_25_UGI_and_SBFT/1_DICOM_Original/";
String inputDir1 = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String inputDir2 =
    "C:/odw/test_data/sfd/CR_and_RF/Patient_27_enema_-_ilioanal_anastomosis/1_DICOM_Original/";

String outputDir = "C:/odw/sdk/io/example/output";


void main() {
  Logger log = new Logger("read_a_directory", Level.debug);

  Directory dir = new Directory(inputDir0);

  List<FileSystemEntity> fList = dir.listSync();
  log.info('File count: ${fList.length}');
  for (File f in fList)
    log.info('File: $f');

  for (File file in fList) {
    print('Reading file: $file');
    Instance instance = readSopInstance(file);
   // print('output:\n${instance.patient.format(new Prefixer())}');
  }

  print('Active Patients: ${activePatients.stats}');

}

Instance readSopInstance(File f) {
  var bytes = f.readAsBytesSync();
  print('LengthInBytes: ${bytes.length}');
  DcmDecoder decoder = new DcmDecoder(bytes);
  return decoder.readSopInstance(f.path);
}
