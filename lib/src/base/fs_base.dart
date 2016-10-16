// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:io';
import 'dart:typed_data';

import 'package:core/dicom.dart';
import 'package:path/path.dart';

import 'fs_index_base.dart';
import '../fs_type.dart';

//TODO: Make all IO calls async

/// Examples:
///     var fs = FileSystem.open(String path);
///     FSFile file = fs.File(studyUid);
///     file.isStudy
///     file.isSeries
///     file.isInstance
///     file.isMetadata
///     file.isBulkdata
///

/// Goals:
/// 1. The file system should be completely independent of core except for [Uid]s.
/// 2. Simple read write interface using study, series, and instance [Uid]s

abstract class FileSystemBase {
  // The next four vars should be implemented as 'static const'
  /// The [type] of the file system.
  static FSType type;

  /// The [version] of the file system.
  static String version;

  // The File [extension] of DICOM files in this FS.
  static String extension;

  /// The root [Directory] of the file system.
  Directory root;

  //TODO: better doc\

  /// Returns an [Index] to the files in this [FileSystem].
  ///
  /// An [FSIndex] is a structured tree, 3 levels deep, where the interior nodes are
  /// are [List] and the leaves are [String]s containing the [Uid] of the [SopInstance].
  /// The root node is a [Study] [Uid] [String]s, and the level 2 nodes are
  /// [Series] [Uid] [String]s,
  FSIndexBase index;

  /// Creates a [SopFileSystem] rooted at the [Directory] specified by the [rootPath].
 // FileSystem(String rootPath, {bool createIfAbsent: true, bool isSync: false})
 //     : root = createRootSync(rootPath, createIfAbsent);


  /// Create the [root] Directory of the [FileSystem] recursively.
  static Directory createRootSync(String rootPath, bool createIfAbsent) {
    var root = new Directory(rootPath);
    if ((!root.existsSync()) && (createIfAbsent == true))
      root.createSync(recursive: true);
    return root;
  }

  /// The [path] to the [root] [Directory] of this [FileSystem].
  String get path => root.path;

  Directory directory(Uid study, [Uid series]) {
    var part3 = (series == null) ? "" : '/$series';
    return new Directory('$path/$study$part3');
  }

  File file (Uid study, Uid series, Uid instance) {
    return new File('$path/$study/$series/$instance.$extension');
  }

  // *** Read Async  ***
  // *** See https://www.dartlang.org/articles/language/await-async
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
  //TODO: maybe provide an implemention
  List<Uint8List> readSync(Uid study, [Uid series, Uid instance]);

  /// Returns a [List] of [Uint8List]s containing all the SOP [Instances] of the [Study]
  /// specified by the [Directory].
  // TODO: fix
  List<Uint8List> readStudySync(Uid study) {
    Directory d = directory(study);
    List<Uint8List> files;
    try {
      var dirList = d.listSync();
      for (FileSystemEntity f in dirList) {
        if (f is File) {
          print('Found file ${f.path}');
          var uid = basenameWithoutExtension(path);
          files[uid] = f.readAsBytesSync();
        } else if (f is Directory) {
          print('Found dir ${f.path}');
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return files;
  }




  /// Returns a [List] of [Uint8List]s containing all the SOP [Instances] of the [Series]
  /// specified by the [Directory].
  /// [Directory].
  List<Uint8List> readSeriesSync(Uid study, Uid series);

  /// Returns a [Uint8List] containing the SOP [Instance] in the specified [File].
  Uint8List readInstanceSync(Uid study, Uid series, Uid instance);

  // *** Write Async  ***
  /* TODO: implement async calls
  Sink<Uint8List> write(Uid study, [Uid series, Uid instance]);

  Sink<Uint8List> writeStudy(Uid study, Uint8List bytes);

  Sink<Uint8List> writeSeries(Uid study, Uid series, Uint8List bytes);

  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance, Uint8List bytes);
*/
  // *** Write Sync  ***

  //TODO: Not needed?
  void writeSync(Uid study, [Uid series, Uid instance]);

  //TODO: Not needed?
  //void writeStudySync(Uid study);

  //TODO: Not needed?
  //void writeSeriesSync(Uid study, Uid series);

  /// Writes the [bytes] containing a SOP [Instance] to the file specified by
  /// "$rootPath/$study/$series/$instance".
  void writeInstanceSync(Uid study, Uid series, Uid instance, Uint8List bytes);

  @override
  String toString() => 'File System ($type), root: $path';

}
