// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the   AUTHORS file for other contributors.

//import 'package:convert/data/test_files.dart';
import 'package:converter/converter.dart';
import 'package:core/server.dart';

const String pathX = 'C:/acr/odw/test_data/mweb/100 MB Studies/1/S234601/15859205';
// Problem Files
//   1. fileList2
void main() {
  Server.initialize(name: 'read_write_file', level: Level.debug3);

  // *** Modify the [path0] value to read/write a different file
  final path = pathX;

  byteReadWriteFileChecked(path, fileNumber: 1, width: 5, fast: true);
}
