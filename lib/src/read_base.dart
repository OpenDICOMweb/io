// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.
library odw.sdk.io.read_base;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Synchronously reads a byte arrary [Uint8List] from [path] and returns it.
Uint8List readBytesSync(String path) {
  File infile = new File(path);
  return infile.readAsBytesSync();
}

/// Asynchronously reads a byte arrary [Uint8List] from [path] and returns it.
Future<Uint8List> readByes(String path) async {
  File infile = new File(path);
  return await infile.readAsBytes();
}

/// Synchronously reads a [String] from [path] and returns it.
Uint8List readStringSync(String path) {
  File infile = new File(path);
  return JSON.decode(infile.readAsStringSync());
}

/// Asynchronously reads a [String] from [path] and returns it.
Future<Uint8List> readString(String path) async {
  File infile = new File(path);
  return JSON.decode(await infile.readAsString());
}
