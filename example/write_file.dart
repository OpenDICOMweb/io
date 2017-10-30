// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'package:dcm_convert/byte_convert.dart';
import 'package:io/io.dart';
import 'package:logger/logger.dart';

String inPath = 'C:/odw/test_data/IM-0001-0001.dcm';
String outPath = 'C:/odw/sdk/io/example/output/IM-0001-0001.dcm';

void main() {
  // Read a File
  Filename fnIn = new Filename(inPath);

  RootDataset rds = TagReader.readFile(fnIn.file);
  print(rds.format(new Formatter(maxDepth: -1)));

  // Write a File
  Filename fnOut = new Filename.withType(outPath, FileSubtype.part10);
  fnOut.writeSync(rds);
}
