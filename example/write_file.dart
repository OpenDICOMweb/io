// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'package:core/server.dart';
import 'package:converter/converter.dart';
import 'package:io_extended/io_extended.dart';

String inPath = 'C:/acr/odw/test_data/IM-0001-0001.dcm';
String outPath = 'C:/acr/odw/sdk/io/example/output/IM-0001-0001.dcm';

void main() {
  // Read a File
  final fnIn = Filename(inPath);

  final bytes = fnIn.file.readAsBytesSync();
  final TagRootDataset rds = TagReader(bytes).readRootDataset();
  print(rds.format(Formatter(maxDepth: -1)));

  // Write a File
  Filename.withType(outPath, FileSubtype.part10).writeSync(rds);
}
