// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/dicom.dart';
import 'package:io/io.dart';


String inRoot0 = "C:/odw/test_data/sfd/CR";
String inRoot1 = "C:/odw/test_data/sfd/CR_and_RF";
String inRoot2 = "C:/odw/test_data/sfd/CT";
String inRoot3 = "C:/odw/test_data/sfd/MG";

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';


void main() {
  Logger log = new Logger("read_a_directory");

  Directory dir = new Directory(inRoot1);

  List<Filename> files = Filename.getFilesFromDirectory(inRoot0);
  log.info('File count: ${files.length}');
  for (Filename fn in files)
    log.info('File: $fn');

  List<Instance> instances;
  for (Filename file in files) {
    print('\nReading file: $file');
    Instance instance = readDicomFile(file);
    instances.add(instance);
    print(instance.info);
  }
  print('Active Patients: ${activeStudies}');

}

Instance readDicomFile(file) {
  if (file is String) file = new File(file);
  if (file is Filename) file = file.file;
  if (file is! File) return null;
  Uint8List bytes = file.readAsBytesSync();
  return DcmDecoder.decode(bytes);
}
