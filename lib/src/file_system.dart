// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//TODO: make everything async

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:io_extended/src/file_system_base.dart';

import 'package:io_extended/src/dcm_file.dart';
import 'package:io_extended/src/file_type.dart';
import 'package:io_extended/src/fs_index.dart';

// ignore_for_file: public_member_api_docs

//TODO: finish all IO calls async

/// A DICOM File System containing SOP Instances.  The structure is not
/// defined, it must be defined at a higher level.
class FileSystem extends FileSystemBase {
  //static const FSType type = FSType.sop;
  static const String version = '0.1.0';
  @override
  final Directory root;
  @override
  final String rootPath;

  FileSystem(this.rootPath)
      : root = FileSystemBase.maybeCreateRootSync(rootPath);

  //TODO: should check that it is a valid [name] for directory
  /// Returns the [Directory] corresponding to the
  /// specified [Study] or [Series].
  @override
  Directory directory(Entity entity) => Directory('$rootPath$entity');

  /// Returns the [DcmFile] corresponding to the arguments.
  @override
  DcmFile file(Entity entity, FileType fType) => DcmFile(this, fType, entity);

  /// Returns the [DcmFile] corresponding to [path].
  DcmFile toFile(String path) => DcmFile.fromPath(this, path);

  //TODO: implement
  @override
  FSIndex get index => FSIndex(rootPath);

  @override
  FileSubtype get defaultFileSubtype => FileSubtype.part10;

  //TODO: if needed, openStudy(Uid study);

  // *** Read Async  ***

  /// Reads a DICOM [Study], [Series], or [Instance] asynchronously
  /// from _this_. Returns a [Uint8List] containing the requested object.
  @override
  Future<Entity> read(String path,
          [FileSubtype subtype = FileSubtype.part10]) async =>
      unimplementedError();

  /// Reads a DICOM [Study] asynchronously from _this_.
  /// The [Study] [Uid] must correspond to a [Study]
  /// or an [Exception] is thrown.
  @override
  Future<Study> readStudy(Uid study,
          [FileSubtype subtype = FileSubtype.part10]) async =>
      unimplementedError();

  /// Reads a DICOM [Series] asynchronously from _this_. Throws an
  /// InvalidSeriesError if [study], or [series] are invalid.
  @override
  Future<Series> readSeries(Uid study, Uid series,
          [FileSubtype subtype = FileSubtype.part10]) async =>
      unimplementedError();

  /// Reads a DICOM [Instance] (SOPInstance) asynchronously from _this_.
  /// Throws an InvalidInstanceError if [study], [series], or [instance]
  /// are invalid.
  @override
  Future<Instance> readInstance(Uid study, Uid series, Uid instance,
          [FileSubtype subtype = FileSubtype.part10]) async =>
      unimplementedError();

  // *** Read Synchronous  ***

  /// Read a [Study], [Series], or [Instance].
  /// Returns a [Uint8List] containing the requested object.
  // TODO: if needed.
  @override
  Entity readSync(String path, [FileSubtype subtype = FileSubtype.part10]) =>
      unimplementedError();

  /// Reads a DICOM [Study].
  /// The [Study] [Uid] must correspond to a [Study] or
  /// an [Exception] is thrown.
  @override
  Study readStudySync(Uid study, [FileSubtype subtype = FileSubtype.part10]) =>
//    var path = toPath(subtype, study);
      unimplementedError();

  /// Reads a DICOM [Series].
  /// The [Series] [Uid] must correspond to a [Series] or
  /// an [Exception] is thrown.
  @override
  Series readSeriesSync(Uid study, Uid series,
          [FileSubtype subtype = FileSubtype.part10]) =>
//    var path = toPath(subtype, study);
      unimplementedError();

  /// Reads a DICOM SopInstance.
  /// The [SopInstance] [Uid] must correspond to a SopInstance or
  /// an [Exception] is thrown.
  @override
  Instance readInstanceSync(Uid study, Uid series, Uid instance,
          [FileSubtype subtype = FileSubtype.part10]) =>
//    var path = toPath(subtype, study);
      unimplementedError();

  // *** Write Async  ***

  // TODO: later
  @override
  Future<bool> write(Entity entity,
          [FileSubtype subtype = FileSubtype.part10]) async =>
      unimplementedError();

  @override
  Future<bool> writeStudy(Study study,
          [FileSubtype subtype = FileSubtype.part10]) async =>
      unimplementedError();

  @override
  Future<bool> writeSeries(Series series,
          [FileSubtype subtype = FileSubtype.part10]) async =>
      unimplementedError();

  @override
  Future<bool> writeInstance(Instance instance,
          [FileSubtype subtype = FileSubtype.part10]) =>
      unimplementedError();

  // *** Write Sync  ***

  @override
  bool writeSync(Entity entity, [FileSubtype subtype = FileSubtype.part10]) =>
      unimplementedError();

  @override
  bool writeStudySync(Study study,
          [FileSubtype subtype = FileSubtype.part10]) =>
      unimplementedError();

  @override
  bool writeSeriesSync(Series series,
          [FileSubtype subtype = FileSubtype.part10]) =>
      unimplementedError();

  @override
  bool writeInstanceSync(Instance instance,
          [FileSubtype subtype = FileSubtype.part10]) =>
      unimplementedError();

  Stream<FileSystemEntity> listEntities(Directory dir) =>
      dir.list(recursive: true, followLinks: false);

  DcmFile parse(String path) => toFile(path);
}
