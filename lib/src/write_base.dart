// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.io.io_base;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

/// Synchronously writes a byte arrary [Uint8List] to [path].
void writeBytesSync(String path, Uint8List bytes) {
  File outfile = new File(path);
  outfile.writeAsBytesSync(bytes);
}

/// Asynchronously writes a byte arrary [Uint8List] to [path].
Future writeBytes(String path, Uint8List bytes) async {
  File infile = new File(path);
  await infile.writeAsBytes(bytes);
}

/// Synchronously writes a [String] to [path].
void writeStringSync(String path, Uint8List bytes) {
  File outfile = new File(path);
  outfile.writeAsBytesSync(bytes);
}

/// Asynchronously writes a [String] to [path].
Future writeString(String path, Uint8List bytes) async {
  File infile = new File(path);
  await infile.writeAsBytes(bytes);
}


