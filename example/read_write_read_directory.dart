// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/encoder.dart';
import 'package:io/io.dart';

String inPath = 'C:/odw/sdk/io/example/input/IM-0001-0001.dcm';
String outPath = 'C:/odw/sdk/io/example/output/IM-0001-0001.dcm';


String inRoot0 = "C:/odw/test_data/sfd/CR";
String inRoot1 = "C:/odw/test_data/sfd/CR_and_RF";
String inRoot2 = "C:/odw/test_data/sfd/CT";
String inRoot3 = "C:/odw/test_data/sfd/MG";

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

String inputDir = 'C:/odw/sdk/io/example/input';
String outputDir = 'C:/odw/sdk/io/example/output';

void main(List<String> args) {
  // Get the files in the directory
  List<Filename> files = Filename.getFilesFromDirectory(inputDir);
  stdout.writeln('File count: ${files.length}');


  // Read, parse, and print a summary of each file.
  for (var i = 0; i < files.length; i++) {
    var fn = files[i];
    if (fn.isDicom) {
      print('Reading file $i: $fn');

      Uint8List bytes = fn.file.readAsBytesSync();
      print('read ${bytes.length} bytes');
      Instance instance = DcmDecoder.decode(new DSSource(bytes, fn.path));
      print(instance.info);
      //print(instance.format(new Formatter(maxDepth: -1)));

      // Write a File
      var outPath = '$outputDir/${fn.base}';
      print('writing file $i: $outPath');
      Filename fnOut = new Filename.withType(outPath, FileSubtype.part10);
      fnOut.writeSync(instance);
      ActiveStudies.removeStudyIfPresent(instance.study.uid);

      // Now read the file we just wrote.
      Filename result = new Filename(outPath);

      print('Re-reading file $i: $result');
      bytes = result.file.readAsBytesSync();
      instance = DcmDecoder.decode(new DSSource(bytes, fn.path));
      print(instance.info);
      //print(instance.format(new Formatter(maxDepth: -1)));
    } else {
      print('Skipping ... $fn');
    }
  }
}



