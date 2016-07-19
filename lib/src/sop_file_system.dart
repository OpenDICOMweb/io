//TODO: copyright

library odw.sdk.reference.io.sop_file_system;

//TODO: make everything async
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:odwsdk/uid.dart';

import 'file_system.dart';
import 'sop_entity.dart';

//Make all IO calls async

/// A DICOM File System containing SOP Instances.  The structure is not
/// defined, it must be defined at a higher level.
class SopFileSystem extends FileSystem {
  static const FSType type = FSType.sop;
  static const FSSubtype subtype = FSSubtype.structured;
  static const String version = "0.1.0";
  static const String extension = ".dcm";

  SopFileSystem(String path) : super(path);

  SopEntity entity(Uid study, [Uid series, Uid instance]) =>
      new SopEntity(this, study, series, instance);

  //TODO: openStudy(Uid study);

  /// Read a [Study], [Series], or [Instance].
  /// Returns a [Uint8List] containing the requested object.
  @override
  Future<Uint8List> read(Uid study, [Uid series, Uid instance]) async {}

  /// Reads a DICOM [Study].
  /// The [Study] [Uid] must correspond to a [Study] or an [Exception] is thrown.
  @override
  Stream<Uint8List> readStudy(Uid study) async* {}

  /// Reads a DICOM [Series].
  /// The [Series] [Uid] must correspond to a [Series] or an [Exception] is thrown.
  @override
  Stream<Uint8List> readSeries(Uid study, Uid series) async* {}

  /// Reads a DICOM [SopInstance].
  /// The [SopInstance] [Uid] must correspond to a [SopInstance] or an [Exception] is thrown.
  @override
  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance) async {

  }

  Stream<FileSystemEntity> listEntities(Directory dir) =>
      dir.list(recursive: true, followLinks: false);

  static bool isSopFile(FileSystemEntity entity) =>
      ((entity is File) && entity.path.endsWith(extension));
}


/// A DICOM File System containing SOP Instances organized in the following
/// structure:
///     /{study}/{series}/{instance}.dcm
class FlatSopFileSystem extends SopFileSystem {
  static const FSType type = FSType.sop;
  static const FSSubtype subtype = FSSubtype.flat;
  static const String version = "0.1.0";
  static const String extension = ".dcm";

  FlatSopFileSystem(String root) : super(root);


  // *** Read Async  ***
  @override
  Future<Uint8List> read(Uid study, [Uid series, Uid instance]){}

  @override
  Stream<Uint8List> readStudy(Uid study){}

  @override
  Stream<Uint8List> readSeries(Uid study, Uid series){}

  @override
  Future<Uint8List> readInstance(Uid study, Uid series, Uid instance){}

  // *** Read Sync  ***

  List<Uint8List> readSync(Uid study, [Uid series, Uid instance]){}

  @override
  List<Uint8List> readStudySync(Uid study){}

  @override
  List<Uint8List> readSeriesSync(Uid study, Uid series){}

  @override
  Uint8List readInstanceSync(Uid study, Uid series, Uid instance){}

  // *** Write Async  ***

  @override
  Future write(Uid study, [Uid series, Uid instance]){}

  @override
  Future writeStudy(Uid study){}

  @override
  Future writeSeries(Uid study, Uid series){}

  @override
  Future<Uint8List> writeInstance(Uid study, Uid series, Uid instance){}

  // *** Write Sync  ***

  @override
  void writeSync(Uid study, [Uid series, Uid instance]){}

  @override
  void writeStudySync(Uid study){}

  @override
  void writeSeriesSync(Uid study, Uid series){}

  void writeInstanceSync(Uid study, Uid series, Uid instance){}


}
