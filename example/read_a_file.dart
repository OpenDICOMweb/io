// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

//import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';

//TODO: cleanup for V0.9.0

/// This program copies DICOM PS3.10 files (i.e. files with an extension of ".dcm") from anywhere
/// in a source directory to a ODW SOP File System rooted at the destination directory.

String inRoot = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String outRoot = "C:/odw/sdk/io/example/output";

String file1 = "CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm";
String file2 = "CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm";

List<String> filesList = [file1, file2];

//TODO move to utilities
List<Filename> getDcmFilesFromDirectory(String source) {
  var dir = new Directory(source);
  List<FileSystemEntity> entities = dir.listSync(recursive: true, followLinks: false);
  List<Filename> filenames = [];
  for(FileSystemEntity f in entities) {
    filenames.add(new Filename(f.path));
  }
  print('Filenames(${filenames.length}): $filenames');
  return filenames;
}

//TODO: cleanup and move to examples
/// A program that takes a random file name and depending on the file extension returns a
/// [Uint8List] or a [String] depending on the extension.
void main(List<String> args) {
  var results = parse(args);
  //var source = results['source'];
  var source = r"C:/odw/test_data/sfd/CR_and_RF";
  List<Filename> files = getDcmFilesFromDirectory(source);
  print(source);
  //var target = results['target'];
  //var target = "C:/odw/sdk/io/example/output";
  //var fs = new FileSystem(target);

  // print('files: $files');

  for (Filename fn in files) {
    if (fn.isPart10) {
      Uint8List bytes = fn.file.readAsBytesSync();
      print('Filename: $fn');
      Entity e = DcmDecoder.decode(bytes);
      print('Entity: ${e.format(new Formatter())}');
      print(activeStudies.summary);
    } else if (fn.isJson) {
      String s = fn.file.readAsStringSync();
      Entity e = JsonDecoder.decode(s);
      print('Entity: ${e.format(new Formatter())}');
    } else {
      print('Skipping none ".dcm" file: $fn');
    }
  }
  //print('Active Studies: ${activeStudies.stats}');
  //print('Summary:\n ${activeStudies.summary}');
}

ArgResults parse(List<String> args) {
  var parser = getArgParser();
  return parser.parse(args);
}

ArgParser getArgParser() {
  var parser = new ArgParser()
    ..addOption('source',
                    abbr: 's',
                    defaultsTo: 'input',
                    help: 'Specifies the source directory.')
    ..addOption('target',
                    abbr: 't',
                    defaultsTo: 'output',
                    help: 'Specifies the root directory of the target SOP File System.')
    ..addFlag('validate',
                  abbr: 'v',
                  defaultsTo: true,
                  help: 'Specifies whether the source files should be cheched that '
                      'they contain valid DICOM as they are copied');

  return parser;
}

