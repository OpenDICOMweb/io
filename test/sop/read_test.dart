// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:encode/dicom.dart';
import 'package:io/io.dart';

import "package:test/test.dart";

String inRoot0 = "C:/odw/test_data/sfd/CR";
String inRoot1 = "C:/odw/test_data/sfd/CR_and_RF";
String inRoot2 = "C:/odw/test_data/sfd/CT";
String inRoot3 = "C:/odw/test_data/sfd/MG";
String inRoot4 = "C:/odw/test_data/sfd/RTOG STUDY/RTOG STUDY/Valid_RT_Datasets/Dicom";

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

void main() {
  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inRoot4);
  stdout.writeln('File count: ${files.length}');

  group("Data set", () {
    test("Create a data set object from map",(){

      // Read, parse, and print a summary of each file.
      for (Filename file in files) {
        if (file.isDicom) {
          print('Reading file: $file');
          Instance  instance = file.readSync();
          print(instance.info);
        } else {
          print('Skipping ... $file');
        }
      }

    });

  });

}

//Instance readDicomFile(file) {
//    if (file is String) file = new File(file);
//    if (file is Filename) file = file.file;
//    if (file is! File) return null;
//    Uint8List bytes = file.readAsBytesSync();
//    return DcmDecoder.decode(new DSSource(bytes, file.path));
//}
