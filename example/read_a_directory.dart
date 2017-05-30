// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:common/logger.dart';
import 'package:convertX/convert.dart';
import 'package:core/core.dart';

String inRoot0 = "C:/odw/test_data/sfd/CR";
String inRoot1 = "C:/odw/test_data/sfd/CR_and_RF";
String inRoot2 = "C:/odw/test_data/sfd/CT";
String inRoot3 = "C:/odw/test_data/sfd/MG";
String inRoot4 = "C:/odw/test_data/sfd";

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';
String outRoot4 = 'test/output/root4';


void main() {
  Logger log = new Logger("read_a_directory");

  Directory dir = new Directory(inRoot1);

  List<FileSystemEntity> fList = dir.listSync();
  log.info('File count: ${fList.length}');

  List<File> files = <File>[];
  for (FileSystemEntity fse in fList) {
    if (fse is File) {
      log.info('File: $fse');
      files.add(fse);
    }
  }
  log.info('Reading ${files.length} files:');

  Instance instance;
  for (File file in files) {
    log.info('\nReading file: $file');
    instance = readInstance(file);
   // print('output:\n${instance.patient.format(new Prefixer())}');
  }
  log.info(instance.study.summary);
  log.info('Active Patients: $activeStudies');

}

Instance readInstance(File f) {
  var bytes = f.readAsBytesSync();
 // print('LengthInBytes: ${bytes.length}');
  DcmDecoder decoder = new DcmDecoder(new DSSource(bytes, f.path));
  return decoder.readInstance();
}
