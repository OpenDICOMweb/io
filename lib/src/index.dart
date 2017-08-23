// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:io';

import 'package:io/src/file_system_base.dart';
import 'package:io/src/file_type.dart';
import 'package:uid/uid.dart';

/// An interface for an [Index] of a [FileSystem].
class FSIndex {
  FileSystemBase fs;
  List<String> _list;
  final String path;
  final Directory root;

  FSIndex(String path)
      : path = path,
        root = FileSystemBase.maybeCreateRootSync(path),
        super();

  /// Asynchronously retrieves and returns a stored [Index].
//  Future<List<String>> load() {}

  /// Synchronously retrieves and returns a stored [Index].
//  List<String> loadSync() {}

  /// Asynchronously stores an [Index].
//  Future<Null> store() {}

  /// Synchronously stores an [Index].
  void storeSync() {}

  /// Returns an [Index] encoded as a JSON string.
  String toJson() => JSON.encode(_list);

  /// Returns a formatted [String] containing the [Index].
  //TODO: fix or flush
  //String format([int indent = 2, int level = 0]);

  /// Return a path to a file in the [FileSystem].
  //TODO: verify this is correct.  If it is move to index.dart
  String toPath(FileSubtype fType, Uid study,
      [Uid series, Uid instance, String extension]) {
    String part4 = (instance == null) ? "" : '/$instance${fType.extension}';
    String part3 = (series == null) ? "" : '/$series';
    return '$path/$study$part3$part4';
  }

  @override
  String toString() => 'FS Index ($runtimeType) rooted at ${fs.root}';
}
