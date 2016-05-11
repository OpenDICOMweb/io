// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
library odw.sdk.base.io.sop_reference;

//TODO: make async
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:uid/uid.dart';

import 'fs_entity.dart';
import 'sop_file_system.dart';


class SopEntity extends FSEntity {

  static const bool isLink = false;
  final SopFileSystem fs;
  final Uid study;
  final Uid series;
  final Uid instance;
  String _path;
  FileSystemEntity _entity;

  SopEntity(this.fs, this.study, [this.series, this.instance]) {

  }

  String get name => _entity.path;

  bool get isDirectory => instance == null;

  bool get isFile => instance != null;

  FileSystemEntity get entity => (_entity == null) ? _initEntity() : _entity;

  String get path => (_path == null) ? _initPath : _path;

  String get _initPath {
    var s1 = study.toString();
    var s2 = (series == null) ? "" : series.toString();
    var s3 = (instance == null) ? "" : instance.toString();
    _path = '$s1/$s2/$s3';
    return _path;
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

}

