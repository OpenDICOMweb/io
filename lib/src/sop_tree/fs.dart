// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: make everything async
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/dicom.dart';
import 'package:io/src/base/fs_base.dart';
import 'package:io/src/fs_type.dart';

//TODO: finish all IO calls async

/// A DICOM File System containing SOP Instances.  The structure is not
/// defined, it must be defined at a higher level.
class SopFileSystem extends FileSystemBase {
  static const FSType type = FSType.sopTree;

  static const String version = "0.1.0";
  static const String extension = ".dcm";

  final Directory root;
  final String path;

  SopFileSystem(String path)
      : path = path,
        root = new Directory(path),
        super();

  Directory directory(Uid study, [Uid series]) {
    var part3 = (series == null) ? "" : '/$series';
    return new Directory('$path/$study$part3');
  }

  File file(Uid study, Uid series, Uid instance) =>
      new File('$path/$study/$series/$instance.$extension');

  /*
  SopEntity entity(Uid study, [Uid series, Uid instance]) =>
      new SopEntity(this, study, series, instance);
  */
  //TODO: openStudy(Uid study);

  // *** Read Async  ***
/* TODO: implement later
  /// Read a [Study], [Series], or [Instance].
  /// Returns a [Uint8List] containing the requested object.
  @override
  Stream<Uint8List> read(Uid study, [Uid series, Uid instance]) async* {}

  /// Reads a DICOM [Study].
  /// The [Study] [Uid] must correspond to a [Study] or an [Exception] is thrown.
  @override
  Stream<Uint8List> readStudy(Uid study) async* {}

  /// Reads a DICOM [Series].
  /// The [Series] [Uid] must correspond to a [Series] or an [Exception] is thrown.
  @override
  Stream<Uint8List> readSeries(Uid study, Uid series) async* {
    throw "Unimplemented";
  }

  /// Reads a DICOM [SopInstance].
  /// The [SopInstance] [Uid] must correspond to a [SopInstance] or an [Exception] is thrown.
  @override
  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance) async {}
*/
  // *** Read Synchronous  ***

  /// Read a [Study], [Series], or [Instance].
  /// Returns a [Uint8List] containing the requested object.
  @override
  List<Uint8List> readSync(Uid study, [Uid series, Uid instance]) {}

  /// Reads a DICOM [Study].
  /// The [Study] [Uid] must correspond to a [Study] or an [Exception] is thrown.
  @override
  List<Uint8List> readStudySync(Uid study) {}

  /// Reads a DICOM [Series].
  /// The [Series] [Uid] must correspond to a [Series] or an [Exception] is thrown.
  @override
  List<Uint8List> readSeriesSync(Uid study, Uid series) {}

  /// Reads a DICOM [SopInstance].
  /// The [SopInstance] [Uid] must correspond to a [SopInstance] or an [Exception] is thrown.
  @override
  Uint8List readInstanceSync(Uid study, Uid series, Uid instance) {

  }

  // *** Write Async  ***

  /* TODO: later
  @override
  Sink<Uint8List> write(Uid study, [Uid series, Uid instance]) async* {}

  @override
  Future writeStudy(Uid study){}

  @override
  Future writeSeries(Uid study, Uid series){}

  @override
  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance){}
*/
  // *** Write Sync  ***

  @override
  void writeSync(Uid study, [Uid series, Uid instance]) {}

  @override
  void writeStudySync(Uid study) {}

  @override
  void writeSeriesSync(Uid study, Uid series) {

  }

  @override
  void writeInstanceSync(Uid study, Uid series, Uid instance, Uint8List bytes) {}

  Stream<FileSystemEntity> listEntities(Directory dir) =>
      dir.list(recursive: true, followLinks: false);

  static bool isSopFile(FileSystemEntity entity) =>
      ((entity is File) && entity.path.endsWith(extension));

}


