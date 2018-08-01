// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:io_extended/io_extended.dart';
import 'package:io_extended/src/tools/compare_files.dart';

String inputDir = 'C:/acr/odw/sdk/io/example/input';
String inputDir2 = 'C:/acr/odw/test_data/sfd/CT';

String outputDir = 'C:/acr/odw/sdk/io/example/output';

class FileTestError {
  Filename inFile;
  Filename outFile;
  String read;
  String reRead;
  String dsCompare;
  FileCompareResult result;
  List<String> errors = [];

  FileTestError(this.inFile, this.outFile);

  void add(String s) => errors.add(s);

  @override
  String toString() => '''
File Text Error:
     in: $inFile
    out: $outFile
     ds: $dsCompare
  bytes: $result
  ''';
}
