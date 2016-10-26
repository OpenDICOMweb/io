// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/core.dart';
import 'package:encode/dicom.dart';
import 'package:logger/logger.dart';

String inRoot0 = "C:/odw/test_data/sfd/CR";
String inRoot1 = "C:/odw/test_data/sfd/CR_and_RF";
String inRoot2 = "C:/odw/test_data/sfd/CT";
String inRoot3 = "C:/odw/test_data/sfd/MG";

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';


void main() {
  Logger log = new Logger("read_a_directory", Level.debug);

  Directory dir = new Directory(inRoot1);

  List<FileSystemEntity> fList = dir.listSync();
  log.info('File count: ${fList.length}');
  for (File f in fList)
    log.info('File: $f');

  Instance instance;
  for (File file in fList) {
    print('\nReading file: $file');
    instance = readSopInstance(file);
   // print('output:\n${instance.patient.format(new Prefixer())}');
  }
  print(instance.study.summary);
  print('Active Patients: ${activeStudies}');

}

Instance readSopInstance(File f) {
  var bytes = f.readAsBytesSync();
 // print('LengthInBytes: ${bytes.length}');
  DcmDecoder decoder = new DcmDecoder(bytes);
  return decoder.readSopInstance(f.path);
}
