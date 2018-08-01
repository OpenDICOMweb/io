// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/server.dart';
import 'package:converter/converter.dart';

String inRoot0 = 'C:/acr/odw/test_data/sfd/CR';
String inRoot1 = 'C:/acr/odw/test_data/sfd/CR_and_RF';
String inRoot2 = 'C:/acr/odw/test_data/sfd/CT';
String inRoot3 = 'C:/acr/odw/test_data/sfd/MG';

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

void main() {
  Server.initialize(name: 'readFile_test.dart', level: Level.info0);

  final dir = new Directory(inRoot1);

  final fList = dir.listSync();
  log.info0('File count: ${fList.length}');
  for (File f in fList) log.info0('File: $f');

  TagRootDataset rds;
  for (File file in fList) {
    print('\nReading file: $file');
    final bytes = file.readAsBytesSync();
    rds = TagReader(bytes).readRootDataset();
  }
  print(rds.summary);
  print('Active Patients: $activeStudies');
}

