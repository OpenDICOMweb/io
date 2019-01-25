// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';

import 'dcm_file.dart';
import 'file_type.dart';
import 'fs_index.dart';
//import 'file_descriptor.dart';

// ignore_for_file: public_member_api_docs

//TODO: Implement all async IO calls

/// Goals:
/// 1. The file system should be completely independent of core
///    except for [Uid]s.
/// 2. Simple read write interface using study, series, and instance [Uid]s

/// The interface to all ODW File Systems.
abstract class FileSystemBase {
  /// The [version] of the file system.
  static String version = '0.1.0';

  /// The path to the [root] directory.
  //TODO: verify that this is the absolute path.
  String get rootPath;

  /// The root [Directory] of the file system.
  //TODO: if [root.path] and [path] are always the same make path get root.path.
  //TODO: if there is no value to making [root] a [Directory] eliminate it.
  Directory get root;

  FileSubtype get defaultFileSubtype;

  /// Returns an Index to the files in this FileSystem.
  ///
  /// An [FSIndex] is a structured tree, 3 levels deep, where the
  /// interior nodes are are [List] and the leaves are [String]s
  /// containing the [Uid] of the SopInstance. The root node is a [Study]
  /// [Uid] [String]s, and the level 2 nodes are [Series] [Uid] [String]s,
  FSIndex get index;

  /// Returns the [Directory] corresponding to the specified [root],
  /// [Study] and [Series].
  Directory directory(Entity entity);

  /// Returns the [File] corresponding to [entity] plus the specified arguments.
  DcmFile file(Entity entity, FileType fType);

  // *** Read Async  ***
  //TODO: *** See https://www.dartlang.org/articles/language/await-async

  /// Returns a [Stream] of [Uint8List] containing the [Study], [Series],
  /// or [Instance] as specified by [path], which must be a [String] of the
  /// form '/{study}{/series}{/instance}'.
  Future<Entity> read(String path, [FileSubtype subtype]);

  /// Returns a [Stream] of [Uint8List]s containing all the
  /// SOPInstances in the [Study].
  Future<Study> readStudy(Uid study, [FileSubtype subtype]);

  /// Returns a [Stream] of [Uint8List]s containing all the
  /// SOPInstances in the [Study].
  Future<Series> readSeries(Uid study, Uid series, [FileSubtype subtype]);

  /// Returns a [Future] containing a [Uint8List] containing
  /// the specified SOP [Instance].
  Future<Instance> readInstance(Uid study, Uid series, Uid instance,
      [FileSubtype subtype]);

  // *** Read Sync  ***

  /// Returns a [List] of [Uint8List] by [path], which must be a
  /// [String] of the form '/{study}{/series}{/instance}'..
  //TODO: decide if this is needed.
  Entity readSync(String path, [FileSubtype subtype]);

  /// Returns a [List] of [Uint8List]s, or [String] (depending on
  /// the [FileSubtype]) containing all the SOP Instances of the
  /// [Study] in the target [Directory] in the specified [FileSubtype].
  Study readStudySync(Uid study, [FileSubtype subtype]);

  /// Returns a [List] of [Uint8List]s, or [String] (depending on
  /// the [FileSubtype]) containing all the SOP Instances of the
  /// [Series] in the target [Directory] in the specified [FileSubtype].
  Series readSeriesSync(Uid study, Uid series, [FileSubtype subtype]);

  /// Returns a [Uint8List] or [String] (depending on the [FileSubtype])
  /// containing the target SOP Instance in the specified [FileSubtype].
  Instance readInstanceSync(Uid study, Uid series, Uid instance,
      [FileSubtype subtype]);

  // *** Write Async  ***

  Future<bool> write(Entity entity, [FileSubtype subtype]);

  Future<bool> writeStudy(Study study, [FileSubtype subtype]);

  Future<bool> writeSeries(Series series, [FileSubtype subtype]);

  Future<bool> writeInstance(Instance instance, [FileSubtype subtype]);

  // *** Write Sync  ***

  //TODO: needed?
  bool writeSync(Entity entity, [FileSubtype subtype]);

  //TODO: needed?
  bool writeStudySync(Study study, [FileSubtype subtype]);

  //TODO: needed?
  bool writeSeriesSync(Series series, [FileSubtype subtype]);

  /// Writes the [Uint8List] or [String] contained in the bytes
  /// argument, to the file specified by by the [FileSubtype],
  /// [Study], [Series], and [Instance] [String]s.
  bool writeInstanceSync(Instance instance, [FileSubtype subtype]);

  /// Return a path to a file in the FileSystem
  String toPath(FileSubtype fType, Uid study,
      [Uid series, Uid instance, String extension]) {
    final part4 = (instance == null) ? '' : '/$instance${fType.extension}';
    final part3 = (series == null) ? '' : '/$series';
    return '$rootPath/$study$part3$part4';
  }

  @override
  String toString() => 'DICOM File System , root: $rootPath';

  // TODO: debug - allows asynchronous creation of the FS root.
  static Future<Directory> maybeCreateRoot(String rootPath) async {
    final root = Directory(rootPath);
    final exists = await root.exists();
    if (!exists) root.createSync(recursive: true);
    return root;
  }

  /// Create the [root] Directory of the FileSystem recursively.
  static Directory maybeCreateRootSync(String path) {
    final root = Directory(path);
    if (!root.existsSync()) root.createSync(recursive: true);
    return root;
  }
}
