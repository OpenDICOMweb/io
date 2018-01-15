// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

//import 'dart:convert';

import 'package:core/server.dart';
import 'package:convert/convert.dart';
import 'package:io/io.dart';

//TODO: cleanup for V0.9.0

/// A program that takes a path name and reads all the files with a
/// DICOM file extension and print's out some information about the
/// [Dataset] contained in the file.
void main(List<String> args) {
  Server.initialize(name: 'readFile_test.dart', level: Level.info0);
  final source = r'C:/acr/odw/test_data/sfd/CT';
  final files = Filename.listFromDirectory(source);

  for (var fn in files) {
    var count = 0;
    log.info0('*** Starting($count): $fn');
    if (fn.isPart10) {
      final  rds = TagReader.readFile(fn.file);
      if (rds == null) {
        log.debug('  *** Skipping Invalid Transfer Syntax: $fn ');
      } else {
        log.debug(rds.info);
        count++;
      }
    } else if (fn.isJson) {
      //TODO: can't read JSON yet
    } else if (fn.isXml) {
      //TODO: can't read XML yet
    } else {
      log.debug('  *** Skipping none ".dcm" file: $fn');
    }
    log.info0('*** Finished $fn\n');
  }
}



