// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:core/uid.dart';
import 'package:io/src/file_type.dart';
import 'package:io/src/fs_type.dart';

import 'index_base.dart';


//TODO: Implement all async IO calls

/// Goals:
/// 1. The file system should be completely independent of core except for [Uid]s.
/// 2. Simple read write interface using study, series, and instance [Uid]s

/// The infterface to all ODW File Systems.
abstract class FileSystemBase {
  /// The [type] of the file system.
  static FSType type;

  /// The [version] of the file system.
  static String version = "0.1.0";

  /// The path to the [root] directory.
  //TODO: verify that this is the absolute path.
  String path;

  /// The root [Directory] of the file system.
  //TODO: if [root.path] and [path] are always the same make path get root.path.
  //TODO: if there is no value to making [root] a [Directory] eliminate it.
  Directory root;

  /// Returns an [Index] to the files in this [FileSystem].
  ///
  /// An [FSIndex] is a structured tree, 3 levels deep, where the interior nodes are
  /// are [List] and the leaves are [String]s containing the [Uid] of the [SopInstance].
  /// The root node is a [Study] [Uid] [String]s, and the level 2 nodes are
  /// [Series] [Uid] [String]s,
  FSIndexBase get index;

  /// Returns the [Directory] corresponding to the specified [root], [Study] and [Series].
  Directory directory(Uid study, [Uid series]);

  /// Returns the [File] corresponding to [root] plus the specified arguments.
  File file (FileType fType, Uid study, Uid series, Uid instance);

  // *** Read Async  ***
  //TODO: *** See https://www.dartlang.org/articles/language/await-async
  /* TODO: implement async later
  /// Returns a [Stream] of [Uint8List] containing the [Study], [Series],
  /// or [Instance] as specified.
  Stream<Uint8List> read(Uid study, [Uid series, Uid instance]) {}

  /// Returns a [Stream] of [Uint8List]s containing all the SOP [Instances] in the [Study].
  Stream<Uint8List> readStudy(Uid study);

  /// Returns a [Stream] of [Uint8List]s containing all the SOP [Instances] in the [Study].
  Stream<Uint8List> readSeries(Uid study, Uid series);

  /// Returns a [Future] containing a [Uint8List] containing the specified SOP [Instance].
  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance);
  */

  // *** Read Sync  ***

  /// Returns a [List] of [Uint8List], where each [Uint8List] contains a [Study], [Series],
  /// or [Instance] as specified by the corresponding [FileSystemEntity].
  //TODO: decide if this is needed.
  // List<Uint8List> readSync(FileType fType, Uid study, [Uid series, Uid instance]);

  /// Returns a [List] of [Uint8List]s, or [String] (depending on the [FileType])
  /// containing all the SOP Instances of the [Study] in the target [Directory]
  /// in the specified [FileType].
  List<Uint8List> readStudySync(FileType fType, Uid study);

  /// Returns a [List] of [Uint8List]s, or [String] (depending on the [FileType])
  /// containing all the SOP Instances of the [Series] in the target [Directory]
  /// in the specified [FileType].
  List readSeriesSync(FileType fType, Uid study, Uid series);

  /// Returns a [Uint8List] or [String] (depending on the [FileType]) containing the
  /// target SOP Instance in the specified [FileType].
  dynamic readInstanceSync(FileType fType, Uid study, Uid series, Uid instance);


  // *** Write Async  ***
  /* TODO: implement async calls
  Sink<Uint8List> write(Uid study, [Uid series, Uid instance]);

  Sink<Uint8List> writeStudy(Uid study, Uint8List bytes);

  Sink<Uint8List> writeSeries(Uid study, Uid series, Uint8List bytes);

  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance, Uint8List bytes);
*/
  // *** Write Sync  ***

  //TODO: needed?
  //void writeSync(FileType fType, Uid study, [Uid series, Uid instance]);

  //TODO: needed?
  //void writeStudySync(Uid study);

  //TODO: needed?
  //void writeSeriesSync(Uid study, Uid series);

  /// Writes the [Uint8List] or [String] contained in the bytes argument, to the
  /// file specified by by the [FileType], [Study], [Series], and [Instance] [Uid]s.
  void writeInstanceSync(FileType fType, Uid study, Uid series, Uid instance, bytes);

  @override
  String toString() => 'File System ($type), root: $path';

  /* TODO: debug - allows asynchronous creation of the FS root.
  static Future<Directory> maybeCreateRoot(String rootPath, bool createIfAbsent) sync* {
    var root = new Directory(rootPath);
    bool exists = await root.exists();
    if (! exists && createIfAbsent)
        await root.createSync(recursive: true);
    return root;
  }
  */

  /// Create the [root] Directory of the [FileSystem] recursively.
  static Directory maybeCreateRootSync(String path) {
    var root = new Directory(path);
    if (!root.existsSync()) root.createSync(recursive: true);
    return root;
  }

}
