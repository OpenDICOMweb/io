//TODO: copyright
library odw.sdk.base.io.file_system;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:base/type.dart';

import 'file_system_index.dart';
import 'sop_entity.dart';

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

  Stream<Uint8List> readStudy(Uid study);

  Stream<Uint8List> readSeries(Uid study, Uid series);

  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance);

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
