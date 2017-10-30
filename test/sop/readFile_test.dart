// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:io/io.dart';
import 'package:logger/logger.dart';
import 'package:system/server.dart';
import "package:test/test.dart";

String inRoot0 = 'C:/odw/test_data/sfd/CR';
String inRoot1 = 'C:/odw/test_data/sfd/CR_and_RF';
String inRoot2 = 'C:/odw/test_data/sfd/CT';
String inRoot3 = 'C:/odw/test_data/sfd/MG';
String inRoot4 = 'E:/dicom';
String file5 = 'E:/dicom/2000+/anmyzd_toshIM-0001-0002.dcm';

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

void main() {
  Server.initialize(name: 'sop/readFile_test', level: Level.info0);

  // Get the files in the directory
  final files = new Filename(file5);
  final file1 = new Filename.fromFile(new File(
      'E:/dicom/1.2.840.113619.2.5.1762583153.215519.978957063.89.dcm'));

  group('Data set', () {
    test('Create a data set object from map', () {
      // Read, parse, and print a summary of each file.
      //TODO: make print out neat:
      log.debug('${files.path} '
          '\n ${files.typeExt}'
          '\n ${files.objectType}'
          '\n ${files.path}'
          '\n ${files.rootPrefix}'
          '\n ${files.dir}'
          '\n ${files.base}'
          '\n ${files.name}'
          '\n ${files.mediaType}'
          '\n ${files.units}');

      log.debug('${file1.path}');
      log.debug(file1.typeExt);
      log.debug(file1.objectType);
      log.debug(file1.path);
      log.debug(file1.rootPrefix);
      log.debug(file1.dir);
      log.debug(file1.base);
      log.debug(file1.name);
      log.debug(file1.mediaType);
      log.debug(file1.units);
    });
  });
}
