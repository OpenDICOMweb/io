// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:core/core.dart';
import 'package:encode/dicom.dart';
import 'package:io/io.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

/// This program copies DICOM PS3.10 files (i.e. files with an extension of ".dcm") from anywhere
/// in a source directory to a ODW SOP File System rooted at the destination directory.

String inRoot = "C:/odw/test_data/sfd/CR/PID_MINT10/1_DICOM_Original/";
String outRoot = "C:/odw/sdk/io/example/output";

String file1 = "CR.2.16.840.1.114255.393386351.1568457295.17895.5.dcm";
String file2 = "CR.2.16.840.1.114255.393386351.1568457295.48879.7.dcm";

List<String> filesList = [file1, file2];

void main(List<String> args) {
  Logger log = Logger.init(level: Level.fine);
  var parser = getArgParser();
  var results = parser.parse(args);
  //var source = results['source'];
  var source = r"C:\odw\test_data\sfd\CR_and_RF";
  var inDir = new Directory(source);

  var target = results['target'];
  var fs = new FileSystem(target);
  List<FileSystemEntity> files = inDir.listSync(recursive: true, followLinks: false);
  // print('files: $files');

  for (var fse in files) {
    if (fse is File) {
    //  print('f: $fse');
    //  print('target: ${FileType.instance.extension}');
    //  print('actual: "${path.extension(fse.path)}"');
      if (path.extension(fse.path) == FileSubtype.instance.extension) {
        log.config('Reading file: $fse');
        Instance instance = fs.readInstanceSync(fse);
        var output = instance.format(new Formatter(maxDepth: 3));
        print('***patient:\n${output}');
      } else {
        print('Skipping none ".dcm" file: $fse');
      }
    }
    // Write the instance
    //writeSopInstance(instance, '$outRoot/${instance.uid}.out');
  }

  //print('Active Studies: ${activeStudies.stats}');
  //print('Summary:\n ${activeStudies.summary}');
}

Instance readSopInstance(file) {
  if (file is String) file = new File(file);
  if (file is! File) throw new ArgumentError('file ($file) must be a String or File.');
  Uint8List bytes = file.readAsBytesSync();
  DcmDecoder decoder = new DcmDecoder(bytes);
  return decoder.readSopInstance(file.path);
}

Instance writeSopInstance(Instance instance, file) {
  if (file is String) file = new File(file);
  if (file is! File) throw new ArgumentError('file ($file) must be a String or File.');
  DcmEncoder encoder = new DcmEncoder(instance.dataset.lengthInBytes);
  encoder.writeSopInstance(instance);
  Uint8List bytes = file.readAsBytesSync();
  DcmDecoder decoder = new DcmDecoder(bytes);
  return decoder.readSopInstance(file.path);
}
ArgParser getArgParser() {
  var parser = new ArgParser()
    ..addOption('source', abbr: 's', defaultsTo: '.', help: 'Specifies the source directory.')
    ..addOption('target',
                    abbr: 't',
                    defaultsTo: '.',
                    help: 'Specifies the root directory of the target SOP File System.')
    ..addFlag('validate',
                  abbr: 'v',
                  defaultsTo: true,
                  help: 'Specifies whether the source files should be cheched that '
                      'they contain valid DICOM as they are copied');

  return parser;
}

