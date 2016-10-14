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

import 'fs_entity.dart';
import 'sop_file_system.dart';

abstact class SopEntity extends SopFileSystem {
  String get path;

  SopEntity(this.path) : super();

}

/// A [SopEntity] is a [Directory], [File], or [link] in a [SopFileSystem].
///
class SopEntity extend SopFileSystem {
  static const bool isLink = false;
  final String path;

  final SopFileSystem fs;
  final Uid study;
  final Uid series;
  final Uid instance;
  String _path;
  FileSystemEntity _entity;

  /// Create a [SopFileSystem] [Entity].
  SopEntity(this.fs, this.study, [this.series, this.instance]);

  ///
  String get name => _entity.path;

  /// Returns [true] if the [Entity] is a [Directory].
  bool get isDirectory => instance == null;

  /// Returns [true] if the [Entity] is a [File].
  bool get isFile => instance != null;

  FileSystemEntity get entity => _entity ??= _initEntity();

  String get path => _path ??= _initPath;

  String get _initPath {
    var s1 = study.toString();
    var s2 = (series == null) ? "" : series.toString();
    var s3 = (instance == null) ? "" : instance.toString();
    _path = '$s1/$s2/$s3';
    return _path;
  }

  FileSystemEntity _initEntity() {
    if(isDirectory) {
      _entity = new Directory(_path);
    } else if(isFile) {
      _entity = new File(_path);
    } else {
      throw "Invalid path: $_path";
    }
    return _entity;
  }

  /// If [this] is a [File], returns a [Uint8List] of the bytes in
  /// the [File].
  /// If [this] is a [Directory], returns a [Stream] of [Uint8List]s, one
  /// for each file in the directory.
  dynamic get readBytes {
    if (_entity is Directory) {
      return readDirBytes(_entity);
    } else if (_entity is File) {
      return readFileBytes(_entity);
    } else {
      throw "Invalid Entity: $_entity";
    }
  }

  Stream<FileSystemEntity> _listEntities(Directory dir) =>
      dir.list(recursive: true, followLinks: false);

  Stream<FileSystemEntity> get list => _listEntities(_entity);

  Future<Uint8List> readFileBytes(File file) => file.readAsBytes();

  Stream<Uint8List> readDirBytes(Directory dir) async* {
    var entities = dir.list(recursive: true, followLinks: false);
    await for(var entity in entities) {
      print('entity: $entity');
      if (entity is File) {
        var bytes = await entity.readAsBytes();
        yield(bytes);
      }
    }
  }

}

