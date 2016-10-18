// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:convert';

import 'file_system_base.dart';

/// An interface for an [Index] of a [FileSystem].
abstract class FSIndexBase {
  FileSystemBase fs;
  List<String> _list;

  String get path;

  /// Asynchronously retrieves and returns a stored [Index].
  Future<List<String>> load();

  /// Synchronously retrieves and returns a stored [Index].
  List<String> loadSync();

  /// Asynchronously stores an [Index].
  Future<Null> store();

  /// Synchronously stores an [Index].
  void storeSync();

  /// Returns an [Index] encoded as a JSON string.
  String toJson() => JSON.encode(_list);

  /// Returns a formatted [String] containing the [Index].
  //TODO: fix or flush
  //String format([int indent = 2, int level = 0]);

  @override
  String toString() => 'FS Index ($runtimeType) rooted at ${fs.root}';
}

