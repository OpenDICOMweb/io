// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.
//
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:converter/converter.dart';
import 'package:core/core.dart' hide checkFile, checkPath;
import 'package:path/path.dart' as pp;

import 'package:io_extended/src/dicom_media_type.dart';

enum DicomFileType { dicom, dicomJson, dicomXml }

/// A binary DICOM file.
///
/// Its media type is application/dicom.
//Issue: should this extend File?
class DicomFile {
  factory DicomFile(String path, {bool exists = true}) =>
      DicomFile.fromPath(path, exists: exists);

  DicomFile._(this.file);

  File file;

  // **** Forwarding Interface for File class
  // TODO: add missing members

  String get path => file.path;

  File get absolute => file.absolute;

  String get extension => pp.extension(file.path);

  DicomMediaType get mediaType => DicomMediaType.fromPath(file.path);

  // Don't support slow.
  // Future<bool> exists() async => await file.exists();
  bool existsSync() => file.existsSync();

  int get length => file.lengthSync();

  // **** Interface

  Future<RootDataset> read() async => unsupportedError();

  RootDataset readSync() => unsupportedError();

  Future<void> write(RootDataset rds) async => unsupportedError();

  void writeSync(RootDataset rds) => unsupportedError();

  // **** Constructors

  static DicomFile fromRawPath(Uint8List rawPath, {bool exists = true}) =>
      DicomFile.fromFile(File.fromRawPath(rawPath), exists: exists);

  static DicomFile fromUri(Uri uri, DicomMediaType mt, {bool exists = true}) =>
      DicomFile.fromFile(File.fromUri(uri), exists: exists);

  static DicomFile fromFile(File file, {bool exists = true}) {
    final mt = DicomMediaType.fromPath(file.path);
    if ((mt is! DicomMediaType) || (exists && (file.existsSync() == false)))
      return null;
    switch (mt) {
      case DicomMediaType.dicom:
        return DicomPart10File.fromFile(file);
      case DicomMediaType.json:
        return DicomXmlFile.fromFile(file);
      case DicomMediaType.xml:
        return DicomXmlFile.fromFile(file);
      default:
        return badDicomFile('Non-DICOM file extension: "$file"');
    }
  }

  static DicomFile fromPath(String path, {bool exists = true}) =>
      fromFile(File(path), exists: true);
}

File _checkFile(File file, DicomMediaType mediaType, bool exists) {
  final mt = DicomMediaType.fromPath(file.path);
  if (mediaType != mt) return null;
  return (file.existsSync()) ? file : null;
}

/// A binary DICOM file.
///
/// Its media type is application/dicom.
//Issue: should this extend File?
class DicomPart10File extends DicomFile {
  DicomPart10File.fromFile(File file, {bool exists = true})
      : super._(_checkFile(file, DicomMediaType.part10, exists));

  @override
  DicomMediaType get mediaType => DicomMediaType.part10;

  @override
  Future<RootDataset> read() async => _read(await file.readAsBytes());

  @override
  RootDataset readSync() => _read(file.readAsBytesSync());

  RootDataset _read(Uint8List data) => ByteReader(data).readRootDataset();

  @override
  Future<void> write(RootDataset rds) async =>
      await file.writeAsBytes(_write(rds));

  @override
  void writeSync(RootDataset rds) => file.writeAsBytes(_write(rds));

  //Urgent: is rds.path necessary
  Bytes _write(RootDataset rds) => ByteWriter(rds).writeRootDataset();
}

//Issue: should this extend File?
/// A binary DICOM file.
///
/// Its media type is application/dicom.
class DicomJsonFile extends DicomFile {
  DicomJsonFile.fromFile(File file, {bool exists = true})
      : super._(_checkFile(file, DicomMediaType.json, exists));

  @override
  DicomMediaType get mediaType => DicomMediaType.json;

  @override
  Future<RootDataset> read() async => _read(await file.readAsString());

  @override
  RootDataset readSync() => _read(file.readAsStringSync());

  RootDataset _read(String s) => JsonReader(s).readRootDataset();

  @override
  Future<void> write(RootDataset rds) async =>
      await file.writeAsString(_write(rds));

  @override
  void writeSync(RootDataset rds) => file.writeAsString(_write(rds));

  //Urgent: is rds.path necessary
  String _write(RootDataset rds) =>
      JsonWriter(rds, rds.path).writeRootDataset();
}

/// A binary DICOM file.
///
/// Its media type is application/dicom.
class DicomXmlFile extends DicomFile {
  DicomXmlFile.fromFile(File file, {bool exists = true})
      : super._(_checkFile(file, DicomMediaType.json, exists));

  @override
  DicomMediaType get mediaType => DicomMediaType.json;

  @override
  Future<RootDataset> read() async => _read(await file.readAsString());

  @override
  RootDataset readSync() => _read(file.readAsStringSync());

  RootDataset _read(String s) => XmlReader(s).readRootDataset();

  @override
  Future<void> write(RootDataset rds) async =>
      await file.writeAsString(_write(rds));

  @override
  void writeSync(RootDataset rds) => file.writeAsString(_write(rds));

  //Urgent: is rds.path necessary
  String _write(RootDataset rds) => XmlWriter(rds, rds.path).writeRootDataset();
}

Null badDicomFile(String msg) {
  log.error(msg);
  if (throwOnError) throw new DicomFileError(msg);
  return null;
}

class DicomFileError extends Error {
  final String msg;

  DicomFileError(this.msg);

  @override
  String toString() => msg;
}
