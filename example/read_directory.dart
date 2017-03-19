// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:io/io.dart';

String inRoot0 = "C:/odw/test_data/sfd/CR";
String inRoot1 = "C:/odw/test_data/sfd/CR_and_RF";
String inRoot2 = "C:/odw/test_data/sfd/CT";
String inRoot3 = "C:/odw/test_data/sfd/MG";

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

void main() {
  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inRoot0);
  stdout.writeln('File count: ${files.length}');

  // Read, parse, and print a summary of each file.
  for (Filename file in files) {
    if (file.isDicom) {
      print('Reading file: $file');
      Instance instance = file.readSync();
      print(instance.info);
    } else {
      print('Skipping ... $file');
    }
  }
}

Instance readDicomFile(file) {
  if (file is String) file = new File(file);
  if (file is Filename) file = file.file;
  if (file is! File) return null;
  Uint8List bytes = file.readAsBytesSync();
  return DcmDecoder.decode(new DSSource(bytes, file.path));
}
