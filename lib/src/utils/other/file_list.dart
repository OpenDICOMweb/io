// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'dart:typed_data';

import 'package:io/src/mint/mint_fs.dart';

class FileList {
  final List files;

  FileList([int length]) : files = (length == null) ? [] : new List(length);

  void add(FileSystem fs, String path, Uint8List bytes) {
    files.add(['${fs.root}/$path', bytes]);
  }

  apply(Function func) {
    for(List l in files) {
      write
    }
  }
}