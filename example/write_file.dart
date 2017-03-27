// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.

// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:common/format.dart';
import 'package:convertX/convert.dart';
import 'package:core/core.dart';
import 'package:io/io.dart';

String inPath = 'C:/odw/test_data/IM-0001-0001.dcm';
String outPath = 'C:/odw/sdk/io/example/output/IM-0001-0001.dcm';

void main() {

  // Read a File
  Filename fnIn = new Filename(inPath);
  Uint8List bytes = fnIn.file.readAsBytesSync();
  Instance instance = DcmDecoder.decode(new DSSource(bytes, inPath));
  print(instance.format(new Formatter(maxDepth: -1)));

  // Write a File
  Filename fnOut = new Filename.withType(outPath, FileSubtype.part10);
  fnOut.writeSync(instance);

}