// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.io.io_base;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';


Uint8List readSync(String path) {
  File infile = new File(path);
  return infile.readAsBytesSync();
}

Future<Uint8List> read(String path) async {
  File infile = new File(path);
  return await infile.readAsBytes();
}


void writeSync(String path, Uint8List bytes) {
  File outfile = new File(path);
  outfile.writeAsBytesSync(bytes);
}

Future write(String path, Uint8List bytes) async {
  File infile = new File(path);
  await infile.writeAsBytes(bytes);
}

