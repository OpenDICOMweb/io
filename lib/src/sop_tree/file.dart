// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

//TODO: make async
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/base.dart';
import 'package:io/src/sop_tree/fs.dart';
import 'package:io/src/sop_tree/entity.dart';


/// A [SopEntity] is a [Directory], [File], or [link] in a [SopFileSystem].
///
class SopFile extends SopEntity {
  final Directory directory;
  final Uid instance;
  final Uint8List bytes;

  /// Create a [SopFileSystem] [Entity].
  SopFile(SopFileSystem fs, this.directory, this.instance, this.bytes) : super(fs);

  ////
  String get path => '${directory.path}/$instance.dcm';

  /// Returns [true] if the [Entity] is a [Directory].
  bool get isDirectory => false;

  bool get isStudy => false;
  bool get isSeries => true;
  bool get isFile => true;

  Future<Uint8List> readFileBytes(File file) => file.readAsBytes();

  Uint8List readFileBytesSync(File file) => file.readAsBytesSync();

}

