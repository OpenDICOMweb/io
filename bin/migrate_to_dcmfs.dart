// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

//import 'dart:convert';

import 'dart:typed_data';

import 'package:common/format.dart';
import 'package:core/core.dart';
import 'package:dcm_convert/dcm.dart';
import 'package:io/io.dart';

//TODO: cleanup for V0.9.0

/// This program copies DICOM PS3.10 files (i.e. files with an extension of ".dcm") from anywhere
/// in a source directory to a ODW SOP File System rooted at the destination directory.

String inRoot = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String outRoot = "C:/odw/sdk/io/bin/output";

//TODO: cleanup and move to examples
/// A program that takes a Directory containing '.dcm' files
/// in its tree, reads them and then stores them in the appropriate
/// place in the DICOM [FileSystem].
//TODO: make this work with arguments. Uncomment the source and target arguments
void main(List<String> args) {
  //var results = parse(args);
  //var source = results['source'];
  var source = r"C:/odw/test_data/sfd/CR_and_RF";
  List<Filename> files = Filename.listFromDirectory(source);
  print('source: $source');
  //var target = results['target'];
  var target = "C:/odw/sdk/io/example/output";
  var fs = new FileSystem(target);

  print('files: $files');

  for (Filename fn in files) {
    if (fn.isPart10) {
      Uint8List bytes = fn.file.readAsBytesSync();
      //print('Filename: $fn');

      RootByteDataset rds = ByteReader.readFile(fn.file);
      print('Entity: ${rds.format(new Formatter())}');

      DcmFile dcmFile = fs.dcmFile(FileType.part10Instance, rds.entity);
      print(dcmFile.path);
      dcmFile.writeSync(bytes);

      // print(activeStudies.summary);
    } else if (fn.isJson) {
//      Uint8List s = fn.file.readAsBytesSync();
//      Entity e = JsonDecoder.decode(s);
//      print('Entity: ${e.format(new Formatter())}');
    } else {
      print('Skipping none ".dcm" file: $fn');
    }
  }
  //print('Active Studies: ${activeStudies.stats}');
  //print('Summary:\n ${activeStudies.summary}');
}
