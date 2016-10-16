// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

//TODO: make async
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/base.dart';
import 'package:io/src/file_system.dart';
import 'package:io/src/fs_entity.dart';
import 'package:io/src/utils/utils.dart';

/// A [FSFile] is a [File], in a [FileSystem].
class FSFile extends FSEntity {
  final Uid instance;
  final File file;

  /// Create a [SopFileSystem] [Entity].
  FSFile(FileSystem fs, Uid study, Uid series, Uid instance)
      : instance = instance,
        file = new File(toPath(fs, study, series, instance)),
        super(fs);

  /// Returns the [path] to the study.
  String get path => file.path;

  /// Returns [true] if the [Entity] is a [Directory].
  bool get isDirectory => false;

  Future<Uint8List> readBytes(File file) => file.readAsBytes();

  Uint8List readBytesSync(File file) => file.readAsBytesSync();

}
