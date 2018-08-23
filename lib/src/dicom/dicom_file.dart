// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
//
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:io_extended/io_extended.dart';
import 'package:path/path.dart' as p;

enum DicomFileType {dicom, dicomJson, dicomXML}

/// A binary DICOM file.
///
/// Its media type is application/dicom.
//Issue: should this extend File?
class DicomFile {
  final File file;
  String mediaType;

  DicomFile(String path, {bool exists = true})
      : file = _checkPath(File(path), exists: exists);

  DicomFile.fromRawPath(Uint8List rawPath, {bool exists = true})
      : file = _checkPath(File.fromRawPath(rawPath), exists: exists);

  DicomFile.fromUri(Uri uri, {bool exists = true})
      : file = _checkPath(File.fromUri(uri), exists: exists);

  DicomFile.fromFile(this.file, {bool exists = true}) {
    final mt = DcmMediaType.fromPath(path);
    switch (mt) {
      case DcmMediaType.dicom:
    }

  }

  // **** Forwarding Interface for File class
  // TODO: add missing members

  File get absolute => file.absolute;
  String get path => file.path;

  // Don't support slow.
  // Future<bool> exists() async => await file.exists();
  bool existsSync() => file.existsSync();


  // **** Parse Methods

  Instance read() {
    is
  }

  static String _extension(File file) => p.extension(file.path);
  static File _checkPath(File file, {bool exists = true}) =>
     exists ? _exists(file) : file;

  static _exists(File file) => (file.existsSync()) ? file : null;



}