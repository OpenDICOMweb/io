// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

//TODO: make async
import 'dart:io';

import 'package:io/src/sop_tree/sop_fs.dart';


/// A [SopEntity] is a [Directory], [File], or [link] in a [FileSystem].
///
abstract class SopEntity {
  FileSystem fs;

  /// Create a [SopFileSystem] [Entity].
  //SopEntity(this.fs);

  Directory get root => fs.root;

  toString() => '$runtimeType: Root($root)';

  /* flush
  /// Returns the
  String get path => _path ??= _initPath;

  /// Returns [true] if the [Entity] is a [Directory].
  bool get isDirectory => instance == null;

  /// Returns [true] if the [Entity] is a [File].
  bool get isFile => instance != null;


  String get _initPath {
    var s2 = (series == null) ? "" : '/$series';
    var s3 = (instance == null) ? "" : '/$instance';
    _path = '${fs.root}/$study/$s2/$s3';
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
  */
}

