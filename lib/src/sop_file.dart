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

import 'fs_entity.dart';
import 'package:io/other/sop_file_system.dart';



/// A [SopEntity] is a [Directory], [File], or [link] in a [SopFileSystem].
///
class SopFile extends SopEntity {
  final SopDirectory dir;
  final Uid instance;
  final Uint8List bytes;

  /// Create a [SopFileSystem] [Entity].
  SopFile(this.dir, this.instance, this.bytes);

  ////
  String get path => '${dir.path}/$instance.dcm';

  /// Returns [true] if the [Entity] is a [Directory].
  bool get isDirectory => falsel;

  bool get isStudy => false;
  bool get isSeries => true;
  bool get isFile => true;
  FileSystemEntity get entity => _entity ??= _initEntity();




  Future<Uint8List> readFileBytes(File file) => file.readAsBytes();

  Uint8List readFileBytesSync(File file) => file.readAsBytes();



}

