// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: make everything async

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dictionary/uid.dart';
import 'package:io/src/base/file_system_base.dart';
import 'package:io/src/file_type.dart';
import 'package:io/src/fs_type.dart';
import 'package:io/src/index.dart';
import 'package:io/src/utils.dart';

//TODO: finish all IO calls async

/// A DICOM File System containing SOP Instances.  The structure is not
/// defined, it must be defined at a higher level.
class SopFileSystem extends FileSystemBase {
  static const FSType type = FSType.sop;
  static const String version = "0.1.0";
  final String path;
  final Directory root;

  SopFileSystem(String path)
      : path = path,
        root = FileSystemBase.maybeCreateRootSync(path);

  /// Returns the [Directory] corresponding to the specified [Study] or [Series].
  Directory directory(Uid study, [Uid series]) {
    var part3 = (series == null) ? "" : '/$series';
    return new Directory('$path/$study$part3');
  }

  /// Returns the [File] corresponding to the specified arguments.
  File file(FileType fType, Uid study, Uid series, Uid instance) =>
      new File('$path/$study/$series/$instance.${fType.extension}');

  //TODO: implement
  FSIndex get index => new FSIndex(path);

  //TODO: if needed, openStudy(Uid study);

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
  // TODO: if needed.
  //@override
  //List<dynamic> readSync(FileType fType, Uid study, [Uid series, Uid instance]) {}

  /// Reads a DICOM [Study].
  /// The [Study] [Uid] must correspond to a [Study] or an [Exception] is thrown.
  @override
  List<dynamic> readStudySync(FileType fType, Uid study) =>
      (fType.contents == "binary")
      ?  readBinaryDirectorySync(toPath(fType, study))
      : readStringDirectorySync(toPath(fType, study));

  /// Reads a DICOM [Series].
  /// The [Series] [Uid] must correspond to a [Series] or an [Exception] is thrown.
  @override
  List<dynamic> readSeriesSync(FileType fType, Uid study, Uid series) =>
      (fType.contents == "binary")
      ?  readBinaryDirectorySync(toPath(fType, study, series))
      : readStringDirectorySync(toPath(fType, study, series));

  /// Reads a DICOM [SopInstance].
  /// The [SopInstance] [Uid] must correspond to a [SopInstance] or an [Exception] is thrown.
  @override
  dynamic readInstanceSync(FileType fType, Uid study, Uid series, Uid instance) =>
      (fType.contents == "binary")
      ?  readBinaryDirectorySync(toPath(fType, study, series, instance))
      : readStringDirectorySync(toPath(fType, study, series, instance));

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
  void writeInstanceSync(FileType fType, Uid study, Uid series, Uid instance, data) {}

  Stream<FileSystemEntity> listEntities(Directory dir) =>
      dir.list(recursive: true, followLinks: false);

}


