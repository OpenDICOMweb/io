// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:core/server.dart';
import 'package:convert/convert.dart';

import 'package:io/src/filename.dart';

String inRoot0 = 'C:/odw_test_data/sfd/CR';
String inRoot1 = 'C:/odw_test_data/sfd/CR_and_RF';
String inRoot2 = 'C:/odw_test_data/sfd/CT';
String inRoot3 = 'C:/odw_test_data/sfd/MG';

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';


void main() {
  Server.initialize(name: 'readFile_test.dart', level: Level.info0);

  // Get the files in the directory
  final files = Filename.listFromDirectory(inRoot0);
  log.info0('File count: ${files.length}');

  // Read, parse, and print a summary of each file.
  for (var file in files) {
    if (file.isDicom) {
      print('Reading file: $file');
      final rds = file.readSync();
      log.info0(rds.info);
    } else {
      print('Skipping ... $file');
    }
  }
}

/// Returns a [TagDataset] read from the [File] associated with [fileId]
TagDataset readDicomFile(Object fileId) {
  File file;
  if (fileId is String) file = new File(fileId);
  if (fileId is Filename) file = fileId.file;
  if (file is! File) return null;
  return TagReader.readFile(file);
}
