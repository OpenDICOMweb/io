// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/server.dart' hide group;
import 'package:io_extended/io_extended.dart';
import 'package:test/test.dart';

String inRoot0 = 'C:/odw_test_data/sfd/CR';
String inRoot1 = 'C:/odw_test_data/sfd/CR_and_RF';
String inRoot2 = 'C:/odw_test_data/sfd/CT';
String inRoot3 = 'C:/odw_test_data/sfd/MG';
String inRoot4 = 'E:/dicom';
String file5 = 'E:/dicom/2000+/anmyzd_toshIM-0001-0002.dcm';

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

void main() {
  Server.initialize(name: 'sop/readFile_test', level: Level.info0);

  // Get the files in the directory
  final files = Filename(file5);
  final file1 = Filename.fromFile(
      File('E:/dicom/1.2.840.113619.2.5.1762583153.215519.978957063.89.dcm'));

  group('Data set', () {
    test('Create a data set object from map', () {
      // Read, parse, and print a summary of each file.
      //TODO: make print out neat:
      log
        ..debug(files.path)
        ..debug(files.typeExt)
        ..debug(files.objectType)
        ..debug(files.path)
        ..debug(files.rootPrefix)
        ..debug(files.dir)
        ..debug(files.base)
        ..debug(files.name)
        ..debug(files.mediaType)
        ..debug(files.units)
        ..debug(file1.path)
        ..debug(file1.typeExt)
        ..debug(file1.objectType)
        ..debug(file1.path)
        ..debug(file1.rootPrefix)
        ..debug(file1.dir)
        ..debug(file1.base)
        ..debug(file1.name)
        ..debug(file1.mediaType)
        ..debug(file1.units);
    });
  });
}
