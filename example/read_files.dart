// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

//import 'dart:convert';

import 'package:common/logger.dart';
import 'package:core/core.dart';
import 'package:dcm_convert/dcm.dart';
import 'package:io/io.dart';

//TODO: cleanup for V0.9.0


//TODO: cleanup documentation
/// A program that takes a path name and reads all the files with a
/// DICOM file extension and print's out some information about the
/// [Dataset] contained in the file.
void main(List<String> args) {
  final Logger log = new Logger('read_files.dart');
  //var results = parse(args);
  //var source = results['source'];
  var source = r"C:/odw/test_data/sfd/CT";
  List<Filename> files = Filename.listFromDirectory(source);

  for (Filename fn in files) {
    int count = 0;
    log.info('*** Starting($count): $fn');
    if (fn.isPart10) {
      RootTagDataset  rds = TagReader.readFile(fn.file);
      if (rds == null) {
        log.debug('  *** Skipping Invalid Transfer Syntax: $fn ');
      } else {
        log.debug(rds.info);
        count++;
      }
    } else if (fn.isJson) {
      //TODO: can't read JSON yet
/*      Uint8List s = fn.file.readAsBytesSync();
      Entity e = JsonDecoder.decode(s);
      log.debug(e.info);*/
    } else if (fn.isXml) {
      //TODO: can't read XML yet
/*      Uint8List s = fn.file.readAsBytesSync();
      Entity e = JsonDecoder.decode(s);
      log.debug(e.info);*/
    } else {
      log.debug('  *** Skipping none ".dcm" file: $fn');
    }
    log.info('*** Finished $fn\n');
  }
}



