// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;

const List<String> kDcmExtensions = const <String>[
  '.dcm', '.DCM', '' //No reformat
];

//TODO: what should default be?
const int kSmallDcmFileLimit = 376;

const int kReadPermissions = 0x0444;

Future<bool> isReadableDcmPath(String fName,
    [List<String> extensions = kDcmExtensions]) async {
  final stats = await FileStat.stat(fName);
  return _isReadableDcmPath(fName, extensions, stats);
}

bool isNotReadableDcmPath(String fName, [List<String> extensions = kDcmExtensions]) =>
    !_isReadableDcmPath(fName, extensions);

/// Returns _true_ if [file] exists and has a DICOM file extension.
bool isReadableDcmFile(File file, [List<String> extensions = kDcmExtensions]) =>
    _isReadableDcmPath(file.path, extensions);

bool isReadableDcmPathSync(String fName, [List<String> extensions = kDcmExtensions]) {
  final stats = FileStat.statSync(fName);
  return _isReadableDcmPath(fName, extensions, stats);
}

bool isNotReadableDcmPathSync(String fName, [List<String> extensions = kDcmExtensions]) =>
    !_isReadableDcmPath(fName, extensions);

/// Returns _true_ if [file] exists and has a DICOM file extension.
bool isReadableDcmFileSync(File file, [List<String> extensions = kDcmExtensions]) =>
    _isReadableDcmPath(file.path, extensions);

/// Returns _true_ if [fName] corresponds to a [File] that exists
/// and has a DICOM file  extension.
bool _isReadableDcmPath(String fName,
    [List<String> extensions = kDcmExtensions, FileStat stats]) {
  final ext = path.extension(fName);
  if (!extensions.contains(ext)) return false;
  final stats = FileStat.statSync(fName);
  if (stats.type == FileSystemEntityType.NOT_FOUND) return false;
  final mode = stats.mode;
  if ((mode & kReadPermissions) == 0) return false;
  if (stats.size < kSmallDcmFileLimit) return false;
  return true;
}

/// Asynchronously reads and returns a [Uint8List] of bytes contained
/// in the [File] corresponding to [fName], or_null_ if the [File]
/// represented by the [fName] is inaccessible.
Future<Uint8List> readDcmPath(String fName,
    [List<String> extensions = kDcmExtensions,
    int sizeLimit = kSmallDcmFileLimit]) async {
  if (isNotReadableDcmPath(fName)) return null;
  return readDcmFile(new File(fName), sizeLimit);
}

/// Asynchronously reads and returns a [Uint8List] of bytes contained
/// in the [file], or_null_ if the [File] represented by the path is inaccessible.
Future<Uint8List> readDcmFile(File file, [int sizeLimit = kSmallDcmFileLimit]) async {
  if (isNotReadableDcmPath(file.path)) return null;
  try {
    return await file.readAsBytes();
  } on FileSystemException {
    return null;
  }
}

Uint8List readDcmPathSync(String fName,
    [List<String> extensions = kDcmExtensions, int sizeLimit = kSmallDcmFileLimit]) {
  if (!_isReadableDcmPath(fName)) return null;
  return readDcmFileSync(new File(fName), sizeLimit);
}

Uint8List readDcmFileSync(File file, [int sizeLimit = kSmallDcmFileLimit]) {
  if (!_isReadableDcmPath(file.path)) return null;
  try {
    return file.readAsBytesSync();
  } on FileSystemException {
    return null;
  }
}
