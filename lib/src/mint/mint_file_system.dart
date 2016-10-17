// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

//import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/uid.dart';
import 'package:io/src/base/fs_base.dart';
import 'package:path/path.dart';

import 'package:io/src/mint/other/fs_index.dart';
import 'package:io/src/fs_type.dart';
import 'package:io/src/file_type.dart';

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

class MintFileSystem extends FileSystemBase {
  static const type = FSType.mint;
  static const String version = '0.1.0';

  final String path;
  final Directory root;

  MintFileSystem(String path)
      : path = path,
        root = FileSystemBase.maybeCreateRootSync(path),
        super();

  FSIndex get index => new FSIndex(this);

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

  /* TODO: is this needed?
  /// Returns a [List] of [Uint8List], where each [Uint8List] contains a [Study], [Series],
  /// or [Instance] as specified by the corresponding [FileSystemEntity].
  //TODO: maybe provide an implemention
  List<Uint8List> readSync(Uid study, [Uid series, Uid instance]) {
    String p = toPath(path, study, series, instance);

  }
*/
  /// Returns a [List] of [Uint8List]s containing all the SOP [Instances] of the [Study]
  /// specified by the [Directory].
  // TODO: fix
  List<Uint8List> readStudySync(FileType fType, Uid study) {
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
  List<Uint8List> readSeriesSync(FileType fType, Uid study, Uid series) {}

  /// Returns a [Uint8List] containing the SOP [Instance] in the specified [File].
  Uint8List readInstanceSync(FileType fType, Uid study, Uid series, Uid instance) {}

  // *** Write Async  ***
  /* TODO: implement async calls
  Sink<Uint8List> write(Uid study, [Uid series, Uid instance]);

  Sink<Uint8List> writeStudy(Uid study, Uint8List bytes);

  Sink<Uint8List> writeSeries(Uid study, Uid series, Uint8List bytes);

  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance, Uint8List bytes);
*/
  // *** Write Sync  ***

  void writeSync(FileType fType, Uid study, [Uid series, Uid instance]) {}

  void writeStudySync(FileType fType, Uid study) {}

  void writeSeriesSync(FileType fType, Uid study, Uid series, bytes) {}

  void writeInstanceSync(FileType fType, Uid study, Uid series, Uid instance, bytes) {}

  @override
  String toString() => 'File System ($type), root: $path';

}
