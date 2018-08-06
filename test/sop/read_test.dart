// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/server.dart' hide group;
import 'package:converter/converter.dart';
import 'package:test/test.dart';

String inRoot0 = 'C:/odw_test_data/sfd/CR';
String inRoot1 = 'C:/odw_test_data/sfd/CR_and_RF';
String inRoot2 = 'C:/odw_test_data/sfd/CT';
String inRoot3 = 'C:/odw_test_data/sfd/MG';
String inRoot4 = 'C:/odw_test_data/sfd/RTOG STUDY/RTOG STUDY/RTFiles-1';
String inRoot5 = 'C:/odw_test_data/mweb/TransferUIDs';

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

void main() {
  Server.initialize(name: 'read_test.dart', level: Level.info0);

  // Get the files in the directory
  final files = getFilesFromDirectory(inRoot5, '.dcm');
  stdout.writeln('File count: ${files.length}');

  group('Data set', () {
    test('Create a data set object from map', () {
      // Read, parse, and print a summary of each file.
      for (var file in files) {
        if (file.path != 'ct.0.dcm') {
          print('Reading file: $file');
          final bytes = file.readAsBytesSync();
          final rds = TagReader(bytes).readRootDataset();
          print(rds.info);
        } else {
          print('Skipping ... $file');
        }
      }
    });
  });
}
