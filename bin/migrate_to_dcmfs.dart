// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

//import 'dart:convert';
//
import 'package:core/server.dart';
import 'package:converter/converter.dart';
import 'package:io_extended/io_extended.dart';


/// This program copies DICOM PS3.10 files (i.e. files with
/// an extension of '.dcm') from anywhere in a source directory
/// to a ODW SOP File System rooted at the destination directory.

String inRoot = 'C:/acr/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/';
String outRoot = 'C:/acr/odw/sdk/io/bin/output';

//TODO: cleanup and move to examples
/// A program that takes a Directory containing '.dcm' files
/// in its tree, reads them and then stores them in the appropriate
/// place in the DICOM [FileSystem].
//TODO: make this work with arguments. Uncomment the source and target arguments
void main() {
  Server.initialize(name: 'read_write_file.dart', level: Level.info0);

  //var results = parse(args);
  //var source = results['source'];
  const source = r'C:/acr/odw/test_data/sfd/CR_and_RF';
  final files = Filename.listFromDirectory(source);
  print('source: $source');
  //var target = results['target'];
  const target = 'C:/acr/odw/sdk/io/example/output';
  final fs = FileSystem(target);

  print('files: $files');

  for (final fn in files) {
    if (fn.isPart10) {
      final bytes = fn.file.readAsBytesSync();
      final rds = TagReader(bytes).readRootDataset();
      print('Entity: ${rds.format(Formatter())}');

      final entity = activeStudies.entityFromRootDataset(rds);

      final dcmFile = fs.file(entity, FileType.part10Instance);
      print(dcmFile.path);
      dcmFile.writeSync(bytes);

      // print(activeStudies.summary);
    } else if (fn.isJson) {
//      Uint8List s = fn.file.readAsBytesSync();
//      Entity e = JsonDecoder.decode(s);
//      print('Entity: ${e.format(Formatter())}');
    } else {
      print('Skipping none ".dcm" file: $fn');
    }
  }
  //print('Active Studies: ${activeStudies.stats}');
  //print('Summary:\n ${activeStudies.summary}');
}
