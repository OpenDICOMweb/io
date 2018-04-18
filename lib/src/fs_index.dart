// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';

import 'package:io/src/file_system_base.dart';
import 'package:io/src/file_type.dart';

/// An interface for an Index of a FileSystem.
abstract class FSIndexBase {
  FileSystemBase fs;
  String get path;
  Directory get root;

  /// Asynchronously retrieves and returns a stored [FSIndex].
//  Future<List<String>> load() {}

  /// Synchronously retrieves and returns a stored [FSIndex].
//  List<String> loadSync() {}

  /// Asynchronously stores an [FSIndex].
//  Future<Null> store() {}

  /// Synchronously stores an [FSIndex].
  void storeSync() {}

  /// Returns an [FSIndex] encoded as a JSON string.
  String toJson();

  /// Return a path to a file in the FileSystem.
  String toPath(FileSubtype fType, Uid study,
      [Uid series, Uid instance, String extension]);

  @override
  String toString() => 'FS Index ($runtimeType) rooted at ${fs.root}';
}

/// An interface for an Index of a FileSystem.
class FSIndex implements FSIndexBase {
  @override
  FileSystemBase fs;
  List<String> _list;
  @override
  final String path;
  @override
  final Directory root;

  FSIndex(this.path)
      : root = FileSystemBase.maybeCreateRootSync(path),
        super();

  /// Asynchronously retrieves and returns a stored [FSIndex].
//  Future<List<String>> load() {}

  /// Synchronously retrieves and returns a stored [FSIndex].
//  List<String> loadSync() {}

  /// Asynchronously stores an [FSIndex].
//  Future<Null> store() {}

  /// Synchronously stores an [FSIndex].
  @override
  void storeSync() {}

  /// Returns an [FSIndex] encoded as a JSON string.
  @override
  String toJson() => json.encode(_list);

  @override

  /// Return a path to a file in the FileSystem.
  //TODO: verify this is correct.  If it is move to index.dart
  String toPath(FileSubtype fType, Uid study,
      [Uid series, Uid instance, String extension]) {
    final part4 = (instance == null) ? '' : '/$instance${fType.extension}';
    final part3 = (series == null) ? '' : '/$series';
    return '$path/$study$part3$part4';
  }

  @override
  String toString() => 'FS Index ($runtimeType) rooted at ${fs.root}';
}
