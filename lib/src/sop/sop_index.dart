// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

import 'dart:async';

import 'package:io/src/base/index_base.dart';

import 'sop_file_system.dart';

class SopIndex extends FSIndexBase {
  SopFileSystem fs;

  //TODO: implement

  SopIndex(this.fs);

  String get path => fs.path;

  /// Asynchronously retrieves and returns a stored [Index].
  Future<List<String>> load() {}

  /// Synchronously retrieves and returns a stored [Index].
  List<String> loadSync() {}

  /// Asynchronously stores an [Index].
  Future<Null> store() {}

  /// Synchronously stores an [Index].
  void storeSync() {}
}