// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/dicom.dart';

import 'fs_index.dart';
import 'fs_type.dart';

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


///     var fs = FileSystem.opent(String path);
///     FSFile file = fs.File(studyUid);
///     file.isStudy
///     file.isSeries
///     file.isInstance
///     file.isMetadata
///     file.isBulkdata
///

///     var fs = FileSystem.opent(String path);
///     FSFile file = fs.File(studyUid);
///     file.isStudy
///     file.isSeries
///     file.isInstance
///     file.isMetadata
///     file.isBulkdata
///

///     var fs = FileSystem.opent(String path);
///     FSFile file = fs.File(studyUid);
///     file.isStudy
///     file.isSeries
///     file.isInstance
///     file.isMetadata
///     file.isBulkdata
///

///     var fs = FileSystem.opent(String path);
///     FSFile file = fs.File(studyUid);
///     file.isStudy
///     file.isSeries
///     file.isInstance
///     file.isMetadata
///     file.isBulkdata
///

///     var fs = FileSystem.opent(String path);
///     FSFile file = fs.File(studyUid);
///     file.isStudy
///     file.isSeries
///     file.isInstance
///     file.isMetadata
///     file.isBulkdata
///

abstract class FileSystem {
  // The next four vars should be implemented as 'static const'
  /// The [type] of the file system.
  static FSType type;

  /// The [subtype] of the file system.
  static FSSubType subtype;

  // The [version] of the file system.
  static String version;

  // The File [extension] of DICOM files in this FS.
  static String extension;

  /// The path to the root of the file system.
  //final String rootPath;

  /// The root [Directory] of the file system.
  final Directory root;

  //TODO: better doc
  /// An index of all the files in the file system.
  ///
  /// An [FSIndex] is a structured tree, 3 levels deep, where the interior nodes are
  /// are [List] and the leaves are [String]s containing the [Uid] of the [SopInstance].
  /// The root node is a [Study] [Uid] [String]s, and the level 2 nodes are
  /// [Series] [Uid] [String]s,
  FileSystemIndex _index;

  //TODO: create the async version of this.
  /// Creates a [SopFileSystem] rooted at the [Directory] specified by the [rootPath].
  FileSystem(String rootPath, {bool createIfAbsent: true})
      : root = createRoot(rootPath, createIfAbsent);

  static Directory createRoot(String rootPath, bool createIfAbsent) {
    var root = new Directory(rootPath);
    if ((!root.existsSync()) && (createIfAbsent == true))
      root.createSync(recursive: true);
    return root;
  }

  String get path => root.path;

  FileSystemIndex get index => new FileSystemIndex(this);


  // *** Read Async  ***
  // *** See https://www.dartlang.org/articles/language/await-async

  /// Returns a [Stream] of [Uint8List] containing the [Study], [Series],
  /// or [Instance] as specified.
  Stream<Uint8List> read(Uid study, [Uid series, Uid instance]);

  /// Returns a [Stream] of [Uint8List]s containing all the SOP [Instances] in the [Study].
  Stream<Uint8List> readStudy(Uid study);

  /// Returns a [Stream] of [Uint8List]s containing all the SOP [Instances] in the [Study].
  Stream<Uint8List> readSeries(Uid study, Uid series);

  /// Returns a [Future] containing a [Uint8List] containing the specified SOP [Instance].
  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance);

  // *** Read Sync  ***

  /// Returns a [List] of [Uint8List], where each [Uint8List] contains a [Study], [Series],
  /// or [Instance] as specified by the corresponding [FileSystemEntity].
  List<Uint8List> readSync(Uid study, [Uid series, Uid instance]);

  /// Returns a [List] of [Uint8List]s containing all the SOP [Instances] of the [Study]
  /// specified by the [Directory].
  List<Uint8List> readStudySync(Uid study);

  /// Returns a [List] of [Uint8List]s containing all the SOP [Instances] of the [Series]
  /// specified by the [Directory].
  /// [Directory].
  List<Uint8List> readSeriesSync(Uid study, Uid series);

  /// Returns a [Uint8List] containing the SOP [Instance] in the specified [File].
  Uint8List readInstanceSync(Uid study, Uid series, Uid instance);

  // *** Write Async  ***

  Sink write(Uid study, [Uid series, Uid instance]);


  Sink<Uint8List> writeStudy(Uid study);

  Future writeSeries(Uid study, Uid series);

  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance);

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

  String toJson() => '''
{ "@type": $type,
  "@subtype": $subtype,
  "@version": $version,
  "index": ${JSON.encode(_index)}
  }
   ''';

  @override
  String toString() => 'File System ($type/$subtype), root: $path';
}
