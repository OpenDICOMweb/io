// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.
//
import 'dart:io';

/// A binary DICOM file.
///
/// Its media type is application/dicom.
class DicomFile {
  File file;

  DicomFile(String path, {bool exists = true})
      : file = _checkPath(path);

  String get path => file.path;

  bool exists() => file.existsSync();




  static File _checkPath(String path, {bool exists = true}) {
    final file = File(path);
    if (exists)
      return (file.existsSync()) ? file : null;
    return file;
  }
}