//TODO: copyright
library odw.sdk.base.io.file_system;

/// Examples:
///     var fs = FileSystem.opent(String path);
///     FSFile file = fs.File(studyUid);
///     file.isStudy
///     file.isSeries
///     file.isInstance
///     file.isMetadata
///     file.isBulkdata
///

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/dicom.dart';

import 'file_system_index.dart';
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


//TODO: Make all IO calls async
//TODO: Create FSType and FSSubType
enum FSType { sop, msd, mint }
enum FSSubtype { structured, flat, metadata }

abstract class FileSystem {
  // The next four vars should be implemented as 'static const'
  /// The [type] of the file system.
  static FSType type;

  /// The [subtype] of the file system.
  static FSSubtype subtype;

  // The [version] of the file system.
  static String version;

  // The File [extension] of DICOM files in this FS.
  static String extension;

  /// The path to the root of the file system.
  final String rootPath;

  /// The root [Directory] of the file system.
  Directory _root;

  //TODO: better doc
  /// The index of all the files in the file system.
  FileSystemIndex _index;

  FileSystem(this.rootPath) {
    //TODO: do we need the index?
    _index = new FileSystemIndex(this);
  }

  Directory get root => (_root != null) ? _root : new Directory(rootPath);

  FileSystemIndex get index =>
      (_index != null) ? _index : new FileSystemIndex(this);

  // *** Read Async  ***

  Future<Uint8List> read(Uid study, [Uid series, Uid instance]);

  Stream<Uint8List> readStudy(Uid study);

  Stream<Uint8List> readSeries(Uid study, Uid series);

  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance);

  // *** Read Sync  ***

  List<Uint8List> readSync(Uid study, [Uid series, Uid instance]);

  List<Uint8List> readStudySync(Uid study);

  List<Uint8List> readSeriesSync(Uid study, Uid series);

  Uint8List readInstanceSync(Uid study, Uid series, Uid instance);

  // *** Write Async  ***

  Future write(Uid study, [Uid series, Uid instance]);

  Future writeStudy(Uid study);

  Future writeSeries(Uid study, Uid series);

  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance);

  // *** Write Sync  ***

  void writeSync(Uid study, [Uid series, Uid instance]);

  void writeStudySync(Uid study);

  void writeSeriesSync(Uid study, Uid series);

  void writeInstanceSync(Uid study, Uid series, Uid instance);

  String toJson() => '''
{ "@type": $type,
  "@subtype": $subtype,
  "@version": $version,
  "index": ${JSON.encode(_index)}
  }
   ''';

  @override
  String toString() => 'File System ($type/$subtype), root: $rootPath';
}
