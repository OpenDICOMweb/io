// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';

import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:core/dataset.dart';
import 'package:io/io.dart';
import "package:test/test.dart";

String inRoot0 = "C:/odw/test_data/sfd/CR";
String inRoot1 = "C:/odw/test_data/sfd/CR_and_RF";
String inRoot2 = "C:/odw/test_data/sfd/CT";
String inRoot3 = "C:/odw/test_data/sfd/MG";
String inRoot4 = "C:/odw/test_data/sfd/RTOG STUDY/RTOG STUDY/RTFiles-1";
String inRoot5 = "C:/odw/test_data/mweb/TransferUIDs";

String outRoot0 = 'test/output/root0';
String outRoot1 = 'test/output/root1';
String outRoot2 = 'test/output/root2';
String outRoot3 = 'test/output/root3';

void main() {
  // Get the files in the directory
  List<Filename> files = Filename.listFromDirectory(inRoot5);
  stdout.writeln('File count: ${files.length}');

      // Read, parse, and print a summary of each file.
      for (Filename file in files) {

        if (file.isDicom) {

          print('Reading file: $file');

          DSSource dsSource = new DSSource(file.readAsBytesSync(), file.path);

          DcmReader reader = new DcmReader(dsSource);

          RootDataset rds;

          group("Data set", () {
            test("Create a data set object from map", (){
              rds = reader.readRootDataset((dsSource.lengthInBytes / 64).round());

              print('File name ${file.base} with Transfer Syntax UID: ${rds[0x00020010].values[0]}');

              expect(() => rds[0x00020010], isNotNull);
              expect(() => rds[0x00020010].values, isNotNull);

              expect(() => rds[0x00143012], isNotNull);
              expect(() => rds[0x00143012].values, isNotNull);

              expect(() =>rds[0x00143073], isNotNull);
              expect(() => rds[0x00143073].values, isNotNull);
              expect(() => rds[0x00143073].values[0], isNotNull);

              expect(() => rds[0x00280008], isNotNull);
              expect(() => rds[0x00280008].values, isNotNull);

              if (rds[0x7FE00010] != null && rds[0x7FE00010].values != null) {
                print('         Pixel Data: ${rds[0x7FE00010].values[0]}');
              }

              if (rds[0x00280008] != null && rds[0x00280008].values != null) {
                print('          Number of Frames: ${rds[0x00280008]?.values[0]}');
              }

              if (rds[0x00143012] != null&&rds[0x00143012].values != null) {
                print('          Number of frames integrated: ${rds[0x00143012]?.values[0]}');
              }

              if (rds[0x00143073] != null&&rds[0x00143073].values != null) {
                print('Number of Frames Used for Integration: ${rds[0x00143073]?.values[0]}');
              }

            });

          });

        } else {
          print('Skipping ... $file');
        }
      }

}
