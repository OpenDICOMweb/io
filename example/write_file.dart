// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:core/server.dart';
import 'package:convert/convert.dart';
import 'package:io/io.dart';

String inPath = 'C:/acr/odw/test_data/IM-0001-0001.dcm';
String outPath = 'C:/acr/odw/sdk/io/example/output/IM-0001-0001.dcm';

void main() {
  // Read a File
  final fnIn = new Filename(inPath);

  final rds = TagReader.readFile(fnIn.file);
  print(rds.format(new Formatter(maxDepth: -1)));

  // Write a File
  new Filename.withType(outPath, FileSubtype.part10)..writeSync(rds);
}
